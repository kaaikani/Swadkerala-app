import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/analytics_helper.dart';

class CartCheckoutSection extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final UtilityController utilityController;
  final VoidCallback onProceedToCheckout;

  const CartCheckoutSection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.onProceedToCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = cartController.cart.value;
      final order = orderController.currentOrder.value;
      if (cart == null) return const SizedBox.shrink();
      
      // Get total directly from query - use order.total if available, otherwise cart.totalWithTax
      final finalTotal = order?.total != null 
          ? order!.total.toInt() 
          : cart.totalWithTax.toInt();
      
      // Button is always enabled if cart has items
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
                onPressed: isButtonEnabled && !isLoading 
                    ? AnalyticsHelper.trackButton(
                        'Proceed to Checkout',
                        screenName: 'Cart',
                        callback: onProceedToCheckout,
                      )
                    : null,
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
}

