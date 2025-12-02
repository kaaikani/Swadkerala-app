import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CheckoutBottomBar extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final VoidCallback onPlaceOrder;

  const CheckoutBottomBar({
    Key? key,
    required this.cartController,
    required this.orderController,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Obx(() {
                    final cart = cartController.cart.value;
                    if (cart == null) return SizedBox.shrink();

                    // Backend already includes shipping in totalWithTax
                    final total = cart.totalWithTax;

                    return Text(
                      cartController.formatPrice(total.toInt()),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),
            Expanded(
              flex: 2,
              child: Obx(() {
                final isProcessing =
                    orderController.utilityController.isLoadingRx.value;
                return ElevatedButton(
                  onPressed: isProcessing ? null : onPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: AppColors.textLight,
                    padding:
                        EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(12)),
                    ),
                    elevation: 0,
                  ),
                  child: isProcessing
                      ? SizedBox(
                          height: ResponsiveUtils.rp(20),
                          width: ResponsiveUtils.rp(20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textLight,
                          ),
                        )
                      : Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
