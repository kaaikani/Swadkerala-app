import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      SnackBarWidget.showError('Please enter a valid Phone number');
      return false;
    }

    setLoading(true);
    final domain = dotenv.env['EMAIL_DOMAIN'] ?? '@kaikani.com';
    final email = '${phoneNumber.text}$domain';

debugPrint('[AuthController] Using email: $email');

    try {
      final response = await GraphqlService.client.value.query$GetChannelList(
        Options$Query$GetChannelList(),
      );

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to check phone number')) {
        return false;
      }

      final modelResponse = response.parsedData;
      final channels = modelResponse?.getChannelList ?? [];

debugPrint('[AuthController] Channels found: ${channels.length}');

      if (channels.isEmpty) {
        ErrorDialog.showError('No channels available.');
        return false;
      }

      // Use the first available channel
      final channel = channels.first;
      await _storage.write('channel_code', channel.code);
      await _storage.write('channel_token', channel.token);
      await GraphqlService.setToken(key: 'channel', token: channel.token);

debugPrint('[AuthController] Channel saved - Code: ${channel.code}, Token: ${channel.token}');
      // Use GetX snackbar to avoid context issues
      SnackBarWidget.showSuccess('Phone number verified!');

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
      final response = await GraphqlService.client.value.query$GetChannelList(
        Options$Query$GetChannelList(),
      );

      if (response.hasException) {
debugPrint('[AuthController] Error checking user existence: ${response.exception}');
        return false; // Assume user doesn't exist on error
      }

      final modelResponse = response.parsedData;
      final channels = modelResponse?.getChannelList ?? [];

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
      SnackBarWidget.showError('Please enter a valid phone number');
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

  /// Step 3: Verify OTP and complete login/registration
  /// Uses Authenticate mutation with phoneOtp input
  /// Works for both login and registration
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
    debugPrint('🔵 [PhoneAuth] ========== VERIFY OTP STARTED ==========');
    debugPrint('🔵 [PhoneAuth] Phone number: ${phoneNumber.text}');
    debugPrint('🔵 [PhoneAuth] OTP code: ${otpController.text}');

    try {
      // Trim first and last name (can be empty strings for login)
      final firstName = firstname.text.trim();
      final lastName = lastname.text.trim();
      
      debugPrint('🔵 [PhoneAuth] First name: ${firstName.isEmpty ? "(empty)" : firstName}');
      debugPrint('🔵 [PhoneAuth] Last name: ${lastName.isEmpty ? "(empty)" : lastName}');
      debugPrint('🔵 [PhoneAuth] Using Authenticate mutation with phoneOtp input');

      // Perform OTP verification mutation
      // This mutation works for both login and registration
      final response = await GraphqlService.client.value.mutate$Authenticate(
        Options$Mutation$Authenticate(
          variables: Variables$Mutation$Authenticate(
            phoneNumber: phoneNumber.text,
            code: otpController.text,
            firstName: firstName.isEmpty ? null : firstName, // Send null if empty
            lastName: lastName.isEmpty ? null : lastName,     // Send null if empty
          ),
        ),
      );
      
      debugPrint('🔵 [PhoneAuth] Mutation response received');
      debugPrint('🔵 [PhoneAuth] Response has exception: ${response.hasException}');

      // Handle GraphQL errors
      if (checkResponseForErrors(response, customErrorMessage: 'OTP verification failed')) {
        return false;
      }

      final data = response.parsedData?.authenticate;

      // OTP verified successfully
      if (data is Mutation$Authenticate$authenticate$$CurrentUser) {
        debugPrint('✅ [PhoneAuth] Authentication successful - CurrentUser received');
        debugPrint('🔵 [PhoneAuth] User ID: ${data.id}');
        debugPrint('🔵 [PhoneAuth] User identifier: ${data.identifier}');
        
        // Extract auth token from response headers
        debugPrint('🔵 [PhoneAuth] Extracting auth token from response headers...');
        final authToken = response.context.entry<HttpLinkResponseContext>()
            ?.headers?['vendure-auth-token'];

        if (authToken != null && authToken.isNotEmpty) {
          debugPrint('✅ [PhoneAuth] Auth token extracted (length: ${authToken.length})');
          
          // 1️⃣ Save auth token
          debugPrint('🔵 [PhoneAuth] Saving auth token...');
          await GraphqlService.setToken(key: 'auth', token: authToken);
          debugPrint('✅ [PhoneAuth] Auth token saved');

          // 2️⃣ Fetch channels for this user using email
          // For new registrations, channels might not be immediately available
          // Retry a few times with delay
          debugPrint('🔵 [PhoneAuth] Fetching channel information...');
          bool channelFetched = false;
          for (int i = 0; i < 3; i++) {
            debugPrint('🔵 [PhoneAuth] Channel fetch attempt ${i + 1}/3...');
            channelFetched = await checkEmailAndGetChannel(context);
            if (channelFetched) break;
            if (i < 2) {
              // Wait before retry (only for first 2 attempts)
              await Future.delayed(Duration(milliseconds: 500));
            }
          }

          if (!channelFetched) {
            debugPrint('❌ [PhoneAuth] Channel fetch failed after 3 attempts');
            // Channel fetch failed - show appropriate message
            ErrorDialog.showError(
              'Registration successful, but there was an issue setting up your account. Please try logging in.',
            );
            return false;
          }

          // 3️⃣ Mark user as logged in and reset form
          debugPrint('🔵 [PhoneAuth] Finalizing login...');
          setLoggedIn(true);
          resetFormField();

          debugPrint('✅ [PhoneAuth] ========== LOGIN/REGISTRATION SUCCESSFUL ==========');
          debugPrint('✅ [PhoneAuth] User logged in: ${isLoggedIn}');
          debugPrint('✅ [PhoneAuth] Auth token saved: ${GraphqlService.authToken.isNotEmpty}');
          debugPrint('✅ [PhoneAuth] Channel token saved: ${GraphqlService.channelToken.isNotEmpty}');

          return true;
        } else {
          debugPrint('❌ [PhoneAuth] Auth token not found in response headers');
        }
      }

      // Handle invalid credentials
      if (data is Mutation$Authenticate$authenticate$$InvalidCredentialsError) {
        debugPrint('❌ [PhoneAuth] Invalid credentials error');
        debugPrint('❌ [PhoneAuth] Error message: ${data.message}');
        ErrorDialog.showError(data.message);
        return false;
      }

      // Fallback error
      debugPrint('❌ [PhoneAuth] Unknown response type: ${data.runtimeType}');
      debugPrint('❌ [PhoneAuth] Response data: $data');
      ErrorDialog.showError('OTP verification failed');
      return false;

    } catch (e, stackTrace) {
      debugPrint('❌ [PhoneAuth] ========== EXCEPTION IN VERIFY OTP ==========');
      debugPrint('❌ [PhoneAuth] Exception: $e');
      debugPrint('❌ [PhoneAuth] Stack trace: $stackTrace');
      handleException(e, customErrorMessage: 'OTP verification failed');
      return false;
    } finally {
      setLoading(false);
      debugPrint('🔵 [PhoneAuth] Loading state set to false');
      debugPrint('🔵 [PhoneAuth] ========== VERIFY OTP PROCESS ENDED ==========');
    }
  }


  /// Resend OTP
  Future<bool> resendOtp(BuildContext? context) async {
    if (!_isValidPhoneNumber(phoneNumber.text)) {
      SnackBarWidget.showError('Please enter a valid phone number');
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
        SnackBarWidget.showSuccess('OTP resent successfully!');
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
      SnackBarWidget.showSuccess('Logged out successfully');
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

  /// Google Sign In and authenticate
  Future<bool> signInWithGoogle(BuildContext context) async {
    setLoading(true);
debugPrint('🔵 [GoogleLogin] ========== GOOGLE SIGN IN STARTED ==========');
debugPrint('🔵 [GoogleLogin] Step 1: Initializing Google Sign In...');

    try {
      // Get Google Client ID from .env
      debugPrint('🔵 [GoogleLogin] Step 2: Reading GOOGLE_CLIENT_ID from .env...');
      final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];
      if (googleClientId == null || googleClientId.isEmpty) {
        debugPrint('❌ [GoogleLogin] GOOGLE_CLIENT_ID not found in .env file');
        ErrorDialog.showError('Google Client ID not configured');
        return false;
      }
      debugPrint('✅ [GoogleLogin] GOOGLE_CLIENT_ID found: ${googleClientId.substring(0, 20)}...');

      // Initialize Google Sign In
      // serverClientId is required to get ID token for backend verification
      // This should be a Web OAuth client ID from the same Google Cloud project
      debugPrint('🔵 [GoogleLogin] Step 3: Creating GoogleSignIn instance...');
      debugPrint('🔵 [GoogleLogin] Using serverClientId to get ID token for backend verification');
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleClientId, // Web OAuth client ID for ID token
        // Android OAuth client (with SHA-1) is used automatically from google-services.json
      );
      debugPrint('✅ [GoogleLogin] GoogleSignIn instance created');
      debugPrint('🔵 [GoogleLogin] Note: Requires both Android OAuth client (with SHA-1) and Web OAuth client (for serverClientId)');

      // Sign in with Google
      debugPrint('🔵 [GoogleLogin] Step 4: Requesting user sign in...');
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        // Handle cancellation or other sign-in errors
        debugPrint('⚠️ [GoogleLogin] Google Sign In exception: $e');
        debugPrint('⚠️ [GoogleLogin] Exception type: ${e.runtimeType}');
        
        final errorStr = e.toString().toLowerCase();
        
        // Check for cancellation
        if (errorStr.contains('canceled') || 
            errorStr.contains('cancelled') ||
            errorStr.contains('sign_in_canceled') ||
            errorStr.contains('sign_in_cancelled') ||
            errorStr.contains('12501')) { // Error code 12501 = SIGN_IN_CANCELLED
          debugPrint('⚠️ [GoogleLogin] User cancelled Google Sign In');
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
        
        debugPrint('🔵 [GoogleLogin] Inner catch - Checking for developer error (code 10)...');
        debugPrint('🔵 [GoogleLogin] Error string (lowercase): $errorStr');
        debugPrint('🔵 [GoogleLogin] Has error 10: $hasError10');
        
        if (hasError10) {
          debugPrint('❌ [GoogleLogin] DEVELOPER_ERROR (Code 10) detected');
          debugPrint('❌ [GoogleLogin] Full error: $e');
          debugPrint('❌ [GoogleLogin] This usually means:');
          debugPrint('❌ [GoogleLogin] 1. SHA-1 fingerprint not configured in Google Cloud Console');
          debugPrint('❌ [GoogleLogin] 2. OAuth client ID mismatch');
          debugPrint('❌ [GoogleLogin] 3. Package name mismatch');
          debugPrint('❌ [GoogleLogin] 4. Google Services JSON not properly configured');
          // Re-throw to show error dialog with helpful message
          rethrow;
        }
        
        // Re-throw if it's not a cancellation
        rethrow;
      }
      
      if (googleUser == null) {
        // User cancelled the sign in
        debugPrint('⚠️ [GoogleLogin] User cancelled Google Sign In (null returned)');
        return false;
      }
      debugPrint('✅ [GoogleLogin] User signed in successfully');
      debugPrint('🔵 [GoogleLogin] User email: ${googleUser.email}');
      debugPrint('🔵 [GoogleLogin] User display name: ${googleUser.displayName}');
      debugPrint('🔵 [GoogleLogin] User ID: ${googleUser.id}');
      debugPrint('🔵 [GoogleLogin] Note: This will work for both login and registration');

      // Step 2: Google returns idToken and accessToken
      // We only need idToken for backend verification
      // accessToken is for direct Google API calls (not needed here)
      debugPrint('🔵 [GoogleLogin] Step 5: Getting authentication details from Google...');
      debugPrint('🔵 [GoogleLogin] Flow: Google Sign-In → Returns idToken & accessToken');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      debugPrint('🔵 [GoogleLogin] ID Token present: ${idToken != null && idToken.isNotEmpty}');
      debugPrint('🔵 [GoogleLogin] Access Token present: ${accessToken != null && accessToken.isNotEmpty}');
      
      if (idToken == null || idToken.isEmpty) {
        debugPrint('❌ [GoogleLogin] ID Token is null or empty');
        ErrorDialog.showError('Failed to get Google ID token');
        return false;
      }
      debugPrint('✅ [GoogleLogin] ID Token obtained (length: ${idToken.length})');
      debugPrint('🔵 [GoogleLogin] Note: accessToken received but not needed (only idToken required)');

      // Step 3: Flutter sends idToken to backend
      // Step 4: Backend verifies token using Google public keys (backend logic)
      // Step 5: Backend creates its own session / JWT
      debugPrint('🔵 [GoogleLogin] Step 6: Sending idToken to backend for verification...');
      debugPrint('🔵 [GoogleLogin] Flow: Flutter → Backend (idToken) → Backend verifies → Backend creates JWT');

      // Authenticate with backend using the ID token
      final response = await GraphqlService.client.value.mutate$LoginWithGoogle(
        Options$Mutation$LoginWithGoogle(
          variables: Variables$Mutation$LoginWithGoogle(token: idToken),
        ),
      );

      debugPrint('🔵 [GoogleLogin] Backend response received');
      debugPrint('🔵 [GoogleLogin] Response has exception: ${response.hasException}');

      // Handle GraphQL errors
      if (response.hasException) {
        debugPrint('❌ [GoogleLogin] GraphQL exception occurred');
        debugPrint('❌ [GoogleLogin] Exception: ${response.exception}');
        if (response.exception?.graphqlErrors != null) {
          for (final error in response.exception!.graphqlErrors) {
            debugPrint('❌ [GoogleLogin] GraphQL Error: ${error.message}');
            debugPrint('❌ [GoogleLogin] Error path: ${error.path}');
            debugPrint('❌ [GoogleLogin] Error extensions: ${error.extensions}');
          }
        }
        if (response.exception?.linkException != null) {
          debugPrint('❌ [GoogleLogin] Link Exception: ${response.exception!.linkException}');
        }
      }

      if (checkResponseForErrors(response, customErrorMessage: 'Google authentication failed')) {
        debugPrint('❌ [GoogleLogin] checkResponseForErrors returned true');
        return false;
      }

      debugPrint('🔵 [GoogleLogin] Step 7: Processing authentication response...');
      final data = response.parsedData?.authenticate;
      debugPrint('🔵 [GoogleLogin] Response data type: ${data.runtimeType}');
      debugPrint('🔵 [GoogleLogin] Response data: $data');

      // Authentication successful
      if (data is Mutation$LoginWithGoogle$authenticate$$CurrentUser) {
        debugPrint('✅ [GoogleLogin] Authentication successful - CurrentUser received');
        debugPrint('🔵 [GoogleLogin] User ID: ${data.id}');
        debugPrint('🔵 [GoogleLogin] User identifier: ${data.identifier}');
        debugPrint('🔵 [GoogleLogin] User authenticated/registered successfully via Google');

        // Extract backend JWT session token from response headers
        // Backend creates its own session/JWT after verifying Google idToken
        debugPrint('🔵 [GoogleLogin] Step 8: Extracting backend JWT session token...');
        debugPrint('🔵 [GoogleLogin] Flow: Backend verified idToken → Created JWT → Sending in response headers');
        final responseContext = response.context.entry<HttpLinkResponseContext>();
        debugPrint('🔵 [GoogleLogin] Response context present: ${responseContext != null}');
        
        if (responseContext != null) {
          debugPrint('🔵 [GoogleLogin] Response headers: ${responseContext.headers}');
        }
        
        final authToken = responseContext?.headers?['vendure-auth-token'];
        debugPrint('🔵 [GoogleLogin] Backend JWT token present: ${authToken != null && authToken.isNotEmpty}');

        if (authToken != null && authToken.isNotEmpty) {
          debugPrint('✅ [GoogleLogin] Backend JWT token extracted (length: ${authToken.length})');
          debugPrint('✅ [GoogleLogin] Backend session/JWT created and received successfully');
          
          // Save backend JWT session token
          debugPrint('🔵 [GoogleLogin] Step 9: Saving backend JWT session token...');
          await GraphqlService.setToken(key: 'auth', token: authToken);
          debugPrint('✅ [GoogleLogin] Backend JWT session token saved to GraphqlService');

          // 2️⃣ Fetch channels for this user
          debugPrint('🔵 [GoogleLogin] Step 10: Fetching channel information...');
          bool channelFetched = false;
          for (int i = 0; i < 3; i++) {
            debugPrint('🔵 [GoogleLogin] Channel fetch attempt ${i + 1}/3...');
            try {
              final channelResponse = await GraphqlService.client.value.query$GetChannelList(
                Options$Query$GetChannelList(),
              );

              debugPrint('🔵 [GoogleLogin] Channel response received');
              debugPrint('🔵 [GoogleLogin] Channel response has exception: ${channelResponse.hasException}');

              if (checkResponseForErrors(channelResponse, customErrorMessage: 'Failed to get channels')) {
                debugPrint('❌ [GoogleLogin] Channel fetch error on attempt ${i + 1}');
                if (i < 2) {
                  debugPrint('🔵 [GoogleLogin] Retrying in 500ms...');
                  await Future.delayed(Duration(milliseconds: 500));
                  continue;
                }
                break;
              }

              final modelResponse = channelResponse.parsedData;
              final channels = modelResponse?.getChannelList ?? [];
              debugPrint('🔵 [GoogleLogin] Channels found: ${channels.length}');

              if (channels.isNotEmpty) {
                final channel = channels.first;
                debugPrint('✅ [GoogleLogin] Channel selected: ${channel.code}');
                debugPrint('🔵 [GoogleLogin] Channel ID: ${channel.id}');
                debugPrint('🔵 [GoogleLogin] Channel token length: ${channel.token.length}');
                
                await _storage.write('channel_code', channel.code);
                await _storage.write('channel_token', channel.token);
                await GraphqlService.setToken(key: 'channel', token: channel.token);
                channelFetched = true;
                debugPrint('✅ [GoogleLogin] Channel saved - Code: ${channel.code}, Token: ${channel.token.substring(0, 20)}...');
                break;
              } else {
                debugPrint('⚠️ [GoogleLogin] No channels found on attempt ${i + 1}');
                if (i < 2) {
                  debugPrint('🔵 [GoogleLogin] Retrying in 500ms...');
                  await Future.delayed(Duration(milliseconds: 500));
                  continue;
                }
              }
            } catch (e, stackTrace) {
              debugPrint('❌ [GoogleLogin] Exception fetching channels on attempt ${i + 1}: $e');
              debugPrint('❌ [GoogleLogin] Stack trace: $stackTrace');
              if (i < 2) {
                debugPrint('🔵 [GoogleLogin] Retrying in 500ms...');
                await Future.delayed(Duration(milliseconds: 500));
                continue;
              }
            }
          }

          if (!channelFetched) {
            debugPrint('❌ [GoogleLogin] Failed to fetch channels after 3 attempts');
            ErrorDialog.showError(
              'Authentication successful, but there was an issue setting up your account. Please try again.',
            );
            return false;
          }

          // 3️⃣ Mark user as logged in
          debugPrint('🔵 [GoogleLogin] Step 11: Finalizing login...');
          setLoggedIn(true);
          resetFormField();

          debugPrint('✅ [GoogleLogin] ========== GOOGLE LOGIN SUCCESSFUL ==========');
          debugPrint('✅ [GoogleLogin] User logged in: ${isLoggedIn}');
          debugPrint('✅ [GoogleLogin] Auth token saved: ${GraphqlService.authToken.isNotEmpty}');
          debugPrint('✅ [GoogleLogin] Channel token saved: ${GraphqlService.channelToken.isNotEmpty}');
          return true;
        } else {
          debugPrint('❌ [GoogleLogin] Auth token not found in response headers');
          debugPrint('❌ [GoogleLogin] Response context: $responseContext');
          ErrorDialog.showError('Authentication token not received from server');
          return false;
        }
      }

      // Handle invalid credentials
      if (data is Mutation$LoginWithGoogle$authenticate$$InvalidCredentialsError) {
        debugPrint('❌ [GoogleLogin] Invalid credentials error');
        debugPrint('❌ [GoogleLogin] Error message: ${data.message}');
        ErrorDialog.showError(data.message);
        return false;
      }

      // Handle not verified error
      if (data is Mutation$LoginWithGoogle$authenticate$$NotVerifiedError) {
        debugPrint('❌ [GoogleLogin] Not verified error');
        debugPrint('❌ [GoogleLogin] Error message: ${data.message}');
        ErrorDialog.showError(data.message);
        return false;
      }

      // Fallback error
      debugPrint('❌ [GoogleLogin] Unknown response type: ${data.runtimeType}');
      debugPrint('❌ [GoogleLogin] Response data: $data');
      ErrorDialog.showError('Google authentication failed');
      return false;

    } catch (e, stackTrace) {
      debugPrint('❌ [GoogleLogin] ========== EXCEPTION IN GOOGLE SIGN IN ==========');
      debugPrint('❌ [GoogleLogin] Exception: $e');
      debugPrint('❌ [GoogleLogin] Exception type: ${e.runtimeType}');
      debugPrint('❌ [GoogleLogin] Stack trace: $stackTrace');
      
      // Check if it's a cancellation - don't show error dialog for cancellations
      final errorStr = e.toString().toLowerCase();
      final isCancellation = errorStr.contains('canceled') || 
                            errorStr.contains('cancelled') ||
                            errorStr.contains('sign_in_canceled') ||
                            errorStr.contains('sign_in_cancelled') ||
                            errorStr.contains('12501'); // Error code 12501 = SIGN_IN_CANCELLED
      
      if (isCancellation) {
        debugPrint('⚠️ [GoogleLogin] User cancelled - not showing error dialog');
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
      
      debugPrint('🔵 [GoogleLogin] Checking for developer error (code 10)...');
      debugPrint('🔵 [GoogleLogin] Error string (lowercase): $errorStr');
      debugPrint('🔵 [GoogleLogin] Is developer error: $isDeveloperError');
      
      if (isDeveloperError) {
        debugPrint('❌ [GoogleLogin] Showing developer error message to user');
        debugPrint('❌ [GoogleLogin] Package name: com.kaaikani.kaaikani');
        debugPrint('❌ [GoogleLogin] Debug SHA-1: 7B:87:2E:43:7B:68:07:28:A6:D2:7F:BE:28:C2:94:52:58:B7:E1:71');
        debugPrint('❌ [GoogleLogin] To fix this error:');
        debugPrint('❌ [GoogleLogin] 1. Go to https://console.cloud.google.com/');
        debugPrint('❌ [GoogleLogin] 2. Select your project');
        debugPrint('❌ [GoogleLogin] 3. Go to APIs & Services > Credentials');
        debugPrint('❌ [GoogleLogin] 4. Find your OAuth 2.0 Client ID (Android)');
        debugPrint('❌ [GoogleLogin] 5. Add SHA-1 fingerprint: 7B:87:2E:43:7B:68:07:28:A6:D2:7F:BE:28:C2:94:52:58:B7:E1:71');
        debugPrint('❌ [GoogleLogin] 6. Ensure package name is: com.kaaikani.kaaikani');
        debugPrint('❌ [GoogleLogin] 7. For release builds, also add release keystore SHA-1');
        
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
      debugPrint('🔵 [GoogleLogin] Loading state set to false');
      debugPrint('🔵 [GoogleLogin] ========== GOOGLE SIGN IN PROCESS ENDED ==========');
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

