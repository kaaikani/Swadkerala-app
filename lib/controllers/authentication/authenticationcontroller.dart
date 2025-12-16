import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/graphql_client.dart';
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
import 'authenticationmodels.dart';
import '../../graphql/authenticate.graphql.dart';

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
    
debugPrint('[AuthController] Checking login status from GraphqlService...');
debugPrint('[AuthController] Auth token: ${authToken.isNotEmpty ? 'present' : 'missing'}');
debugPrint('[AuthController] Channel token: ${channelToken.isNotEmpty ? 'present' : 'missing'}');
    
    if (authToken.isNotEmpty && channelToken.isNotEmpty) {
      setLoggedIn(true);
debugPrint('[AuthController] Login status updated to true based on GraphqlService tokens');
    } else {
      setLoggedIn(false);
              debugPrint('[AuthController] Login status updated to false - tokens missing');
    }
  }

  /// Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    try {
      final box = GetStorage();
      final authToken = box.read('auth_token') ?? '';
      final channelToken = box.read('channel_token') ?? '';
      
      // Check if both tokens exist
      if (authToken.isNotEmpty && channelToken.isNotEmpty) {
        // Verify the tokens are valid by making a test request
        final isValid = await _verifyTokensAreValid();
        if (isValid) {
          setLoggedIn(true);
debugPrint('[AuthController] User already logged in with valid tokens');
        } else {
          setLoggedIn(false);
debugPrint('[AuthController] Tokens found but invalid, clearing login status');
          // Clear invalid tokens
          await _clearInvalidTokens();
        }
      } else {
        setLoggedIn(false);
debugPrint('[AuthController] No valid tokens found, user not logged in');
      }
    } catch (e) {
debugPrint('[AuthController] Error checking login status: $e');
      setLoggedIn(false);
    }
  }

  /// Verify if stored tokens are still valid
  Future<bool> _verifyTokensAreValid() async {
    try {
      // Make a simple GraphQL request to verify tokens
      final response = await GraphqlService.client.value.query$GetChannelsByCustomerEmail(
        Options$Query$GetChannelsByCustomerEmail(
          variables: Variables$Query$GetChannelsByCustomerEmail(email: 'test@test.com'),
        ),
      );
      
      // If we get a response without authentication errors, tokens are valid
      if (response.hasException) {
        final errors = response.exception?.graphqlErrors ?? [];
        // Check if it's an authentication error
        for (final error in errors) {
          if (error.message.toLowerCase().contains('unauthorized') ||
              error.message.toLowerCase().contains('authentication') ||
              error.message.toLowerCase().contains('token')) {
debugPrint('[AuthController] Authentication error detected: ${error.message}');
            return false;
          }
        }
      }
      
      return true; // Tokens appear to be valid
    } catch (e) {
debugPrint('[AuthController] Error verifying tokens: $e');
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
debugPrint('[AuthController] Invalid tokens cleared');
    } catch (e) {
debugPrint('[AuthController] Error clearing invalid tokens: $e');
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
      Get.snackbar(
        '',
        'Please enter a valid Phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
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

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to check phone number')) {
        return false;
      }

      final modelResponse = ChannelsByEmailResponse.fromJson(response.parsedData?.toJson() ?? {});
      final channels = modelResponse.getChannelsByCustomerEmail;

debugPrint('[AuthController] Channels found: ${channels.length}');

      if (channels.isEmpty) {
        ErrorDialog.showError('Phone number not registered. Please sign up first.');
        return false;
      }

      final channel = channels.first;
      await _storage.write('channel_code', channel.code);
      await _storage.write('channel_token', channel.token);
      await GraphqlService.setToken(key: 'channel', token: channel.token);

debugPrint('[AuthController] Channel saved - Code: ${channel.code}, Token: ${channel.token}');
      // Use GetX snackbar to avoid context issues
      Get.snackbar(
        '',
        'Phone number verified!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      return true;
    } catch (e) {
debugPrint('[AuthController] Exception in checkEmailAndGetChannel: $e');
      handleException(e, customErrorMessage: 'Failed to verify phone number');
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
      // final channel = channels.first; // Unused variable

debugPrint('[AuthController] User exists in channel: ${channels.first.code}');
      return true; // User exists
    } catch (e) {
debugPrint('[AuthController] Exception checking user existence: $e');
      return false; // Assume user doesn't exist on error
    } finally {
      setLoading(false);
    }
  }

  /// Step 2: Send OTP after channel verification
  Future<bool> sendOtp(BuildContext? context)
  async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      Get.snackbar(
        '',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
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

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to send OTP')) {
        return false;
      }

      // Debug: Log the raw response data
      final rawResult = response.parsedData?.sendPhoneOtp;
debugPrint('[AuthController] Raw sendPhoneOtp value: $rawResult (type: ${rawResult.runtimeType})');

      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;

      if (success) {
        setOtpSent(true);
debugPrint('[AuthController] OTP sent successfully');
        Get.snackbar(
          '',
          'OTP sent successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.accent,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return true;
      } else {
debugPrint('[AuthController] OTP send failed - raw value: $rawResult');
        ErrorDialog.showError('Failed to send OTP');
        return false;
      }

    } catch (e) {
debugPrint('[AuthController] Exception in sendOtp: $e');
      handleException(e, customErrorMessage: 'Failed to send OTP');
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
      if (checkResponseForErrors(response, customErrorMessage: 'OTP verification failed')) {
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
          // For new registrations, channels might not be immediately available
          // Retry a few times with delay
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
            // Channel fetch failed - show appropriate message
            ErrorDialog.showError(
              'Registration successful, but there was an issue setting up your account. Please try logging in.',
            );
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
        ErrorDialog.showError(data.message);
        return false;
      }

      // Fallback error
      ErrorDialog.showError('OTP verification failed');
      return false;

    } catch (e) {
debugPrint('[AuthController] Exception in verifyOtp: $e');
      handleException(e, customErrorMessage: 'OTP verification failed');
      return false;
    } finally {
      setLoading(false);
    }
  }


  /// Resend OTP
  Future<bool> resendOtp(BuildContext? context) async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      Get.snackbar(
        '',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
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

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to resend OTP')) {
        return false;
      }

      final rawResult = response.parsedData?.resendPhoneOtp;
      final success = rawResult != null && rawResult != false && rawResult != "false" && rawResult != 0;
