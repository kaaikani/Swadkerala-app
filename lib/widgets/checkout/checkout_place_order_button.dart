import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/price_formatter.dart';
import '../../graphql/banner.graphql.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final UtilityController utilityController;
  final BannerController bannerController;
  final Query$GetActiveCustomer$activeCustomer$addresses? selectedAddress;
  final GlobalKey<SlideActionState> slideActionKey;
  final bool orderPlacedSuccessfully;
  final Future<void> Function() onPlaceOrder;

  const CheckoutPlaceOrderButton({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.bannerController,
    required this.selectedAddress,
    required this.slideActionKey,
    required this.orderPlacedSuccessfully,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final isEnabled = selectedAddress != null &&
          orderController.selectedShippingMethod.value != null &&
          orderController.selectedPaymentMethod.value != null;
      final cart = cartController.cart.value;
      final total = cart?.totalWithTax ?? 0;

      final hasOutOfStockItems = cart?.lines.any((line) {
        final stockLevel = line.productVariant.stockLevel.toUpperCase();
        final isLowStock = stockLevel == 'LOW_STOCK';
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isProductDisabled = line.productVariant.product.enabled == false;
        return !line.isAvailable || isLowStock || isOutOfStock || isProductDisabled;
      }) ?? false;

      final subTotal = orderController.currentOrder.value?.subTotalWithTax ?? 0;
      final eligibleCoupons = bannerController.getEligibleCoupons(subTotal.toInt());

      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: ResponsiveUtils.rp(20),
              offset: Offset(0, -ResponsiveUtils.rp(4)),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasOutOfStockItems) ...[
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                  margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: AppColors.error,
                        size: ResponsiveUtils.rp(20),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Expanded(
                        child: Text(
                          'Some items are out of stock. Please remove them to proceed.',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (!hasOutOfStockItems && eligibleCoupons.isNotEmpty) ...[
                Obx(() {
                  final coupon = eligibleCoupons.first;
                  final requiredAmount = bannerController.getRequiredAmount(coupon);
                  final currentSubTotal = orderController.currentOrder.value?.subTotalWithTax ?? 0;
                  final difference = requiredAmount - currentSubTotal;

                  if (difference > 0) {
                    final differenceInRupees = difference / 100;
                    return Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1a1a2e),
                            const Color(0xFF16213e),
                            const Color(0xFF0f3460),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowMedium,
                            blurRadius: ResponsiveUtils.rp(8),
                            offset: Offset(0, ResponsiveUtils.rp(4)),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_offer_rounded,
                            color: AppColors.buttonText,
                            size: ResponsiveUtils.rp(18),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(
                            child: Text(
                              'Add ${PriceFormatter.formatPrice((differenceInRupees * 100).toInt())} more to unlock coupon \'${coupon.couponCode}\'',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonText,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
              isLoading
                  ? Container(
                      height: ResponsiveUtils.rp(60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                        color: AppColors.inputBorder,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: ResponsiveUtils.rp(24),
                          height: ResponsiveUtils.rp(24),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonText),
                          ),
                        ),
                      ),
                    )
                  : SlideAction(
                      key: slideActionKey,
                      height: ResponsiveUtils.rp(60),
                      borderRadius: ResponsiveUtils.rp(16),
                      innerColor: AppColors.buttonText,
                      outerColor: isEnabled
                          ? AppColors.button
                          : AppColors.inputBorder,
                      text: isEnabled && total > 0
                          ? 'Place Order - ${PriceFormatter.formatPrice(total.toInt())}'
                          : 'Place Order',
                      textStyle: TextStyle(
                        fontSize: ResponsiveUtils.sp(16),
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? AppColors.buttonText : AppColors.textSecondary,
                      ),
                      sliderButtonIcon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isEnabled ? AppColors.button : AppColors.textSecondary,
                        size: ResponsiveUtils.rp(20),
                      ),
                      sliderButtonIconPadding: ResponsiveUtils.rp(12),
                      submittedIcon: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.buttonText,
                        size: ResponsiveUtils.rp(20),
                      ),
                      onSubmit: () {
                        if (!isLoading && isEnabled && !orderPlacedSuccessfully) {
                          onPlaceOrder();
                        }
                        return null;
                      },
                    ),
            ],
          ),
        ),
      );
    });
  }
}
