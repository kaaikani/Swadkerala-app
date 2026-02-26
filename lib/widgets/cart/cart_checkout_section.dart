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
  /// When not logged in, show this label (e.g. "Login or Sign up to Checkout") and use callback to go to login.
  final String checkoutButtonLabel;

  const CartCheckoutSection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.onProceedToCheckout,
    this.checkoutButtonLabel = 'Proceed to Checkout',
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = cartController.cart.value;
      final order = orderController.currentOrder.value;
      if (cart == null) return const SizedBox.shrink();
      
      // Get total with tax - use order.totalWithTax if available, otherwise cart.totalWithTax
      final finalTotal = order?.totalWithTax != null 
          ? order!.totalWithTax.toInt() 
          : cart.totalWithTax.toInt();
      
      // Check for quantity limit violations
      final hasQuantityLimitViolations = cart.quantityLimitStatus.hasViolations;
      
      // Button is enabled if cart has items AND no quantity limit violations
      final isButtonEnabled = cartController.cartItemCount > 0 && !hasQuantityLimitViolations;
      final isLoading = utilityController.isLoadingRx.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Total with Tax on left
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total with Tax',
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
                            checkoutButtonLabel,
                            screenName: 'Cart',
                            callback: onProceedToCheckout,
                          )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled ? AppColors.button : AppColors.textTertiary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      ),
                      elevation: isButtonEnabled ? 2 : 0,
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
                                checkoutButtonLabel,
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
          ),
          // Show quantity limit violation message
          if (hasQuantityLimitViolations) ...[
            SizedBox(height: ResponsiveUtils.rp(8)),
            Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity limit exceeded',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        Text(
                          'Please decrease the quantity to proceed to checkout',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}

