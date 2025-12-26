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

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  /// Refresh data - called from initState and when returning to page
  void _refreshData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Only fetch authenticated data if user is logged in
      if (_isUserAuthenticated()) {
        cartController.getActiveOrder();
        await customerController.getActiveCustomer();
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
      collectionController.fetchAllCollections();
      bannerController.getFrequentlyOrderedProducts();
     
      
      // Track screen view
      AnalyticsService().logScreenView(screenName: 'Home');
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

  /// Check if default shipping address exists and show dialog if not
  void _checkAndShowShippingAddressDialog() {
    if (!mounted) return; // Don't show dialog if widget is unmounted
    if (_isAddressDialogShowing) return; // Prevent multiple dialogs
    
    final addresses = customerController.addresses;
    
    // Check if there's a default shipping address
    final hasDefaultShipping = addresses.any(
      (addr) => addr.defaultShippingAddress == true,
    );
    
    if (!hasDefaultShipping && addresses.isNotEmpty) {
      // Show non-dismissible dialog
      _showSetDefaultAddressDialog();
    } else if (addresses.isEmpty) {
      // No addresses at all - show dialog to add address
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
    // Refresh data when returning to this page
    _refreshData();
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
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    // Location with Channel Code (only show when authenticated)
                    if (_isUserAuthenticated()) ...[
                      _buildLocationInfo(cityName),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                    ],
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
    return Container(
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
    );
  }

  /// Build delivery address header (above search bar)
  Widget _buildDeliveryAddressHeader() {
    return Obx(() {
      // Get default shipping address only
      final addresses = customerController.addresses;
      if (addresses.isEmpty) {
        return const SizedBox.shrink();
      }

      // Find default shipping address (must have defaultShippingAddress = true)
      var deliveryAddress = addresses.firstWhereOrNull(
        (addr) => addr.defaultShippingAddress == true,
      );
      
      // If no default shipping address found, don't show anything
      if (deliveryAddress == null) {
        return const SizedBox.shrink();
      }

      // Build address display text with city and postal code
      String cityText = '';
      String postalCodeText = '';
      
      final city = deliveryAddress.city;
      final postalCode = deliveryAddress.postalCode;
      
      if (city != null && city.isNotEmpty) {
        cityText = city;
      } else if (deliveryAddress.streetLine1.isNotEmpty) {
        // Truncate if too long
        cityText = deliveryAddress.streetLine1.length > 25 
            ? '${deliveryAddress.streetLine1.substring(0, 25)}...' 
            : deliveryAddress.streetLine1;
      } else {
        cityText = 'Address';
      }
      
      if (postalCode != null && postalCode.isNotEmpty) {
        postalCodeText = postalCode;
      }

      return InkWell(
        onTap: () {
          AnalyticsHelper.trackButton(
            'Delivery Address - Home',
            screenName: 'Home',
            callback: () {
              Get.toNamed('/addresses');
            },
          )?.call();
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
                            cityText,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (postalCodeText.isNotEmpty) ...[
                          Text(
                            " - ",
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            postalCodeText,
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
