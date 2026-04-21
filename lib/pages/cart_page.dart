import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/coupon/coupon_controller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../routes.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart/cart_empty_state.dart';
import '../widgets/cart/cart_shimmer_loading.dart';
import '../widgets/cart/cart_items_list.dart';
import '../widgets/cart/cart_order_summary_section.dart';
import '../widgets/cart/cart_checkout_section.dart';
import '../utils/responsive.dart';
import '../utils/app_strings.dart';
import '../theme/colors.dart';
import '../services/analytics_service.dart';
import '../utils/analytics_helper.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with WidgetsBindingObserver {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final UtilityController utilityController = Get.find<UtilityController>();
  final BannerController bannerController = Get.find<BannerController>();
  final CouponController couponController = Get.find<CouponController>();
  final CustomerController customerController = Get.find<CustomerController>();

  // Scroll controller and keys
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _cartItemsListKey = GlobalKey();

  // Animation states for item removal
  String? _removingItemId; // Track which item is being removed (single item)
  bool _isClearingCart = false; // Track if cart is being cleared (all items)
  
  // Local loading flag to prevent flicker on initial load
  bool _isInitialLoading = true;
  
  // Track if data refresh is in progress to prevent duplicate calls
  bool _isRefreshingData = false;
  
  // Track which order line is currently being adjusted (for loading state)
  final Set<String> _adjustingOrderLineIds = <String>{};
  
  // Track if this is the first build to prevent unnecessary refreshes
  bool _isFirstBuild = true;
  
  // Track the last route to detect when returning to cart page
  String? _lastRoute;

  @override
  void initState() {
    super.initState();
    
    // Add observer to detect app lifecycle and route changes
    WidgetsBinding.instance.addObserver(this);
    
    // Store current route
    _lastRoute = Get.currentRoute;
    
    _refreshData();
  }

  /// Refresh data - called from initState and when returning to page
  void _refreshData() {
    // Prevent duplicate refresh calls
    if (_isRefreshingData) {
      return;
    }
    
    _isRefreshingData = true;
    // Load data without showing loading state to prevent flicker
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load cart first
      await cartController.getActiveOrder();

      // Load customer data in parallel
      await customerController.getActiveCustomer();

      // Mark refresh as complete
      _isRefreshingData = false;

      // Mark initial loading as complete after first frame
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }

      // Track screen view
      AnalyticsService().logScreenView(screenName: 'Cart');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRemoveItem(String orderLineId, String productName) async {
    // Set removing state to trigger slide-out animation
    setState(() {
      _removingItemId = orderLineId;
    });

    // Wait for animation to complete (slide-out)
    await Future.delayed(const Duration(milliseconds: 300));

    final success = await orderController.removeOrderLine(orderLineId);

    if (success) {
      // Clear removing state
      setState(() {
        _removingItemId = null;
      });
      
      // Show success snackbar with different style for single item removal
      SnackBarWidget.showSuccess('$productName removed from cart');
      
      // Refresh cart to ensure UI is updated with the latest state
      await cartController.getActiveOrder();
    } else {
      // Clear removing state on failure
      setState(() {
        _removingItemId = null;
      });
      showErrorSnackbar('Failed to remove item');
    }
  }

  Future<void> _handleQuantityChange(
      String orderLineId, int newQuantity) async {
    // Ensure minimum quantity is 1
    if (newQuantity < 1) {
      newQuantity = 1;
    }

    // Set loading state for this specific order line
    setState(() {
      _adjustingOrderLineIds.add(orderLineId);
    });

    try {
      final success = await cartController.adjustOrderLine(
        orderLineId: orderLineId,
        quantity: newQuantity,
      );
      if (!success) {
        // If adjustOrderLine failed, ensure cart is refreshed to show correct quantity
        // This is especially important for OrderInterceptorError cases
        // print('[CartPage] adjustOrderLine failed, refreshing cart to ensure UI is in sync');
        await cartController.getActiveOrder();
      }
      // Note: When success is true, adjustOrderLine already updates cart.value
      // and calls validateAndRemoveCouponsIfNeeded(). The UI will update via reactive variables.
    } finally {
      // Clear loading state for this order line
      setState(() {
        _adjustingOrderLineIds.remove(orderLineId);
      });
    }
  }

  void _proceedToCheckout() {
    if (cartController.cartItemCount == 0) {
      showErrorSnackbar('Your cart is empty');
      return;
    }

    // Check for quantity limit violations
    final cart = cartController.cart.value;
    if (cart != null) {
      final quantityLimitStatus = cart.quantityLimitStatus;
      if (quantityLimitStatus.hasViolations && quantityLimitStatus.violations.isNotEmpty) {
        // Show error message with details
        final violationMessages = quantityLimitStatus.violations
            .map((v) => '${v.productName} (${v.variantName}): Max ${v.maxQuantity} allowed, current ${v.currentQuantity}')
            .join('\n');
        showErrorSnackbar('Quantity limit exceeded. Please decrease quantities:\n$violationMessages');
        
        // Find the first violation order line for scrolling
        final firstViolationLineId = quantityLimitStatus.violations.first.orderLineId;
        int? firstViolationIndex;
        for (int i = 0; i < cart.lines.length; i++) {
          if (cart.lines[i].id == firstViolationLineId) {
            firstViolationIndex = i;
            break;
          }
        }
        
        // Scroll to first violation item
        if (firstViolationIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final estimatedPosition = firstViolationIndex! * 150.0;
              _scrollController.animateTo(
                estimatedPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          });
        }
        
        // CRITICAL: Return early to prevent checkout navigation
        return;
      }

      // Check numeric stock: Vendure may return stockLevel as "2", "10" etc. (or backend sets !isAvailable when quantity > stock)
      int? firstExceededIndex;
      String? firstExceededProductName;
      int? firstExceededStock;
      int? firstExceededQuantity;
      for (int i = 0; i < cart.lines.length; i++) {
        final line = cart.lines[i];
        final stockLevelRaw = line.productVariant.stockLevel.trim();
        final numericStock = int.tryParse(stockLevelRaw);
        // Quantity exceeds available stock (numeric), or backend marked unavailable and we have a numeric stock level
        final exceedsNumericStock = numericStock != null && line.quantity > numericStock;
        final unavailableWithNumericStock = !line.isAvailable && numericStock != null && line.quantity > numericStock;
        if (exceedsNumericStock || unavailableWithNumericStock) {
          firstExceededIndex = i;
          firstExceededProductName = line.productVariant.name;
          firstExceededStock = numericStock;
          firstExceededQuantity = line.quantity;
          break;
        }
      }
      if (firstExceededIndex != null &&
          firstExceededProductName != null &&
          firstExceededStock != null &&
          firstExceededQuantity != null) {
        SnackBarWidget.showError(
          '$firstExceededProductName: Only $firstExceededStock in stock (cart has $firstExceededQuantity). Please decrease quantity to proceed.',
          title: 'Stock limit',
          duration: const Duration(seconds: 4),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final estimatedPosition = (firstExceededIndex! * 150.0).clamp(0.0, _scrollController.position.maxScrollExtent);
            _scrollController.animateTo(
              estimatedPosition,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
        return;
      }

      // Check validationStatus for unavailable items (e.g., "This variant is no longer available")
      final validationStatus = cart.validationStatus;
      if (validationStatus.hasUnavailableItems && validationStatus.unavailableItems.isNotEmpty) {
        // Iterate through unavailable items (unused in loop, just for logging)
        for (final _ in validationStatus.unavailableItems) {
          // Logging is commented out, so variable is unused
        }
        showErrorSnackbar('Some product out of stock remove product from cart to proceed');
        
        // Find the order line index for scrolling
        final unavailableLineIds = validationStatus.unavailableItems.map((item) => item.orderLineId).toSet();
        int? firstUnavailableIndex;
        for (int i = 0; i < cart.lines.length; i++) {
          if (unavailableLineIds.contains(cart.lines[i].id)) {
            firstUnavailableIndex = i;
            break;
          }
        }
        
        // Auto-expand list if there are more than 3 items and list is collapsed
        if (cart.lines.length > 3) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // expandList is now handled internally by CartItemsList
          });
        }
        
        // Scroll to first unavailable item
        if (firstUnavailableIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final estimatedPosition = firstUnavailableIndex! * 150.0;
              _scrollController.animateTo(
                estimatedPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          });
        }
        
        // CRITICAL: Return early to prevent checkout navigation
        return;
      }
    }

    // Also check for out of stock or disabled product items (LOW_STOCK does not block checkout)
    if (cart != null) {
      final unavailableItems = <int>[];
      for (int i = 0; i < cart.lines.length; i++) {
        final line = cart.lines[i];
        final stockLevel = line.productVariant.stockLevel.toUpperCase();
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        
        // Check if product is disabled (multiple ways to detect)
        final isProductDisabled = line.productVariant.product.enabled == false;
        final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true ||
                                   line.unavailableReason?.toLowerCase().contains('no longer available') == true;
        final isProductDisabledAny = isProductDisabled || isDisabledByReason;
        
        // Item blocks checkout only if: isAvailable is false OR OUT_OF_STOCK OR product is disabled (not LOW_STOCK)
        final isUnavailable = !line.isAvailable || isOutOfStock || isProductDisabledAny;
        
        if (isUnavailable) {
          unavailableItems.add(i);
        }
      }
      
      if (unavailableItems.isNotEmpty) {
        // Count different types of unavailable items for better logging
        // ignore: unused_local_variable
        int outOfStockCount = 0;
        // ignore: unused_local_variable
        int disabledCount = 0;
        for (int i = 0; i < cart.lines.length; i++) {
          if (unavailableItems.contains(i)) {
            final line = cart.lines[i];
            final stockLevel = line.productVariant.stockLevel.toUpperCase();
            final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
            final isProductDisabled = line.productVariant.product.enabled == false;
            final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true ||
                                       line.unavailableReason?.toLowerCase().contains('no longer available') == true;
            
            if (isOutOfStock) outOfStockCount++;
            if (isProductDisabled || isDisabledByReason) disabledCount++;
          }
        }
        showErrorSnackbar('Some product out of stock remove product from cart to proceed');
        
        // Auto-expand list if there are more than 3 items and list is collapsed
        if (cart.lines.length > 3) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // expandList is now handled internally by CartItemsList
          });
        }
        
        // Scroll to first unavailable item (out of stock, low stock, or disabled)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && unavailableItems.isNotEmpty) {
            final firstUnavailableIndex = unavailableItems.first;
            final estimatedPosition = firstUnavailableIndex * 150.0;
            _scrollController.animateTo(
              estimatedPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
        
        // CRITICAL: Return early to prevent checkout navigation
        return;
      }
    }

    Get.toNamed(AppRoutes.offers);
  }

  Future<void> _handleClearCart() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: AnalyticsHelper.trackButton(
              'Cancel - Clear Cart Dialog',
              screenName: 'Cart',
              callback: () => Get.back(result: false),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: AnalyticsHelper.trackButton(
              'Confirm Clear Cart',
              screenName: 'Cart',
              callback: () => Get.back(result: true),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Set clearing state to trigger fade-out animation for all items
    setState(() {
      _isClearingCart = true;
    });

    // Wait for animation to complete (fade-out)
    await Future.delayed(const Duration(milliseconds: 400));

    final success = await orderController.removeAllOrderLines();

    if (success) {
      // Clear clearing state
      setState(() {
        _isClearingCart = false;
      });
      
      // Refresh cart to reflect changes
      await cartController.getActiveOrder();
      
      // Show success snackbar with different style for clear cart
    } else {
      // Clear clearing state on failure
      setState(() {
        _isClearingCart = false;
      });
      showErrorSnackbar('Failed to clear cart');
    }
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Mark first build as complete
    if (_isFirstBuild) {
      _isFirstBuild = false;
      return; // Skip refresh on first build (already done in initState)
    }
    
    // Check if we're returning to this page from another route
    final currentRoute = Get.currentRoute;
    if (_lastRoute != null && 
        _lastRoute != currentRoute && 
        currentRoute == '/cart' && 
        !_isRefreshingData && 
        mounted) {
      // Reset refresh flag to allow refresh when returning to page
      _isRefreshingData = false;
      // Use microtask to ensure it runs after current frame
      Future.microtask(() {
        if (mounted && !_isRefreshingData) {
    _refreshData();
        }
      });
    }
    
    // Update last route
    if (_lastRoute != currentRoute) {
      _lastRoute = currentRoute;
    }
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh data when app comes back to foreground
    if (state == AppLifecycleState.resumed && mounted && !_isRefreshingData) {
      _isRefreshingData = false;
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check route on every build to catch route changes
    // This is a backup check in case didChangeDependencies doesn't fire
    final currentRoute = Get.currentRoute;
    
    // Detect when returning to cart page from another route (like checkout)
    // Only check if we're actually on cart route and route changed
    if (currentRoute == '/cart' && 
        _lastRoute != null && 
        _lastRoute != '/cart' && 
        _lastRoute != currentRoute &&
        !_isFirstBuild && 
        !_isRefreshingData && 
        mounted) {
      // Use a microtask to ensure this runs after the current build
      Future.microtask(() {
        if (mounted && !_isRefreshingData) {
          _isRefreshingData = false; // Reset flag to allow refresh
          _refreshData();
        }
      });
    }
    
    // Update last route
    if (_lastRoute != currentRoute) {
      _lastRoute = currentRoute;
    }
    
    return OrientationBuilder(
      builder: (context, orientation) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            // Refresh data when page is about to be popped (user navigating back)
            if (!didPop && !_isRefreshingData && mounted) {
              _isRefreshingData = false; // Reset flag to allow refresh
              _refreshData();
            }
          },
          child: Obx(() {
            final cart = cartController.cart.value;
            final hasItems = cart != null && cart.lines.isNotEmpty;
            return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Shopping Cart',
        actions: hasItems
            ? [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: ResponsiveUtils.rp(20),
                  ),
                  tooltip: 'Clear Cart',
                  onPressed: AnalyticsHelper.trackButton(
                    'Clear Cart - Icon',
                    screenName: 'Cart',
                    callback: _handleClearCart,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ]
            : null,
      ),
      body: GetBuilder<UtilityController>(
        builder: (utilityCtrl) {
          // Only show shimmer on initial load, not on subsequent loading states
          if (_isInitialLoading && utilityCtrl.isLoading) {
            return const CartShimmerLoading();
          }

          return Obx(() {
            final cart = cartController.cart.value;

        if (cart == null || cart.lines.isEmpty) {
          return const CartEmptyState();
        }

        // Calculate totals will be done in Obx

        return Column(
          children: [
            // Cart Items List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await cartController.getActiveOrder();
                },
                color: AppColors.refreshIndicator,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Each cart line in its own card, no left/right padding
                      CartItemsList(
                        removingItemId: _removingItemId,
                        isClearingCart: _isClearingCart,
                        adjustingOrderLineIds: _adjustingOrderLineIds,
                        key: _cartItemsListKey,
                        cart: cart,
                        cartController: cartController,
                        utilityController: utilityController,
                        onQuantityChange: _handleQuantityChange,
                        onRemoveItem: _handleRemoveItem,
                        scrollController: _scrollController,
                        expandIfHasUnavailableItems: cart.lines.any((l) => !l.isAvailable),
                      ),
                      // Order Summary Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: CartOrderSummarySection(
                          cartController: cartController,
                          orderController: orderController,
                          bannerController: bannerController,
                          couponController: couponController,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                    ],
                  ),
                ),
              ),
            ),

            // Checkout Section - Fixed Bottom Bar
            SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(16),
                  vertical: ResponsiveUtils.rp(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Obx(() {
                  final authController = Get.find<AuthController>();
                  final isLoggedIn = authController.isLoggedIn;
                  return CartCheckoutSection(
                    cartController: cartController,
                    orderController: orderController,
                    utilityController: utilityController,
                    isGuest: !isLoggedIn,
                    checkoutButtonLabel: isLoggedIn ? 'Continue' : 'Login to Continue',
                    onProceedToCheckout: isLoggedIn
                        ? _proceedToCheckout
                        : () {
                            const key = 'login_intended_route';
                            GetStorage().write(key, AppRoutes.cart);
                            Get.toNamed(AppRoutes.login, arguments: {'intendedRoute': AppRoutes.cart});
                          },
                  );
                }),
              ),
            ),
          ],
        );
      });
        },
      ),
            );
          }));
      },
    );
  }

  // Build Methods for Sections (removed - now using components)
  // Old methods _buildCouponSection, _buildOrderSummarySection, _buildCheckoutSection,
  // _buildEmptyCartUI, _buildShimmerList have been moved to separate component files.

  // Old methods removed - now using components
  // _buildLoyaltyPointsSection, _buildOtherInstructionsSection, _showCouponCodesBottomSheet
  // have been moved to separate component files.

}
