import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import '../components/collectioncomponent.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../graphql/product.graphql.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../components/bannercomponent.dart';
import '../components/vertical_list_component.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/google_auth_env.dart';
import '../widgets/responsive_spacing.dart';
import '../components/bottomnavigationbar.dart';
import '../components/home_components/home_delivery_address_header.dart';
import '../components/home_components/home_shipping_ticker.dart';
import '../components/home_components/home_switch_store_sheet.dart';
import '../components/home_components/home_header.dart';
import '../components/home_components/home_postal_code_sheet.dart';
import '../components/home_components/home_frequently_ordered_section.dart';
import '../components/home_components/home_favorites_section.dart';
import '../services/analytics_service.dart';
import '../utils/analytics_helper.dart';
import '../widgets/snackbar.dart';
import '../services/graphql_client.dart';
import '../controllers/theme_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/notification_permission_dialog.dart';
import '../services/channel_service.dart';
import '../routes.dart';
import '../graphql/schema.graphql.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();
  final BannerController bannerController = Get.put(BannerController());
  final CollectionsController collectionController =
      Get.put(CollectionsController());
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final CustomerController customerController = Get.put(CustomerController());
  final UtilityController utilityController = Get.put(UtilityController());
  final ThemeController themeController = Get.find<ThemeController>();
  
  // Track selected variant for each product in favorites (moved to component state)
  
  // Track if dialog is showing to prevent multiple dialogs
  bool _isAddressDialogShowing = false;
  bool _isPostalCodeDialogShowing = false;
  
  // Track if data refresh is in progress to prevent duplicate calls
  bool _isRefreshingData = false;
  
  // Track if this is initial load to prevent false positive change detection
  bool _isInitialLoad = true;
  
  // Reactive variables for channel and postal code to trigger UI updates
  final RxString _channelName = ''.obs;
  final RxString _postalCode = ''.obs;
  final RxString _channelType = ''.obs;
  final RxString _channelToken = ''.obs; // Track channel token changes
  
  // Track previous channel token to prevent unnecessary refreshes
  String _previousChannelToken = '';
  
  // Track previous postal code to prevent false positives during refresh
  String _previousPostalCode = '';

  final ScrollController _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load active order (cart) when home page opens
    cartController.getActiveOrder();
    // Initialize reactive variables
    _previousChannelToken = GraphqlService.channelToken;
    _updateChannelDisplay(skipRefreshTrigger: true); // Skip refresh on initial load
    
    // Check postal code and validate available channels
    _checkPostalCodeAndChannels();
    
    _refreshData();
    // Mark initial load as complete after first refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isInitialLoad = false;
      // Check notification permission after page is built
      _checkNotificationPermission();
    });
    
    // Listen to channel token changes and update UI immediately
    // Only trigger refresh if token actually changed (not just emitted)
    // Wait until initial load is complete before setting up listener to prevent loops
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set up listener after initial load to prevent loops during initialization
      Future.delayed(Duration(milliseconds: 500), () {
        ever(GraphqlService.channelTokenRx, (String newToken) {
          // Only proceed if token actually changed and initial load is complete
          if (_isInitialLoad || _previousChannelToken == newToken) {
            return;
          }
          
          _previousChannelToken = newToken;
          
          if (mounted) {
            _updateChannelDisplay(skipRefreshTrigger: false); // Allow refresh for actual channel token changes
            // Force UI refresh when channel changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isInitialLoad) {
                setState(() {});
                // Refresh data with new channel - force refresh since channel actually changed
                _refreshData(forceRefresh: true);
              }
            });
          }
        });
      });
    });
    _mainScrollController.addListener(_onMainScroll);
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onMainScroll);
    _mainScrollController.dispose();
    super.dispose();
  }

  void _onMainScroll() {
    if (!_mainScrollController.hasClients) return;
    final position = _mainScrollController.position;
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      if (collectionController.hasMoreCollections &&
          !collectionController.isLoadingMoreCollections) {
        collectionController.loadMoreCollections();
      }
    }
  }

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    final authController = Get.find<AuthController>();
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    
    return authController.isLoggedIn && 
           authToken.isNotEmpty && 
           channelToken.isNotEmpty;
  }

  /// Check notification permission and show dialog if denied
  Future<void> _checkNotificationPermission() async {
    try {
      // Check current permission status
      final status = await Permission.notification.status;
      
      
      // If permission is granted (or provisional on iOS = "deliver quietly"), don't show dialog
      if (status.isGranted || status.isProvisional) {
        await box.remove('notification_permission_dialog_shown');
        await box.remove('notification_settings_dialog_shown');
        return;
      }
      
      // Check if we've already shown the dialog in this session
      final hasShownDialog = box.read<bool>('notification_permission_dialog_shown') ?? false;
      final lastShownTime = box.read<int>('notification_permission_dialog_last_shown');
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Show dialog if:
      // 1. Permission is denied, restricted, or not yet determined (not granted, not permanently denied)
      // 2. We haven't shown it before, OR it's been more than 7 days since last shown
      final needsPrompt = status.isDenied || status.isRestricted;
      if (needsPrompt && mounted) {
        final shouldShow = !hasShownDialog || 
                          (lastShownTime != null && (now - lastShownTime) > (7 * 24 * 60 * 60 * 1000));
        
        if (shouldShow) {
          // Show the dialog after a short delay to ensure page is fully loaded
          await Future.delayed(Duration(milliseconds: 500));
          
          if (mounted) {
            await NotificationPermissionDialog.show(context);
            // Mark that we've shown the dialog and record the time
            await box.write('notification_permission_dialog_shown', true);
            await box.write('notification_permission_dialog_last_shown', now);
          }
        }
      } else if (status.isPermanentlyDenied && mounted) {
        // If permanently denied, show settings dialog (but only once per 30 days)
        final hasShownSettingsDialog = box.read<bool>('notification_settings_dialog_shown') ?? false;
        final lastShownSettingsTime = box.read<int>('notification_settings_dialog_last_shown');
        
        final shouldShowSettings = !hasShownSettingsDialog || 
                                  (lastShownSettingsTime != null && 
                                   (now - lastShownSettingsTime) > (30 * 24 * 60 * 60 * 1000));
        
        if (shouldShowSettings) {
          await Future.delayed(Duration(milliseconds: 500));
          if (mounted) {
            // Show settings dialog
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: AppColors.surface,
                title: Row(
                  children: [
                    Icon(Icons.settings_rounded, color: AppColors.button),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    Expanded(
                      child: Text(
                        'Enable Notifications',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(18),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Notification permission is disabled. Please enable it in your device settings to receive order updates and offers.',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(15),
                    color: AppColors.textSecondary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Later'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await openAppSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Open Settings'),
                  ),
                ],
              ),
            );
            await box.write('notification_settings_dialog_shown', true);
            await box.write('notification_settings_dialog_last_shown', now);
          }
        }
      }
    } catch (e) {
    }
  }

  /// Update reactive channel display variables
  /// [skipRefreshTrigger] - if true, don't trigger refresh even if values changed (used during refresh operations)
  void _updateChannelDisplay({bool skipRefreshTrigger = false}) {
    final newChannelName = ChannelService.getChannelName() ?? ChannelService.getChannelCode() ?? 'Select Location';
    // Ensure postal code is always converted to string for proper comparison
    final postalCodeValue = ChannelService.getPostalCode();
    final newPostalCode = postalCodeValue != null ? postalCodeValue.toString() : '';
    final newChannelType = ChannelService.getChannelType() ?? '';
    final newChannelToken = ChannelService.getChannelToken()?.toString() ?? GraphqlService.channelToken;
    
    // Track channel token changes to force UI refresh
    bool channelTokenChanged = false;
    bool postalCodeChanged = false;
    bool channelNameChanged = false;
    
    if (_channelToken.value != newChannelToken) {
      _channelToken.value = newChannelToken;
      channelTokenChanged = true;
      if (!skipRefreshTrigger && !_isInitialLoad) {
      } else {
      }
    }
    
    // Always update reactive variables to trigger Obx rebuild, even if value appears same
    // This ensures UI updates when postal code changes
    if (_channelName.value != newChannelName) {
      _channelName.value = newChannelName;
      channelNameChanged = true;
    } else {
      // Force update even if same to ensure Obx rebuilds
      _channelName.value = newChannelName;
    }
    
    // Always update postal code reactive variable to ensure UI reflects latest value
    // Convert to string to ensure consistent comparison
    final currentPostalCodeStr = _postalCode.value;
    // Only consider it a change if:
    // 1. The value actually changed AND
    // 2. It's not just going from empty to a value (which happens during initial load/refresh)
    // 3. OR it's a real change (not empty to empty or same value)
    final isRealPostalCodeChange = currentPostalCodeStr != newPostalCode && 
                                    !(currentPostalCodeStr.isEmpty && newPostalCode.isNotEmpty && _previousPostalCode.isNotEmpty);
    
    if (isRealPostalCodeChange) {
      _postalCode.value = newPostalCode;
      _previousPostalCode = newPostalCode;
      postalCodeChanged = true;
    } else if (newPostalCode.isNotEmpty) {
      // Even if value appears same, ensure reactive variable is set (handles type mismatches)
      _postalCode.value = newPostalCode;
      if (_previousPostalCode.isEmpty) {
        _previousPostalCode = newPostalCode; // Initialize on first load
      }
      if (currentPostalCodeStr.isEmpty && newPostalCode.isNotEmpty) {
      } else {
      }
    }
    
    if (_channelType.value != newChannelType) {
      _channelType.value = newChannelType;
    } else {
      // Force update even if same
      _channelType.value = newChannelType;
    }
    
    // If any value changed, force a UI refresh
    // Only trigger refresh if there was an actual change (not just reactive variable update)
    // AND we're not in the middle of a refresh operation AND it's not the initial load
    if ((channelTokenChanged || postalCodeChanged || channelNameChanged) && 
        !skipRefreshTrigger && 
        !_isInitialLoad && 
        mounted) {
      // Force rebuild by updating a reactive variable that the UI observes
      // This ensures all Obx widgets rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {}); // Force StatefulWidget rebuild
        }
      });
    } else if (skipRefreshTrigger || _isInitialLoad) {
      // Called during refresh or initial load - just update values, don't trigger refresh
    } else {
      // No actual change detected - just reactive variable updates
      // Don't trigger unnecessary UI refresh
    }
  }

  /// Refresh data - called from initState and when returning to page
  /// [forceRefresh] - if true, force refresh even if conditions suggest it's unnecessary
  void _refreshData({bool forceRefresh = false}) {
    // Prevent duplicate refresh calls
    if (_isRefreshingData) {
      return;
    }

    // If this is not a forced refresh and we're not on initial load,
    // check if channel token actually changed to prevent unnecessary refreshes
    if (!forceRefresh && !_isInitialLoad) {
      final currentToken = GraphqlService.channelToken;
      if (currentToken == _previousChannelToken) {
        return;
      }
    }

    _isRefreshingData = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _doRefresh(forceRefresh: forceRefresh);
    });
  }

  /// Core refresh logic - awaitable, used by both _refreshData and RefreshIndicator
  Future<void> _doRefresh({bool forceRefresh = false}) async {
    // Check if we're still on HomePage - if not, abort refresh
    if (!mounted) {
      _isRefreshingData = false;
      return;
    }

    // Check current route - if we're not on HomePage, abort refresh
    try {
      final currentRoute = Get.currentRoute;
      if (currentRoute != '/home' && currentRoute != '/') {
        _isRefreshingData = false;
        return;
      }
    } catch (e) {
    }

    // Double-check: If channel token hasn't changed and this is not initial load or forced refresh, skip
    if (!forceRefresh && !_isInitialLoad) {
      final currentToken = GraphqlService.channelToken;
      if (currentToken == _previousChannelToken) {
        _isRefreshingData = false;
        return;
      }
    }


    // STEP 1: Get customer data if authenticated
    // This internally calls checkAndSetPostalCodeFromShippingAddress() to extract postal code from address
    if (_isUserAuthenticated()) {
      await customerController.getActiveCustomer();
    }

    // STEP 2: Check if postal code is saved in local storage
    // Only fetch collections, banners, and other data if postal code exists AND has available CITY channel
    final storedPostalCode = ChannelService.getPostalCode();
    final hasPostalCode = storedPostalCode != null && storedPostalCode.toString().isNotEmpty;

    // Always update UI display after checking postal code/channel (ensures UI is in sync)
    // Add small delay to ensure storage is written before reading
    await Future.delayed(Duration(milliseconds: 100));
    _updateChannelDisplay(skipRefreshTrigger: true); // Skip refresh trigger since we're already in refresh

    // STEP 3: Check if postal code has valid available CITY channel
    bool hasValidAvailableChannel = false;
    if (hasPostalCode) {
      // Check if postal code has available CITY channel (isAvailable == true)
      hasValidAvailableChannel = await customerController.hasValidPostalCode(storedPostalCode.toString());
    }

    // STEP 3b: BRAND channels (e.g. ind-snacks) may have channel token set without CITY channel
    // Allow fetch when channel token is set so banners/collections load for BRAND channels
    final hasChannelToken = (ChannelService.getChannelToken() ?? '').toString().isNotEmpty;
    final shouldFetchData = (hasPostalCode && hasValidAvailableChannel) || hasChannelToken;

    // STEP 4: Fetch collections, banners, and other data when we have valid channel (CITY or BRAND)
    if (shouldFetchData) {
      // Load active order for current channel so cart persists across app close/reopen (guest and logged-in)
      if (forceRefresh) {
        await cartController.getActiveOrder();
      } else if (cartController.cart.value == null) {
        // Initial load or reopen: fetch cart so guest sees previously added items (guest token restored in GraphqlService.initialize())
        await cartController.getActiveOrder();
      }
      // Postal code exists and has available CITY channel - fetch all data
      if (_isUserAuthenticated()) {
        // Sync customer location from stored postal: get channel by postal code, pass channel name to updateCustomer (location)
        customerController.syncCustomerLocationFromStoredPostalCode();

        if (!forceRefresh && cartController.cart.value == null) {
          cartController.getActiveOrder();
        }
        bannerController.getCustomerFavorites();

        // Check for default shipping address after customer data is loaded
        // Only check if widget is still mounted
        if (mounted) {
          _checkAndShowShippingAddressDialog();
          // For BRAND channels only: show update email/phone dialogs on home page
          if (_isBrandChannel()) {
            _checkAndShowUpdateDialogs();
          }
        }
      }

      // Fetch collections and banners (only if postal code exists and has available channel)
      await Future.wait([
        collectionController.fetchAllCollections(),
        bannerController.getBannersForChannel(),
        bannerController.getFrequentlyOrderedProducts(),
      ], eagerError: false);
    } else {
      // No postal code OR no available channel - show dialog but don't fetch collections/banners
      // Check for postal code dialog if still needed
      // Only check if dialog is not already showing
      if (mounted && !_isPostalCodeDialogShowing) {
        _checkAndShowPostalCodeDialog();
      }
    }


    // Track screen view
    AnalyticsService().logScreenView(screenName: 'Home');

    // Reset refresh flag
    _isRefreshingData = false;
  }

  /// Check if email is a valid Gmail address
  bool _isValidGmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email.toLowerCase());
  }

  /// Check and show dialogs for invalid email or missing phone number
  void _checkAndShowUpdateDialogs() {
    if (!mounted) return;
    
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final channelCode = ChannelService.getChannelCode()?.toLowerCase() ?? '';
    final isIndSnacks = channelCode == 'ind-snacks';
    // Ind-Snacks: only show update email dialog when email is @kaikani.com (placeholder). If not @kaikani.com, skip email dialog.
    final emailIsPlaceholder = customer.emailAddress.trim().toLowerCase().endsWith('@kaikani.com');
    final shouldShowEmailDialog = !_isValidGmail(customer.emailAddress) &&
        (!isIndSnacks || emailIsPlaceholder);

    if (shouldShowEmailDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showUpdateEmailDialog();
        }
      });
      return; // Don't check phone if email dialog is shown
    }

    // Check if phone number is null
    if (customer.phoneNumber == null || customer.phoneNumber!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showUpdatePhoneDialog();
        }
      });
    }
  }


  /// Show dialog to update email address (same as account page: Sign in with Google only, no text box)
  void _showUpdateEmailDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    customerController.emailUpdateError.value = '';

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isLoading = false;
              final emailController = TextEditingController();
              return Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: ResponsiveUtils.rp(28),
                          color: AppColors.button,
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Text(
                            'Update Email Address',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(20)),
                    Text(
                      'Sign in with Google to set your email address',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    Obx(() {
                      final errorMsg = customerController.emailUpdateError.value;
                      if (errorMsg.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                          padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.error,
                                size: ResponsiveUtils.rp(20),
                              ),
                              SizedBox(width: ResponsiveUtils.rp(8)),
                              Expanded(
                                child: Text(
                                  errorMsg,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(13),
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    SizedBox(
                      width: double.infinity,
                      child: AbsorbPointer(
                        absorbing: isLoading,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            setState(() => isLoading = true);
                            await _handleGoogleSignInForEmail(
                              context,
                              setState,
                              emailController,
                              () => setState(() => isLoading = false),
                            );
                          },
                          icon: isLoading
                              ? SizedBox(
                                  width: ResponsiveUtils.rp(20),
                                  height: ResponsiveUtils.rp(20),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/google_logo.png',
                                  width: ResponsiveUtils.rp(24),
                                  height: ResponsiveUtils.rp(24),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.login,
                                    size: ResponsiveUtils.rp(20),
                                    color: AppColors.button,
                                  ),
                                ),
                          label: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.button,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.button, width: 1.5),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.rp(16),
                              vertical: ResponsiveUtils.rp(14),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Handle Google Sign-In for email (same flow as account page)
  Future<void> _handleGoogleSignInForEmail(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
    VoidCallback onComplete,
  ) async {
    setState(() => customerController.emailUpdateError.value = '');
    try {
      final googleClientId = GoogleAuthEnv.googleClientId;
      if (googleClientId == null || googleClientId.isEmpty) {
        setState(() {
          customerController.emailUpdateError.value = 'Google Client ID not configured';
        });
        onComplete();
        return;
      }
      if (!GoogleAuthEnv.isIosConfigValid) {
        setState(() {
          customerController.emailUpdateError.value =
              'Set GOOGLE_CLIENT_ID_IOS in .env for iOS (iOS OAuth client). See docs/GOOGLE_AUTH_SETUP.md.';
        });
        onComplete();
        return;
      }
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleClientId,
        clientId: GoogleAuthEnv.clientIdForPlatform,
        scopes: ['email'],
      );
      try {
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) await googleSignIn.signOut();
      } catch (_) {
        try { await googleSignIn.signOut(); } catch (_) {}
      }
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('canceled') || errorStr.contains('cancelled') ||
            errorStr.contains('sign_in_canceled') || errorStr.contains('sign_in_cancelled') ||
            errorStr.contains('12501')) {
          onComplete();
          return;
        }
        final hasError10 = errorStr.contains('apiexception: 10') ||
            errorStr.contains('apiException: 10') || errorStr.contains('apiexception:10') ||
            errorStr.contains('error 10') || errorStr.contains('developer_error') ||
            errorStr.contains(': 10:') || errorStr.contains(': 10 ') ||
            RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);
        if (hasError10) {
          setState(() {
            customerController.emailUpdateError.value =
                'Google Sign-In Configuration Error. Please contact support.';
          });
          onComplete();
          return;
        }
        setState(() {
          customerController.emailUpdateError.value = 'Failed to sign in with Google. Please try again.';
        });
        onComplete();
        return;
      }
      if (googleUser == null) {
        onComplete();
        return;
      }
      final email = googleUser.email;
      if (email.isEmpty) {
        setState(() {
          customerController.emailUpdateError.value = 'Failed to get email address from Google account';
        });
        onComplete();
        return;
      }
      if (!_isValidGmail(email)) {
        setState(() {
          customerController.emailUpdateError.value = 'Please use a Gmail address (@gmail.com)';
        });
        onComplete();
        return;
      }
      setState(() {
        emailController.text = email;
        customerController.emailUpdateError.value = '';
      });
      final success = await customerController.updateCustomerEmail(email);
      onComplete();
      if (success) {
        Get.back();
        showSuccessSnackbar('Email updated successfully');
        _checkAndShowUpdateDialogs();
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      final isCancellation = errorStr.contains('canceled') ||
          errorStr.contains('cancelled') ||
          errorStr.contains('sign_in_canceled') ||
          errorStr.contains('sign_in_cancelled') ||
          errorStr.contains('12501');
      if (isCancellation) {
        onComplete();
        return;
      }
      final isDeveloperError = errorStr.contains('apiexception: 10') ||
          errorStr.contains('apiException: 10') || errorStr.contains('apiexception:10') ||
          errorStr.contains('error 10') || errorStr.contains('developer_error') ||
          errorStr.contains(': 10:') || errorStr.contains(': 10 ') ||
          RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);
      if (isDeveloperError) {
        setState(() {
          customerController.emailUpdateError.value =
              'Google Sign-In Configuration Error. Please contact support.';
        });
        onComplete();
        return;
      }
      setState(() {
        customerController.emailUpdateError.value = 'Failed to sign in with Google. Please try again.';
      });
      onComplete();
    }
  }

  /// Show dialog to update phone number
  void _showUpdatePhoneDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final phoneController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent closing by back button
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: ResponsiveUtils.rp(28),
                        color: AppColors.button,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Text(
                          'Update Phone Number',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Text(
                    'Please enter your phone number',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  // Error message display
                  if (errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(12),
                        vertical: ResponsiveUtils.rp(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: ResponsiveUtils.rp(18),
                            color: AppColors.error,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(13),
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                  ],
                  TextField(
                    controller: phoneController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter 10 digit phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(
                          color: errorMessage != null 
                              ? AppColors.error 
                              : AppColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(
                          color: errorMessage != null 
                              ? AppColors.error 
                              : AppColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(
                          color: errorMessage != null 
                              ? AppColors.error 
                              : AppColors.button, 
                          width: 2,
                        ),
                      ),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (errorMessage != null) {
                        setState(() {
                          errorMessage = null;
                        });
                      }
                      // Validate on change - show error if non-digit characters are entered
                      if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        setState(() {
                          errorMessage = 'Only numbers are allowed';
                        });
                      }
                    },
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          final phone = phoneController.text.trim();
                          
                          if (phone.isEmpty) {
                            setState(() {
                              errorMessage = 'Please enter a phone number';
                            });
                            return;
                          }
                          
                          // Validate: Only digits allowed
                          if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                            setState(() {
                              errorMessage = 'Only numbers are allowed. No special characters.';
                            });
                            return;
                          }
                          
                          // Validate: Must be exactly 10 digits
                          if (phone.length != 10) {
                            setState(() {
                              errorMessage = 'Phone number must be exactly 10 digits';
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true;
                            errorMessage = null; // Clear any previous error
                          });

                          // Update phone number using customer controller
                          try {
                            final success = await customerController.updateCustomerPhoneNumber(phone);
                            
                            if (success) {
                              // Close dialog first
                              Navigator.of(context).pop();
                              showSuccessSnackbar('Phone number updated successfully');
                            } else {
                          setState(() {
                            isLoading = false;
                                errorMessage = 'Failed to update phone number. Please try again.';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              // Check if error message contains "already registered"
                              final errorStr = e.toString();
                              if (errorStr.toLowerCase().contains('already registered') ||
                                  errorStr.toLowerCase().contains('already exists')) {
                                errorMessage = 'This phone number is already registered with another account.';
                              } else {
                                errorMessage = 'Failed to update phone number. Please try again.';
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.button,
                          foregroundColor: Colors.white,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: ResponsiveUtils.rp(20),
                                height: ResponsiveUtils.rp(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text('Update Phone'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }


  /// Check postal code from GetStorage and validate available channels
  /// REVERSED LOGIC: Show postal code bottom sheet ONLY if there IS an available CITY type channel
  Future<void> _checkPostalCodeAndChannels() async {
    try {
      // Skip if app is restarting (channel token already exists) - don't call getAvailableChannels
      final channelToken = ChannelService.getChannelToken();
      if (channelToken != null && channelToken.toString().isNotEmpty) {
        return; // App restarting with existing channel, skip getAvailableChannels call
      }
      
      // Get postal code from GetStorage
      final storedPostalCode = ChannelService.getPostalCode();
      
      // If no postal code exists, don't show bottom sheet (reversed logic)
      if (storedPostalCode == null || storedPostalCode.toString().isEmpty) {
        return;
      }
      
      // Postal code exists, call getAvailableChannels
      final channels = await customerController.getAvailableChannels(storedPostalCode.toString());
      
      // If no data returned, don't show postal code bottom sheet (reversed logic)
      if (channels.isEmpty) {
        return;
      }
      
      // Check if there's an available CITY type channel
      bool hasAvailableCityChannel = false;
      for (final channel in channels) {
        if (channel.isAvailable == true && channel.type == Enum$ChannelType.CITY) {
          hasAvailableCityChannel = true;
          break;
        }
      }
      
      // REVERSED: If there IS an available CITY channel, show postal code bottom sheet
      if (hasAvailableCityChannel) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && context.mounted) {
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted && context.mounted) {
                _showPostalCodeBottomSheet(isMandatory: true);
              }
            });
          }
        });
      }
    } catch (e) {
      // On error, don't show postal code bottom sheet (reversed logic)
      return;
    }
  }

  /// Check if postal code is saved, if not show postal code bottom sheet
  /// Also shows dialog if postal code exists but no available CITY channel
  void _checkAndShowPostalCodeDialog() async {
    if (!mounted) {
      return;
    }
    if (_isPostalCodeDialogShowing) {
      return; // Prevent multiple dialogs
    }
    
    final storedPostalCode = ChannelService.getPostalCode();
    
    // If no postal code is saved, show the postal code bottom sheet
    if (storedPostalCode == null || storedPostalCode.toString().isEmpty) {
      _isPostalCodeDialogShowing = true; // Mark as showing
      
      // Use multiple callbacks to ensure the widget tree is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isPostalCodeDialogShowing) {
          // Add a small delay to ensure context is fully available
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted && _isPostalCodeDialogShowing && context.mounted) {
              _showPostalCodeBottomSheet(isMandatory: true);
            } else {
              _isPostalCodeDialogShowing = false;
            }
          });
        }
      });
    } else {
      // Postal code exists - check if it has valid available CITY channel
      final postalCodeStr = storedPostalCode.toString();
      final hasValidChannels = await customerController.hasValidPostalCode(postalCodeStr);
      
      // Show dialog if no available channel (even if postal code exists)
      if (!hasValidChannels) {
        _isPostalCodeDialogShowing = true; // Mark as showing
        
        // Use multiple callbacks to ensure the widget tree is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isPostalCodeDialogShowing) {
            // Add a small delay to ensure context is fully available
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted && _isPostalCodeDialogShowing && context.mounted) {
                _showPostalCodeBottomSheet(isMandatory: true);
              } else {
                _isPostalCodeDialogShowing = false;
              }
            });
          }
        });
      }
    }
  }

  void _checkAndShowShippingAddressDialog() {
    if (!mounted) return; // Don't show dialog if widget is unmounted
    if (_isAddressDialogShowing) return; // Prevent multiple dialogs
    
    final addresses = customerController.addresses;
    
    // Don't show dialog if there are no addresses
    if (addresses.isEmpty) {
      return;
    }
    
    // Check if there's a default shipping address
    final hasDefaultShipping = addresses.any(
      (addr) => addr.defaultShippingAddress == true,
    );
    
    // Only show dialog if there are addresses but no default shipping address
    if (!hasDefaultShipping && addresses.isNotEmpty) {
      // Show non-dismissible dialog
      _showSetDefaultAddressDialog();
    }
  }

  /// Show non-dismissible dialog to set default address
  void _showSetDefaultAddressDialog() {
    if (!mounted) return; // Don't show dialog if widget is unmounted
    if (_isAddressDialogShowing) return;
    _isAddressDialogShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: false, // Cannot close by tapping outside
      builder: (BuildContext dialogContext) {
        // Listen to address changes and close dialog when default address is set
        return Obx(() {
          final addresses = customerController.addresses;
          final hasDefaultShipping = addresses.any(
            (addr) => addr.defaultShippingAddress == true,
          );
          
          // Close dialog if default address is now set
          if (hasDefaultShipping && _isAddressDialogShowing) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && Navigator.of(dialogContext, rootNavigator: true).canPop()) {
                _isAddressDialogShowing = false;
                Navigator.of(dialogContext, rootNavigator: true).pop();
              }
            });
          }
          
          return WillPopScope(
            onWillPop: () async => false, // Prevent back button from closing
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(24),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: Text(
                      'Set Default Address',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Please set a default shipping address to continue. This is required for placing orders.',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  color: AppColors.textSecondary,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    AnalyticsHelper.trackButton(
                      'Set Default Address - Dialog',
                      screenName: 'Home',
                      callback: () {
                        Get.toNamed('/addresses');
                      },
                    )?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(24),
                      vertical: ResponsiveUtils.rp(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  child: Text(
                    'Go to Addresses',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refresh data when returning to this page (not on initial build)
    // initState already calls _refreshData(), so we skip it here to avoid duplicate calls
    // This will only refresh when dependencies actually change (e.g., theme changes)
    // For navigation back to page, we rely on the PopScope callback
  }

  @override
  Widget build(BuildContext context) {
    // Observe theme changes to rebuild the entire page
    // Access the observable directly through a getter that GetX can track
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Refresh data when page is about to be popped (user navigating back)
        if (!didPop) {
          _refreshData(forceRefresh: true); // Force refresh when navigating back to page
        }
      },
      child: Obx(() {
        // Access the theme value - GetX will track this through the getter
        final isDarkMode = themeController.isDarkMode;
        // Also observe channel token changes to trigger UI updates
        final channelToken = GraphqlService.channelTokenRx.value;
        
        // Use the value in the widget tree so GetX can properly track it
        return Scaffold(
          key: ValueKey('home_${isDarkMode}_${channelToken}'), // Include channel token in key to force rebuild on channel change
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: () async {
              _isRefreshingData = false; // Reset flag so _doRefresh can run
              await _doRefresh(forceRefresh: true);
            },
            color: AppColors.refreshIndicator,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use LayoutBuilder instead of OrientationBuilder to avoid layout callback issues
                return CustomScrollView(
                  controller: _mainScrollController,
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    // ==================== HEADER ====================
                    HomeHeader(
                      isUserAuthenticated: _isUserAuthenticated(),
                      isBrandChannel: _isBrandChannel(),
                      deliveryAddressHeader: _buildDeliveryAddressHeader(),
                      bannerController: bannerController,
                      channelName: _channelName.value.isNotEmpty
                          ? _channelName.value
                          : (ChannelService.getChannelName()?.toString() ?? ChannelService.getChannelCode()?.toString() ?? 'Kaaikani'),
                      customerController: customerController,
                      postalCode: _postalCode.value.isNotEmpty ? _postalCode.value : (ChannelService.getPostalCode()?.toString()),
                      onWelcomeTap: _showPostalCodeBottomSheet,
                    ),

                    // ==================== MAIN CONTENT ====================
                    SliverToBoxAdapter(
                      child: _buildMainContent(),
                    ),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: Obx(() => BottomNavComponent(
            cartCount: cartController.cartItemCount,
            onSwitchStoreTap: _showSwitchStoreBottomSheet,
          )),
        );
      }),
    );
  }

  /// Check if current channel type is BRAND (reactive)
  bool _isBrandChannel() {
    try {
      final channelType = _channelType.value.isEmpty 
          ? (ChannelService.getChannelType() ?? '')
          : _channelType.value;
      if (channelType.isEmpty) return false;
      // Check if it's BRAND type (could be "Enum$ChannelType.BRAND" or just "BRAND")
      return channelType.contains('BRAND');
    } catch (e) {
      return false;
    }
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Shipping ticker (only show if not BRAND channel)
        Obx(() {
          if (_isBrandChannel()) return SizedBox.shrink();
          return Column(
            children: [
              _buildShippingTicker(),
              // No spacing before banner - banner has no top padding
            ],
          );
        }),
        // Hero Banner Section - Full width with curvy corners, no top/left/right padding
        _buildHeroBanner(),
        ResponsiveSpacing.vertical(16),

        // Category Selection Horizontal Scroll
        _buildCategorySelection(),

        // Reward Points Section

        // Favorites Section (prioritized over frequently ordered)
        HomeFavoritesSection(
          bannerController: bannerController,
          cartController: cartController,
          utilityController: utilityController,
        ),
        Obx(() {
          final enabledProducts = bannerController.frequentlyOrderedProducts
              .where((item) => item.product.enabled == true)
              .toList();
          if (enabledProducts.isEmpty) {
            return SizedBox.shrink();
          }
          return ResponsiveSpacing.vertical(18);
        }),



        // All Products Section
        CollectionGrid(
        onCollectionTap: (Query$Collections$collections$items collection) {
          Get.toNamed(AppRoutes.collectionProducts, arguments: {
            'collectionId': collection.id,
            'collectionName': collection.name,
            'slug': collection.slug,
            'collectionImage': collection.featuredAsset?.preview ?? '',
            'totalItems': collection.productVariants.totalItems,
          });
        },
        ),
        ResponsiveSpacing.vertical(40),
        // Frequently Ordered Section
        HomeFrequentlyOrderedSection(
          bannerController: bannerController,
          cartController: cartController,
        ),
        Obx(() {
          final enabledProducts = bannerController.frequentlyOrderedProducts
              .where((item) => item.product.enabled == true)
              .toList();
          if (enabledProducts.isEmpty) {
            return SizedBox.shrink();
          }
          return ResponsiveSpacing.vertical(32);
        }),
      ],
    );
  }

  Widget _buildShippingTicker() {
    return const HomeShippingTicker();
  }

  Widget _buildHeroBanner() {
    return BannerComponent();
  }

  Widget _buildCategorySelection() {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final hasCollections = collectionController.allCollections.isNotEmpty;

      if (!isLoading && !hasCollections) {
        return const SizedBox.shrink();
      }

      return VerticalListComponent(
        title: '',
        onTap: (collection) {
          Get.toNamed(AppRoutes.collectionProducts, arguments: {
            'collectionId': collection.id,
            'collectionName': collection.name,
            'slug': collection.slug,
          });
        },
      );
    });
  }

  /// Show postal code search bottom sheet
  void _showPostalCodeBottomSheet({bool isMandatory = false}) {
    if (!mounted || !context.mounted) {
      _isPostalCodeDialogShowing = false;
      return;
    }
    
    // Check if bottom sheet is already showing by checking Navigator
    if (Navigator.of(context).canPop()) {
      // There might be a route/dialog already showing, check more carefully
    }
    
    
    final storedPostalCode = ChannelService.getPostalCode();
    final bool hasValidPostalCode = storedPostalCode != null && storedPostalCode.toString().isNotEmpty && !isMandatory;

    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: hasValidPostalCode, // Only dismissible if postal code exists and is valid
        enableDrag: hasValidPostalCode, // Only draggable if postal code exists and is valid
        backgroundColor: Colors.transparent,
        builder: (BuildContext bottomSheetContext) {
          return HomePostalCodeSheet(
            customerController: customerController,
            isMandatory: isMandatory,
            onPostalCodeSelected: () {
              // Add small delay to ensure storage is written before reading
              Future.delayed(Duration(milliseconds: 150), () {
                if (mounted) {
                  // Read latest postal code from storage and update reactive variable immediately
                  final latestPostalCode = ChannelService.getPostalCode();
                  if (latestPostalCode != null) {
                    final postalCodeStr = latestPostalCode.toString();
                    if (_postalCode.value != postalCodeStr) {
                      _postalCode.value = postalCodeStr;
                    }
                  }
                  // Force immediate UI update
                  _updateChannelDisplay();
                  // Force UI rebuild to ensure channel changes are reflected
                  setState(() {});
                  // Refresh data to ensure all channel-specific data is updated
                  _refreshData();
                }
              });
            },
          );
        },
      ).then((_) {
        _isPostalCodeDialogShowing = false;
      }).catchError((error) {
        _isPostalCodeDialogShowing = false;
      });
    } catch (e) {
      _isPostalCodeDialogShowing = false;
    }
  }

  /// Build delivery address header (above search bar)
  Widget _buildDeliveryAddressHeader() {
    return HomeDeliveryAddressHeader(
      onTap: _showPostalCodeBottomSheet,
      channelName: _channelName,
      postalCode: _postalCode,
    );
  }

  /// Show switch store bottom sheet
  void _showSwitchStoreBottomSheet() {
    final storedPostalCode = ChannelService.getPostalCode();
    if (storedPostalCode == null || storedPostalCode.toString().isEmpty) {
      showErrorSnackbar('Please select a postal code first');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return HomeSwitchStoreSheet(
          postalCode: storedPostalCode.toString(),
          customerController: customerController,
          onChannelSwitched: () {
            // Force immediate UI update
            _updateChannelDisplay(skipRefreshTrigger: false);
            // Refresh data and force UI rebuild - force since channel changed
            if (mounted) {
              setState(() {});
              _refreshData(forceRefresh: true);
            }
          },
        );
      },
    );
  }
}
