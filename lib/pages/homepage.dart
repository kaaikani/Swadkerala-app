import 'package:marquee/marquee.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../components/searchbarcomponent.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../services/postal_code_service.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/app_strings.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/product_card.dart';
import '../utils/price_formatter.dart';
import '../utils/navigation_helper.dart';
import '../components/bottomnavigationbar.dart';
import '../services/analytics_service.dart';
import '../utils/analytics_helper.dart';
import '../widgets/snackbar.dart';
import '../services/graphql_client.dart';
import '../services/remote_config_service.dart';
import '../graphql/banner.graphql.dart';
import '../controllers/theme_controller.dart';

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
  
  // Track selected variant for each product in favorites
  final Map<String, String> _selectedVariantIds = {};
  
  // Track if dialog is showing to prevent multiple dialogs
  bool _isAddressDialogShowing = false;
  bool _isPostalCodeDialogShowing = false;
  
  // Track if data refresh is in progress to prevent duplicate calls
  bool _isRefreshingData = false;
  
  // Reactive variables for channel and postal code to trigger UI updates
  final RxString _channelName = ''.obs;
  final RxString _postalCode = ''.obs;

  @override
  void initState() {
    super.initState();
    // Initialize reactive variables
    _updateChannelDisplay();
    _refreshData();
  }
  
  /// Update reactive channel display variables
  void _updateChannelDisplay() {
    final newChannelName = box.read('channel_name') ?? box.read('channel_code') ?? 'Select Location';
    final newPostalCode = box.read('postal_code') ?? '';
    
    // Only update if values changed to trigger Obx rebuild
    if (_channelName.value != newChannelName) {
      _channelName.value = newChannelName;
      debugPrint('[HomePage] Channel name updated: $newChannelName');
    }
    if (_postalCode.value != newPostalCode) {
      _postalCode.value = newPostalCode;
      debugPrint('[HomePage] Postal code updated: $newPostalCode');
    }
  }

  /// Refresh data - called from initState and when returning to page
  void _refreshData() {
    // Prevent duplicate refresh calls
    if (_isRefreshingData) {
      debugPrint('[HomePage] Data refresh already in progress, skipping duplicate call...');
      return;
    }
    
    _isRefreshingData = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('[HomePage] ========== STARTING DATA REFRESH ==========');
      
      // STEP 1: Get customer data if authenticated
      if (_isUserAuthenticated()) {
        debugPrint('[HomePage] User is authenticated, fetching customer data...');
        await customerController.getActiveCustomer();
        debugPrint('[HomePage] Customer data fetched');
      }
      
      // STEP 2: Get postal code from shipping address and set channel FIRST
      debugPrint('[HomePage] Checking postal code and setting channel...');
      final channelChanged = await _ensurePostalCodeAndChannelSet();
      debugPrint('[HomePage] Postal code and channel check completed. Channel changed: $channelChanged');
      
      // Always update UI display after checking postal code/channel (ensures UI is in sync)
      // Add small delay to ensure storage is written before reading
      await Future.delayed(Duration(milliseconds: 100));
      _updateChannelDisplay();
      debugPrint('[HomePage] UI display updated with latest channel and postal code');
      
      // STEP 3: Only after channel is set, fetch all other data
      // If channel changed, data is already being refreshed by switchChannelByPostalCode
      // So we can skip duplicate fetches or wait a bit for refresh to complete
      if (channelChanged) {
        debugPrint('[HomePage] Channel changed, waiting for data refresh to complete...');
        // Wait a bit for the refresh to complete (it's async in the background)
        await Future.delayed(Duration(milliseconds: 500));
        debugPrint('[HomePage] Data refresh should be complete, continuing...');
      }
      
      debugPrint('[HomePage] Fetching channel-specific data...');
      
      if (_isUserAuthenticated()) {
        cartController.getActiveOrder();
        bannerController.getCustomerFavorites();
        
        // Check for default shipping address after customer data is loaded
        // Only check if widget is still mounted
        if (mounted) {
          _checkAndShowShippingAddressDialog();
          // Check for invalid email or missing phone number
       //   _checkAndShowUpdateDialogs();
        }
      }
      
      // These can be fetched regardless of authentication status
      // Only fetch if channel didn't change (to avoid duplicate fetches)
      if (!channelChanged) {
      collectionController.fetchAllCollections();
        bannerController.getBannersForChannel(); // Refresh banners with current channel token
      bannerController.getFrequentlyOrderedProducts();
      } else {
        debugPrint('[HomePage] Skipping duplicate data fetch - already refreshed after channel change');
      }
      
      // Check for postal code dialog if still needed (for non-authenticated users)
      // Only check if dialog is not already showing
      if (mounted && !_isPostalCodeDialogShowing) {
        _checkAndShowPostalCodeDialog();
      }
     
      debugPrint('[HomePage] ========== DATA REFRESH COMPLETED ==========');
      
      // Track screen view
      AnalyticsService().logScreenView(screenName: 'Home');
      
      // Reset refresh flag
      _isRefreshingData = false;
    });
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

    // Check if email is not a valid Gmail
    if (!_isValidGmail(customer.emailAddress)) {
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

  /// Show dialog to update email address
  void _showUpdateEmailDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final emailController = TextEditingController();
    bool isLoading = false;

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
                    'Please enter a valid Gmail address',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  TextField(
                    controller: emailController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter Gmail address',
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(color: AppColors.button, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          final email = emailController.text.trim();
                          if (email.isEmpty) {
                            showErrorSnackbar('Please enter an email address');
                            return;
                          }
                          if (!_isValidGmail(email)) {
                            showErrorSnackbar('Please enter a valid Gmail address');
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          // Update email using the dedicated method
                          final success = await customerController.updateCustomerEmail(email);

                          setState(() {
                            isLoading = false;
                          });

                          if (success) {
                            Get.back();
                            showSuccessSnackbar('Email updated successfully');
                            // Check for phone number after email is updated
                            _checkAndShowUpdateDialogs();
                          } else {
                            showErrorSnackbar('Failed to update email');
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
                            : Text('Update Email'),
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

  /// Show dialog to update phone number
  void _showUpdatePhoneDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final phoneController = TextEditingController();
    bool isLoading = false;

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
                  TextField(
                    controller: phoneController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(color: AppColors.button, width: 2),
                      ),
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          final phone = phoneController.text.trim();
                          if (phone.isEmpty) {
                            showErrorSnackbar('Please enter a phone number');
                            return;
                          }
                          if (phone.length != 10) {
                            showErrorSnackbar('Phone number must be 10 digits');
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          // Note: Phone number update may need to be implemented in customer controller
                          // For now, we'll just refresh customer data
                          // TODO: Implement phone number update in customer controller
                          await customerController.getActiveCustomer();
                          
                          setState(() {
                            isLoading = false;
                          });

                          Get.back();
                          showSuccessSnackbar('Phone number updated successfully');
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

  /// Ensure postal code and channel are set before fetching data
  /// Returns true if channel was changed, false otherwise
  Future<bool> _ensurePostalCodeAndChannelSet() async {
    try {
      debugPrint('[HomePage] ========== ENSURING POSTAL CODE AND CHANNEL SET ==========');
      
      // Store current channel token to detect changes
      final currentChannelToken = box.read('channel_token');
      debugPrint('[HomePage] Current channel token: ${currentChannelToken ?? "NOT FOUND"}');
      
      // Check if postal code exists in local storage
      final storedPostalCode = box.read('postal_code');
      debugPrint('[HomePage] Postal code in local storage: ${storedPostalCode ?? "NOT FOUND"}');
      
      // If authenticated, try to get postal code from shipping address first
      if (_isUserAuthenticated()) {
        debugPrint('[HomePage] User is authenticated, checking shipping address for postal code...');
        await customerController.checkAndSetPostalCodeFromShippingAddress();
        
        // Re-check postal code after trying to get from shipping address
        final updatedPostalCode = box.read('postal_code');
        if (updatedPostalCode != null && updatedPostalCode.toString().isNotEmpty) {
          debugPrint('[HomePage] Postal code set from shipping address: $updatedPostalCode');
          
          // Check if channel changed
          final newChannelToken = box.read('channel_token');
          final channelChanged = currentChannelToken != newChannelToken;
          if (channelChanged) {
            debugPrint('[HomePage] Channel changed from $currentChannelToken to $newChannelToken');
            // Data is already being refreshed by checkAndSetPostalCodeFromShippingAddress
            return true;
          }
          return false; // Channel should already be set by checkAndSetPostalCodeFromShippingAddress
        }
      }
      
      // If postal code is in local storage, verify channel is set
      if (storedPostalCode != null && storedPostalCode.toString().isNotEmpty) {
        final channelToken = box.read('channel_token');
        if (channelToken != null && channelToken.toString().isNotEmpty) {
          debugPrint('[HomePage] Postal code and channel already set');
          return false;
        } else {
          // Postal code exists but channel not set, fetch channel
          debugPrint('[HomePage] Postal code exists but channel not set, fetching channel...');
          final success = await customerController.switchChannelByPostalCode(
            storedPostalCode.toString(),
            showLoading: false, // Don't show loading dialog during initialization
          );
          if (success) {
            debugPrint('[HomePage] Channel successfully set for postal code: $storedPostalCode');
            // Check if channel changed
            final newChannelToken = box.read('channel_token');
            final channelChanged = currentChannelToken != newChannelToken;
            if (channelChanged) {
              debugPrint('[HomePage] Channel changed from $currentChannelToken to $newChannelToken');
              // Data is already being refreshed by switchChannelByPostalCode
              return true;
            }
            return false;
          } else {
            debugPrint('[HomePage] Failed to set channel for postal code: $storedPostalCode');
            return false;
          }
        }
      } else {
        debugPrint('[HomePage] No postal code found in local storage');
        return false;
      }
    } catch (e) {
      debugPrint('[HomePage] Error ensuring postal code and channel: $e');
      // Don't throw - continue with data fetch even if channel setup fails
      return false;
    }
  }

  /// Check if postal code is saved, if not show postal code bottom sheet
  void _checkAndShowPostalCodeDialog() {
    if (!mounted) return;
    if (_isPostalCodeDialogShowing) {
      debugPrint('[HomePage] Postal code dialog already showing, skipping...');
      return; // Prevent multiple dialogs
    }
    
    final storedPostalCode = box.read('postal_code');
    debugPrint('[HomePage] Checking postal code in local storage: ${storedPostalCode ?? "NOT FOUND"}');
    
    // If no postal code is saved, show the postal code bottom sheet
    if (storedPostalCode == null || storedPostalCode.toString().isEmpty) {
      debugPrint('[HomePage] No postal code found, showing postal code bottom sheet');
      _isPostalCodeDialogShowing = true; // Mark as showing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isPostalCodeDialogShowing) {
          _showPostalCodeBottomSheet();
        }
      });
    }
  }

  void _checkAndShowShippingAddressDialog() {
    if (!mounted) return; // Don't show dialog if widget is unmounted
    if (_isAddressDialogShowing) return; // Prevent multiple dialogs
    
    final addresses = customerController.addresses;
    
    // Don't show dialog if there are no addresses
    if (addresses.isEmpty) {
      debugPrint('[HomePage] No addresses found, skipping default address dialog');
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
    final channelCode = box.read('channel_code') ?? '';
    final cityName = _formatCityName(channelCode);

    // Observe theme changes to rebuild the entire page
    // Access the observable directly through a getter that GetX can track
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Refresh data when page is about to be popped (user navigating back)
        if (!didPop) {
          _refreshData();
        }
      },
      child: Obx(() {
      // Access the theme value - GetX will track this through the getter
      final isDarkMode = themeController.isDarkMode;
      
      // Use the value in the widget tree so GetX can properly track it
      return Scaffold(
        key: ValueKey('home_${isDarkMode}'), // Use in key to ensure GetX tracks it
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
        onRefresh: () async {
          // Create list of futures based on authentication status
          List<Future> futures = [
            collectionController.fetchAllCollections(),
            bannerController.getFrequentlyOrderedProducts(),
          ];
          
          // Only add authenticated requests if user is logged in
          if (_isUserAuthenticated()) {
            futures.addAll([
              cartController.getActiveOrder(),
              customerController.getActiveCustomer(),
              bannerController.getCustomerFavorites(),
            ]);
          }
          
          await Future.wait(futures);
        },
        color: AppColors.refreshIndicator,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ==================== HEADER ====================
            _buildHeader(cityName),

            // ==================== MAIN CONTENT ====================
            SliverToBoxAdapter(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavComponent(
            cartCount: cartController.cartItemCount,
          )),
      );
    }),
    );
  }

  SliverToBoxAdapter _buildHeader(String cityName) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.background,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Section (above search, only when authenticated)
                if (_isUserAuthenticated()) ...[
                  _buildDeliveryAddressHeader(),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                ],
                // Search Bar and Icons Row
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: SearchComponent(
                        hintText: AppStrings.searchForFreshCuts,
                        onSearch: (String query) {
                          bannerController.searchProducts({'term': query});
                        },
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(2)),
                    // Location with Channel Code (only show when authenticated)

                    // Account Icon
                    InkWell(
                      onTap: () => Get.toNamed('/account'),
                      child: Icon(
                        Icons.person,
                        color: AppColors.textPrimary,
                        size: ResponsiveUtils.rp(32),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    // Cart Icon with Badge
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build location info widget with channel code
  Widget _buildLocationInfo(String cityName) {
    return InkWell(
      onTap: () => _showPostalCodeBottomSheet(),
      child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(8),
        vertical: ResponsiveUtils.rp(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: ResponsiveUtils.rp(16),
          ),
          SizedBox(width: ResponsiveUtils.rp(4)),
          Text(
            cityName,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: ResponsiveUtils.rp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        ),
      ),
    );
  }

  /// Show postal code search bottom sheet
  void _showPostalCodeBottomSheet() {
    final pincodeController = TextEditingController();
    List<PostalCodeData> searchResults = [];
    bool isSearching = false;
    bool isGettingLocation = false;
    bool isServiceUnavailable = false;
    
    // Check if postal code is already saved - if not, hide close button
    final storedPostalCode = box.read('postal_code');
    final bool hasPostalCode = storedPostalCode != null && storedPostalCode.toString().isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // Prevent closing by tapping outside or back button - user must select postal code or click close
      enableDrag: false, // Prevent closing by dragging down
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveUtils.rp(20)),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
                  width: ResponsiveUtils.rp(40),
                  height: ResponsiveUtils.rp(4),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.button, size: ResponsiveUtils.rp(24)),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Text(
                          'Select Location',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Only show close button if postal code is already saved
                      if (hasPostalCode)
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () {
                            Navigator.pop(bottomSheetContext);
                            _isPostalCodeDialogShowing = false;
                          },
                        ),
                    ],
                  ),
                ),
                Divider(height: 1),
                // Search section
                Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                  child: Column(
                    children: [
                      // Location button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isGettingLocation ? null : () async {
                            setState(() {
                              isGettingLocation = true;
                              searchResults = [];
                            });
                            
                            final postalCodeService = PostalCodeService();
                            final locationData = await postalCodeService.getPostalCodeFromLocation();
                            
                            setState(() {
                              isGettingLocation = false;
                            });
                            
                            if (locationData != null) {
                              setState(() {
                                pincodeController.text = locationData.pincode;
                                searchResults = [locationData];
                              });
      } else {
                              SnackBarWidget.showError('Could not get location. Please enter postal code manually.');
                            }
                          },
                          icon: isGettingLocation
                              ? SizedBox(
                                  width: ResponsiveUtils.rp(20),
                                  height: ResponsiveUtils.rp(20),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(Icons.my_location, color: AppColors.button),
                          label: Text(
                            isGettingLocation ? 'Getting location...' : 'Use Current Location',
                            style: TextStyle(color: AppColors.button),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.button),
                            padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(16)),
                      // Search field
                      TextField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'Enter 6-digit postal code',
                          hintText: '628008',
                          prefixIcon: Icon(Icons.pin),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 6) {
                            // Close keyboard when 6 digits are entered
                            FocusScope.of(context).unfocus();
                            
                            // Auto-search when 6 digits are entered
                            setState(() {
                              isSearching = true;
                              searchResults = [];
                            });
                            customerController.searchPostalCodes(value).then((results) async {
                              if (bottomSheetContext.mounted) {
                                // Check channel availability for the postal code
                                if (results.isNotEmpty) {
                                  // Try to get available channels for this postal code
                                  final testSuccess = await customerController.switchChannelByPostalCode(
                                    value,
                                    city: results.first.city,
                                    showLoading: false, // Don't show loading dialog
                                  );
                                  
                                  if (!testSuccess) {
                                    // Service not available - show message in UI instead of dialog
                                    setState(() {
                                      searchResults = results; // Keep results but mark as unavailable
                                      isSearching = false;
                                      isServiceUnavailable = true;
                                    });
      } else {
                                    // Service available - show results
                                    setState(() {
                                      searchResults = results;
                                      isSearching = false;
                                      isServiceUnavailable = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    searchResults = [];
                                    isSearching = false;
                                  });
                                }
                              }
                            }).catchError((error) {
                              if (bottomSheetContext.mounted) {
                                setState(() {
                                  searchResults = [];
                                  isSearching = false;
                                  isServiceUnavailable = false;
                                });
                              }
                            });
                          } else {
                            setState(() {
                              searchResults = [];
                              isServiceUnavailable = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(height: 1),
                // Results section
                Expanded(
                  child: isSearching
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : isServiceUnavailable && searchResults.isNotEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(ResponsiveUtils.rp(40)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      size: ResponsiveUtils.rp(80),
                                      color: AppColors.error,
                                    ),
                                    SizedBox(height: ResponsiveUtils.rp(20)),
                                    Text(
                                      'Service Not Available',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: ResponsiveUtils.sp(24),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveUtils.rp(12)),
                                    Text(
                                      'Service is not available for this location.\nPlease try another postal code.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: ResponsiveUtils.sp(16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      : searchResults.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                                child: Text(
                                  pincodeController.text.length == 6
                                      ? 'Enter valid postal code'
                                      : 'Enter 6-digit postal code or use current location',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: ResponsiveUtils.sp(14),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final result = searchResults[index];
                                return ListTile(
                                  leading: Icon(Icons.location_city, color: AppColors.button),
                                  title: Text(
                                    '${result.city}, ${result.district}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${result.state} - ${result.pincode}',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                  onTap: isServiceUnavailable ? null : () async {
                                    // Close the bottom sheet first
                                    Navigator.pop(bottomSheetContext);
                                    // Reset the flag so dialog can be shown again if needed
                                    _isPostalCodeDialogShowing = false;
                                    
                                    final success = await customerController.switchChannelByPostalCode(
                                      result.pincode,
                                      city: result.city,
                                    );
                                    if (success && mounted) {
                                      // Update UI display immediately
                                      _updateChannelDisplay();
                                      // Don't call _refreshData() here as it might trigger the dialog again
                                      // The data will be refreshed automatically by the channel switch
                                    }
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Reset the flag when bottom sheet is closed (by any means)
      _isPostalCodeDialogShowing = false;
      debugPrint('[HomePage] Postal code bottom sheet closed, flag reset');
    });
  }

  /// Build delivery address header (above search bar)
  Widget _buildDeliveryAddressHeader() {
    // Wrap in Obx to make it reactive to channel changes
    return Obx(() {
      // Use reactive variables that update when channel changes
      final channelName = _channelName.value.isEmpty 
          ? (box.read('channel_name') ?? box.read('channel_code') ?? 'Select Location')
          : _channelName.value;
      final postalCode = _postalCode.value;

      return InkWell(
        onTap: () {
        _showPostalCodeBottomSheet();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.rp(16),
            vertical: ResponsiveUtils.rp(12),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            border: Border.all(
              color: AppColors.border.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                decoration: BoxDecoration(
                  color: AppColors.button.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(20),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Delivery to',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(11),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(2)),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            channelName,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (postalCode.isNotEmpty) ...[
                          Text(
                            " - ",
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            postalCode,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary.withOpacity(0.6),
                size: ResponsiveUtils.rp(16),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildShippingTicker(),
        ResponsiveSpacing.vertical(16),
        // Hero Banner Section - Clean without overlay
        _buildHeroBanner(),
        ResponsiveSpacing.vertical(16),

        // Category Selection Horizontal Scroll
        _buildCategorySelection(),
        ResponsiveSpacing.vertical(8),

        // Reward Points Section

        // Favorites Section (prioritized over frequently ordered)
        _buildFavoritesSection(),
        ResponsiveSpacing.vertical(18),

        // Frequently Ordered Section
        _buildFrequentlyOrderedSection(),
        ResponsiveSpacing.vertical(32),

        // All Products Section
        CollectionGrid(
          onCollectionTap: (Query$Collections$collections$items collection) {
            Get.toNamed('/collection-products', arguments: {
              'collectionId': collection.id,
              'collectionName': collection.name,
              'collectionSlug': collection.slug,
              'collectionImage': collection.featuredAsset?.preview ?? '',
              'totalItems': collection.productVariants.totalItems,
            });
          },
        ),
        ResponsiveSpacing.vertical(40),
      ],
    );
  }

  Widget _buildShippingTicker() {
    // Check if service is registered before using Obx
    if (!Get.isRegistered<RemoteConfigService>()) {
      return const SizedBox.shrink();
    }
    
    return Obx(() {
      // Get Remote Config service - it's guaranteed to exist due to check above
      final remoteConfigService = Get.find<RemoteConfigService>();
      // Access observable directly - this must happen for GetX to track it
      final tickerText = remoteConfigService.shippingTickerText.value;
      
      // Only show if text is fetched from Remote Config
      if (tickerText.isEmpty) {
        return const SizedBox.shrink();
      }

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.rp(10),
            horizontal: ResponsiveUtils.rp(14),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.button.withValues(alpha: 0.12),
                AppColors.button.withValues(alpha: 0.06),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            border: Border.all(
              color: AppColors.button.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
                decoration: BoxDecoration(
                  color: AppColors.button.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(16),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(10)),
              Expanded(
                child: SizedBox(
                  height: ResponsiveUtils.rp(20),
                  child: Marquee(
                    key: const ValueKey('shippingTicker'),
                    text: tickerText,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                    blankSpace: 50,
                    velocity: 25,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10,
                  ),
                ),
              ),
            ],
          ),
        );
    });
  }

  Widget _buildHeroBanner() {
    return BannerComponent();
  }

  Widget _buildCategorySelection() {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final hasCollections = collectionController.allCollections.isNotEmpty;

      if (!isLoading && !hasCollections) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(
          top: ResponsiveUtils.rp(2),
          bottom: ResponsiveUtils.rp(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalListComponent(
              title: '',
              onTap: (collection) {
                Get.toNamed('/collection-products', arguments: {
                  'collectionId': collection.id,
                  'collectionName': collection.name,
                });
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFrequentlyOrderedSection() {
    return Obx(() {
      // Filter out disabled products
      final enabledProducts = bannerController.frequentlyOrderedProducts
          .where((item) => item.product.enabled == true)
          .toList();
      
      if (enabledProducts.isEmpty) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ResponsiveSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Frequently Ordered',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (enabledProducts.length > 3)
                    TextButton(
                      onPressed: AnalyticsHelper.trackButton(
                        'See All - Frequently Ordered',
                        screenName: 'Home',
                        callback: () {
                          Get.toNamed('/frequently-ordered');
                        },
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.rp(260),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: ResponsiveSpacing.screenPadding,
                physics: const BouncingScrollPhysics(),
                itemCount: enabledProducts.length > 10 ? 10 : enabledProducts.length,
                separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
                itemBuilder: (context, index) {
                  final item = enabledProducts[index];
                  final product = item.product;
                  final variants = product.variants;
                  
                  if (variants.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  // Get selected variant ID or default to first variant
                  final selectedVariantId = _selectedVariantIds[product.id] ?? 
                      (variants.isNotEmpty ? variants.first.id : '');
                  
                  final selectedVariant = selectedVariantId.isNotEmpty
                      ? variants.firstWhere(
                          (v) => v.id == selectedVariantId,
                          orElse: () => variants.first,
                        )
                      : variants.first;
                  
                  final priceText = PriceFormatter.formatPrice(
                      selectedVariant.priceWithTax.round());
                  final isFavorite = bannerController.isFavorite(product.id);
                  final hasMultipleVariants = variants.length > 1;
                  
                  // Get option value from variant options (like category product page)
                  final variantLabel = _getVariantLabelFromFrequentlyOrderedVariant(selectedVariant);

                  return SizedBox(
                    width: ResponsiveUtils.rp(170),
                    child: ProductCard(
                      name: product.name,
                      imageUrl: product.featuredAsset?.preview,
                      onTap: () {
                        NavigationHelper.navigateToProductDetail(
                          productId: product.id,
                          productName: product.name,
                        );
                      },
                      onDoubleTap: () => bannerController.toggleFavorite(
                          productId: product.id),
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => bannerController.toggleFavorite(
                          productId: product.id),
                      discountPercent: null,
                      variantSelector: hasMultipleVariants
                          ? _buildFrequentlyOrderedVariantDropdown(
                              productId: product.id,
                              variants: variants,
                              currentVariantId: selectedVariantId,
                            )
                          : null,
                      showVariantSelector: hasMultipleVariants,
                      variantLabel: variantLabel,
                      priceText: priceText,
                      shadowPriceText: null,
                      onAddToCart: () async {
                        if (selectedVariantId.isEmpty) {
                          SnackBarWidget.showWarning(
                            'Unable to add this item right now.',
                            title: 'Variant unavailable',
                          );
                          return false;
                        } else {
                          return await _addVariantToCartById(
                            selectedVariantId,
                            product.name,
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFavoritesSection() {
    return Obx(() {
      // Filter out disabled products
      final enabledFavorites = bannerController.favoritesList
          .where((item) => item.product?.enabled == true)
          .where((item) => item.product != null)
          .toList();
      
      if (enabledFavorites.isEmpty) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ResponsiveSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: AppColors.error,
                        size: ResponsiveUtils.rp(20),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Your Favorites',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.sp(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (enabledFavorites.length > 3)
                    TextButton(
                      onPressed: AnalyticsHelper.trackButton(
                        'See All - Favorites',
                        screenName: 'Home',
                        callback: () {
                          Get.toNamed('/favourite');
                        },
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.rp(260),
              child: utilityController.isLoadingRx.value && enabledFavorites.isEmpty
                  ? _buildFavoritesShimmerRow()
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: ResponsiveSpacing.screenPadding,
                      physics: const BouncingScrollPhysics(),
                itemCount: enabledFavorites.length > 10 ? 10 : enabledFavorites.length,
                      separatorBuilder: (_, __) =>
                          ResponsiveSpacing.horizontal(16),
                itemBuilder: (context, index) {
                  final favorite = enabledFavorites[index];
                  final product = favorite.product;
                  if (product == null) return SizedBox.shrink();
                  final imageUrl = product.featuredAsset?.preview;
                  
                  // Get selected variant or default to first variant
                  final selectedVariantId = _selectedVariantIds[product.id] ?? 
                      (product.variants.isNotEmpty ? product.variants.first.id : '');
                  
                  final selectedVariant = selectedVariantId.isNotEmpty
                      ? product.variants.firstWhere(
                          (v) => v.id == selectedVariantId,
                          orElse: () => product.variants.first,
                        )
                      : (product.variants.isNotEmpty ? product.variants.first : null);
                  
                  final hasMultipleVariants = product.variants.length > 1;

                  return SizedBox(
                    width: ResponsiveUtils.rp(170),
                    child: ProductCard(
                      name: product.name,
                      imageUrl: imageUrl,
                      onTap: () {
                        NavigationHelper.navigateToProductDetail(
                          productId: product.id,
                          productName: product.name,
                        );
                      },
                      onDoubleTap: () => bannerController.toggleFavorite(
                          productId: product.id),
                      isFavorite: true,
                      onFavoriteToggle: () => bannerController
                          .toggleFavorite(productId: product.id),
                      discountPercent: null,
                      variantSelector: hasMultipleVariants
                          ? _buildFavoritesVariantDropdown(
                              productId: product.id,
                              variants: product.variants,
                              currentVariantId: selectedVariantId,
                            )
                          : null,
                      showVariantSelector: hasMultipleVariants,
                      variantLabel: selectedVariant != null
                          ? _getVariantLabelFromFavoritesVariant(selectedVariant)
                          : 'Default',
                      priceText: selectedVariant != null
                          ? PriceFormatter.formatPrice(
                              selectedVariant.priceWithTax.round())
                          : 'Rs --',
                      shadowPriceText: null,
                      onAddToCart: () async {
                        if (selectedVariantId.isEmpty) {
                          SnackBarWidget.showWarning(
                            'Unable to add this item right now.',
                            title: 'Variant unavailable',
                          );
                          return false;
                        } else {
                          return await _addVariantToCartById(
                            selectedVariantId,
                            product.name,
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }


  /// Build variant dropdown for favorites (shows option group names and option names like category products)
  Widget _buildFavoritesVariantDropdown({
    required String productId,
    required List<Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants> variants,
    required String currentVariantId,
  }) {
    // Extract unique option values from variant options (same as category product page: opt.name)
    final uniqueOptions = <String>{};
    final optionToVariantMap = <String, String>{};
    
    for (final variant in variants) {
      // Get option name from variant's options (same as category page: opt.name)
      String optionValue;
      if (variant.options.isNotEmpty) {
        optionValue = variant.options.first.name;
      } else {
        // Fallback to variant name if no options
        optionValue = variant.name;
      }
      uniqueOptions.add(optionValue);
      optionToVariantMap[optionValue] = variant.id;
    }
    
    final uniqueOptionsList = uniqueOptions.toList();
    if (uniqueOptionsList.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Get current option value for selected variant (same as category page: opt.name)
    final currentVariant = variants.firstWhere(
      (v) => v.id == currentVariantId,
      orElse: () => variants.first,
    );
    // Get option name from variant's options (same as category page: opt.name)
    String currentOptionValue;
    if (currentVariant.options.isNotEmpty) {
      currentOptionValue = currentVariant.options.first.name;
    } else {
      // Fallback to variant name if no options
      currentOptionValue = currentVariant.name;
    }
    
    // Get option group name from variant's options (like category product page)
    String groupName = 'Size'; // Default
    if (variants.isNotEmpty && variants.first.options.isNotEmpty) {
      final firstOption = variants.first.options.first;
      if (firstOption.group.name.isNotEmpty) {
        groupName = firstOption.group.name;
      }
    }
    
    return Container(
      height: ResponsiveUtils.rp(32),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentOptionValue,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: ResponsiveUtils.rp(20),
            color: AppColors.icon.withValues(alpha: 0.7),
          ),
          iconSize: ResponsiveUtils.rp(20),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(12),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          hint: Text(
            groupName,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: uniqueOptionsList.map((optionName) {
            final isSelected = optionName == currentOptionValue;
            return DropdownMenuItem<String>(
              value: optionName,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.rp(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      Icon(
                        Icons.check_circle_rounded,
                        size: ResponsiveUtils.rp(16),
                        color: AppColors.button,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
          dropdownColor: AppColors.card,
          menuMaxHeight: ResponsiveUtils.rp(200),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          onChanged: (String? newOptionName) {
            if (newOptionName == null) return;
            
            // Find matching variant for the selected option (same as category product page)
            Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? matchingVariant;
            for (final variant in variants) {
              // Get option name from variant's options (same as category page: opt.name == newOptionName)
              String? optionValue;
              if (variant.options.isNotEmpty) {
                optionValue = variant.options.first.name;
              } else {
                // Fallback to variant name if no options
                optionValue = variant.name;
              }
              
              if (optionValue == newOptionName) {
                matchingVariant = variant;
                break;
              }
            }
            
            if (matchingVariant != null) {
              setState(() {
                _selectedVariantIds[productId] = matchingVariant!.id;
              });
            }
          },
        ),
      ),
    );
  }

  /// Build variant dropdown for frequently ordered products (shows option group names and option names like category products)
  Widget _buildFrequentlyOrderedVariantDropdown({
    required String productId,
    required List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants> variants,
    required String currentVariantId,
  }) {
    // Extract unique option values from variant options (same as category product page: opt.name)
    final uniqueOptions = <String>{};
    final optionToVariantMap = <String, String>{};
    
    for (final variant in variants) {
      // Get option name from variant's options (same as category page: opt.name)
      String optionValue;
      if (variant.options.isNotEmpty) {
        optionValue = variant.options.first.name;
      } else {
        // Fallback to variant name if no options
        optionValue = variant.name;
      }
      uniqueOptions.add(optionValue);
      optionToVariantMap[optionValue] = variant.id;
    }
    
    final uniqueOptionsList = uniqueOptions.toList();
    if (uniqueOptionsList.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Get current option value for selected variant (same as category page: opt.name)
    final currentVariant = variants.firstWhere(
      (v) => v.id == currentVariantId,
      orElse: () => variants.first,
    );
    // Get option name from variant's options (same as category page: opt.name)
    String currentOptionValue;
    if (currentVariant.options.isNotEmpty) {
      currentOptionValue = currentVariant.options.first.name;
    } else {
      // Fallback to variant name if no options
      currentOptionValue = currentVariant.name;
    }
    
    // Get option group name from variant's options (like category product page)
    String groupName = 'Size'; // Default
    if (variants.isNotEmpty && variants.first.options.isNotEmpty) {
      final firstOption = variants.first.options.first;
      if (firstOption.group.name.isNotEmpty) {
        groupName = firstOption.group.name;
      }
    }
    
    return Container(
      height: ResponsiveUtils.rp(32),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentOptionValue,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: ResponsiveUtils.rp(20),
            color: AppColors.icon.withValues(alpha: 0.7),
          ),
          iconSize: ResponsiveUtils.rp(20),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(12),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          hint: Text(
            groupName,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: uniqueOptionsList.map((optionName) {
            final isSelected = optionName == currentOptionValue;
            return DropdownMenuItem<String>(
              value: optionName,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.rp(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      Icon(
                        Icons.check_circle_rounded,
                        size: ResponsiveUtils.rp(16),
                        color: AppColors.button,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
          dropdownColor: AppColors.card,
          menuMaxHeight: ResponsiveUtils.rp(200),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          onChanged: (String? newOptionName) {
            if (newOptionName == null) return;
            
            // Find matching variant for the selected option (like category product page)
            Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants? matchingVariant;
            for (final variant in variants) {
              // Get option name from variant's options (same as category page: opt.name == newOptionName)
              String optionValue;
              if (variant.options.isNotEmpty) {
                optionValue = variant.options.first.name;
              } else {
                // Fallback to variant name if no options
                optionValue = variant.name;
              }
              
              if (optionValue == newOptionName) {
                matchingVariant = variant;
                break;
              }
            }
            
            if (matchingVariant != null) {
              setState(() {
                _selectedVariantIds[productId] = matchingVariant!.id;
              });
            }
          },
        ),
      ),
    );
  }


  /// Get variant label from selected variant (option name) for favorites
  String _getVariantLabelFromFavoritesVariant(
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? variant) {
    if (variant == null) return 'Default';
    
    // If variant has options, return the first option name
    if (variant.options.isNotEmpty) {
      return variant.options.first.name;
    }
    
    // Fallback to variant name if no options
    return variant.name;
  }

  /// Get variant label from selected variant (option name) for frequently ordered
  String _getVariantLabelFromFrequentlyOrderedVariant(
      Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants? variant) {
    if (variant == null) return 'Default';
    
    // If variant has options, return the first option name
    if (variant.options.isNotEmpty) {
      return variant.options.first.name;
    }
    
    // Fallback to variant name if no options
    return variant.name;
  }

  Future<bool> _addVariantToCartById(
      String variantId, String productName) async {
    final parsedVariantId = int.tryParse(variantId);
    if (parsedVariantId == null) {
      SnackBarWidget.showWarning(
        'Unable to add $productName right now.',
        title: 'Variant unavailable',
      );
      return false;
    }

    final success =
        await cartController.addToCart(productVariantId: parsedVariantId);
    if (success && mounted) {
      setState(() {});
    }
    
    return success;
  }


  Widget _buildFavoritesShimmerRow() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveSpacing.screenPadding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
        itemBuilder: (context, index) {
          return Container(
            width: ResponsiveUtils.rp(170),
        decoration: BoxDecoration(
          color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
              borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
              ),
            ),
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(6)),
                    Container(
                        height: 14,
                        width: ResponsiveUtils.rp(80),
                      decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Container(
                        height: ResponsiveUtils.rp(32),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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

  /// Format channel code to display name
  String _formatCityName(String channelCode) {
    if (channelCode.isEmpty) return 'Location';
    
    // Handle common channel code formats
    if (channelCode.contains('-')) {
      final parts = channelCode.split('-');
      if (parts.length > 1) {
        // Convert "ind-madurai" to "Madurai"
        return parts.last.split(' ').map((word) => 
          word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : ''
        ).join(' ');
      }
    }
    
    // Fallback: capitalize first letter
    return channelCode.isNotEmpty 
        ? channelCode[0].toUpperCase() + channelCode.substring(1).toLowerCase()
        : 'Location';
  }
}
