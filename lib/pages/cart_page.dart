import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/banner/bannermodels.dart';
import '../controllers/customer/customer_controller.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart_item_card_premium.dart';
import '../widgets/checkout/checkout_shipping_section.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/premium_card.dart';
import '../theme/colors.dart';
import '../utils/navigation_helper.dart';
import '../services/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart' as analytics;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final UtilityController utilityController = Get.find<UtilityController>();
  final BannerController bannerController = Get.find<BannerController>();
  final CustomerController customerController = Get.find<CustomerController>();

  // Loyalty Points
  final _loyaltyPointsController = TextEditingController();

  // Scroll controller and keys
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _shippingSectionKey = GlobalKey();
  final GlobalKey<_CartItemsListState> _cartItemsListKey = GlobalKey<_CartItemsListState>();
  
  // Animation for blinking shipping section
  late AnimationController _blinkAnimationController;
  late Animation<double> _blinkAnimation;

  // Other Instructions
  final _otherInstructionsController = TextEditingController();
  Timer? _instructionsDebounceTimer;
  bool _showInstructionsOptions = false;
  bool _showOtherTextField = false;
  String? _selectedDefaultInstruction;

  // Default instruction options
  final List<String> _defaultInstructions = [
    'Leave at door',
    'Call before delivery',
    'Special packaging required',
  ];

  String? _lastAppliedShippingMethodId;

  @override
  void initState() {
    super.initState();
    
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cartController.getActiveOrder();
      // Load coupon codes
      if (!bannerController.couponCodesLoaded.value) {
        bannerController.getCouponCodeList();
      }
      // Load shipping methods
      await orderController.getEligibleShippingMethods();
      // Load existing shipping method from order
      _loadExistingShippingMethod();
      // Load loyalty points config
      bannerController.fetchLoyaltyPointsConfig();
      // Load existing data
      _loadExistingCouponCodes();
      _loadExistingLoyaltyPoints();
      _loadExistingInstructions();
      
      // Track screen view
      AnalyticsService().logScreenView(screenName: 'Cart');
    });
  }

  @override
  void dispose() {
    _instructionsDebounceTimer?.cancel();
    _loyaltyPointsController.dispose();
    _otherInstructionsController.dispose();
    _scrollController.dispose();
    _blinkAnimationController.dispose();
    super.dispose();
  }

  /// Get minimum order amount from coupon conditions
  int? _getCouponMinimumAmount(CouponCodeModel coupon) {
    try {
      for (final condition in coupon.conditions) {
        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
            if (arg.name == 'amount') {
              final value = arg.value;
              if (value is num) {
                return value.toInt();
              } else if (value is String) {
                return int.tryParse(value);
              }
            }
          }
        }
      }
    } catch (e) {
debugPrint('Error getting coupon minimum amount: $e');
    }
    return null;
  }

  /// Get applicable coupons - show coupons with minimum amounts 500, 1000, 1500
  /// regardless of cart value. Validation happens when applying.
  // ignore: unused_element
  List<CouponCodeModel> _getApplicableCoupons(int cartTotal) {
    final coupons = bannerController.availableCouponCodes;
    final applicableCoupons = <CouponCodeModel>[];

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
  Map<String, dynamic> _calculateCouponInfo(double totalPrice, List<CouponCodeModel> coupons) {
    final totalInPaise = (totalPrice * 100).toInt(); // Convert to paise
    CouponCodeModel? suggestedCoupon;
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
debugPrint('[CartPage] Coupon $couponCode has products: $hasProducts');
    
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
    final success = await orderController.removeOrderLine(orderLineId);

    if (success) {
      // Update cart controller
      cartController.cart.value = orderController.currentOrder.value != null
          ? cartController.cart.value
          : null;
      showSuccessSnackbar('$productName removed from cart');
      await cartController.getActiveOrder();
    } else {
      showErrorSnackbar('Failed to remove item');
    }
  }

  Future<void> _handleQuantityChange(
      String orderLineId, int newQuantity) async {
    // Ensure minimum quantity is 1
    if (newQuantity < 1) {
      newQuantity = 1;
    }

    final success = await cartController.adjustOrderLine(
      orderLineId: orderLineId,
      quantity: newQuantity,
    );

    if (!success) {
      showErrorSnackbar('Failed to update quantity');
    }
  }

  void _proceedToCheckout() {
debugPrint('[CartPage] _proceedToCheckout called');
debugPrint('[CartPage] Shipping methods count: ${orderController.shippingMethods.length}');
debugPrint('[CartPage] Selected shipping method: ${orderController.selectedShippingMethod.value?.name ?? "null"}');
    
    if (cartController.cartItemCount == 0) {
      showErrorSnackbar('Your cart is empty');
      return;
    }

    // Check validationStatus for unavailable items (e.g., "This variant is no longer available")
    final cart = cartController.cart.value;
    if (cart != null && cart.validationStatus != null) {
      final validationStatus = cart.validationStatus!;
      if (validationStatus.hasUnavailableItems && validationStatus.unavailableItems.isNotEmpty) {
debugPrint('[CartPage] ❌ ValidationStatus shows ${validationStatus.totalUnavailableItems} unavailable items');
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
            _cartItemsListKey.currentState?.expandList();
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
        final stockLevel = line.productVariant.stockLevel?.toUpperCase();
        final isLowStock = stockLevel == 'LOW_STOCK';
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isStockUnavailable = isLowStock || isOutOfStock;
        
        // Check if product is disabled (multiple ways to detect)
        final isProductDisabled = line.productVariant.productEnabled == false;
        final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true ||
                                   line.unavailableReason?.toLowerCase().contains('no longer available') == true;
        final isProductDisabledAny = isProductDisabled || isDisabledByReason;
        
        // Item is unavailable if: isAvailable is false OR stock level is LOW_STOCK/OUT_OF_STOCK OR product is disabled
        final isUnavailable = !line.isAvailable || isStockUnavailable || isProductDisabledAny;
        
        if (isUnavailable) {
          unavailableItems.add(i);
debugPrint('[CartPage] Item $i is unavailable - isAvailable: ${line.isAvailable}, stockLevel: $stockLevel, productEnabled: ${line.productVariant.productEnabled}, unavailableReason: ${line.unavailableReason}');
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
            final stockLevel = line.productVariant.stockLevel?.toUpperCase();
            final isLowStock = stockLevel == 'LOW_STOCK';
            final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
            final isProductDisabled = line.productVariant.productEnabled == false;
            final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true ||
                                       line.unavailableReason?.toLowerCase().contains('no longer available') == true;
            
            if (isOutOfStock) outOfStockCount++;
            if (isLowStock) lowStockCount++;
            if (isProductDisabled || isDisabledByReason) disabledCount++;
          }
        }
debugPrint('[CartPage] ❌ Found ${unavailableItems.length} unavailable items: $outOfStockCount out of stock, $lowStockCount low stock, $disabledCount disabled');
debugPrint('[CartPage] ❌ Blocking checkout - Please remove unavailable items');
        showErrorSnackbar('Some product out of stock remove product from cart to proceed');
        
        // Auto-expand list if there are more than 3 items and list is collapsed
        if (cart.lines.length > 3) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _cartItemsListKey.currentState?.expandList();
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
debugPrint('[CartPage] ❌ No shipping methods available');
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
    
debugPrint('[CartPage] Shipping method validation:');
debugPrint('[CartPage] - selectedMethod: ${selectedMethod != null ? "not null" : "null"}');
debugPrint('[CartPage] - method ID: ${selectedMethod?.id ?? "null"}');
debugPrint('[CartPage] - method Name: ${selectedMethod?.name ?? "null"}');
debugPrint('[CartPage] - currentOrder: ${currentOrder != null ? "exists" : "null"}');
debugPrint('[CartPage] - order shippingLines count: ${currentOrder?.shippingLines.length ?? 0}');
debugPrint('[CartPage] - isMethodSelected: $isMethodSelected');
debugPrint('[CartPage] - isMethodApplied: $isMethodApplied');
debugPrint('[CartPage] - isShippingMethodValid: $isShippingMethodValid');
    
    if (!isShippingMethodValid) {
debugPrint('[CartPage] ❌ Shipping method validation FAILED - preventing checkout');
      
      // If method is selected but not applied, clear the selection
      if (isMethodSelected && !isMethodApplied) {
debugPrint('[CartPage] Clearing selected shipping method (not applied to order)');
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
      
      showErrorSnackbar('Please select a delivery method before checkout');
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
debugPrint('[CartPage] ❌ Final validation check FAILED - blocking navigation');
debugPrint('[CartPage] Final check - ID: ${finalCheck?.id ?? "null"}, Name: ${finalCheck?.name ?? "null"}');
debugPrint('[CartPage] Final check - isApplied: $finalIsApplied');
      showErrorSnackbar('Please select a delivery method before checkout');
      return; // Block navigation
    }
    
debugPrint('[CartPage] ✅ All validations passed, proceeding to checkout');
debugPrint('[CartPage] Selected shipping method: ${selectedMethod.name} (ID: ${selectedMethod.id})');

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

debugPrint('[CartPage] 🚀 Navigating to checkout page...');
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
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await orderController.removeAllOrderLines();

    if (success) {
      // Refresh cart to reflect changes
      await cartController.getActiveOrder();
      showSuccessSnackbar('Cart cleared successfully');
    } else {
      showErrorSnackbar('Failed to clear cart');
    }
  }

  // Shipping Method Methods
  Future<void> _loadExistingShippingMethod() async {
    try {
      await orderController.getActiveOrder(skipLoading: true);
      final order = orderController.currentOrder.value;
      
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
debugPrint('[CartPage] Loaded existing shipping method: ${matchingMethod.name}');
          return; // Already has a shipping method, no need to auto-apply
        }
      }
      
      // If no existing shipping method and only one method available, auto-apply it
      if (orderController.selectedShippingMethod.value == null &&
          orderController.shippingMethods.length == 1) {
        final singleMethod = orderController.shippingMethods.first;
        orderController.selectedShippingMethod.value = singleMethod;
debugPrint('[CartPage] Auto-applying single shipping method: ${singleMethod.name}');
        await _applyShippingMethod(showFeedback: false, force: true);
      }
    } catch (e) {
debugPrint('[CartPage] Error loading existing shipping method: $e');
    }
  }

  Future<void> _applyShippingMethod({bool showFeedback = false, bool force = false}) async {
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
      if (showFeedback) {
        showSuccessSnackbar('Shipping method selected');
      }
      await cartController.getActiveOrder();
    } else {
      showErrorSnackbar('Failed to set shipping method');
    }
  }


  // Instructions Methods
  void _saveOtherInstructions(String instructions) {
    _instructionsDebounceTimer?.cancel();
    _instructionsDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await orderController.setOtherInstruction(instructions);
    });
  }

  Future<void> _loadExistingCouponCodes() async {
    try {
      await cartController.getActiveOrder();
      final cart = cartController.cart.value;
      if (cart != null && cart.couponCodes.isNotEmpty) {
        for (final couponCode in cart.couponCodes) {
          if (!bannerController.appliedCouponCodes.contains(couponCode)) {
            bannerController.appliedCouponCodes.add(couponCode);
          }
        }
      }
    } catch (e) {
debugPrint('[CartPage] Error loading existing coupon codes: $e');
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
        await cartController.getActiveOrder();
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
          await cartController.getActiveOrder();
        } else {
          showErrorSnackbar('Failed to apply loyalty points');
        }
      }
    }
  }

  // Loyalty Points Methods
  Future<void> _applyLoyaltyPoints() async {
    final pointsText = _loyaltyPointsController.text.trim();
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
      await cartController.getActiveOrder();
    } else {
      showErrorSnackbar('Failed to apply loyalty points');
    }
  }

  Future<void> _removeLoyaltyPoints() async {
    final success = await bannerController.removeLoyaltyPoints();
    if (success) {
      _loyaltyPointsController.clear();
      showSuccessSnackbar('Loyalty points removed successfully');
      await cartController.getActiveOrder();
    } else {
      showErrorSnackbar('Failed to remove loyalty points');
    }
  }

  Future<void> _loadExistingLoyaltyPoints() async {
    try {
      await orderController.getActiveOrder(skipLoading: true);
      final order = orderController.currentOrder.value;
      if (order != null && order.customFields != null) {
        final loyaltyPointsUsed = order.customFields!.loyaltyPointsUsed;
        if (loyaltyPointsUsed != null && loyaltyPointsUsed > 0) {
          bannerController.loyaltyPointsUsed.value = loyaltyPointsUsed;
          bannerController.loyaltyPointsApplied.value = true;
          if (mounted) {
            _loyaltyPointsController.text = loyaltyPointsUsed.toString();
          }
        }
      }
    } catch (e) {
debugPrint('[CartPage] Error loading existing loyalty points: $e');
    }
  }

  Future<void> _loadExistingInstructions() async {
    try {
      await orderController.getActiveOrder(skipLoading: true);
      if (orderController.currentOrder.value?.customFields?.otherInstructions != null) {
        final instructions = orderController.currentOrder.value!.customFields!.otherInstructions!;
        if (instructions.isNotEmpty && mounted) {
          _otherInstructionsController.text = instructions;
          if (_defaultInstructions.contains(instructions)) {
            setState(() {
              _selectedDefaultInstruction = instructions;
              _showInstructionsOptions = true;
              _showOtherTextField = false;
            });
          } else {
            setState(() {
              _showInstructionsOptions = true;
              _showOtherTextField = true;
              _selectedDefaultInstruction = null;
            });
          }
        }
      }
    } catch (e) {
debugPrint('[CartPage] Error loading existing instructions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Shopping Cart',
        actions: [  IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: AppColors.error,
            size: ResponsiveUtils.rp(20),
          ),
          tooltip: 'Clear Cart',
          onPressed: _handleClearCart,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),],
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerList();
        }

        final cart = cartController.cart.value;

        if (cart == null || cart.lines.isEmpty) {
          return _buildEmptyCartUI();
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
                        child: _buildProductsCard(cart),
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
                              child: _buildShippingSection(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      
                      // Coupon Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: _buildCouponSection(),
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
                          child: _buildLoyaltyPointsSection(),
                        );
                      }),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      
                      // Other Instructions Section (Small)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: _buildOtherInstructionsSection(),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      
                      // Order Summary Section - Below Additional Instructions
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                        child: _buildOrderSummarySection(),
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

              // Check for out of stock items
              final hasOutOfStockItems = cart.lines.any((line) {
                final stockLevel = line.productVariant.stockLevel?.toUpperCase();
                final isLowStock = stockLevel == 'LOW_STOCK';
                final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
                final isProductDisabled = line.productVariant.productEnabled == false;
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
                  bottom: ResponsiveUtils.rp(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(16),
                  vertical: ResponsiveUtils.rp(16),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1a1a2e), // Dark blue-gray
                      const Color(0xFF16213e), // Darker blue
                      const Color(0xFF0f3460), // Deep blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: ResponsiveUtils.rp(8),
                      offset: Offset(0, ResponsiveUtils.rp(4)),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      color: Colors.white,
                      size: ResponsiveUtils.rp(24),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    Expanded(
                      child: Text(
                        'Add ₹${differenceInRupees.toStringAsFixed(2)} more to unlock coupon \'${coupon.couponCode}\'',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
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
                child: _buildCheckoutSection(),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Build Methods for Sections
  Widget _buildProductsCard(dynamic cart) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header with Clear Cart button

          // Cart Items List
          _CartItemsList(
            key: _cartItemsListKey,
            cart: cart,
            cartController: cartController,
            utilityController: utilityController,
            onQuantityChange: _handleQuantityChange,
            onRemoveItem: _handleRemoveItem,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }



  Widget _buildShippingSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: CheckoutShippingSection(
        orderController: orderController,
        cartController: cartController,
        onShippingMethodSelected: () async {
          await _applyShippingMethod(showFeedback: true);
        },
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Coupon Codes',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Obx(() {
                final appliedCount = bannerController.appliedCouponCodes.length;
                if (appliedCount > 0) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(10),
                      vertical: ResponsiveUtils.rp(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    ),
                    child: Text(
                      '$appliedCount Applied',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.sp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Obx(() {
            if (bannerController.appliedCouponCodes.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.success,
                            size: ResponsiveUtils.rp(16)),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        Text(
                          'Applied Coupons:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                            fontSize: ResponsiveUtils.sp(14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    ...bannerController.appliedCouponCodes.map(
                      (code) => Padding(
                        padding: EdgeInsets.only(
                            left: ResponsiveUtils.rp(24),
                            bottom: ResponsiveUtils.rp(4)),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer,
                                color: AppColors.success,
                                size: ResponsiveUtils.rp(14)),
                            SizedBox(width: ResponsiveUtils.rp(8)),
                            Text(code,
                                style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveUtils.sp(13))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCouponCodesBottomSheet(),
              icon: Icon(Icons.local_offer, size: ResponsiveUtils.rp(20)),
              label: Text('Browse Coupons'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8))),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLoyaltyPointsSection() {
    return Obx(() {
      final availablePoints = customerController.loyaltyPoints;
      final config = bannerController.loyaltyPointsConfig.value;
      final minimumPoints = config?.pointsPerRupee ?? 0;
      
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loyalty Points',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              decoration: BoxDecoration(
                color: availablePoints > 0
                    ? AppColors.info.withValues(alpha: 0.1)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: availablePoints > 0
                      ? AppColors.info.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars,
                      color: availablePoints > 0
                          ? AppColors.info
                          : AppColors.textSecondary,
                      size: ResponsiveUtils.rp(20)),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Text(
                    'Available: $availablePoints points',
                    style: TextStyle(
                      color: availablePoints > 0
                          ? AppColors.info
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(14),
                    ),
                  ),
                ],
              ),
            ),
            if (minimumPoints > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Text(
                'Minimum: $minimumPoints points',
                style: TextStyle(
                    color: AppColors.warning,
                    fontSize: ResponsiveUtils.sp(12)),
              ),
            ],
            SizedBox(height: ResponsiveUtils.rp(12)),
            Obx(() {
              final isApplied = bannerController.loyaltyPointsApplied.value;
              final appliedPoints = bannerController.loyaltyPointsUsed.value;
              
              if (isApplied && _loyaltyPointsController.text != appliedPoints.toString()) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _loyaltyPointsController.text = appliedPoints.toString();
                });
              }
              
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _loyaltyPointsController,
                          keyboardType: TextInputType.number,
                          enabled: !isApplied,
                          style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              color: isApplied 
                                  ? AppColors.success 
                                  : AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: isApplied 
                                ? 'Applied: $appliedPoints points' 
                                : 'Enter points',
                            hintStyle: TextStyle(
                                color: isApplied 
                                    ? AppColors.success 
                                    : AppColors.textTertiary,
                                fontSize: ResponsiveUtils.sp(14)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(ResponsiveUtils.rp(8)),
                                borderSide: BorderSide(
                                  color: isApplied 
                                      ? AppColors.success 
                                      : AppColors.border,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(ResponsiveUtils.rp(8)),
                                borderSide: BorderSide(
                                  color: isApplied 
                                      ? AppColors.success 
                                      : AppColors.border,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(ResponsiveUtils.rp(8)),
                                borderSide: BorderSide(
                                  color: isApplied 
                                      ? AppColors.success 
                                      : AppColors.button,
                                  width: 2,
                                )),
                            filled: true,
                            fillColor: isApplied 
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.inputFill,
                            suffixIcon: isApplied
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                    size: ResponsiveUtils.rp(20),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Container(
                        height: ResponsiveUtils.rp(50),
                        decoration: BoxDecoration(
                          gradient: !isApplied
                              ? LinearGradient(
                                  colors: [AppColors.button, AppColors.buttonLight],
                                )
                              : null,
                          color: isApplied ? AppColors.error : null,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isApplied ? _removeLoyaltyPoints : _applyLoyaltyPoints,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                              child: Center(
                                child: Text(
                                  isApplied ? 'Remove' : 'Apply',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(14),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildOrderSummarySection() {
    return Obx(() {
      final cart = cartController.cart.value;
      if (cart == null) return SizedBox.shrink();
      
      final order = orderController.currentOrder.value;
      final shippingCost = order?.shippingWithTax ?? 0;
      final loyaltyDiscount =
          bannerController.loyaltyPointsApplied.value
              ? bannerController.loyaltyPointsUsed.value
              : 0;
      
      // Calculate coupon discount from order discounts
      int couponDiscountTotal = 0;
      String? appliedCouponName;
      if (order != null && order.discounts.isNotEmpty) {
        couponDiscountTotal = order.discounts
            .where((discount) => discount.adjustmentSource == 'PROMOTION' || 
                                 discount.adjustmentSource == 'COUPON_CODE')
            .fold(0, (sum, discount) => sum + discount.amountWithTax);
        
        if (bannerController.appliedCouponCodes.isNotEmpty) {
          if (bannerController.availableCouponCodes.isNotEmpty) {
            final appliedCode = bannerController.appliedCouponCodes.first;
            final coupon = bannerController.availableCouponCodes.firstWhereOrNull(
              (c) => c.couponCode == appliedCode,
            );
            appliedCouponName = coupon?.name.isNotEmpty == true 
                ? coupon!.name 
                : appliedCode;
          } else {
            appliedCouponName = bannerController.appliedCouponCodes.first;
          }
        }
      }
      
      final cartTotal = cart.totalWithTax.toInt();
      final finalTotal = cartTotal - loyaltyDiscount;
      
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  cartController.formatPrice(cart.subTotalWithTax.toInt()),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            // Loyalty Points Discount
            if (loyaltyDiscount > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                     
                      Text(
                        'Loyalty Points',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '-${cartController.formatPrice(loyaltyDiscount)}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ],
            // Delivery Charge
            if (order != null && order.shippingLines.isNotEmpty && shippingCost > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    cartController.formatPrice(shippingCost.toInt()),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
            // Coupon Discount
            if (couponDiscountTotal > 0 && appliedCouponName != null) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        size: ResponsiveUtils.rp(16),
                        color: AppColors.success,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      Text(
                        appliedCouponName,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '-${cartController.formatPrice(couponDiscountTotal)}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: ResponsiveUtils.rp(12)),
            Divider(
              color: AppColors.border.withValues(alpha: 0.3),
              height: 1,
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  cartController.formatPrice(finalTotal),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                    color: AppColors.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCheckoutSection() {
    return Obx(() {
      final cart = cartController.cart.value;
      if (cart == null) return SizedBox.shrink();
      
      final cartTotal = cart.totalWithTax.toInt();
      final loyaltyDiscount =
          bannerController.loyaltyPointsApplied.value
              ? bannerController.loyaltyPointsUsed.value
              : 0;
      final finalTotal = cartTotal - loyaltyDiscount;
      
      // Button is always enabled if cart has items
      // Validation for unavailable items happens in _proceedToCheckout()
      final isButtonEnabled = cartController.cartItemCount > 0;
      final isLoading = utilityController.isLoadingRx.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Total on left
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(4)),
              Text(
                cartController.formatPrice(finalTotal),
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.button,
                ),
              ),
            ],
          ),
          // Checkout button on right
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: ResponsiveUtils.rp(16)),
              child: ElevatedButton(
                onPressed: isButtonEnabled && !isLoading ? _proceedToCheckout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? SizedBox(
                        height: ResponsiveUtils.rp(20),
                        width: ResponsiveUtils.rp(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Icon(
                            Icons.arrow_forward,
                            size: ResponsiveUtils.rp(18),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOtherInstructionsSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.note_rounded,
                    color: AppColors.warning,
                    size: ResponsiveUtils.rp(16),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Text(
                    'Additional Instructions',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(4)),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (!_showInstructionsOptions)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showInstructionsOptions = true;
                    });
                  },
                  child: Text(
                    'Show more',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showInstructionsOptions = false;
                      _showOtherTextField = false;
                      _selectedDefaultInstruction = null;
                      _otherInstructionsController.clear();
                    });
                  },
                  child: Text(
                    'Show less',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                    ),
                  ),
                ),
            ],
          ),
          if (_showInstructionsOptions) ...[
            SizedBox(height: ResponsiveUtils.rp(12)),
            if (!_showOtherTextField) ...[
              ..._defaultInstructions.map((instruction) {
                final isSelected = _selectedDefaultInstruction == instruction;
                return Container(
                  margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDefaultInstruction = instruction;
                        _otherInstructionsController.text = instruction;
                        _showOtherTextField = false;
                      });
                      _saveOtherInstructions(instruction);
                    },
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.button.withOpacity(0.1)
                            : AppColors.inputFill,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.button
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ResponsiveUtils.rp(16),
                            height: ResponsiveUtils.rp(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.button
                                    : AppColors.border,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.button
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: ResponsiveUtils.rp(12),
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(
                            child: Text(
                              instruction,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(12),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: ResponsiveUtils.rp(8)),
              InkWell(
                onTap: () {
                  setState(() {
                    _showOtherTextField = true;
                    _selectedDefaultInstruction = null;
                    _otherInstructionsController.text = '';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: ResponsiveUtils.rp(16), color: AppColors.button),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Other',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_showOtherTextField) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              TextField(
                controller: _otherInstructionsController,
                maxLines: 2,
                style: TextStyle(fontSize: ResponsiveUtils.sp(12)),
                decoration: InputDecoration(
                  hintText: 'Enter custom instructions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  contentPadding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                ),
                onChanged: (value) {
                  _saveOtherInstructions(value);
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _showCouponCodesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.rp(20)),
            topRight: Radius.circular(ResponsiveUtils.rp(20)),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
              width: ResponsiveUtils.rp(40),
              height: ResponsiveUtils.rp(4),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Coupon Codes',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: ResponsiveUtils.rp(24),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: ResponsiveUtils.rp(1), color: AppColors.divider),
            Expanded(
              child: Obx(() {
                if (!bannerController.couponCodesLoaded.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.button),
                  );
                }

                final enabledCoupons = bannerController.availableCouponCodes
                    .where((coupon) => coupon.enabled)
                    .toList();

                if (enabledCoupons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: ResponsiveUtils.rp(64),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: ResponsiveUtils.rp(16)),
                        Text(
                          'No coupon codes available',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                  itemCount: enabledCoupons.length,
                  itemBuilder: (context, index) {
                    final coupon = enabledCoupons[index];
                    final isApplied =
                        bannerController.isCouponCodeApplied(coupon.couponCode);
                    final descriptionText = (coupon.description ?? '').replaceAll(RegExp(r'<[^>]*>'), '');

                    return Card(
                      color: AppColors.surface,
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                      elevation: ResponsiveUtils.rp(2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.rp(12)),
                        side: BorderSide(
                          color:
                              isApplied ? AppColors.success : AppColors.border,
                          width: isApplied
                              ? ResponsiveUtils.rp(2)
                              : ResponsiveUtils.rp(1),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.rp(8),
                                    vertical: ResponsiveUtils.rp(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isApplied
                                        ? AppColors.success
                                        : AppColors.button,
                                    borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.rp(6)),
                                  ),
                                  child: Text(
                                    coupon.couponCode,
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveUtils.sp(12),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                if (isApplied)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.rp(8),
                                      vertical: ResponsiveUtils.rp(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.rp(6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: AppColors.textLight,
                                          size: ResponsiveUtils.rp(14),
                                        ),
                                        SizedBox(width: ResponsiveUtils.rp(4)),
                                        Text(
                                          'APPLIED',
                                          style: TextStyle(
                                            color: AppColors.textLight,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveUtils.sp(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: ResponsiveUtils.rp(12)),
                            Text(
                              coupon.name,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (descriptionText.isNotEmpty) ...[
                              SizedBox(height: ResponsiveUtils.rp(8)),
                              Text(
                                descriptionText,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.sp(14),
                                ),
                              ),
                            ],
                            SizedBox(height: ResponsiveUtils.rp(12)),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isApplied
                                    ? () async {
                                        final canRemove = bannerController.appliedCouponCodes.length < 2;
                                        if (!canRemove) {
                                          showErrorSnackbar('Cannot remove coupon when multiple coupons are applied');
                                          return;
                                        }
                                        await bannerController.removeCouponCode(coupon.couponCode);
                                        // Cart is already updated by removeCouponCode - no need for additional refresh
                                        Navigator.pop(context);
                                      }
                                    : () async {
                                        // Check if coupon has products to add
                                        final hasProducts = bannerController.hasCouponProducts(coupon.couponCode);
debugPrint('[CartPage] Coupon ${coupon.couponCode} has products: $hasProducts');
                                        
                                        final result = hasProducts
                                            ? await bannerController.applyCouponCodeWithProducts(coupon.couponCode)
                                            : await bannerController.applyCouponCode(coupon.couponCode);
                                        
                                        if (result['success'] == true) {
                                          // Cart is already updated by applyCouponCode/applyCouponCodeWithProducts - no need for additional refresh
                                          Navigator.pop(context);
                                        } else {
                                          if (result['rollbackPerformed'] == true) {
                                            showErrorSnackbar(result['message'] ?? 'Failed to apply coupon. Added products have been removed.');
                                          } else {
                                            showErrorSnackbar(result['message'] ?? 'Failed to apply coupon');
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isApplied
                                      ? AppColors.error
                                      : AppColors.button,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveUtils.rp(12)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(ResponsiveUtils.rp(8))),
                                ),
                                child: Text(
                                  isApplied ? 'Remove Coupon' : 'Apply Coupon',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveUtils.sp(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCartUI() {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large animated cart icon with background circle
            Container(
              width: ResponsiveUtils.rp(180),
              height: ResponsiveUtils.rp(180),
              decoration: BoxDecoration(
                color: AppColors.zomatoRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: ResponsiveUtils.rp(100),
                color: AppColors.zomatoRed,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(32)),
            
            // Title
            Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(24),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            
            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(48),
              ),
              child: Text(
                'Looks like you haven\'t added anything to your cart yet',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(48)),
            
            // CTA Button with icon
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(32),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zomatoRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveUtils.rp(16),
                      horizontal: ResponsiveUtils.rp(24),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.rp(12),
                      ),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        size: ResponsiveUtils.rp(20),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Start Shopping',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.rp(24)),
            
            // Additional helpful text
            TextButton(
              onPressed: () {
                Get.offAllNamed('/home');
              },
              child: Text(
                'Browse Products',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.zomatoRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        children: List.generate(5, (index) {
          return PremiumCard(
            padding: ResponsiveSpacing.padding(all: 12),
            margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image shimmer
                Container(
                  width: ResponsiveUtils.rp(100),
                  height: ResponsiveUtils.rp(100),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                  ),
                ),
                ResponsiveSpacing.horizontal(12),
                // Details shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: ResponsiveUtils.rp(18),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      Container(
                        height: ResponsiveUtils.rp(16),
                        width: ResponsiveUtils.rp(150),
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Container(
                        height: ResponsiveUtils.rp(14),
                        width: ResponsiveUtils.rp(100),
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: ResponsiveUtils.rp(32),
                            width: ResponsiveUtils.rp(100),
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Container(
                            height: ResponsiveUtils.rp(16),
                            width: ResponsiveUtils.rp(80),
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Separate widget for cart items list with "show more" functionality
class _CartItemsList extends StatefulWidget {
  final dynamic cart;
  final CartController cartController;
  final UtilityController utilityController;
  final Function(String, int) onQuantityChange;
  final Function(String, String) onRemoveItem;
  final ScrollController scrollController;

  const _CartItemsList({
    Key? key,
    required this.cart,
    required this.cartController,
    required this.utilityController,
    required this.onQuantityChange,
    required this.onRemoveItem,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<_CartItemsList> createState() => _CartItemsListState();
}

class _CartItemsListState extends State<_CartItemsList> {
  bool _showAllItems = false;

  /// Expand the list to show all items
  void expandList() {
    if (!_showAllItems) {
      setState(() {
        _showAllItems = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = _showAllItems 
        ? widget.cart.lines 
        : widget.cart.lines.take(3).toList();
    final hasMoreItems = widget.cart.lines.length > 3;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
      itemCount: itemsToShow.length + 
          (hasMoreItems && !_showAllItems ? 1 : 0) + // "Show more" button
          (hasMoreItems && _showAllItems ? 1 : 0),   // "Show less" button
      itemBuilder: (context, index) {
        // Show "Show More" button after first 3 items
        if (hasMoreItems && !_showAllItems && index == 3) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAllItems = true;
                  });
                },
                icon: Icon(
                  Icons.expand_more,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(20),
                ),
                label: Text(
                  'Show ${widget.cart.lines.length - 3} more items',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                  ),
                ),
              ),
            ),
          );
        }

        // Show "Show Less" button if all items are shown
        if (_showAllItems && hasMoreItems && index == widget.cart.lines.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAllItems = false;
                  });
                  // Scroll to top when showing less items
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (widget.scrollController.hasClients) {
                      widget.scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
                icon: Icon(
                  Icons.expand_less,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(20),
                ),
                label: Text(
                  'Show less',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                  ),
                ),
              ),
            ),
          );
        }

        final line = itemsToShow[index];
        final variant = line.productVariant;
        final imageUrl = line.featuredAsset?.preview;
        final unitPriceInt = line.unitPriceWithTax.toInt();
        final isLoading = widget.utilityController.isLoadingRx.value;
        
        // Check stock level - treat LOW_STOCK and OUT_OF_STOCK as unavailable
        final stockLevel = variant.stockLevel?.toUpperCase();
        final isLowStock = stockLevel == 'LOW_STOCK';
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isStockUnavailable = isLowStock || isOutOfStock;
        
        // Check if product is disabled (from productEnabled field or unavailableReason)
        final isProductDisabled = variant.productEnabled == false;
        final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true;
        final isProductDisabledAny = isProductDisabled || isDisabledByReason;
        
        // Item is unavailable if: isAvailable is false OR stock level is LOW_STOCK/OUT_OF_STOCK OR product is disabled
        final isUnavailable = !line.isAvailable || isStockUnavailable || isProductDisabledAny;
        
        // Determine status message - show "OUT OF STOCK" for LOW_STOCK, OUT_OF_STOCK, and disabled products
        String statusMessage;
        if (isStockUnavailable || isProductDisabledAny) {
          statusMessage = 'OUT OF STOCK - Please remove from cart';
        } else if (line.unavailableReason?.isNotEmpty == true) {
          final reason = line.unavailableReason!.toLowerCase();
          // If reason contains stock-related keywords or disabled, show "OUT OF STOCK"
          if (reason.contains('stock') || reason.contains('out of') || reason.contains('unavailable') || reason.contains('disabled')) {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          } else {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          }
        } else {
          // Default message when no reason provided but item is unavailable
          statusMessage = 'OUT OF STOCK - Please remove from cart';
        }

        return CartItemCardPremium(
          imageUrl: imageUrl,
          productName: variant.name,
          variantName: null,
          unitPrice: widget.cartController.formatPrice(unitPriceInt),
          totalPrice: widget.cartController
              .formatPrice(line.linePriceWithTax.toInt()),
          quantity: line.quantity,
          onIncreaseQuantity: isUnavailable
              ? null
              : () => widget.onQuantityChange(line.id, line.quantity + 1),
          onDecreaseQuantity: isUnavailable
              ? null
              : () => widget.onQuantityChange(line.id, line.quantity - 1),
          onRemove: () => widget.onRemoveItem(line.id, variant.name),
          isLoading: isLoading,
          isUnavailable: isUnavailable,
          statusMessage: isUnavailable ? statusMessage : null,
        );
      },
    );
  }
}
