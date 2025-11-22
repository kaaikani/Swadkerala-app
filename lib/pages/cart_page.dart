import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/banner/bannermodels.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart_item_card_premium.dart';
import '../widgets/order_summary_card.dart';
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

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final UtilityController utilityController = Get.find<UtilityController>();
  final BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.getActiveOrder();
      // Load coupon codes
      if (!bannerController.couponCodesLoaded.value) {
        bannerController.getCouponCodeList();
      }
      
      // Track screen view
      AnalyticsService().logScreenView(screenName: 'Cart');
    });
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
  Future<void> _applyCouponCode(String couponCode) async {
    final result = await bannerController.applyCouponCode(couponCode);
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
      
      await cartController.getActiveOrder();
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
    if (newQuantity < 1) return;

    final success = await cartController.adjustOrderLine(
      orderLineId: orderLineId,
      quantity: newQuantity,
    );

    if (!success) {
      showErrorSnackbar('Failed to update quantity');
    }
  }

  void _proceedToCheckout() {
    if (cartController.cartItemCount == 0) {
      showErrorSnackbar('Your cart is empty');
      return;
    }

    if (cartController.hasUnavailableItems) {
      showErrorSnackbar('Remove unavailable items before checkout');
      return;
    }

    // Track begin checkout event
    final cart = cartController.cart.value;
    if (cart != null) {
      final items = cart.lines.map((line) {
        return analytics.AnalyticsEventItem(
          itemId: line.productVariant.id,
          itemName: line.productVariant.name,
          itemCategory: 'Product', // ProductVariant doesn't have product reference
          price: line.unitPriceWithTax / 100.0,
          quantity: line.quantity,
        );
      }).toList();
      
      AnalyticsService().logBeginCheckout(
        value: cart.totalWithTax / 100.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Shopping Cart',
        actions: [
          Obx(() {
            final cart = cartController.cart.value;
            final hasItems = cart != null && cart.lines.isNotEmpty;
            
            if (!hasItems) return const SizedBox.shrink();
            
            return IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.error,
              ),
              tooltip: 'Clear Cart',
              onPressed: _handleClearCart,
            );
          }),
        ],
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
                child: ListView.builder(
                  padding: ResponsiveSpacing.padding(all: 16),
                  itemCount: cart.lines.length,
                  itemBuilder: (context, index) {
                    final line = cart.lines[index];
                    final variant = line.productVariant;
                    final imageUrl = line.featuredAsset?.preview;
                    final unitPriceInt = line.unitPriceWithTax.toInt();
                    final isLoading = utilityController.isLoadingRx.value;
                    final isUnavailable = !line.isAvailable;
                    final statusMessage =
                        line.unavailableReason?.isNotEmpty == true
                            ? line.unavailableReason!
                            : 'This item is currently out of stock.';

                    return CartItemCardPremium(
                      imageUrl: imageUrl,
                      productName: variant.name,
                      variantName:
                          null, // ProductVariant doesn't have sku property
                      unitPrice: cartController.formatPrice(unitPriceInt),
                      totalPrice: cartController
                          .formatPrice(line.linePriceWithTax.toInt()),
                      quantity: line.quantity,
                      onIncreaseQuantity: isUnavailable
                          ? null
                          : () =>
                              _handleQuantityChange(line.id, line.quantity + 1),
                      onDecreaseQuantity: isUnavailable
                          ? null
                          : () =>
                              _handleQuantityChange(line.id, line.quantity - 1),
                      onRemove: () => _handleRemoveItem(line.id, variant.name),
                      isLoading: isLoading,
                      isUnavailable: isUnavailable,
                      statusMessage: isUnavailable ? statusMessage : null,
                    );
                  },
                ),
              ),
            ),

            // Cart Summary - Fixed Bottom
            PremiumCard(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveUtils.rp(16)),
                topRight: Radius.circular(ResponsiveUtils.rp(16)),
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  final hasUnavailable = cartController.hasUnavailableItems;
                  final shippingText = cartController.getShippingDisplayText();
                  final hasFreeShipping =
                      cartController.hasFreeShippingCoupon();
                  final cartTotal = cart.totalWithTax.toInt();
                  final loyaltyDiscount =
                      bannerController.loyaltyPointsApplied.value
                          ? bannerController.loyaltyPointsUsed.value
                          : 0;
                  final finalTotal = cartTotal - loyaltyDiscount;
                  final warningMessage = hasUnavailable
                      ? (cartController.firstUnavailableReason ??
                          'Remove unavailable items before proceeding to checkout.')
                      : null;

                  // Get applicable coupons
                  final applicableCoupons = _getApplicableCoupons(cartTotal);

                  // Calculate suggested coupon
                  final couponInfo = _calculateCouponInfo(
                    cart.totalWithTax,
                    bannerController.availableCouponCodes,
                  );

                  return OrderSummaryCard(
                    subtotal: cartController
                        .formatPrice(cart.subTotalWithTax.toInt()),
                    shipping: shippingText,
                    shippingNote:
                        hasFreeShipping ? 'Free shipping applied' : null,
                    total: cartController.formatPrice(finalTotal),
                    onProceedToCheckout: _proceedToCheckout,
                    buttonLabel: 'Proceed to Checkout',
                    isButtonEnabled:
                        cartController.cartItemCount > 0 && !hasUnavailable,
                    isLoading: utilityController.isLoadingRx.value,
                    warningMessage: warningMessage,
                    applicableCoupons: applicableCoupons,
                    onApplyCoupon: _applyCouponCode,
                    appliedCouponCodes: bannerController.appliedCouponCodes,
                    suggestedCoupon: couponInfo['coupon'] as CouponCodeModel?,
                    amountShort: couponInfo['amountShort'] as int?,
                  );
                }),
              ),
            ),
          ],
        );
      }),
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
