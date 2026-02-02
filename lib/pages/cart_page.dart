import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart/cart_empty_state.dart';
import '../widgets/cart/cart_shimmer_loading.dart';
import '../widgets/cart/cart_items_list.dart';
import '../widgets/cart/cart_shipping_section.dart';
import '../widgets/cart/cart_coupon_section.dart';
import '../widgets/cart/cart_order_summary_section.dart';
import '../widgets/cart/cart_checkout_section.dart';
import '../widgets/cart/cart_loyalty_points_section.dart';
import '../widgets/cart/cart_other_instructions_section.dart';
import '../widgets/cart/cart_coupon_bottom_sheet.dart';
import '../utils/responsive.dart';
import '../utils/app_strings.dart';
import '../theme/colors.dart';
import '../utils/navigation_helper.dart';
import '../services/analytics_service.dart';
import '../utils/analytics_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart' as analytics;
import '../graphql/order.graphql.dart';
import '../graphql/banner.graphql.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final UtilityController utilityController = Get.find<UtilityController>();
  final BannerController bannerController = Get.find<BannerController>();
  final CustomerController customerController = Get.find<CustomerController>();

  // Loyalty Points - moved to CartLoyaltyPointsSection component

  // Scroll controller and keys
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _shippingSectionKey = GlobalKey();
  final GlobalKey _cartItemsListKey = GlobalKey();
  
  // Animation for blinking shipping section
  late AnimationController _blinkAnimationController;
  late Animation<double> _blinkAnimation;

  // Other Instructions - moved to CartOtherInstructionsSection component

  String? _lastAppliedShippingMethodId;

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
    
    // Initialize blink animation
    _blinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _blinkAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
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
      
      // Call getActiveCustomer which will also load coupon codes and loyalty points config
      // Load other data in parallel
      Future.wait([
        customerController.getActiveCustomer(),
        orderController.getEligibleShippingMethods(),
      ], eagerError: false).then((_) async {
        // After shipping methods are loaded, check for single method
        if (orderController.shippingMethods.length == 1) {
          final singleMethod = orderController.shippingMethods.first;
          orderController.selectedShippingMethod.value = singleMethod;
          // Skip sync during initialization since getActiveOrder was just called
          await _applyShippingMethod(showFeedback: false, force: true, skipSync: true);
        }
        
        // OrderController is already updated by cartController.getActiveOrder() above
        // No need to fetch again - just load existing data from controllers
        _loadExistingShippingMethod();
        _loadExistingCouponCodes();
        _loadExistingLoyaltyPoints();
        _loadExistingInstructions();
        
        // Mark refresh as complete
        _isRefreshingData = false;
      });
      
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
    _instructionsDebounceTimer?.cancel();
    _scrollController.dispose();
    _blinkAnimationController.dispose();
    super.dispose();
  }

  /// Get minimum order amount from coupon conditions
  int? _getCouponMinimumAmount(Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    try {
      for (final condition in coupon.conditions) {
        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
            if (arg.name == 'amount') {
              // arg.value is always String, so parse it directly
              return int.tryParse(arg.value);
            }
          }
        }
      }
    } catch (e) {
    }
    return null;
  }

  /// Get applicable coupons - show coupons with minimum amounts 500, 1000, 1500
  /// regardless of cart value. Validation happens when applying.
  // ignore: unused_element
  List<Query$GetCouponCodeList$getCouponCodeList$items> _getApplicableCoupons(int cartTotal) {
    final coupons = bannerController.availableCouponCodes;
    final applicableCoupons = <Query$GetCouponCodeList$getCouponCodeList$items>[];

    for (final coupon in coupons) {
      if (!coupon.enabled) continue;

      // Get minimum order amount required for this coupon
      final minimumAmount = _getCouponMinimumAmount(coupon);
      
      // Show coupons with minimum amounts of 500, 1000, 1500
      // (or any coupon if no minimum amount is set)
      if (minimumAmount == null) {
        // If no minimum amount condition, show the coupon
        applicableCoupons.add(coupon);
      } else if (minimumAmount == 500 || minimumAmount == 1000 || minimumAmount == 1500) {
        // Show coupons that require 500, 1000, or 1500 minimum order
        applicableCoupons.add(coupon);
      }
    }

    return applicableCoupons;
  }

  /// Calculate coupon suggestion based on cart total
  /// Returns coupon and amount short if user is close to qualifying
  // ignore: unused_element
  Map<String, dynamic> _calculateCouponInfo(double totalPrice, List<Query$GetCouponCodeList$getCouponCodeList$items> coupons) {
    final totalInPaise = (totalPrice * 100).toInt(); // Convert to paise
    Query$GetCouponCodeList$getCouponCodeList$items? suggestedCoupon;
    int? amountShort;

    for (final coupon in coupons) {
      if (!coupon.enabled) continue;

      // Get minimum order amount from coupon conditions
      final minimumAmount = _getCouponMinimumAmount(coupon);
      if (minimumAmount == null) continue;

      // Calculate difference: (requiredAmount - totalInPaise) + 100
      final difference = (minimumAmount - totalInPaise) + 100;

      // If difference is between 1-40000 (₹0.01 to ₹400), suggest this coupon
      if (difference >= 1 && difference <= 40000) {
        suggestedCoupon = coupon;
        amountShort = difference;
        break; // Use first matching coupon
      }
    }

    return {
      'coupon': suggestedCoupon,
      'amountShort': amountShort,
    };
  }

  /// Apply coupon code
  // ignore: unused_element
  Future<void> _applyCouponCode(String couponCode) async {
    // Check if coupon has products to add
    final hasProducts = bannerController.hasCouponProducts(couponCode);
    final result = hasProducts 
        ? await bannerController.applyCouponCodeWithProducts(couponCode)
        : await bannerController.applyCouponCode(couponCode);
    
    if (result['success'] == true) {
      showSuccessSnackbar(result['message'] ?? 'Coupon applied successfully');
      
      // Track coupon application
      final cart = cartController.cart.value;
      if (cart != null) {
        final coupon = bannerController.availableCouponCodes.firstWhere(
          (c) => c.couponCode == couponCode,
          orElse: () => bannerController.availableCouponCodes.first,
        );
        await AnalyticsService().logApplyCoupon(
          couponName: coupon.name,
          couponCode: couponCode,
          value: cart.totalWithTax / 100.0,
          currency: 'INR',
        );
      }
      
      // Cart is already updated by applyCouponCode/applyCouponCodeWithProducts - no need for additional refresh
    } else {
      showErrorSnackbar(result['message'] ?? 'Failed to apply coupon');
    }
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
        print('[CartPage] adjustOrderLine failed, refreshing cart to ensure UI is in sync');
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

    // Also check for out of stock, low stock, or disabled product items from line data
    if (cart != null) {
      final unavailableItems = <int>[];
      for (int i = 0; i < cart.lines.length; i++) {
        final line = cart.lines[i];
        final stockLevel = line.productVariant.stockLevel.toUpperCase();
        final isLowStock = stockLevel == 'LOW_STOCK';
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isStockUnavailable = isLowStock || isOutOfStock;
        
        // Check if product is disabled (multiple ways to detect)
        final isProductDisabled = line.productVariant.product.enabled == false;
        final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true ||
                                   line.unavailableReason?.toLowerCase().contains('no longer available') == true;
        final isProductDisabledAny = isProductDisabled || isDisabledByReason;
        
        // Item is unavailable if: isAvailable is false OR stock level is LOW_STOCK/OUT_OF_STOCK OR product is disabled
        final isUnavailable = !line.isAvailable || isStockUnavailable || isProductDisabledAny;
        
        if (isUnavailable) {
          unavailableItems.add(i);
        }
      }
      
      if (unavailableItems.isNotEmpty) {
        // Count different types of unavailable items for better logging
        // ignore: unused_local_variable
        int outOfStockCount = 0;
        // ignore: unused_local_variable
        int lowStockCount = 0;
        // ignore: unused_local_variable
        int disabledCount = 0;
        for (int i = 0; i < cart.lines.length; i++) {
          if (unavailableItems.contains(i)) {
            final line = cart.lines[i];
            final stockLevel = line.productVariant.stockLevel.toUpperCase();
            final isLowStock = stockLevel == 'LOW_STOCK';
            final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
            final isProductDisabled = line.productVariant.product.enabled == false;
            final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true ||
                                       line.unavailableReason?.toLowerCase().contains('no longer available') == true;
            
            if (isOutOfStock) outOfStockCount++;
            if (isLowStock) lowStockCount++;
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

    // Check if shipping methods are available
    if (orderController.shippingMethods.isEmpty) {
      showErrorSnackbar('No shipping methods available. Please contact support.');
      return;
    }

    // Check if delivery method is selected and actually applied to the order
    final selectedMethod = orderController.selectedShippingMethod.value;
    final currentOrder = orderController.currentOrder.value;
    
    // Check if shipping method is selected and has valid values
    final isMethodSelected = selectedMethod != null && 
                             selectedMethod.id.isNotEmpty && 
                             selectedMethod.name.isNotEmpty &&
                             selectedMethod.id != '0' &&
                             selectedMethod.id != 'null';
    
    // Check if shipping method is actually applied to the current order
    final isMethodApplied = currentOrder != null && 
                           currentOrder.shippingLines.isNotEmpty &&
                           currentOrder.shippingLines.any((line) => 
                             line.shippingMethod.id == selectedMethod?.id);
    
    final isShippingMethodValid = isMethodSelected && isMethodApplied;
    if (!isShippingMethodValid) {
      // If method is selected but not applied, clear the selection
      if (isMethodSelected && !isMethodApplied) {
        orderController.selectedShippingMethod.value = null;
      }
      
      // Scroll to shipping section
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _shippingSectionKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
      
      // Trigger blink animation
      if (mounted) {
        _blinkAnimationController.reset();
        _blinkAnimationController.repeat(reverse: true);
        
        // Stop blinking after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _blinkAnimationController.stop();
            _blinkAnimationController.reset();
          }
        });
      }
      
      return; // CRITICAL: Return early to prevent navigation
    }
    
    // Final validation check right before navigation (double-check to be absolutely sure)
    final finalCheck = orderController.selectedShippingMethod.value;
    final finalOrder = orderController.currentOrder.value;
    final finalIsApplied = finalOrder != null && 
                           finalOrder.shippingLines.isNotEmpty &&
                           finalOrder.shippingLines.any((line) => 
                             line.shippingMethod.id == finalCheck?.id);
    
    if (finalCheck == null || 
        finalCheck.id.isEmpty || 
        finalCheck.name.isEmpty || 
        finalCheck.id == '0' || 
        finalCheck.id == 'null' ||
        !finalIsApplied) {
      return; // Block navigation
    }

    // Track begin checkout event
    final cartForAnalytics = cartController.cart.value;
    if (cartForAnalytics != null) {
      final items = cartForAnalytics.lines.map((line) {
        return analytics.AnalyticsEventItem(
          itemId: line.productVariant.id,
          itemName: line.productVariant.name,
          itemCategory: 'Product', // ProductVariant doesn't have product reference
          price: line.unitPriceWithTax / 100.0,
          quantity: line.quantity,
        );
      }).toList();
      
      AnalyticsService().logBeginCheckout(
        value: cartForAnalytics.totalWithTax / 100.0,
        currency: 'INR',
        items: items,
      );
    }
    NavigationHelper.navigateToCheckout();
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

  // Shipping Method Methods

  Future<void> _loadExistingShippingMethod() async {
    try {
      // Use already-loaded order data instead of fetching again
      final order = orderController.currentOrder.value;
      
      // If there's only one shipping method, always set and apply it
      if (orderController.shippingMethods.length == 1) {
        final singleMethod = orderController.shippingMethods.first;
        
        // Always set the single method
        orderController.selectedShippingMethod.value = singleMethod;
        // Check if it's already applied to the order (using already-loaded data)
        final isAlreadyApplied = order != null &&
            order.shippingLines.isNotEmpty &&
            order.shippingLines.any((line) => line.shippingMethod.id == singleMethod.id);
        
        // Only apply if not already applied
        if (!isAlreadyApplied) {
          await _applyShippingMethod(showFeedback: false, force: true);
        } else {
          _lastAppliedShippingMethodId = singleMethod.id;
        }
        return;
      }
      
      // Multiple methods - check for existing shipping method from order (using already-loaded data)
      if (order != null && order.shippingLines.isNotEmpty) {
        final shippingLine = order.shippingLines.first;
        final shippingMethodId = shippingLine.shippingMethod.id;
        
        // Find matching shipping method from available methods
        final matchingMethod = orderController.shippingMethods.firstWhereOrNull(
          (method) => method.id == shippingMethodId,
        );
        
        if (matchingMethod != null) {
          orderController.selectedShippingMethod.value = matchingMethod;
          _lastAppliedShippingMethodId = matchingMethod.id;
          return; // Already has a shipping method, no need to auto-apply
        }
        // If order has shipping method but it doesn't match any available method, clear selection
        orderController.selectedShippingMethod.value = null;
        _lastAppliedShippingMethodId = null;
        return;
      }
      
      // If no existing shipping method in order, clear selection to show "Select delivery method"
      orderController.selectedShippingMethod.value = null;
      _lastAppliedShippingMethodId = null;
    } catch (e) {
    }
  }

  Future<void> _applyShippingMethod({bool showFeedback = false, bool force = false, bool skipSync = false}) async {
    final selected = orderController.selectedShippingMethod.value;
    if (selected == null) return;

    if (!force && _lastAppliedShippingMethodId == selected.id) {
      return; // Already applied
    }

    final success = await orderController.setShippingMethod(
      selected.id, 
      skipIfAlreadySet: false,
    );

    if (success) {
      _lastAppliedShippingMethodId = selected.id;

      // Sync CartController with updated order only if not skipping sync
      // (skipSync is true during initialization when getActiveOrder was just called)
      if (!skipSync) {
        await cartController.getActiveOrder();
      }
      // During initialization with skipSync=true, we skip the getActiveOrder call
      // The order is already updated in orderController.currentOrder by setShippingMethod
      // and will be synced on the next getActiveOrder call or when needed
    } else {
    }
  }


  // Instructions Methods
  Timer? _instructionsDebounceTimer;
  void _saveOtherInstructions(String instructions) {
    _instructionsDebounceTimer?.cancel();
    _instructionsDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await orderController.setOtherInstruction(instructions);
    });
  }

  Future<void> _loadExistingCouponCodes() async {
    try {
      // Use already-loaded cart data instead of fetching again
      final cart = cartController.cart.value;
      if (cart != null && cart.couponCodes.isNotEmpty) {
        for (final couponCode in cart.couponCodes) {
          if (!bannerController.appliedCouponCodes.contains(couponCode)) {
            bannerController.appliedCouponCodes.add(couponCode);
          }
        }
      } else {
      }
    } catch (e) {
    }
  }

  /// Toggle loyalty points
  // ignore: unused_element
  Future<void> _toggleLoyaltyPoints() async {
    final isApplied = bannerController.loyaltyPointsApplied.value;
    
    if (isApplied) {
      // Remove loyalty points
      final success = await bannerController.removeLoyaltyPoints();
      if (success) {
        showSuccessSnackbar('Loyalty points removed');
        // Cart is already updated in removeLoyaltyPoints(), no need to fetch again
      } else {
        showErrorSnackbar('Failed to remove loyalty points');
      }
    } else {
      // Apply loyalty points
      final loyaltyPointsUsed = bannerController.loyaltyPointsUsed.value;
      if (loyaltyPointsUsed > 0) {
        final success = await bannerController.applyLoyaltyPoints(loyaltyPointsUsed);
        if (success) {
          showSuccessSnackbar('Loyalty points applied');
          // Cart is already updated in applyLoyaltyPoints(), no need to fetch again
        } else {
          showErrorSnackbar('Failed to apply loyalty points');
        }
      }
    }
  }

  // Loyalty Points Methods - moved to CartLoyaltyPointsSection component

  Future<void> _loadExistingLoyaltyPoints() async {
    try {
      
      // Loyalty points are now extracted directly in cartController.getActiveOrder()
      // This function is kept as a fallback, but the main extraction happens in CartController
      // Check if loyalty points are already set (from getActiveOrder)
      final isApplied = bannerController.loyaltyPointsApplied.value;
      final pointsUsed = bannerController.loyaltyPointsUsed.value;
      
      if (isApplied && pointsUsed > 0) {
        return;
      }
      
      // Fallback: Try to get from order if not already loaded
      // Note: This is unlikely to work since orderController.currentOrder is Fragment$Cart
      // which doesn't have customFields, but kept as a safety check
      final order = orderController.currentOrder.value;
      if (order != null) {
        try {
          // Try to access customFields if available (for Query$ActiveOrder$activeOrder type)
          // Fragment$Cart doesn't have customFields, so this will fail gracefully
          if (order is Query$ActiveOrder$activeOrder && order.customFields != null) {
        final customFields = order.customFields as Query$ActiveOrder$activeOrder$customFields;
        final loyaltyPointsUsed = customFields.loyaltyPointsUsed;
        if (loyaltyPointsUsed != null && loyaltyPointsUsed > 0) {
          bannerController.loyaltyPointsUsed.value = loyaltyPointsUsed;
          bannerController.loyaltyPointsApplied.value = true;
            }
          } else {
          }
        } catch (e) {
          // Fragment$Cart doesn't have customFields, that's okay
        }
      }
    } catch (e) {
    }
  }

  Future<void> _loadExistingInstructions() async {
    try {
      // Use already-loaded order data instead of fetching again
      final order = orderController.currentOrder.value;
      
      // Try to get customFields - Fragment$Cart doesn't have customFields, but Query$ActiveOrder$activeOrder does
      if (order != null) {
        try {
          // Try to access customFields if available (for Query$ActiveOrder$activeOrder type)
          // Fragment$Cart doesn't have customFields, so this will fail gracefully
      if (order is Query$ActiveOrder$activeOrder && order.customFields != null) {
        final customFields = order.customFields as Query$ActiveOrder$activeOrder$customFields;
        final instructions = customFields.otherInstructions;
        if (instructions != null && instructions.isNotEmpty && mounted) {
          // Instructions are now managed by CartOtherInstructionsSection component
          // The component will handle loading existing instructions internally
            }
          } else {
          }
        } catch (e) {
          // Fragment$Cart doesn't have customFields, that's okay
        }
      }
    } catch (e) {
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
          child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Shopping Cart',
        actions: [  IconButton(
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
        ),],
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
                      // Products in one card
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: CartItemsList(
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
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),

                      // Shipping Method Section with blink animation
                      Padding(
                        key: _shippingSectionKey,
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: AnimatedBuilder(
                          animation: _blinkAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                border: Border.all(
                                  color: _blinkAnimation.value > 0
                                      ? AppColors.button.withValues(alpha: _blinkAnimation.value)
                                      : Colors.transparent,
                                  width: _blinkAnimation.value > 0 ? 3 : 0,
                                ),
                              ),
                              child: CartShippingSection(
                                orderController: orderController,
                                cartController: cartController,
                                onShippingMethodSelected: () async {
                                  await _applyShippingMethod(showFeedback: true);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      
                      // Coupon Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: CartCouponSection(
                          bannerController: bannerController,
                          cartController: cartController,
                          orderController: orderController,
                          onShowCouponBottomSheet: () {
                            CartCouponBottomSheet.show(
                              context: context,
                              bannerController: bannerController,
                              cartController: cartController,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      
                      // Loyalty Points Section
                      Obx(() {
                        final availablePoints = customerController.loyaltyPoints;
                        final config = bannerController.loyaltyPointsConfig.value;
                        final minimumPoints = config?.pointsPerRupee ?? 0;
                        final isApplied = bannerController.loyaltyPointsApplied.value;
                        
                        // If minimum points required and available points less than minimum, hide section
                        // BUT if points are already applied, show UI anyway
                        if (minimumPoints > 0 && availablePoints < minimumPoints && !isApplied) {
                          return SizedBox.shrink();
                        }
                        
                        // Always show apply UI if points are applied (regardless of remaining points)
                        // Also show UI if points not applied and available >= minimum
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                          child: CartLoyaltyPointsSection(
                            bannerController: bannerController,
                            customerController: customerController,
                            onApplyLoyaltyPoints: (pointsText) async {
                              if (pointsText.isEmpty) {
                                showErrorSnackbar('Please enter loyalty points amount');
                                return;
                              }

                              final points = int.tryParse(pointsText);
                              if (points == null || points <= 0) {
                                showErrorSnackbar('Please enter a valid loyalty points amount');
                                return;
                              }

                              final availablePoints = customerController.loyaltyPoints;
                              if (points > availablePoints) {
                                showErrorSnackbar('Insufficient loyalty points! You have $availablePoints points available.');
                                return;
                              }

                              final config = bannerController.loyaltyPointsConfig.value;
                              if (config != null && points < config.pointsPerRupee) {
                                showErrorSnackbar('Minimum loyalty points required: ${config.pointsPerRupee} points.');
                                return;
                              }

                              final success = await bannerController.applyLoyaltyPoints(points);
                              if (success) {
                                showSuccessSnackbar('Loyalty points applied successfully');
                                // Cart is already updated in applyLoyaltyPoints(), no need to fetch again
                              } else {
                                showErrorSnackbar('Failed to apply loyalty points');
                              }
                            },
                            onRemoveLoyaltyPoints: () async {
                              final success = await bannerController.removeLoyaltyPoints();
                              if (success) {
                                showSuccessSnackbar('Loyalty points removed successfully');
                                // Cart is already updated in removeLoyaltyPoints(), no need to fetch again
                              } else {
                                showErrorSnackbar('Failed to remove loyalty points');
                              }
                            },
                          ),
                        );
                      }),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      
                      // Other Instructions Section (Small)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: CartOtherInstructionsSection(
                          bannerController: bannerController,
                          onSaveInstructions: _saveOtherInstructions,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      
                      // Order Summary Section - Below Additional Instructions
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: CartOrderSummarySection(
                          cartController: cartController,
                          orderController: orderController,
                          bannerController: bannerController,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                    ],
                  ),
                ),
              ),
            ),

            // Amount to apply coupon code section (above bottom navigation bar)
            Obx(() {
              final cart = cartController.cart.value;
              if (cart == null) return SizedBox.shrink();

              // Hide banner if coupon is already applied
              if (bannerController.appliedCouponCodes.isNotEmpty) {
                return SizedBox.shrink();
              }

              // Check for out of stock items
              final hasOutOfStockItems = cart.lines.any((line) {
                final stockLevel = line.productVariant.stockLevel.toUpperCase();
                final isLowStock = stockLevel == 'LOW_STOCK';
                final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
                final isProductDisabled = line.productVariant.product.enabled == false;
                return !line.isAvailable || isLowStock || isOutOfStock || isProductDisabled;
              });

              if (hasOutOfStockItems) return SizedBox.shrink();

              // Get eligible coupons
              final subTotal = cart.subTotalWithTax.toInt();
              final eligibleCoupons = bannerController.getEligibleCoupons(subTotal);

              if (eligibleCoupons.isEmpty) return SizedBox.shrink();

              final coupon = eligibleCoupons.first;
              final requiredAmount = bannerController.getRequiredAmount(coupon);
              final difference = requiredAmount - subTotal;

              if (difference <= 0 || difference >= 40000) return SizedBox.shrink();

              final differenceInRupees = difference / 100;

              return Container(
                margin: EdgeInsets.only(
                  left: ResponsiveUtils.rp(16),
                  right: ResponsiveUtils.rp(16),
                  bottom: ResponsiveUtils.rp(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(16),
                  vertical: ResponsiveUtils.rp(14),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B35),
                      const Color(0xFFFF8C42),
                      const Color(0xFFFFA500),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(14)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.35),
                      blurRadius: ResponsiveUtils.rp(10),
                      offset: Offset(0, ResponsiveUtils.rp(4)),
                      spreadRadius: ResponsiveUtils.rp(1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      color: Colors.white,
                      size: ResponsiveUtils.rp(22),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: 'Add ₹${differenceInRupees.toStringAsFixed(2)} more to unlock ',
                            ),
                            TextSpan(
                              text: coupon.couponCode ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Checkout Section - Fixed Bottom Navigation Bar
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
                child: CartCheckoutSection(
            cartController: cartController,
                  orderController: orderController,
            utilityController: utilityController,
                  onProceedToCheckout: _proceedToCheckout,
                ),
              ),
            ),
          ],
      );
    });
        },
      ),
        ),
      );
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
