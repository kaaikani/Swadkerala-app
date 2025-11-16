import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/empty_state.dart';
import '../widgets/snackbar.dart';
import '../widgets/cart_item_card_premium.dart';
import '../widgets/order_summary_card.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/premium_card.dart';
import '../theme/colors.dart';

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
    });
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

    Get.toNamed('/checkout');
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
          return EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'Your Cart is Empty',
            subtitle: 'Add items to your cart to see them here',
            action: AppButton(
              text: 'Start Shopping',
              onPressed: () async {
                Get.back();
              },
            ),
          );
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
              padding: ResponsiveSpacing.padding(all: 16),
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
                  );
                }),
              ),
            ),
          ],
        );
      }),
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
