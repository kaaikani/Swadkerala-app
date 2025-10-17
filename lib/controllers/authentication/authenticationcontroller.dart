import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/graphql_client.dart';
import '../../theme/colors.dart';
import '../../widgets/snackbar.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'authenticationmodels.dart';
import '../../graphql/authenticate.graphql.dart';

class AuthController extends GetxController {
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
  final RxBool _isLoading = false.obs;
  final RxString _currentChannelCode = ''.obs;
  final RxString _currentChannelToken = ''.obs;
  
  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isOtpSent => _isOtpSent.value;
  bool get isLoading => _isLoading.value;
  String get currentChannelCode => _currentChannelCode.value;
  String get currentChannelToken => _currentChannelToken.value;
  
  // Setters
  void setLoggedIn(bool value) => _isLoggedIn.value = value;
  void setOtpSent(bool value) => _isOtpSent.value = value;
  void setLoading(bool value) => _isLoading.value = value;
  void setChannelCode(String value) => _currentChannelCode.value = value;
  void setChannelToken(String value) => _currentChannelToken.value = value;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    try {
      final box = GetStorage();
      final token = box.read('auth_token') ?? '';
      if (token.isNotEmpty) {
        setLoggedIn(true);
        debugPrint('[AuthController] User already logged in');
      } else {
        setLoggedIn(false);
      }
    } catch (e) {
      debugPrint('[AuthController] Error checking login status: $e');
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
  Future<bool> checkEmailAndGetChannel(BuildContext context) async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.show(
        context,
        'Please enter a valid Phone number',
        backgroundColor: AppColors.error,
      );
      return false;
    }

    setLoading(true);
    final domain = dotenv.env['EMAIL_DOMAIN'] ?? '@kaikani.com';
    final email = '${phoneNumber.text}$domain';

    debugPrint('[AuthController] Using email: $email');

    try {
      final response = await GraphqlService.client.value.query$GetChannelsByCustomerEmail(
        Options$Query$GetChannelsByCustomerEmail(
          variables: Variables$Query$GetChannelsByCustomerEmail(email: email),
        ),
      );

      if (response.hasException) {
        final msg = response.exception!.graphqlErrors.isNotEmpty
            ? response.exception!.graphqlErrors.first.message
            : 'Failed to check Phone number';
        debugPrint('[AuthController] Error checking email: $msg');
        SnackBarWidget.show(context, msg, backgroundColor: AppColors.error);
        return false;
      }

      final modelResponse = ChannelsByEmailResponse.fromJson(response.parsedData?.toJson() ?? {});
      final channels = modelResponse.getChannelsByCustomerEmail;

      debugPrint('[AuthController] Channels found: ${channels.length}');

      if (channels.isEmpty) {
        SnackBarWidget.show(context, 'Kindly register', backgroundColor: AppColors.error);
        return false;
      }

      final channel = channels.first;
      setChannelCode(channel.code);
      setChannelToken(channel.token);

      await _storage.write('channel_code', channel.code);
      await _storage.write('channel_token', channel.token);
      await GraphqlService.setToken(key: 'channel', token: channel.token);

      debugPrint('[AuthController] Channel saved - Code: ${channel.code}, Token: ${channel.token}');
      SnackBarWidget.show(context, 'Phone number verified!', backgroundColor: AppColors.accent);

      return true;
    } catch (e, stack) {
      debugPrint('[AuthController] Exception in checkEmailAndGetChannel: $e');
      debugPrint('[AuthController] Stack trace: $stack');
      SnackBarWidget.show(context, 'Unexpected error occurred', backgroundColor: AppColors.error);
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Check if user exists (for signup - silent check without snackbars)
  Future<bool> checkUserExists() async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      return false;
    }

    setLoading(true);
    final domain = dotenv.env['EMAIL_DOMAIN'] ?? '@kaikani.com';
    final email = '${phoneNumber.text}$domain';

    debugPrint('[AuthController] Checking if user exists with email: $email');

