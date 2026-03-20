import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../services/graphql_client.dart';
import '../../services/channel_service.dart';
import '../../services/notification_service.dart';
import '../../theme/colors.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/error_dialog.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../customer/customer_controller.dart';
import '../cart/Cartcontroller.dart';
import '../banner/bannercontroller.dart';
import '../order/ordercontroller.dart';
import '../base_controller.dart';
import '../../services/analytics_service.dart';
import '../../graphql/authenticate.graphql.dart';
import '../../graphql/Customer.graphql.dart';
import '../../graphql/order.graphql.dart';
import '../../utils/logger.dart';
import '../../utils/google_auth_env.dart';
import '../../routes.dart';
import '../referral/referral_controller.dart';

class AuthController extends BaseController {
  // Controllers
  final firstname = TextEditingController(); // ✅ add this
  final lastname = TextEditingController();  // ✅ add this
  final phoneNumber = TextEditingController();
  final otpController = TextEditingController();

  // Dependencies
  final UtilityController utilityController = Get.find();
  final GetStorage _storage = GetStorage();

  // State variables
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isOtpSent = false.obs;
  /// True while logout is in progress; other controllers should not redirect to login.
  static bool isLoggingOut = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  /// Reactive version of isLoggedIn for use in Obx/ever/workers
  RxBool get isLoggedInRx => _isLoggedIn;
  bool get isOtpSent => _isOtpSent.value;
  bool get isLoading => utilityController.isLoading;

  /// Debug: dump current controller state for logging
  String get _debugState => 'AuthController{isOtpSent=${_isOtpSent.value}, isLoading=$isLoading, isLoggedIn=${_isLoggedIn.value}, phoneLength=${phoneNumber.text.length}}';

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
  void setOtpSent(bool value) {
    debugPrint('[AuthController] setOtpSent called with: $value, current: ${_isOtpSent.value} | $_debugState');
    if (_isOtpSent.value != value) {
      _isOtpSent.value = value;
      debugPrint('[AuthController] setOtpSent applied | $_debugState');
    } else {
      debugPrint('[AuthController] setOtpSent value unchanged ($value), forcing Obx refresh');
      _isOtpSent.value = !value;
      _isOtpSent.value = value;
      debugPrint('[AuthController] setOtpSent after force | $_debugState');
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

  /// Helper to show SnackBar and return a bool


  /// Validate phone number format
  bool _isValidPhoneNumber(String phone) {
    // Remove any non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return cleanPhone.length >= 10;
  }

  /// Step 1: Check if phone number exists and get channel info (for login)
  Future<bool> checkEmailAndGetChannel(BuildContext? context) async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      // Use GetX snackbar to avoid context issues
      SnackBarWidget.showError('Please enter a valid Phone number');
      return false;
    }

    setLoading(true);
    try {
      final response = await GraphqlService.client.value.query$GetChannelList(
        Options$Query$GetChannelList(),
      );

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to check phone number')) {
        return false;
      }

      final modelResponse = response.parsedData;
      final channels = modelResponse?.getChannelList ?? [];
      if (channels.isEmpty) {
        ErrorDialog.showError('No channels available.');
        return false;
      }

      // Use the first available channel
      final channel = channels.first;
      await ChannelService.setChannelInfo(
        token: channel.token,
        code: channel.code,
      );
      await NotificationService.instance.subscribeToChannelTopic();
      // Use GetX snackbar to avoid context issues

      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to verify phone number');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Check if user exists (for signup - silent check without snackbars)
  Future<bool> checkUserExists() async {
    Logger.logFunction(functionName: 'checkUserExists', queryName: 'GetChannelList');
    
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      return false;
    }

    setLoading(true);
    try {
      final response = await GraphqlService.client.value.query$GetChannelList(
        Options$Query$GetChannelList(),
      );

      if (response.hasException) {
        return false; // Assume user doesn't exist on error
      }

      final modelResponse = response.parsedData;
      final channels = modelResponse?.getChannelList ?? [];
      if (channels.isNotEmpty) {
      }

      if (channels.isEmpty) {
        return false; // User doesn't exist
      }

      // User exists - save their channel info
      // final channel = channels.first; // Unused variable
      return true; // User exists
    } catch (e) {
      return false; // Assume user doesn't exist on error
    } finally {
      setLoading(false);
    }
  }

