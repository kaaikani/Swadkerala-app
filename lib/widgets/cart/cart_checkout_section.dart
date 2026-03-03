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
  /// When not logged in, show this label (e.g. "Login to Checkout") and use callback to go to login.
  final String checkoutButtonLabel;
  /// Whether the user is a guest (not logged in).
  final bool isGuest;

  const CartCheckoutSection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.onProceedToCheckout,
    this.checkoutButtonLabel = 'Proceed to Checkout',
    this.isGuest = false,
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

      // Check for insufficient stock (items where quantity exceeds available stock)
      final hasInsufficientStockItems = cart.validationStatus.hasUnavailableItems ||
          cart.lines.any((line) {
            final stockLevelRaw = line.productVariant.stockLevel.trim();
            final stockLevel = stockLevelRaw.toUpperCase();
            final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
            final isProductDisabled = line.productVariant.product.enabled == false;
            // Parse numeric stock level (e.g., "2", "10") and compare with quantity
            final numericStock = int.tryParse(stockLevelRaw);
            final exceedsStock = numericStock != null && line.quantity > numericStock;
            return !line.isAvailable || isOutOfStock || isProductDisabled || exceedsStock;
          });

      // Button is enabled if cart has items AND no quantity limit violations AND no insufficient stock
      final isButtonEnabled = cartController.cartItemCount > 0 && !hasQuantityLimitViolations && !hasInsufficientStockItems;
      final isLoading = utilityController.isLoadingRx.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Guest login prompt banner
          if (isGuest) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(12),
                vertical: ResponsiveUtils.rp(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                border: Border.all(
                  color: AppColors.button.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(18),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Expanded(
                    child: Text(
                      'Sign in to place your order',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(13),
                        fontWeight: FontWeight.w500,
                        color: AppColors.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(10)),
          ],
          // Show quantity limit violation message above checkout button
          if (hasQuantityLimitViolations) ...[
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
            SizedBox(height: ResponsiveUtils.rp(8)),
          ],
          // Show insufficient stock warning above checkout button
          if (hasInsufficientStockItems && !hasQuantityLimitViolations) ...[
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.warning,
                    size: ResponsiveUtils.rp(20),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        Text(
                          'Some products are not in stock, kindly check',
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
            SizedBox(height: ResponsiveUtils.rp(8)),
          ],
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
              // Checkout / Login button on right
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
                              if (isGuest) ...[
                                Icon(
                                  Icons.login_rounded,
                                  size: ResponsiveUtils.rp(18),
                                ),
                                SizedBox(width: ResponsiveUtils.rp(8)),
                              ],
                              Text(
                                checkoutButtonLabel,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (!isGuest) ...[
                                SizedBox(width: ResponsiveUtils.rp(8)),
                                Icon(
                                  Icons.arrow_forward,
                                  size: ResponsiveUtils.rp(18),
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
