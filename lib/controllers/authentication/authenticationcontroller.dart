import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/graphql_client.dart';
import '../../services/channel_service.dart';
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
import '../../utils/logger.dart';

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

  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isOtpSent => _isOtpSent.value;
  bool get isLoading => utilityController.isLoading;

  // Setters
  void setLoggedIn(bool value) => _isLoggedIn.value = value;
  void setOtpSent(bool value) => _isOtpSent.value = value;
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
    final domain = dotenv.env['EMAIL_DOMAIN'] ?? '@kaikani.com';
    final email = '${phoneNumber.text}$domain';
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
    final domain = dotenv.env['EMAIL_DOMAIN'] ?? '@kaikani.com';
    final email = '${phoneNumber.text}$domain';
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
      return false;
    }

    try {
      final response = await GraphqlService.client.value.query$GetChannelsByCustomerPhoneNumber(
        Options$Query$GetChannelsByCustomerPhoneNumber(
          variables: Variables$Query$GetChannelsByCustomerPhoneNumber(
            phoneNumber: phoneNumber.text,
          ),
        ),
      );
      if (response.hasException) {
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          for (int i = 0; i < response.exception!.graphqlErrors.length; i++) {
            final error = response.exception!.graphqlErrors[i];
          }
        }
        if (response.exception?.linkException != null) {
        }
      }

      // Check for "Customer not found" or "Customer is not registered" error
      // This is expected during registration, but should show error during login
      bool isCustomerNotFoundError = false;
      if (response.hasException && response.exception?.graphqlErrors.isNotEmpty == true) {
        final errorMessages = response.exception!.graphqlErrors
            .map((e) => e.message.toLowerCase())
            .toList();
        isCustomerNotFoundError = errorMessages.any((msg) => 
          msg.contains('customer not found') || 
          msg.contains('not found with phone') ||
          msg.contains('customer is not registered') ||
          msg.contains('not registered') ||
          msg.contains('is not registered'));
        
        if (isCustomerNotFoundError) {
          if (!isLogin) {
            // For registration, "customer not found/not registered" is expected - proceed with OTP
            return true;
          } else {
            // For login, "customer not registered" means account doesn't exist - show error
            ErrorDialog.showError('No account found with this phone number. Please register first.');
            return false;
          }
        }
      }

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to check channels')) {
        return false;
      }

      final channels = response.parsedData?.getChannelsByCustomerPhoneNumber ?? [];
      if (channels.isNotEmpty) {
        for (int i = 0; i < channels.length; i++) {
          final channel = channels[i];
        }
      } else {
      }

      if (isLogin) {
        // For login: channel must exist
        if (channels.isEmpty) {
          ErrorDialog.showError('No account found with this phone number. Please register first.');
          return false;
        }
        // Channel exists, proceed with OTP
        return true;
      } else {
        // For register: if channels exist, show error. If empty, proceed (kindly register)
        if (channels.isNotEmpty) {
          ErrorDialog.showError('An account already exists with this phone number. Please login instead.');
          return false;
        }
        // No channels found, proceed with registration OTP
        return true;
      }
    } catch (e, stackTrace) {
      handleException(e, customErrorMessage: 'Failed to check phone number', functionName: 'checkChannelsByPhoneNumber');
      return false;
    }
  }

  /// Step 2: Send OTP after channel verification
  Future<bool> sendOtp(BuildContext? context, {bool isLogin = false}) async {
    Logger.logFunction(functionName: 'sendOtp', mutationName: 'SendPhoneOtp');
    
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.showError('Please enter a valid phone number');
      return false;
    }

    // Check channels before sending OTP
    final canProceed = await checkChannelsByPhoneNumber(isLogin: isLogin);
    if (!canProceed) {
      return false;
    }

    setLoading(true);
    try {
      final response = await GraphqlService.client.value.mutate$SendPhoneOtp(
        Options$Mutation$SendPhoneOtp(
          variables: Variables$Mutation$SendPhoneOtp(phoneNumber: phoneNumber.text),
        ),
      );

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to send OTP')) {
        return false;
      }

      // Debug: Log the raw response data
      final rawResult = response.parsedData?.sendPhoneOtp;

      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;

      if (success) {
        // Set OTP sent flag first to trigger UI update
        setOtpSent(true);
        // Wait a moment to ensure UI updates, then show success message
        await Future.delayed(Duration(milliseconds: 100));
        
        // Show success message
        SnackBarWidget.showSuccess('OTP sent successfully!');
        
        // Ensure UI has time to update and show OTP field
        await Future.delayed(Duration(milliseconds: 200));
        
        return true;
      } else {
        ErrorDialog.showError('Failed to send OTP');
        return false;
      }

    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to send OTP', functionName: 'sendOtp');
      return false;
    } finally {
      setLoading(false);
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
      // Perform OTP verification mutation for login (no firstName/lastName)
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

    } catch (e, stackTrace) {
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

    } catch (e, stackTrace) {
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
      // 2️⃣ Fetch channels for this user using email (only for login, not registration)
      if (!isRegistration) {
        // For login: Fetch channels for this user using email
        // For new registrations, channels might not be immediately available, so skip
        bool channelFetched = false;
        for (int i = 0; i < 3; i++) {
          channelFetched = await checkEmailAndGetChannel(context);
          if (channelFetched) break;
          if (i < 2) {
            // Wait before retry (only for first 2 attempts)
            await Future.delayed(Duration(milliseconds: 500));
          }
        }

        if (!channelFetched) {
          ErrorDialog.showError('Login successful, but there was an issue loading your account. Please try again.');
          return false;
        }
      } else {
      }

      // 3️⃣ Mark user as logged in and reset form
      setLoggedIn(true);
      resetFormField();
      return true;
    } else {
      return false;
    }
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
        // Ensure OTP sent flag is set (in case it was reset)
        setOtpSent(true);
        
        // Wait a moment to ensure UI updates
        await Future.delayed(Duration(milliseconds: 100));
        
        // Show success message
        SnackBarWidget.showSuccess('OTP resent successfully!');
        
        // Ensure UI has time to update and show OTP field
        await Future.delayed(Duration(milliseconds: 200));
      } else {
        ErrorDialog.showError('Failed to resend OTP');
      }

      return success;

    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to resend OTP');
      return false;
    } finally {
          Logger.logFunction(functionName: 'logout', mutationName: 'LogoutUser');
      setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
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
      // Navigate to login page
      Future.microtask(() {
        Get.offAllNamed('/login');
      });
    } catch (e, stackTrace) {
      // Don't show error dialog for logout - just log it
      // Still try to clear data even if logout mutation failed
      try {
        await _clearAllAppData();
        setLoggedIn(false);
        setOtpSent(false);
        resetFormField();
        Future.microtask(() => Get.offAllNamed('/login'));
      } catch (cleanupError) {
      }
    } finally {
      setLoading(false);
    }
  }

  /// Clear all app data and cache
  Future<void> _clearAllAppData() async {
    try {
      // Clear GraphQL tokens (this also recreates the client)
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      // Clear Flutter image cache
      try {
        imageCache.clear();
        imageCache.clearLiveImages();
      } catch (e) {
      }

      // Clear all storage data (preserve landing page cache: postal_code, channel_code, channel_name, channel_type)
      // Preserve landing page cache keys for better user experience
      final preservedPostalCode = _storage.read('postal_code');
      final preservedChannelCode = _storage.read('channel_code');
      final preservedChannelName = _storage.read('channel_name');
      final preservedChannelType = _storage.read('channel_type');
      
      await _storage.remove('auth_token');
      await _storage.remove('channel_token');
      // Keep channel_code for landing page
      // await _storage.remove('channel_code');
      await _storage.remove('user_data');
      await _storage.remove('customer_data');
      await _storage.remove('cart_data');
      await _storage.remove('favorites_data');
      await _storage.remove('order_data');
      await _storage.remove('loyalty_points');
      await _storage.remove('app_settings');
      await _storage.remove('intro_shown');
      await _storage.remove('active_customer');
      await _storage.remove('customer_addresses');
      await _storage.remove('customer_orders');
      await _storage.remove('coupon_codes');
      await _storage.remove('banner_data');
      await _storage.remove('collection_data');
      await _storage.remove('product_data');
      await _storage.remove('search_history');
      await _storage.remove('notification_data');
      await _storage.remove('preferences');
      await _storage.remove('session_data');
      await _storage.remove('temp_data');
      await _storage.remove('cache_data');
      await _storage.remove('offline_data');
      await _storage.remove('sync_data');
      await _storage.remove('analytics_data');
      await _storage.remove('debug_data');
      await _storage.remove('error_logs');
      await _storage.remove('performance_data');
      await _storage.remove('user_activity');
      await _storage.remove('device_info');
      await _storage.remove('app_version');
      await _storage.remove('last_sync');
      await _storage.remove('background_sync');
      await _storage.remove('push_tokens');
      await _storage.remove('location_data');
      await _storage.remove('permissions');
      await _storage.remove('settings');
      await _storage.remove('theme_data');
      await _storage.remove('language');
      await _storage.remove('currency');
      await _storage.remove('timezone');
      await _storage.remove('locale');
      await _storage.remove('country');
      await _storage.remove('region');
      await _storage.remove('city');
      // Keep postal_code for landing page
      // await _storage.remove('postal_code');
      await _storage.remove('phone_verified');
      await _storage.remove('email_verified');
      await _storage.remove('profile_complete');
      await _storage.remove('onboarding_complete');
      await _storage.remove('tutorial_shown');
      await _storage.remove('help_shown');
      await _storage.remove('tips_shown');
      await _storage.remove('updates_shown');
      await _storage.remove('news_shown');
      await _storage.remove('promotions_shown');
      await _storage.remove('offers_shown');
      await _storage.remove('deals_shown');
      await _storage.remove('sales_shown');
      await _storage.remove('events_shown');
      await _storage.remove('announcements_shown');
      await _storage.remove('notifications_shown');
      await _storage.remove('alerts_shown');
      await _storage.remove('warnings_shown');
      await _storage.remove('errors_shown');
      await _storage.remove('success_shown');
      await _storage.remove('info_shown');
      await _storage.remove('debug_shown');
      await _storage.remove('trace_shown');
      await _storage.remove('verbose_shown');
      await _storage.remove('detailed_shown');
      await _storage.remove('comprehensive_shown');
      await _storage.remove('complete_shown');
      await _storage.remove('full_shown');
      await _storage.remove('total_shown');
      await _storage.remove('entire_shown');
      await _storage.remove('whole_shown');
      await _storage.remove('all_shown');
      await _storage.remove('everything_shown');
      await _storage.remove('complete_data');
      await _storage.remove('full_data');
      await _storage.remove('total_data');
      await _storage.remove('entire_data');
      await _storage.remove('whole_data');
      await _storage.remove('all_data');
      await _storage.remove('everything_data');
      await _storage.remove('complete_cache');
      await _storage.remove('full_cache');
      await _storage.remove('total_cache');
      await _storage.remove('entire_cache');
      await _storage.remove('whole_cache');
      await _storage.remove('all_cache');
      await _storage.remove('everything_cache');
      await _storage.remove('complete_storage');
      await _storage.remove('full_storage');
      await _storage.remove('total_storage');
      await _storage.remove('entire_storage');
      await _storage.remove('whole_storage');
      await _storage.remove('all_storage');
      await _storage.remove('everything_storage');
      // Don't use erase() - preserve landing page cache
      // Instead, manually remove all keys except preserved ones
      // Restore preserved landing page cache if they existed
      if (preservedPostalCode != null) {
        await _storage.write('postal_code', preservedPostalCode);
      }
      if (preservedChannelCode != null) {
        await _storage.write('channel_code', preservedChannelCode);
      }
      if (preservedChannelName != null) {
        await _storage.write('channel_name', preservedChannelName);
      }
      if (preservedChannelType != null) {
        await _storage.write('channel_type', preservedChannelType);
      }
      // Clear any GetX controllers that might have cached data
      try {
        // Clear customer controller data
        if (Get.isRegistered<CustomerController>()) {
          final customerController = Get.find<CustomerController>();
          customerController.activeCustomer.value = null;
          customerController.addresses.clear();
          customerController.orders.clear();
          customerController.isEditingProfile.value = false;
        } else {
        }

        // Clear cart controller data
        if (Get.isRegistered<CartController>()) {
          final cartController = Get.find<CartController>();
          cartController.clearCart();
        } else {
        }

        // Clear banner controller data
        if (Get.isRegistered<BannerController>()) {
          final bannerController = Get.find<BannerController>();
          bannerController.availableCouponCodes.clear();
          bannerController.couponCodesLoaded.value = false;
          bannerController.appliedCouponCodes.clear();
        } else {
        }

        // Clear order controller data
        if (Get.isRegistered<OrderController>()) {
        } else {
        }

        // Clear utility controller data
        if (Get.isRegistered<UtilityController>()) {
          final utilityController = Get.find<UtilityController>();
          utilityController.setLoadingState(false);
        } else {
        }

      } catch (controllerError) {
      }
    } catch (e, stackTrace) {
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
    // Send OTP with login flag - channel check is done inside sendOtp
    return await sendOtp(context, isLogin: true);
  }

  /// Google Sign In and authenticate
  Future<bool> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      // Get Google Client ID from .env
      final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];
      if (googleClientId == null || googleClientId.isEmpty) {
        ErrorDialog.showError('Google Client ID not configured');
        return false;
      }
      final clientIdPreview = googleClientId.length > 20
          ? '${googleClientId.substring(0, 20)}...'
          : googleClientId;
      // Initialize Google Sign In
      // serverClientId is required to get ID token for backend verification
      // This should be a Web OAuth client ID from the same Google Cloud project
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleClientId, // Web OAuth client ID for ID token
        // Android OAuth client (with SHA-1) is used automatically from google-services.json
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
      final String? accessToken = googleAuth.accessToken;
      if (idToken == null || idToken.isEmpty) {
        ErrorDialog.showError('Failed to get Google ID token');
        return false;
      }

      // Step 3: Flutter sends idToken to backend
      // Step 4: Backend verifies token using Google public keys (backend logic)
      // Step 5: Backend creates its own session / JWT

      // Authenticate with backend using the ID token
      final response = await GraphqlService.client.value.mutate$LoginWithGoogle(
        Options$Mutation$LoginWithGoogle(
          variables: Variables$Mutation$LoginWithGoogle(token: idToken),
        ),
      );
      // Handle GraphQL errors
      if (response.hasException) {
        if (response.exception?.graphqlErrors != null) {
          for (final error in response.exception!.graphqlErrors) {
          }
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
          // 2️⃣ Fetch channels for this user
          bool channelFetched = false;
          for (int i = 0; i < 3; i++) {
            try {
              final channelResponse = await GraphqlService.client.value.query$GetChannelList(
                Options$Query$GetChannelList(),
              );
              if (checkResponseForErrors(channelResponse, customErrorMessage: 'Failed to get channels')) {
                if (i < 2) {
                  await Future.delayed(Duration(milliseconds: 500));
                  continue;
                }
                break;
              }

              final modelResponse = channelResponse.parsedData;
              final channels = modelResponse?.getChannelList ?? [];
              if (channels.isNotEmpty) {
                final channel = channels.first;
                await _storage.write('channel_code', channel.code);
                await _storage.write('channel_token', channel.token);
                await GraphqlService.setToken(key: 'channel', token: channel.token);
                channelFetched = true;
                final tokenPreview = channel.token.length > 20
                    ? '${channel.token.substring(0, 20)}...'
                    : channel.token;
                break;
              } else {
                if (i < 2) {
                  await Future.delayed(Duration(milliseconds: 500));
                  continue;
                }
              }
            } catch (e, stackTrace) {
              if (i < 2) {
                await Future.delayed(Duration(milliseconds: 500));
                continue;
              }
            }
          }

          if (!channelFetched) {
            ErrorDialog.showError(
              'Authentication successful, but there was an issue setting up your account. Please try again.',
            );
            return false;
          }

          // 3️⃣ Mark user as logged in
          setLoggedIn(true);
          resetFormField();
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

    } catch (e, stackTrace) {
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

      // For other errors, show error dialog
      handleException(e, customErrorMessage: 'Google sign in failed');
      return false;
    } finally {
      setLoading(false);
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