  /// Check channels by phone number before sending OTP
  Future<bool> checkChannelsByPhoneNumber({required bool isLogin}) async {
    Logger.logFunction(functionName: 'checkChannelsByPhoneNumber', queryName: 'GetChannelsByCustomerPhoneNumber');
    
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.showError('Please enter a valid phone number');
      return false;
    }

    setLoading(true);
    try {
      final response = await GraphqlService.client.value.query$GetChannelsByCustomerPhoneNumber(
        Options$Query$GetChannelsByCustomerPhoneNumber(
          variables: Variables$Query$GetChannelsByCustomerPhoneNumber(
            phoneNumber: phoneNumber.text,
          ),
        ),
      );
      
      // First check for exceptions/errors - if any error occurs, don't proceed
      if (response.hasException) {
        // Check for GraphQL errors
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          final errorMessages = response.exception!.graphqlErrors
              .map((e) => e.message.toLowerCase())
              .toList();
          
          // Check for "Customer not found" or "Customer is not registered" error
          bool isCustomerNotFoundError = errorMessages.any((msg) => 
            msg.contains('customer not found') || 
            msg.contains('not found with phone') ||
            msg.contains('customer is not registered') ||
            msg.contains('not registered') ||
            msg.contains('is not registered'));
          
          if (isCustomerNotFoundError) {
            if (!isLogin) {
              // For registration, "customer not found/not registered" is expected - proceed with OTP
              setLoading(false);
              return true;
            } else {
              // For login, "customer not registered" means account doesn't exist
              // Redirect to signup page with the phone number pre-filled
              setLoading(false);
              final phone = phoneNumber.text;
              debugPrint('[AuthController] Customer not registered - redirecting to signup with phone=$phone');
              SnackBarWidget.showError('No account found. Please sign up first.');
              Get.toNamed(AppRoutes.signup, arguments: {'phoneNumber': phone});
              return false;
            }
          } else {
            // Other GraphQL errors - don't proceed
            setLoading(false);
            if (checkResponseForErrors(response, customErrorMessage: 'Failed to check phone number')) {
              return false;
            }
            return false;
          }
        }
        
        // Check for link exceptions (network errors, etc.)
        if (response.exception?.linkException != null) {
          setLoading(false);
          if (checkResponseForErrors(response, customErrorMessage: 'Failed to check phone number')) {
            return false;
          }
          return false;
        }
      }

      // Check for general response errors
      if (checkResponseForErrors(response, customErrorMessage: 'Failed to check phone number')) {
        setLoading(false);
        return false;
      }

      final channels = response.parsedData?.getChannelsByCustomerPhoneNumber ?? [];

