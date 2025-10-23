import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/empty_state.dart';
import '../widgets/snackbar.dart';
import 'checkout_page.dart';

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

  Future<void> _handleQuantityChange(String orderLineId, int newQuantity) async {
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
    
    Get.to(() => const CheckoutPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Shopping Cart',
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return const Center(child: CircularProgressIndicator());
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

        return Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cart.lines.length,
                itemBuilder: (context, index) {
                  final line = cart.lines[index];
                  final variant = line.productVariant;
                  final imageUrl = line.featuredAsset?.preview;
                  final unitPriceInt = line.unitPriceWithTax.toInt();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image),
                                  ),
                          ),

                          const SizedBox(width: 12),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  variant.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cartController.formatPrice(unitPriceInt),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Quantity Controls
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => _handleQuantityChange(
                                        line.id,
                                        line.quantity - 1,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        '${line.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => _handleQuantityChange(
                                        line.id,
                                        line.quantity + 1,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Remove Button & Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _handleRemoveItem(line.id, variant.name),
                              ),
                              const SizedBox(height: 8),
                          Text(
                            cartController.formatPrice(line.linePriceWithTax.toInt()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cart Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          cartController.formatPrice(cart.subTotalWithTax.toInt()),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Shipping Cost
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shipping',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            cartController.getShippingDisplayText(),
                            style: TextStyle(
                              fontSize: 15,
                              color: cartController.hasFreeShippingCoupon() 
                                  ? Colors.green 
                                  : Colors.black,
                              fontWeight: cartController.hasFreeShippingCoupon() 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }),
                    // Applied Coupon Codes
                    Obx(() {
                      if (bannerController.appliedCouponCodes.isNotEmpty) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Applied Coupon Codes:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${bannerController.appliedCouponCodes.length} applied',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ...bannerController.appliedCouponCodes.map((code) => 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '• $code',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final success = await bannerController.removeCouponCode(code);
                                      if (success) {
                                        showSuccessSnackbar('Coupon code removed');
                                        setState(() {}); // Refresh UI
                                      } else {
                                        showErrorSnackbar('Failed to remove coupon code');
                                      }
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ).toList(),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    // Loyalty Points Applied
                    Obx(() {
                      if (bannerController.loyaltyPointsApplied.value && bannerController.loyaltyPointsUsed.value > 0) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Loyalty Points Discount:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '-${cartController.formatPrice(bannerController.loyaltyPointsUsed.value)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    // Shipping will be calculated at checkout
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() {
                          final cartTotal = cart.totalWithTax.toInt();
                          final loyaltyDiscount = bannerController.loyaltyPointsApplied.value 
                              ? bannerController.loyaltyPointsUsed.value 
                              : 0;
                          final finalTotal = cartTotal - loyaltyDiscount;
                          
                          return Text(
                            cartController.formatPrice(finalTotal),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Proceed to Checkout',
                        icon: Icons.arrow_forward,
                        onPressed: () async => _proceedToCheckout(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