    try {
      // First, clear any channel token to search across ALL channels
      final originalChannelToken = GraphqlService.channelToken;
      await GraphqlService.setToken(key: 'channel', token: originalChannelToken);
      debugPrint('[AuthController] Cleared channel token for global search');

      final response = await GraphqlService.client.value.query$GetChannelsByCustomerEmail(
        Options$Query$GetChannelsByCustomerEmail(
          variables: Variables$Query$GetChannelsByCustomerEmail(email: email),
        ),
      );

      // Restore original channel token
      if (originalChannelToken.isNotEmpty) {
        await GraphqlService.setToken(key: 'channel', token: originalChannelToken);
        debugPrint('[AuthController] Restored channel token: $originalChannelToken');
      }

      if (response.hasException) {
        debugPrint('[AuthController] Error checking user existence: ${response.exception}');
        return false; // Assume user doesn't exist on error
      }

      final modelResponse = ChannelsByEmailResponse.fromJson(response.parsedData?.toJson() ?? {});
      final channels = modelResponse.getChannelsByCustomerEmail;

      debugPrint('[AuthController] User exists check - Channels found: ${channels.length}');
      if (channels.isNotEmpty) {
        debugPrint('[AuthController] Channel details: ${channels.map((c) => '${c.code}:${c.token}').join(', ')}');
      }

      if (channels.isEmpty) {
        return false; // User doesn't exist
      }

      // User exists - save their channel info
      final channel = channels.first;
      setChannelCode(channel.code);
      setChannelToken(channel.token);

      debugPrint('[AuthController] User exists in channel: ${channel.code}');
      return true; // User exists
    } catch (e, stack) {
      debugPrint('[AuthController] Exception checking user existence: $e');
      debugPrint('[AuthController] Stack trace: $stack');
      return false; // Assume user doesn't exist on error
    } finally {
      setLoading(false);
    }
  }

  /// Step 2: Send OTP after channel verification
  Future<bool> sendOtp(BuildContext context)
  async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.show(context, 'Please enter a valid phone number', backgroundColor: AppColors.error);
      return false;
    }

    setLoading(true);
    debugPrint('[AuthController] Sending OTP to: ${phoneNumber.text}');

    try {
      final response = await GraphqlService.client.value.mutate$SendPhoneOtp(
        Options$Mutation$SendPhoneOtp(
          variables: Variables$Mutation$SendPhoneOtp(phoneNumber: phoneNumber.text),
        ),
      );

      if (response.hasException) {
        final msg = response.exception!.graphqlErrors.isNotEmpty
            ? response.exception!.graphqlErrors.first.message
            : 'Failed to send OTP';
        debugPrint('[AuthController] Error sending OTP: $msg');
        SnackBarWidget.show(context, msg, backgroundColor: AppColors.error);
        return false;
      }

      // Debug: Log the raw response data
      final rawResult = response.parsedData?.sendPhoneOtp;
      debugPrint('[AuthController] Raw sendPhoneOtp value: $rawResult (type: ${rawResult.runtimeType})');

      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;

      if (success) {
        setOtpSent(true);
        debugPrint('[AuthController] OTP sent successfully');
        SnackBarWidget.show(context, 'OTP sent successfully!', backgroundColor: AppColors.accent);
        return true;
      } else {
        debugPrint('[AuthController] OTP send failed - raw value: $rawResult');
        SnackBarWidget.show(context, 'Failed to send OTP', backgroundColor: AppColors.error);
        return false;
      }

    } catch (e, stack) {
      debugPrint('[AuthController] Exception in sendOtp: $e');
      debugPrint(stack.toString());
      SnackBarWidget.show(context, 'Unexpected error occurred', backgroundColor: AppColors.error);
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Step 3: Verify OTP and complete login
  Future<bool> verifyOtp(BuildContext context) async {
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
    debugPrint('[AuthController] Verifying OTP: ${otpController.text}');

    try {
      // Trim first and last name
      final firstName = firstname.text.trim();
      final lastName = lastname.text.trim();

      // Perform OTP verification mutation
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
      if (response.hasException) {
        final msg = response.exception!.graphqlErrors.isNotEmpty
            ? response.exception!.graphqlErrors.first.message
            : 'OTP verification failed';
        debugPrint('[AuthController] Error verifying OTP: $msg');
        SnackBarWidget.show(context, msg, backgroundColor: AppColors.error);
        return false;
      }

      final data = response.parsedData?.authenticate;

      // OTP verified successfully
      if (data is Mutation$Authenticate$authenticate$$CurrentUser) {
        // Extract auth token from response headers
        final authToken = response.context.entry<HttpLinkResponseContext>()
            ?.headers?['vendure-auth-token'];

        if (authToken != null && authToken.isNotEmpty) {
          // 1️⃣ Save auth token
          await GraphqlService.setToken(key: 'auth', token: authToken);

          // 2️⃣ Fetch channels for this user using email
          final channelFetched = await checkEmailAndGetChannel(context);

          if (!channelFetched) {
            // Channel fetch failed
            return false;
          }

          // 3️⃣ Mark user as logged in and reset form
          setLoggedIn(true);
          resetFormField();

          debugPrint('[AuthController] Login successful');
          SnackBarWidget.show(
            context,
            'Login successful!',
            backgroundColor: AppColors.accent,
          );
          return true;
        }
      }

      // Handle invalid credentials
      if (data is Mutation$Authenticate$authenticate$$InvalidCredentialsError) {
        SnackBarWidget.show(context, data.message, backgroundColor: AppColors.error);
        return false;
      }

      // Fallback error
      SnackBarWidget.show(context, 'OTP verification failed', backgroundColor: AppColors.error);
      return false;

    } catch (e, stack) {
      debugPrint('[AuthController] Exception in verifyOtp: $e');
      debugPrint(stack.toString());
      SnackBarWidget.show(context, 'Unexpected error occurred', backgroundColor: AppColors.error);
      return false;
    } finally {
      setLoading(false);
    }
  }


  /// Resend OTP
  Future<bool> resendOtp(BuildContext context) async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.show(context, 'Please enter a valid phone number', backgroundColor: AppColors.error);
      return false;
    }

    setLoading(true);
    debugPrint('[AuthController] Resending OTP to: ${phoneNumber.text}');

    try {
      final response = await GraphqlService.client.value.mutate$ResendPhoneOtp(
        Options$Mutation$ResendPhoneOtp(
          variables: Variables$Mutation$ResendPhoneOtp(phoneNumber: phoneNumber.text),
        ),
      );

      if (response.hasException) {
        final msg = response.exception!.graphqlErrors.isNotEmpty
            ? response.exception!.graphqlErrors.first.message
            : 'Failed to resend OTP';
        debugPrint('[AuthController] Error resending OTP: $msg');
        SnackBarWidget.show(context, msg, backgroundColor: AppColors.error);
        return false;
      }

      final rawResult = response.parsedData?.resendPhoneOtp;
      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;
      debugPrint('[AuthController] OTP resend result: $success');

      SnackBarWidget.show(
        context,
        success ? 'OTP resent successfully!' : 'Failed to resend OTP',
        backgroundColor: success ? AppColors.accent : AppColors.error,
      );

      return success;

    } catch (e, stack) {
      debugPrint('[AuthController] Exception in resendOtp: $e');
      debugPrint(stack.toString());
      SnackBarWidget.show(context, 'Unexpected error occurred', backgroundColor: AppColors.error);
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    setLoading(true);
    debugPrint('[AuthController] Logging out user');

    try {
      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      if (response.hasException) {
        debugPrint('[AuthController] Logout error: ${response.exception}');
      } else {
        final success = response.parsedData?.logout.success ?? false;
        debugPrint('[AuthController] Logout result: $success');
      }

      // Clear all stored data
      await GraphqlService.clearToken('auth');
      await _storage.remove('channel_code');
      await _storage.remove('channel_token');

      // Reset auth state
      setLoggedIn(false);
      setOtpSent(false);
      setChannelCode('');
      setChannelToken('');
      resetFormField();

      debugPrint('[AuthController] User logged out successfully');
      SnackBarWidget.show(context, 'Logged out successfully', backgroundColor: AppColors.accent);

      // Navigate to login page
      Future.microtask(() => Get.offAllNamed('/login'));

    } catch (e, stack) {
      debugPrint('[AuthController] Exception in logout: $e');
      debugPrint(stack.toString());
      SnackBarWidget.show(context, 'Unexpected error occurred', backgroundColor: AppColors.error);
    } finally {
      setLoading(false);
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
  Future<bool> startLoginFlow(BuildContext context) async {
    // First check if phone exists and get channel
    final phoneCheck = await checkEmailAndGetChannel(context);
    if (!phoneCheck) {
      return false;
    }
    
    // Then send OTP
    return await sendOtp(context);
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