      if (isLogin) {
        // For login: channel must exist
        if (channels.isEmpty) {
          setLoading(false);
          final phone = phoneNumber.text;
          debugPrint('[AuthController] No channels found for login - redirecting to signup with phone=$phone');
          SnackBarWidget.showError('No account found. Please sign up first.');
          Get.toNamed(AppRoutes.signup, arguments: {'phoneNumber': phone});
          return false;
        }
        // Channel exists, proceed with OTP
        setLoading(false);
        return true;
      } else {
        // For register: if channels exist, show error. If empty, proceed (kindly register)
        if (channels.isNotEmpty) {
          setLoading(false);
          ErrorDialog.showError('An account already exists with this phone number. Please login instead.');
          return false;
        }
        // No channels found, proceed with registration OTP
        setLoading(false);
        return true;
      }
    } catch (e) {
      setLoading(false);
      handleException(e, customErrorMessage: 'Failed to check phone number', functionName: 'checkChannelsByPhoneNumber');
      return false;
    }
  }

  /// Step 2: Send OTP after channel verification
  Future<bool> sendOtp(BuildContext? context, {bool isLogin = false}) async {
    debugPrint('[sendOtp] ENTRY isLogin=$isLogin | $_debugState');
    Logger.logFunction(functionName: 'sendOtp', mutationName: 'SendPhoneOtp');

    if (!_isValidPhoneNumber(phoneNumber.text)) {
      debugPrint('[sendOtp] EXIT invalid phone | $_debugState');
      SnackBarWidget.showError('Please enter a valid phone number');
      return false;
    }

    debugPrint('[sendOtp] Checking channels before sending OTP...');
    final canProceed = await checkChannelsByPhoneNumber(isLogin: isLogin);
    if (!canProceed) {
      debugPrint('[sendOtp] EXIT channel check failed | $_debugState');
      return false;
    }
    debugPrint('[sendOtp] Channel check passed - calling SendPhoneOtp mutation | $_debugState');

    setLoading(true);
    try {
      final response = await GraphqlService.client.value.mutate$SendPhoneOtp(
        Options$Mutation$SendPhoneOtp(
          variables: Variables$Mutation$SendPhoneOtp(phoneNumber: phoneNumber.text),
        ),
      );

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to send OTP')) {
        debugPrint('[sendOtp] EXIT checkResponseForErrors | $_debugState');
        setLoading(false);
        return false;
      }

      final rawResult = response.parsedData?.sendPhoneOtp;
      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;
      debugPrint('[sendOtp] Mutation result: rawResult=$rawResult, success=$success | $_debugState');

      if (success) {
        debugPrint('[sendOtp] OTP sent successfully - calling setOtpSent(true)');
        setOtpSent(true);
        debugPrint('[sendOtp] After setOtpSent | $_debugState');

        await Future.delayed(Duration(milliseconds: 50));
        debugPrint('[sendOtp] After 50ms delay | $_debugState');

        SnackBarWidget.showSuccess('OTP sent successfully!');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint('[sendOtp] PostFrameCallback | $_debugState');
        });

        await Future.delayed(Duration(milliseconds: 100));
        setLoading(false);
        debugPrint('[sendOtp] EXIT success=true | $_debugState');
        return true;
      } else {
        setLoading(false);
        debugPrint('[sendOtp] EXIT success=false (rawResult) | $_debugState');
        ErrorDialog.showError('Failed to send OTP');
        return false;
      }
    } catch (e) {
      setLoading(false);
      debugPrint('[sendOtp] EXIT exception: $e | $_debugState');
      handleException(e, customErrorMessage: 'Failed to send OTP', functionName: 'sendOtp');
      return false;
    }
  }

  /// Step 3a: Verify OTP for Login
  /// Uses LoginWithPhoneOtp mutation (no firstName/lastName)
  Future<bool> verifyOtpForLogin(BuildContext context) async {
    Logger.logFunction(functionName: 'verifyOtpForLogin', mutationName: 'LoginWithPhoneOtp');
    
    // Validate OTP length
    if (otpController.text.length != 4) {
      SnackBarWidget.show(
        context,
        'Please enter a valid 4-digit OTP',
        backgroundColor: AppColors.error,
      );
      return false;
    }

    setLoading(true);

    try {
      // Ensure guest token is sent with authenticate so server can merge guest cart (no ClaimGuestOrder).
      await GraphqlService.ensureGuestSessionForLogin();
      // Perform OTP verification mutation for login (no firstName/lastName).
      final response = await GraphqlService.client.value.mutate$LoginWithPhoneOtp(
        Options$Mutation$LoginWithPhoneOtp(
          variables: Variables$Mutation$LoginWithPhoneOtp(
            phoneNumber: phoneNumber.text,
            code: otpController.text,
          ),
        ),
      );
      // Handle GraphQL errors
      if (checkResponseForErrors(response, customErrorMessage: 'OTP verification failed')) {
        return false;
      }

      final data = response.parsedData?.authenticate;

      // OTP verified successfully
      if (data is Mutation$LoginWithPhoneOtp$authenticate$$CurrentUser) {
        return await _handleSuccessfulAuthentication(context, data, response, isRegistration: false);
      }

      // Handle invalid credentials
      if (data is Mutation$LoginWithPhoneOtp$authenticate$$InvalidCredentialsError) {
        ErrorDialog.showError(data.message);
        return false;
      }

      // Handle not verified error
      if (data is Mutation$LoginWithPhoneOtp$authenticate$$NotVerifiedError) {
        ErrorDialog.showError(data.message);
        return false;
      }

      // Fallback error
      ErrorDialog.showError('OTP verification failed');
      return false;

    } catch (e) {
      handleException(e, customErrorMessage: 'OTP verification failed');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Step 3b: Verify OTP for Registration
  /// Uses Authenticate mutation with firstName and lastName
  Future<bool> verifyOtpForRegistration(BuildContext context) async {
    // Validate OTP length
    if (otpController.text.length != 4) {
      SnackBarWidget.show(
        context,
        'Please enter a valid 4-digit OTP',
        backgroundColor: AppColors.error,
      );
      return false;
    }

    setLoading(true);
    try {
      // Trim first and last name
      final firstName = firstname.text.trim();
      final lastName = lastname.text.trim();
      // For registration: first name, last name are required
      if (firstName.isEmpty || firstName.length < 2) {
        setLoading(false);
        SnackBarWidget.show(
          context,
          'First name is required (minimum 2 characters)',
          backgroundColor: AppColors.error,
        );
        return false;
      }
      
      if (lastName.isEmpty) {
        setLoading(false);
        SnackBarWidget.show(
          context,
          'Last name is required',
          backgroundColor: AppColors.error,
        );
        return false;
      }
      
      // Validate first name contains only alphabets
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(firstName)) {
        setLoading(false);
        SnackBarWidget.show(
          context,
          'First name should contain only alphabets',
          backgroundColor: AppColors.error,
        );
        return false;
      }
      // Perform OTP verification mutation for registration (with firstName/lastName)
      Logger.logFunction(functionName: 'verifyOtpForRegister', mutationName: 'Authenticate');
      await GraphqlService.ensureGuestSessionForLogin();
      final response = await GraphqlService.client.value.mutate$Authenticate(
        Options$Mutation$Authenticate(
          variables: Variables$Mutation$Authenticate(
            phoneNumber: phoneNumber.text,
            code: otpController.text,
            firstName: firstName,
            lastName: lastName,
          ),
        ),
      );
      // Handle GraphQL errors
      if (checkResponseForErrors(response, customErrorMessage: 'OTP verification failed')) {
        return false;
      }

      final data = response.parsedData?.authenticate;

      // OTP verified successfully
      if (data is Mutation$Authenticate$authenticate$$CurrentUser) {
        return await _handleSuccessfulAuthentication(context, data, response, isRegistration: true);
      }

      // Handle invalid credentials
      if (data is Mutation$Authenticate$authenticate$$InvalidCredentialsError) {
        ErrorDialog.showError(data.message);
        return false;
      }

      // Fallback error
      ErrorDialog.showError('OTP verification failed');
      return false;

    } catch (e) {
      handleException(e, customErrorMessage: 'OTP verification failed');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Common handler for successful authentication (both login and registration)
  Future<bool> _handleSuccessfulAuthentication(
    BuildContext context,
    dynamic currentUser,
    dynamic response,
    {required bool isRegistration}
  ) async {
    // Extract auth token from response headers
    final authToken = response.context.entry<HttpLinkResponseContext>()
        ?.headers?['vendure-auth-token'];

    if (authToken != null && authToken.isNotEmpty) {

      // 1️⃣ Save auth token
      await GraphqlService.setToken(key: 'auth', token: authToken);

      // 2️⃣ Do not change channel on login — preserve the current (or guest) channel and postal code.
      // Previously we called checkEmailAndGetChannel() here, which overwrote the channel with the
      // first channel from GetChannelList (e.g. Madurai) and caused guest cart to disappear.
      // We no longer fetch/set channel on login so the user stays in the same channel they were in.

      // 3️⃣ Mark user as logged in and reset form
      setLoggedIn(true);
      resetFormField();

      // 3.5️⃣ Flag new registration so homepage can show referral code dialog
      // Skip if user came from a referral deep link — referral is auto-processed.
      if (isRegistration && ReferralController.pendingReferrerId == null) {
        GetStorage().write('just_registered', true);
      }

      // 4️⃣ Claim guest cart if any, then refresh cart and customer
      await _claimGuestOrderIfAny();
      await _refreshCartAndCustomerAfterLogin();

      return true;
    } else {
      return false;
    }
  }

  /// Preserve guest channel key: when set, checkAndSetPostalCodeFromShippingAddress skips channel switch
  /// so guest cart items (in guest's channel) stay visible after login.
  static const String _preserveGuestChannelKey = 'preserve_guest_channel';

  /// Claim guest cart to logged-in customer so guest-added items appear after login.
  /// Call after setToken('auth') and before _refreshCartAndCustomerAfterLogin().
  /// NOTE: claimGuestOrder is not in live API schema (https://kaaikani.co.in/shop-api) — stub no-op.
  Future<void> _claimGuestOrderIfAny() async {
    // claimGuestOrder mutation removed from order.graphql (not in live schema)
    return;
    // final code = GraphqlService.guestOrderCode;
    // if (code.isEmpty) return;
    // try {
    //   final response = await GraphqlService.client.value.mutate$ClaimGuestOrder(
    //     Options$Mutation$ClaimGuestOrder(
    //       variables: Variables$Mutation$ClaimGuestOrder(guestOrderCode: code),
    //     ),
    //   );
    //   if (!response.hasException && response.parsedData?.claimGuestOrder != null) {
    //     await GraphqlService.clearGuestOrderCode();
    //     await _storage.write(_preserveGuestChannelKey, true);
    //   }
    // } catch (_) {}
  }

  Future<void> _refreshCartAndCustomerAfterLogin() async {
    try {
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().getActiveOrder();
      }
      if (Get.isRegistered<CustomerController>()) {
        // skipPostalCodeCheck: false → extract postal code from shipping address
        // and set channel if not already set (prevents mandatory postal code sheet after login)
        await Get.find<CustomerController>().getActiveCustomer(skipPostalCodeCheck: false);
      }
    } catch (_) {}
  }

  /// Check if the customer was just created (within last 60 seconds) and set the
  /// `just_registered` flag so homepage shows the referral code dialog.
  /// Used for Google/Apple sign-in where login and registration are the same flow.
  void _checkIfNewRegistrationAndSetFlag() {
    try {
      if (Get.isRegistered<CustomerController>()) {
        final customerController = Get.find<CustomerController>();
        final customer = customerController.activeCustomer.value;
        if (customer != null) {
          final createdAt = customer.createdAt.toLocal();
          final now = DateTime.now();
          final diff = now.difference(createdAt).inSeconds;
          // Only treat as new registration if:
          // 1. Account was created within 30 seconds (tight window)
          // 2. Customer has no orders (truly new, not an existing customer)
          // 3. User did NOT come via referral deep link (referral auto-processed)
          // 4. Customer has NOT already been referred by someone
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

  /// Step 3: Verify OTP (deprecated - use verifyOtpForLogin or verifyOtpForRegistration)
  /// Kept for backward compatibility
  @Deprecated('Use verifyOtpForLogin or verifyOtpForRegistration instead')
  Future<bool> verifyOtp(BuildContext context) async {
    // Auto-detect login vs registration based on firstName/lastName
    final firstName = firstname.text.trim();
    final lastName = lastname.text.trim();
    final isRegistration = firstName.isNotEmpty || lastName.isNotEmpty;
    
    if (isRegistration) {
      return await verifyOtpForRegistration(context);
    } else {
      return await verifyOtpForLogin(context);
    }
  }


  /// Resend OTP
  Future<bool> resendOtp(BuildContext? context) async {
    debugPrint('[AuthController] resendOtp ENTRY | $_debugState');
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.showError('Please enter a valid phone number');
      return false;
    }

    setLoading(true);
    try {
      final response = await GraphqlService.client.value.mutate$ResendPhoneOtp(
        Options$Mutation$ResendPhoneOtp(
          variables: Variables$Mutation$ResendPhoneOtp(phoneNumber: phoneNumber.text),
        ),
      );

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to resend OTP')) {
        return false;
      }

      final rawResult = response.parsedData?.resendPhoneOtp;
      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;
      if (success) {
        setOtpSent(true);
        debugPrint('[AuthController] resendOtp success | $_debugState');
        await Future.delayed(Duration(milliseconds: 100));
        SnackBarWidget.showSuccess('OTP resent successfully!');
        await Future.delayed(Duration(milliseconds: 200));
      } else {
        ErrorDialog.showError('Failed to resend OTP');
      }
      debugPrint('[AuthController] resendOtp EXIT success=$success | $_debugState');
      return success;

    } catch (e) {
      debugPrint('[AuthController] resendOtp EXIT exception: $e | $_debugState');
      handleException(e, customErrorMessage: 'Failed to resend OTP');
      return false;
    } finally {
          Logger.logFunction(functionName: 'logout', mutationName: 'LogoutUser');
      setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    isLoggingOut = true;
    setLoading(true);
    try {
      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      if (response.hasException) {
      } else {
        final success = response.parsedData?.logout.success ?? false;
        if (success) {
        } else {
        }
      }
      // Clear all stored data and cache
      await _clearAllAppData();
      // Reset analytics data
      await AnalyticsService().resetAnalytics();
      // Reset auth state
      setLoggedIn(false);
      setOtpSent(false);
      resetFormField();
      SnackBarWidget.showSuccess('Logged out successfully');
      // Navigate to home page (not login) after this frame so no other controller can redirect to login first
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.home);
        // Keep isLoggingOut true briefly so any session-expiry logic on home still redirects to home, not login
        Future.delayed(const Duration(milliseconds: 800), () {
          isLoggingOut = false;
        });
      });
    } catch (e) {
      // Don't show error dialog for logout - just log it
      // Still try to clear data even if logout mutation failed
      try {
        await _clearAllAppData();
        setLoggedIn(false);
        setOtpSent(false);
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

        if (Get.isRegistered<BannerController>()) {
          final bannerController = Get.find<BannerController>();
          bannerController.availableCouponCodes.clear();
          bannerController.couponCodesLoaded.value = false;
          bannerController.appliedCouponCodes.clear();
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

    phoneNumber.clear();
    otpController.clear();
    setOtpSent(false);
  }

  /// Complete login flow: check phone -> send OTP
  Future<bool> startLoginFlow(BuildContext? context) async {
    debugPrint('[AuthController] startLoginFlow ENTRY | $_debugState');
    final result = await sendOtp(context, isLogin: true);
    debugPrint('[AuthController] startLoginFlow EXIT result=$result | $_debugState');
    return result;
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
    _appleLog('1. Request', {'scopes': 'email, fullName', 'state': _debugState});
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
      _appleLog('finally', {'state': _debugState});
    }
  }

  @override
  void onClose() {
    firstname.dispose();
    lastname.dispose();
    phoneNumber.dispose();
    otpController.dispose();
    super.onClose();
  }
}
