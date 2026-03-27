import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../services/graphql_client.dart';
import '../../services/channel_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/error_dialog.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../customer/customer_controller.dart';
import '../cart/Cartcontroller.dart';
import '../coupon/coupon_controller.dart';
import '../base_controller.dart';
import '../../services/analytics_service.dart';
import '../../graphql/authenticate.graphql.dart';
import '../../utils/logger.dart';
import '../../utils/google_auth_env.dart';
import '../../routes.dart';
import '../referral/referral_controller.dart';

class AuthController extends BaseController {
  // Controllers
  final firstname = TextEditingController();
  final lastname = TextEditingController();

  // Dependencies
  final UtilityController utilityController = Get.find();
  final GetStorage _storage = GetStorage();

  // State variables
  final RxBool _isLoggedIn = false.obs;
  /// True while logout is in progress; other controllers should not redirect to login.
  static bool isLoggingOut = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  /// Reactive version of isLoggedIn for use in Obx/ever/workers
  RxBool get isLoggedInRx => _isLoggedIn;
  bool get isLoading => utilityController.isLoading;

  // Setters
  void setLoggedIn(bool value) {
    _isLoggedIn.value = value;
    if (value) {
      // Process pending referral from deep link after login
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isRegistered<ReferralController>()) {
          Get.find<ReferralController>().processPendingReferral();
        } else if (ReferralController.pendingReferrerId != null) {
          final controller = Get.put(ReferralController());
          controller.processPendingReferral();
        }
      });
    }
  }
  void setLoading(bool value) => utilityController.setLoadingState(value);

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  /// Manually check login status from GraphqlService tokens
  Future <void> checkLoginStatusFromGraphqlService() async {
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    if (authToken.isNotEmpty && channelToken.isNotEmpty) {
      setLoggedIn(true);
    } else {
      setLoggedIn(false);
    }
  }

  /// Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    try {
      final box = GetStorage();
      final authToken = box.read('auth_token') ?? '';
      final channelToken = ChannelService.getChannelToken() ?? '';

      // Check if both tokens exist
      if (authToken.isNotEmpty && channelToken.isNotEmpty) {
        // Verify the tokens are valid by making a test request
        final isValid = await _verifyTokensAreValid();
        if (isValid) {
          setLoggedIn(true);
        } else {
          setLoggedIn(false);
          // Clear invalid tokens
          await _clearInvalidTokens();
        }
      } else {
        setLoggedIn(false);
      }
    } catch (e) {
      setLoggedIn(false);
    }
  }

  /// Verify if stored tokens are still valid
  Future<bool> _verifyTokensAreValid() async {
        Logger.logFunction(functionName: '_verifyTokensAreValid', queryName: 'GetChannelList');
    try {
      // Make a simple GraphQL request to verify tokens
      final response = await GraphqlService.client.value.query$GetChannelList(
        Options$Query$GetChannelList(),
      );

      // If we get a response without authentication errors, tokens are valid
      if (response.hasException) {
        final errors = response.exception?.graphqlErrors ?? [];
        // Check if it's an authentication error
        for (final error in errors) {
          if (error.message.toLowerCase().contains('unauthorized') ||
              error.message.toLowerCase().contains('authentication') ||
              error.message.toLowerCase().contains('token')) {
            return false;
          }
        }
      }

      return true; // Tokens appear to be valid
    } catch (e) {
      return false; // Assume invalid on error
    }
  }

  /// Clear invalid tokens from storage
  Future<void> _clearInvalidTokens() async {
    try {
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      await _storage.remove('auth_token');
      await _storage.remove('channel_token');
      await _storage.remove('channel_code');
    } catch (e) {
    }
  }

  /// Common handler for successful authentication (Google/Apple sign-in)
  Future<bool> handleSuccessfulAuth(dynamic response, {required bool isRegistration}) async {
    final authToken = response.context.entry<HttpLinkResponseContext>()
        ?.headers?['vendure-auth-token'];

    if (authToken != null && authToken.isNotEmpty) {
      await GraphqlService.setToken(key: 'auth', token: authToken);
      setLoggedIn(true);
      resetFormField();

      if (isRegistration && ReferralController.pendingReferrerId == null) {
        GetStorage().write('just_registered', true);
      }

      await _claimGuestOrderIfAny();
      await _refreshCartAndCustomerAfterLogin();
      return true;
    }
    return false;
  }

  static const String _preserveGuestChannelKey = 'preserve_guest_channel';

  Future<void> _claimGuestOrderIfAny() async {
    return;
  }

  Future<void> _refreshCartAndCustomerAfterLogin() async {
    try {
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().getActiveOrder();
      }
      if (Get.isRegistered<CustomerController>()) {
        await Get.find<CustomerController>().getActiveCustomer(skipPostalCodeCheck: false);
      }
    } catch (_) {}
  }

  void _checkIfNewRegistrationAndSetFlag() {
    try {
      if (Get.isRegistered<CustomerController>()) {
        final customerController = Get.find<CustomerController>();
        final customer = customerController.activeCustomer.value;
        if (customer != null) {
          final createdAt = customer.createdAt.toLocal();
          final now = DateTime.now();
          final diff = now.difference(createdAt).inSeconds;
          final isNewCustomer = diff <= 30 &&
              customerController.orders.isEmpty &&
              ReferralController.pendingReferrerId == null &&
              customer.referredBy == null;
          if (isNewCustomer) {
            GetStorage().write('just_registered', true);
          }
        }
      }
    } catch (_) {}
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    isLoggingOut = true;
    setLoading(true);
    try {
      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      await _clearAllAppData();
      await AnalyticsService().resetAnalytics();
      setLoggedIn(false);
      resetFormField();
      SnackBarWidget.showSuccess('Logged out successfully');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.home);
        Future.delayed(const Duration(milliseconds: 800), () {
          isLoggingOut = false;
        });
      });
    } catch (e) {
      try {
        await _clearAllAppData();
        setLoggedIn(false);
        resetFormField();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRoutes.home);
          Future.delayed(const Duration(milliseconds: 800), () {
            isLoggingOut = false;
          });
        });
      } catch (cleanupError) {
        isLoggingOut = false;
      }
    } finally {
      setLoading(false);
    }
  }

  /// Clear all app data and cache
  Future<void> _clearAllAppData() async {
    try {
      // Unsubscribe from channel FCM topic so user doesn't get channel notifications until next login
      await NotificationService.instance.unsubscribeFromChannelTopic();
      // Clear auth and channel tokens from GraphqlService in-memory state
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      // Clear guest session (in-memory guest token + per-channel guest tokens + guest order code)
      await GraphqlService.clearGuestSession();
      // Clear Flutter image cache
      try {
        imageCache.clear();
        imageCache.clearLiveImages();
      } catch (e) {
      }

      // Preserve onboarding and theme state before erasing all storage
      final preservedOnboardingComplete = _storage.read('onboarding_complete');
      final preservedIntroShown = _storage.read('intro_shown');
      final preservedIsDarkMode = _storage.read('isDarkMode');

      // Erase ALL storage data at once — catches every key including any new ones
      await _storage.erase();

      // Restore onboarding and theme state so user doesn't see onboarding again
      if (preservedOnboardingComplete != null) {
        await _storage.write('onboarding_complete', preservedOnboardingComplete);
      }
      if (preservedIntroShown != null) {
        await _storage.write('intro_shown', preservedIntroShown);
      }
      if (preservedIsDarkMode != null) {
        await _storage.write('isDarkMode', preservedIsDarkMode);
      }

      // Clear any GetX controllers that might have cached data
      try {
        if (Get.isRegistered<CustomerController>()) {
          final customerController = Get.find<CustomerController>();
          customerController.activeCustomer.value = null;
          customerController.addresses.clear();
          customerController.orders.clear();
          customerController.isEditingProfile.value = false;
        }

        if (Get.isRegistered<CartController>()) {
          final cartController = Get.find<CartController>();
          cartController.clearCart();
        }

        if (Get.isRegistered<CouponController>()) {
          final couponController = Get.find<CouponController>();
          couponController.availableCouponCodes.clear();
          couponController.couponCodesLoaded.value = false;
          couponController.appliedCouponCodes.clear();
        }

        if (Get.isRegistered<UtilityController>()) {
          final utilityController = Get.find<UtilityController>();
          utilityController.setLoadingState(false);
        }
      } catch (controllerError) {
      }
    } catch (e) {
    }
  }

  /// Clear all input fields and reset state
  void resetFormField() {
    firstname.clear();
    lastname.clear();
  }

  /// Google Sign In and authenticate
  Future<bool> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      // Google Auth: read from .env via GoogleAuthEnv
      final googleClientId = GoogleAuthEnv.googleClientId;
      if (googleClientId == null || googleClientId.isEmpty) {
        ErrorDialog.showError('Google Client ID not configured');
        return false;
      }
      if (!GoogleAuthEnv.isIosConfigValid) {
        ErrorDialog.showError(
            'On iOS, set GOOGLE_CLIENT_ID_IOS in .env (iOS OAuth client ID). '
            'Web client is not allowed with custom URL scheme. See docs/GOOGLE_AUTH_SETUP.md.');
        return false;
      }
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleClientId,
        clientId: GoogleAuthEnv.clientIdForPlatform,
      );

      // Sign out any existing Google account to force account selection
      try {
        // Check if user is already signed in
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) {
          await googleSignIn.signOut();
        } else {
        }
      } catch (e) {
        // Try to sign out anyway
        try {
          await googleSignIn.signOut();
        } catch (signOutError) {
        }
      }

      // Sign in with Google - this will show account picker
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        // Handle cancellation or other sign-in errors
        final errorStr = e.toString().toLowerCase();

        // Check for cancellation
        if (errorStr.contains('canceled') ||
            errorStr.contains('cancelled') ||
            errorStr.contains('sign_in_canceled') ||
            errorStr.contains('sign_in_cancelled') ||
            errorStr.contains('12501')) { // Error code 12501 = SIGN_IN_CANCELLED
          return false;
        }

        // Check for developer error (error code 10)
        // Error formats: "ApiException: 10:", "ApiException: 10", "error 10", etc.
        final hasError10 = errorStr.contains('apiexception: 10') ||
            errorStr.contains('apiException: 10') ||
            errorStr.contains('apiexception:10') ||
            errorStr.contains('error 10') ||
            errorStr.contains('developer_error') ||
            errorStr.contains(': 10:') ||
            errorStr.contains(': 10 ') ||
            RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);

        if (hasError10) {
          // Re-throw to show error dialog with helpful message
          rethrow;
        }

        // Re-throw if it's not a cancellation
        rethrow;
      }

      if (googleUser == null) {
        // User cancelled the sign in
        return false;
      }
      // Step 2: Google returns idToken and accessToken
      // We only need idToken for backend verification
      // accessToken is for direct Google API calls (not needed here)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null || idToken.isEmpty) {
        ErrorDialog.showError('Failed to get Google ID token');
        return false;
      }

      // Step 3: Flutter sends idToken to backend
      // Step 4: Backend verifies token using Google public keys (backend logic)
      // Step 5: Backend creates its own session / JWT
      await GraphqlService.ensureGuestSessionForLogin();
      final response = await GraphqlService.client.value.mutate$LoginWithGoogle(
        Options$Mutation$LoginWithGoogle(
          variables: Variables$Mutation$LoginWithGoogle(token: idToken),
        ),
      );
      // Handle GraphQL errors
      if (response.hasException) {
        if (response.exception?.graphqlErrors != null) {
          // GraphQL errors handled by exception
        }
        if (response.exception?.linkException != null) {
        }
      }

      if (checkResponseForErrors(response, customErrorMessage: 'Google authentication failed')) {
        return false;
      }
      final data = response.parsedData?.authenticate;
      // Authentication successful
      if (data is Mutation$LoginWithGoogle$authenticate$$CurrentUser) {
        // Extract backend JWT session token from response headers
        // Backend creates its own session/JWT after verifying Google idToken
        final responseContext = response.context.entry<HttpLinkResponseContext>();
        if (responseContext != null) {
        }

        final authToken = responseContext?.headers?['vendure-auth-token'];
        if (authToken != null && authToken.isNotEmpty) {
          // Save backend JWT session token
          await GraphqlService.setToken(key: 'auth', token: authToken);

          // 2️⃣ Do not change channel on login — preserve the current (or guest) channel and postal code.
          // Previously we fetched GetChannelList and overwrote with channels.first, which switched away
          // from the guest's channel and caused guest cart to disappear (same fix as phone login).

          // 3️⃣ Claim guest cart if any, then mark logged in and refresh
          await _claimGuestOrderIfAny();
          setLoggedIn(true);
          resetFormField();
          await _refreshCartAndCustomerAfterLogin();
          _checkIfNewRegistrationAndSetFlag();
          return true;
        } else {
          ErrorDialog.showError('Authentication token not received from server');
          return false;
        }
      }

      // Handle invalid credentials
      if (data is Mutation$LoginWithGoogle$authenticate$$InvalidCredentialsError) {
        ErrorDialog.showError(data.message);
        return false;
      }

      // Handle not verified error
      if (data is Mutation$LoginWithGoogle$authenticate$$NotVerifiedError) {
        ErrorDialog.showError(data.message);
        return false;
      }

      // Fallback error
      ErrorDialog.showError('Google authentication failed');
      return false;

    } catch (e) {
      // Check if it's a cancellation - don't show error dialog for cancellations
      final errorStr = e.toString().toLowerCase();
      final isCancellation = errorStr.contains('canceled') ||
          errorStr.contains('cancelled') ||
          errorStr.contains('sign_in_canceled') ||
          errorStr.contains('sign_in_cancelled') ||
          errorStr.contains('12501'); // Error code 12501 = SIGN_IN_CANCELLED

      if (isCancellation) {
        return false;
      }

      // Check for developer error (error code 10) and provide helpful message
      // Error format: "ApiException: 10:", "ApiException: 10", etc.
      final isDeveloperError = errorStr.contains('apiexception: 10') ||
          errorStr.contains('apiException: 10') ||
          errorStr.contains('apiexception:10') ||
          errorStr.contains('error 10') ||
          errorStr.contains('developer_error') ||
          errorStr.contains(': 10:') ||
          errorStr.contains(': 10 ') ||
          RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);

      if (isDeveloperError) {
        ErrorDialog.showError(
            'Google Sign-In Configuration Error (Code 10)\n\n'
                'To fix this:\n\n'
                '1. Go to Google Cloud Console\n'
                '2. Navigate to: APIs & Services > Credentials\n'
                '3. Find your Android OAuth 2.0 Client ID\n'
                '4. Add SHA-1 fingerprint:\n'
                '   7B:87:2E:43:7B:68:07:28:A6:D2:7F:BE:28:C2:94:52:58:B7:E1:71\n\n'
                '5. Verify package name: com.kaaikani.kaaikani\n\n'
                '6. For release builds, add your release keystore SHA-1 as well'
        );
        return false;
      }

      // "Access blocked" / OAuth consent: app in Testing and user not in Test users
      final isAccessBlocked = errorStr.contains('access') &&
          (errorStr.contains('block') ||
              errorStr.contains('denied') ||
              errorStr.contains('unauthorized') ||
              errorStr.contains('invalid_request') ||
              errorStr.contains('redirect'));
      if (isAccessBlocked) {
        ErrorDialog.showError(
            'Google sign-in was blocked.\n\n'
                'If you saw "Access blocked" in the browser:\n'
                '1. Open Google Cloud Console → APIs & Services → OAuth consent screen\n'
                '2. Under "Test users", click + ADD USERS\n'
                '3. Add your Gmail address and save\n'
                '4. Try again'
        );
        return false;
      }

      // For other errors, show error dialog
      handleException(e, customErrorMessage: 'Google sign in failed');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Structured debug for Apple Sign In
  void _appleLog(String phase, [Map<String, Object?>? kv]) {
    const tag = '[Apple Sign In]';
    if (kv != null && kv.isNotEmpty) {
      for (final e in kv.entries) {
        debugPrint('$tag $phase | ${e.key}=${e.value}');
      }
    } else {
      debugPrint('$tag $phase');
    }
  }

  /// Apple Sign In and authenticate
  Future<bool> signInWithApple(BuildContext context) async {
    _appleLog('═══ START ═══');
    _appleLog('1. Request', {'scopes': 'email, fullName'});
    Logger.logFunction(functionName: 'signInWithApple', mutationName: 'LoginWithApple');
    setLoading(true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final givenNamePresent = credential.givenName != null && credential.givenName!.isNotEmpty;
      final familyNamePresent = credential.familyName != null && credential.familyName!.isNotEmpty;
      _appleLog('2. Credential', {
        'userIdentifier': credential.userIdentifier ?? 'null',
        'emailPresent': credential.email != null && credential.email!.isNotEmpty,
        'givenNamePresent': givenNamePresent,
        'familyNamePresent': familyNamePresent,
      });
      debugPrint('[Apple Sign In] 2. Debug name | givenName=${credential.givenName ?? "null"} | familyName=${credential.familyName ?? "null"} | givenNamePresent=$givenNamePresent | familyNamePresent=$familyNamePresent');

      final String? identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        _appleLog('EXIT', {'reason': 'identityToken null/empty'});
        _appleLog('═══ END ═══');
        ErrorDialog.showError('Failed to get Apple ID token');
        return false;
      }

      _appleLog('3. Token', {
        'length': identityToken.length,
        'prefix': identityToken.length >= 30 ? '${identityToken.substring(0, 30)}...' : identityToken,
      });
      _appleLog('3. Token.full', {'token': identityToken});
      String? emailFromToken;
      try {
        final parts = identityToken.split('.');
        if (parts.length >= 2) {
          final payload = parts[1];
          final padded = payload + List.filled((4 - payload.length % 4) % 4, '=').join();
          final decoded = utf8.decode(base64Url.decode(padded));
          _appleLog('3. Token.payload (claims)', {'json': decoded});
          final map = jsonDecode(decoded) as Map<String, dynamic>?;
          emailFromToken = map?['email'] as String?;
        }
      } catch (_) {
        _appleLog('3. Token.payload', {'decode': 'skipped'});
      }

      final email = (credential.email?.trim().isNotEmpty == true ? credential.email!.trim() : emailFromToken?.trim()) ?? '';
      final firstName = credential.givenName?.trim() ?? '';
      final lastName = credential.familyName?.trim() ?? '';
      debugPrint('[Apple Sign In] 4. Debug email=$email | firstName=$firstName | lastName=$lastName | firstNameEmpty=${firstName.isEmpty} | lastNameEmpty=${lastName.isEmpty}');
      if (firstName.isEmpty && lastName.isEmpty) {
        debugPrint('[Apple Sign In] 4. Why empty: Apple only sends givenName/familyName on FIRST sign-in; on later sign-ins they are null (so we pass "").');
      }
      _appleLog('4. Mutation', {'action': 'sending LoginWithApple', 'email': email.isEmpty ? '(empty)' : email, 'firstName': firstName.isEmpty ? '(empty)' : firstName, 'lastName': lastName.isEmpty ? '(empty)' : lastName});
      await GraphqlService.ensureGuestSessionForLogin();
      final response = await GraphqlService.client.value.mutate$LoginWithApple(
        Options$Mutation$LoginWithApple(
          variables: Variables$Mutation$LoginWithApple(
            token: identityToken,
            email: email,
            firstName: firstName,
            lastName: lastName,
          ),
        ),
      );

      _appleLog('4. Mutation', {'hasException': response.hasException});
      if (response.hasException) {
        _appleLog('4. Mutation.exception', {'raw': response.exception.toString()});
        if (response.exception?.graphqlErrors != null && response.exception!.graphqlErrors.isNotEmpty) {
          for (final e in response.exception!.graphqlErrors) {
            _appleLog('4. Mutation.graphqlError', {'message': e.message});
            if (e.extensions != null) _appleLog('4. Mutation.extensions', {'data': e.extensions.toString()});
          }
        }
        if (response.exception?.linkException != null) {
          _appleLog('4. Mutation.linkException', {'raw': response.exception!.linkException.toString()});
        }
      }

      if (checkResponseForErrors(response, customErrorMessage: 'Apple authentication failed')) {
        _appleLog('EXIT', {'reason': 'checkResponseForErrors failed'});
        _appleLog('═══ END ═══');
        return false;
      }

      final data = response.parsedData?.authenticate;
      _appleLog('5. Result', {'parsedType': data.runtimeType.toString()});

      if (data is Mutation$LoginWithApple$authenticate$$CurrentUser) {
        final responseContext = response.context.entry<HttpLinkResponseContext>();
        final authToken = responseContext?.headers?['vendure-auth-token'];
        _appleLog('5. Result', {'authTokenReceived': authToken != null && authToken.isNotEmpty});
        if (authToken != null && authToken.isNotEmpty) {
          await GraphqlService.setToken(key: 'auth', token: authToken);

          // Do not change channel on login — preserve the current (or guest) channel and postal code.
          // Previously we fetched GetChannelList and overwrote with channels.first, which switched away
          // from the guest's channel and caused guest cart to disappear (same fix as phone login).

          _appleLog('5. Result', {'outcome': 'success'});
          _appleLog('═══ END ═══');
          await _claimGuestOrderIfAny();
          setLoggedIn(true);
          resetFormField();
          await _refreshCartAndCustomerAfterLogin();
          _checkIfNewRegistrationAndSetFlag();
          return true;
        } else {
          _appleLog('EXIT', {'reason': 'authToken not received from server'});
          _appleLog('═══ END ═══');
          ErrorDialog.showError('Authentication token not received from server');
          return false;
        }
      }
      if (data is Mutation$LoginWithApple$authenticate$$InvalidCredentialsError) {
        _appleLog('5. Result', {'outcome': 'InvalidCredentialsError', 'message': data.message});
        _appleLog('═══ END ═══');
        ErrorDialog.showError(data.message);
        return false;
      }
      if (data is Mutation$LoginWithApple$authenticate$$NotVerifiedError) {
        _appleLog('5. Result', {'outcome': 'NotVerifiedError', 'message': data.message});
        _appleLog('═══ END ═══');
        ErrorDialog.showError(data.message);
        return false;
      }
      _appleLog('EXIT', {'reason': 'fallback error'});
      _appleLog('═══ END ═══');
      ErrorDialog.showError('Apple authentication failed');
      return false;
    } on SignInWithAppleAuthorizationException catch (e) {
      _appleLog('EXIT', {'reason': 'SignInWithAppleAuthorizationException', 'code': e.code.toString(), 'message': e.message});
      if (e.code == AuthorizationErrorCode.canceled ||
          e.code == AuthorizationErrorCode.notHandled) {
        _appleLog('═══ END ═══ (user canceled)');
        return false;
      }
      _appleLog('═══ END ═══');
      ErrorDialog.showError(e.message);
      return false;
    } catch (e, stack) {
      _appleLog('EXIT', {'reason': 'exception', 'error': e.toString()});
      _appleLog('5. Result', {'stackTrace': stack.toString().split('\n').take(3).join(' | ')});
      _appleLog('═══ END ═══');
      handleException(e, customErrorMessage: 'Apple sign in failed');
      return false;
    } finally {
      setLoading(false);
      _appleLog('finally');
    }
  }

  @override
  void onClose() {
    firstname.dispose();
    lastname.dispose();
    super.onClose();
  }
}