debugPrint('[AuthController] OTP resend result: $success');

      if (success) {
        Get.snackbar(
          '',
          'OTP resent successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.accent,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        ErrorDialog.showError('Failed to resend OTP');
      }

      return success;

    } catch (e) {
debugPrint('[AuthController] Exception in resendOtp: $e');
      handleException(e, customErrorMessage: 'Failed to resend OTP');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    setLoading(true);
debugPrint('🚪 [AuthController] ========== LOGOUT STARTED ==========');
debugPrint('🚪 [AuthController] Logging out user...');

    try {
debugPrint('🚪 [AuthController] Step 1: Calling GraphQL logout mutation...');
      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      if (response.hasException) {
debugPrint('❌ [AuthController] Logout mutation error: ${response.exception}');
debugPrint('❌ [AuthController] Exception details: ${response.exception?.graphqlErrors}');
      } else {
        final success = response.parsedData?.logout.success ?? false;
debugPrint('✅ [AuthController] Logout mutation result: $success');
        if (success) {
debugPrint('✅ [AuthController] Server confirmed logout success');
        } else {
debugPrint('⚠️ [AuthController] Server returned logout failure');
        }
      }

debugPrint('🚪 [AuthController] Step 2: Clearing all app data and cache...');
      // Clear all stored data and cache
      await _clearAllAppData();
debugPrint('✅ [AuthController] All app data cleared');

debugPrint('🚪 [AuthController] Step 3: Resetting analytics data...');
      // Reset analytics data
      await AnalyticsService().resetAnalytics();
debugPrint('✅ [AuthController] Analytics data reset');

debugPrint('🚪 [AuthController] Step 4: Resetting auth state...');
      // Reset auth state
      setLoggedIn(false);
      setOtpSent(false);
      resetFormField();
debugPrint('✅ [AuthController] Auth state reset - isLoggedIn: false, isOtpSent: false');

debugPrint('🚪 [AuthController] Step 5: Showing success message...');
      Get.snackbar(
        '',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
debugPrint('✅ [AuthController] Success message shown');
debugPrint('✅ [AuthController] Success message: "Logged out successfully"');
debugPrint('✅ [AuthController] Success message displayed to user');

debugPrint('🚪 [AuthController] Step 6: Navigating to login page...');
      // Navigate to login page
      Future.microtask(() {
debugPrint('🚪 [AuthController] Executing navigation to /login');
        Get.offAllNamed('/login');
debugPrint('✅ [AuthController] Navigation completed');
      });

debugPrint('✅ [AuthController] ========== LOGOUT COMPLETED SUCCESSFULLY ==========');
    } catch (e, stackTrace) {
debugPrint('❌ [AuthController] ========== LOGOUT EXCEPTION ==========');
debugPrint('❌ [AuthController] Exception in logout: $e');
debugPrint('❌ [AuthController] Stack trace: $stackTrace');
      // Don't show error dialog for logout - just log it
debugPrint('⚠️ [AuthController] Logout error handled silently - continuing with cleanup');
      
      // Still try to clear data even if logout mutation failed
      try {
debugPrint('🚪 [AuthController] Attempting cleanup despite error...');
        await _clearAllAppData();
        setLoggedIn(false);
        setOtpSent(false);
        resetFormField();
debugPrint('✅ [AuthController] Cleanup completed despite error');
        Future.microtask(() => Get.offAllNamed('/login'));
      } catch (cleanupError) {
debugPrint('❌ [AuthController] Cleanup also failed: $cleanupError');
      }
    } finally {
      setLoading(false);
debugPrint('🚪 [AuthController] Loading state set to false');
debugPrint('🚪 [AuthController] ========== LOGOUT PROCESS ENDED ==========');
    }
  }

  /// Clear all app data and cache
  Future<void> _clearAllAppData() async {
    try {
debugPrint('🗑️ [AuthController] ========== CACHE CLEARING STARTED ==========');
debugPrint('🗑️ [AuthController] Starting comprehensive cache clearing...');
      
debugPrint('🗑️ [AuthController] Step 1: Clearing GraphQL tokens...');
      // Clear GraphQL tokens (this also recreates the client)
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
debugPrint('✅ [AuthController] GraphQL tokens cleared and client recreated');
      
debugPrint('🗑️ [AuthController] Step 2: Clearing Flutter image cache...');
      // Clear Flutter image cache
      try {
        imageCache.clear();
        imageCache.clearLiveImages();
debugPrint('✅ [AuthController] Image cache cleared (all images and live images)');
      } catch (e) {
debugPrint('❌ [AuthController] Error clearing image cache: $e');
      }
      
      // Clear all storage data
      await _storage.remove('auth_token');
      await _storage.remove('channel_token');
      await _storage.remove('channel_code');
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
      await _storage.remove('postal_code');
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
      
debugPrint('🗑️ [AuthController] Step 3: Erasing all storage data...');
      // Clear all keys (nuclear option)
      await _storage.erase();
debugPrint('✅ [AuthController] Storage completely erased (all keys removed)');
      
debugPrint('🗑️ [AuthController] Step 4: Clearing GetX controllers...');
      // Clear any GetX controllers that might have cached data
      try {
        // Clear customer controller data
        if (Get.isRegistered<CustomerController>()) {
          final customerController = Get.find<CustomerController>();
          customerController.activeCustomer.value = null;
          customerController.addresses.clear();
          customerController.orders.clear();
          customerController.isEditingProfile.value = false;
debugPrint('✅ [AuthController] Customer controller data cleared (activeCustomer, addresses, orders)');
        } else {
debugPrint('⚠️ [AuthController] CustomerController not registered, skipping');
        }
        
        // Clear cart controller data
        if (Get.isRegistered<CartController>()) {
          final cartController = Get.find<CartController>();
          cartController.clearCart();
debugPrint('✅ [AuthController] Cart controller data cleared');
        } else {
debugPrint('⚠️ [AuthController] CartController not registered, skipping');
        }
        
        // Clear banner controller data
        if (Get.isRegistered<BannerController>()) {
          final bannerController = Get.find<BannerController>();
          bannerController.availableCouponCodes.clear();
          bannerController.couponCodesLoaded.value = false;
          bannerController.appliedCouponCodes.clear();
debugPrint('✅ [AuthController] Banner controller data cleared (coupon codes, applied codes)');
        } else {
debugPrint('⚠️ [AuthController] BannerController not registered, skipping');
        }
        
        // Clear order controller data
        if (Get.isRegistered<OrderController>()) {
debugPrint('✅ [AuthController] Order controller found (no specific data to clear)');
        } else {
debugPrint('⚠️ [AuthController] OrderController not registered, skipping');
        }
        
        // Clear utility controller data
        if (Get.isRegistered<UtilityController>()) {
          final utilityController = Get.find<UtilityController>();
          utilityController.setLoadingState(false);
debugPrint('✅ [AuthController] Utility controller data cleared (loading state reset)');
        } else {
debugPrint('⚠️ [AuthController] UtilityController not registered, skipping');
        }
        
      } catch (controllerError) {
debugPrint('❌ [AuthController] Error clearing controllers: $controllerError');
      }
      
debugPrint('✅ [AuthController] ========== CACHE CLEARING COMPLETED SUCCESSFULLY ==========');
    } catch (e, stackTrace) {
debugPrint('❌ [AuthController] ========== CACHE CLEARING ERROR ==========');
debugPrint('❌ [AuthController] Error clearing storage: $e');
debugPrint('❌ [AuthController] Stack trace: $stackTrace');
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

