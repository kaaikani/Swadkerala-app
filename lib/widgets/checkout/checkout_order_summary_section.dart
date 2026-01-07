import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/price_formatter.dart';
import '../../graphql/banner.graphql.dart';

class CheckoutOrderSummarySection extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final UtilityController utilityController;
  final BannerController bannerController;

  const CheckoutOrderSummarySection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.bannerController,
  });

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(18),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(20)),
              child: CircularProgressIndicator(
                color: AppColors.button,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = cartController.cart.value;
      final isLoading = utilityController.isLoadingRx.value;
      
      if (cart == null && isLoading) {
        return _buildOrderSummaryLoading();
      }
      
      final itemCount = cart?.lines.length ?? 0;
      final subtotal = cart?.subTotalWithTax ?? 0;
      final shipping = orderController.getShippingPrice(orderController.selectedShippingMethod.value);
      // Use cart's totalWithTax directly (updated after coupon application)
      final total = cart?.totalWithTax ?? 0;
      final hasFreeShipping = cartController.hasFreeShippingCoupon();
      
      // Get applied coupon details
      final appliedCouponCode = bannerController.getCurrentlyAppliedCoupon();
      String? appliedCouponName;
      bool hasFreeShippingInCoupon = false;
      
      if (appliedCouponCode != null) {
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = bannerController.availableCouponCodes.firstWhere(
            (c) => (c.couponCode ?? '').toUpperCase() == appliedCouponCode.toUpperCase(),
          );
        } catch (e) {
          coupon = null;
        }
        
        if (coupon != null && coupon.id.isNotEmpty) {
          appliedCouponName = coupon.name;
          hasFreeShippingInCoupon = coupon.actions.any(
            (action) => action.code == 'free_shipping',
          );
        }
      }
      
      // Loyalty Points
      final loyaltyPointsUsed = bannerController.loyaltyPointsUsed.value;
      final loyaltyPointsApplied = bannerController.loyaltyPointsApplied.value;
      final config = bannerController.loyaltyPointsConfig.value;
      final rupeesPerPoint = config?.rupeesPerPoint ?? 0;
      
      final loyaltyDiscountAmount = loyaltyPointsApplied && loyaltyPointsUsed > 0 && rupeesPerPoint > 0
          ? (loyaltyPointsUsed * rupeesPerPoint)
          : 0;
      
      // Get coupon discount from cart discounts (updated after coupon application)
      int couponDiscount = 0;
      if (cart != null && cart.discounts.isNotEmpty) {
        couponDiscount = cart.discounts
            .where((discount) => discount.adjustmentSource == 'PROMOTION' || 
                                 discount.adjustmentSource == 'COUPON_CODE')
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt());
      } else if (bannerController.appliedCouponCodes.isNotEmpty) {
        // Fallback: calculate from subtotal and total
        final totalDiscount = (subtotal + (hasFreeShipping ? 0 : shipping) - total);
        couponDiscount = (totalDiscount - loyaltyDiscountAmount).toInt();
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Text(
              'Order Summary',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Items ($itemCount)',
                  PriceFormatter.formatPrice(subtotal.toInt()),
                ),
                SizedBox(height: ResponsiveUtils.rp(12)),
                if (hasFreeShipping && hasFreeShippingInCoupon && appliedCouponCode != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Charge',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(15),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(4)),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  size: ResponsiveUtils.rp(14),
                                  color: AppColors.success,
                                ),
                                SizedBox(width: ResponsiveUtils.rp(4)),
                                Flexible(
                                  child: Text(
                                    'Applied: $appliedCouponCode',
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(12),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.success,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(15),
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  _buildSummaryRow(
                    'Delivery Charge',
                    hasFreeShipping 
                        ? 'FREE' 
                        : PriceFormatter.formatPrice(shipping.toInt()),
                    valueColor: hasFreeShipping ? AppColors.success : null,
                  ),
                ],
                if (loyaltyPointsApplied && loyaltyPointsUsed > 0 && loyaltyDiscountAmount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildSummaryRow(
                    'Loyalty Points Discount',
                    '-${PriceFormatter.formatPrice(loyaltyDiscountAmount.toInt())}',
                    valueColor: AppColors.success,
                  ),
                ],
                if (bannerController.appliedCouponCodes.isNotEmpty && couponDiscount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              size: ResponsiveUtils.rp(16),
                              color: AppColors.success,
                            ),
                            SizedBox(width: ResponsiveUtils.rp(6)),
                            Flexible(
                              child: Text(
                                appliedCouponName != null 
                                    ? 'Coupon: $appliedCouponName'
                                    : 'Coupon Discount',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(15),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '-${PriceFormatter.formatPrice(couponDiscount.toInt())}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(15),
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: ResponsiveUtils.rp(16)),
                Divider(height: 1),
                SizedBox(height: ResponsiveUtils.rp(16)),
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
                      PriceFormatter.formatPrice(total.toInt()),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.button,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
