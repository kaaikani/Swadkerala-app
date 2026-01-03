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
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
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
  
  // Reactive variables for channel and postal code to trigger UI updates
  final RxString _channelName = ''.obs;
  final RxString _postalCode = ''.obs;
  final RxString _channelType = ''.obs;
  final RxString _channelToken = ''.obs; // Track channel token changes

  @override
  void initState() {
    super.initState();
    // Initialize reactive variables
    _updateChannelDisplay();
    _refreshData();
    
    // Listen to channel token changes and update UI immediately
    ever(GraphqlService.channelTokenRx, (String newToken) {
      debugPrint('[HomePage] 🔄 Channel token changed reactively: $newToken');
      if (mounted) {
        _updateChannelDisplay();
        // Force UI refresh when channel changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
            // Refresh data with new channel
            _refreshData();
          }
        });
      }
    });
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

  /// Update reactive channel display variables
  void _updateChannelDisplay() {
    final newChannelName = box.read('channel_name') ?? box.read('channel_code') ?? 'Select Location';
    // Ensure postal code is always converted to string for proper comparison
    final postalCodeValue = box.read('postal_code');
    final newPostalCode = postalCodeValue != null ? postalCodeValue.toString() : '';
    final newChannelType = box.read('channel_type')?.toString() ?? '';
    final newChannelToken = box.read('channel_token')?.toString() ?? GraphqlService.channelToken;
    
    // Track channel token changes to force UI refresh
    bool channelTokenChanged = false;
    bool postalCodeChanged = false;
    bool channelNameChanged = false;
    
    if (_channelToken.value != newChannelToken) {
      _channelToken.value = newChannelToken;
      channelTokenChanged = true;
      debugPrint('[HomePage] ⚠️ Channel token changed - forcing UI refresh');
    }
    
    // Always update reactive variables to trigger Obx rebuild, even if value appears same
    // This ensures UI updates when postal code changes
    if (_channelName.value != newChannelName) {
      _channelName.value = newChannelName;
      channelNameChanged = true;
      debugPrint('[HomePage] Channel name updated: $newChannelName');
    } else {
      // Force update even if same to ensure Obx rebuilds
      _channelName.value = newChannelName;
    }
    
    // Always update postal code reactive variable to ensure UI reflects latest value
    // Convert to string to ensure consistent comparison
    final currentPostalCodeStr = _postalCode.value;
    if (currentPostalCodeStr != newPostalCode) {
      _postalCode.value = newPostalCode;
      postalCodeChanged = true;
      debugPrint('[HomePage] Postal code updated: $newPostalCode (was: $currentPostalCodeStr)');
    } else if (newPostalCode.isNotEmpty) {
      // Even if value appears same, ensure reactive variable is set (handles type mismatches)
      _postalCode.value = newPostalCode;
      debugPrint('[HomePage] Postal code refreshed: $newPostalCode');
    }
    
    if (_channelType.value != newChannelType) {
      _channelType.value = newChannelType;
      debugPrint('[HomePage] Channel type updated: $newChannelType');
    } else {
      // Force update even if same
      _channelType.value = newChannelType;
    }
    
    // If any value changed, force a UI refresh
    if ((channelTokenChanged || postalCodeChanged || channelNameChanged) && mounted) {
      debugPrint('[HomePage] ⚠️ Channel/postal code changed - triggering UI refresh');
      // Force rebuild by updating a reactive variable that the UI observes
      // This ensures all Obx widgets rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {}); // Force StatefulWidget rebuild
        }
      });
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
        
        // Force UI refresh after channel change to ensure UI updates
        if (mounted) {
          debugPrint('[HomePage] Forcing UI refresh after channel change...');
          _updateChannelDisplay(); // Update again to ensure UI reflects changes
          // Trigger a rebuild
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {});
            }
          });
        }
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

    // Clear any previous error
    customerController.emailUpdateError.value = '';

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
                  // Show error message if available
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
                  TextField(
                    controller: emailController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (customerController.emailUpdateError.value.isNotEmpty) {
                        customerController.emailUpdateError.value = '';
                      }
                    },
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

                          // Clear previous error
                          customerController.emailUpdateError.value = '';

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
                            // Error message is already set in controller and will be shown in UI
                            // Don't show snackbar as error is displayed in dialog
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
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
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
                            showErrorSnackbar('Please enter a phone number');
                            return;
                          }
                          if (phone.length != 10) {
                            showErrorSnackbar('Phone number must be 10 digits');
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
            debugPrint('[HomePage] ⚠️ Channel changed from $currentChannelToken to $newChannelToken');
            // Force UI refresh when channel changes
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _updateChannelDisplay();
                  setState(() {});
                }
              });
            }
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
              debugPrint('[HomePage] ⚠️ Channel changed from $currentChannelToken to $newChannelToken');
              // Force UI refresh when channel changes
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _updateChannelDisplay();
                    setState(() {});
                  }
                });
              }
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
  void _checkAndShowPostalCodeDialog() async {
    if (!mounted) {
      debugPrint('[HomePage] Widget not mounted, skipping postal code dialog check');
      return;
    }
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
      
      // Use multiple callbacks to ensure the widget tree is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isPostalCodeDialogShowing) {
          // Add a small delay to ensure context is fully available
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted && _isPostalCodeDialogShowing && context.mounted) {
              debugPrint('[HomePage] Showing postal code bottom sheet now...');
              _showPostalCodeBottomSheet(isMandatory: true);
            } else {
              debugPrint('[HomePage] Context not available, resetting flag');
              _isPostalCodeDialogShowing = false;
            }
          });
        }
      });
    } else {
      // Postal code exists - check if it has valid channels
      final postalCodeStr = storedPostalCode.toString();
      debugPrint('[HomePage] Checking if postal code has valid channels: $postalCodeStr');
      
      final hasValidChannels = await customerController.hasValidPostalCode(postalCodeStr);
      debugPrint('[HomePage] Postal code validity check result: $hasValidChannels');
      
      if (!hasValidChannels) {
        debugPrint('[HomePage] Postal code has no valid channels, showing mandatory postal code bottom sheet');
        _isPostalCodeDialogShowing = true; // Mark as showing
        
        // Use multiple callbacks to ensure the widget tree is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isPostalCodeDialogShowing) {
            // Add a small delay to ensure context is fully available
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted && _isPostalCodeDialogShowing && context.mounted) {
                debugPrint('[HomePage] Showing mandatory postal code bottom sheet now...');
                _showPostalCodeBottomSheet(isMandatory: true);
              } else {
                debugPrint('[HomePage] Context not available, resetting flag');
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
        // Also observe channel token changes to trigger UI updates
        final channelToken = GraphqlService.channelTokenRx.value;
        
        // Use the value in the widget tree so GetX can properly track it
        return Scaffold(
          key: ValueKey('home_${isDarkMode}_${channelToken}'), // Include channel token in key to force rebuild on channel change
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
            child: OrientationBuilder(
              builder: (context, orientation) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ==================== HEADER ====================
                    HomeHeader(
                      isUserAuthenticated: _isUserAuthenticated(),
                      isBrandChannel: _isBrandChannel(),
                      deliveryAddressHeader: _buildDeliveryAddressHeader(),
                      bannerController: bannerController,
                      channelName: _channelName.value.isNotEmpty 
                          ? _channelName.value 
                          : (box.read('channel_name')?.toString() ?? box.read('channel_code')?.toString() ?? 'Kaaikani'),
                      customerController: customerController,
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
            onSwitchStoreTap: _isUserAuthenticated() ? _showSwitchStoreBottomSheet : null,
          )),
        );
      }),
    );
  }

  /// Check if current channel type is BRAND (reactive)
  bool _isBrandChannel() {
    try {
      final channelType = _channelType.value.isEmpty 
          ? (box.read('channel_type')?.toString() ?? '')
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
              ResponsiveSpacing.vertical(16),
            ],
          );
        }),
        // Hero Banner Section - Clean without overlay
        _buildHeroBanner(),
        ResponsiveSpacing.vertical(16),

        // Category Selection Horizontal Scroll
        _buildCategorySelection(),
        ResponsiveSpacing.vertical(8),

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

  /// Show postal code search bottom sheet
  void _showPostalCodeBottomSheet({bool isMandatory = false}) {
    if (!mounted || !context.mounted) {
      debugPrint('[HomePage] Context not mounted, cannot show postal code bottom sheet');
      _isPostalCodeDialogShowing = false;
      return;
    }
    
    // Check if bottom sheet is already showing by checking Navigator
    if (Navigator.of(context).canPop()) {
      // There might be a route/dialog already showing, check more carefully
      debugPrint('[HomePage] Navigator can pop - checking if postal code sheet is already showing');
    }
    
    debugPrint('[HomePage] ========== SHOWING POSTAL CODE BOTTOM SHEET ==========');
    debugPrint('[HomePage] Is mandatory: $isMandatory');
    
    final storedPostalCode = box.read('postal_code');
    final bool hasValidPostalCode = storedPostalCode != null && storedPostalCode.toString().isNotEmpty && !isMandatory;

    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: hasValidPostalCode, // Only dismissible if postal code exists and is valid
        enableDrag: hasValidPostalCode, // Only draggable if postal code exists and is valid
        backgroundColor: Colors.transparent,
        builder: (BuildContext bottomSheetContext) {
          debugPrint('[HomePage] Building postal code bottom sheet widget');
          return HomePostalCodeSheet(
            customerController: customerController,
            isMandatory: isMandatory,
            onPostalCodeSelected: () {
              debugPrint('[HomePage] Postal code selected callback triggered');
              // Add small delay to ensure storage is written before reading
              Future.delayed(Duration(milliseconds: 150), () {
                if (mounted) {
                  // Read latest postal code from storage and update reactive variable immediately
                  final latestPostalCode = box.read('postal_code');
                  if (latestPostalCode != null) {
                    final postalCodeStr = latestPostalCode.toString();
                    if (_postalCode.value != postalCodeStr) {
                      _postalCode.value = postalCodeStr;
                      debugPrint('[HomePage] Postal code updated in callback: $postalCodeStr');
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
        debugPrint('[HomePage] Postal code bottom sheet closed');
        _isPostalCodeDialogShowing = false;
        debugPrint('[HomePage] Postal code bottom sheet closed, flag reset');
      }).catchError((error) {
        debugPrint('[HomePage] Error showing postal code bottom sheet: $error');
        _isPostalCodeDialogShowing = false;
      });
    } catch (e) {
      debugPrint('[HomePage] Exception showing postal code bottom sheet: $e');
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
    final storedPostalCode = box.read('postal_code');
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
            debugPrint('[HomePage] Channel switched callback triggered');
            // Force immediate UI update
            _updateChannelDisplay();
            // Refresh data and force UI rebuild
            if (mounted) {
              setState(() {});
              _refreshData();
            }
          },
        );
      },
    );
  }
}
