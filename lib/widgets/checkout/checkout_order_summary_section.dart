import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/coupon/coupon_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/price_formatter.dart';
import '../../graphql/banner.graphql.dart';
import '../../graphql/schema.graphql.dart';

class CheckoutOrderSummarySection extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final UtilityController utilityController;
  final BannerController bannerController;
  final CouponController couponController;

  const CheckoutOrderSummarySection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.bannerController,
    required this.couponController,
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
      // Get shipping price from selected method, fallback to cart's shippingWithTax
      final selectedMethod = orderController.selectedShippingMethod.value;
      final shippingFromMethod = orderController.getShippingPrice(selectedMethod);
      final shippingFromCart = cart?.shippingWithTax ?? 0;
      // Use shipping from method if method is selected and has valid price, otherwise use cart's shippingWithTax
      // This ensures delivery charge is always shown correctly even if method selection is delayed
      final shipping = (selectedMethod != null && shippingFromMethod > 0) 
          ? shippingFromMethod 
          : shippingFromCart.toInt();
      // Use cart's totalWithTax directly (updated after coupon application)
      final total = cart?.totalWithTax ?? 0;
      final hasFreeShipping = cartController.hasFreeShippingCoupon();
      
      // Get applied coupon details
      final appliedCouponCode = couponController.getCurrentlyAppliedCoupon();
      String? appliedCouponName;
      bool hasFreeShippingInCoupon = false;

      if (appliedCouponCode != null) {
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = couponController.availableCouponCodes.firstWhere(
            (c) => (c.promotion.couponCode ?? '').toUpperCase() == appliedCouponCode.toUpperCase(),
          );
        } catch (e) {
          coupon = null;
        }

        if (coupon != null && coupon.promotion.id.isNotEmpty) {
          appliedCouponName = coupon.promotion.name;
          hasFreeShippingInCoupon = coupon.promotion.actions.any(
            (action) => action.code == 'free_shipping',
          );
        }
      }
      
      // Loyalty Points - discount = points / pointsPerRupee (in paise: * 100)
      final loyaltyPointsUsed = bannerController.loyaltyPointsUsed.value;
      final loyaltyPointsApplied = bannerController.loyaltyPointsApplied.value;
      final config = bannerController.loyaltyPointsConfig.value;
      final pointsPerRupee = config?.pointsPerRupee ?? 0;
      
      final loyaltyDiscountAmount = loyaltyPointsApplied && loyaltyPointsUsed > 0 && pointsPerRupee > 0
          ? (loyaltyPointsUsed / pointsPerRupee * 100).toInt()
          : 0;
      
      // Extract discount percentage from applied coupon promotion
      String? discountPercentage;
      if (appliedCouponCode != null && cart != null) {
        final promo = cart.promotions.firstWhereOrNull(
          (p) => (p.couponCode ?? '').toUpperCase() == appliedCouponCode.toUpperCase(),
        );
        if (promo != null) {
          for (final action in promo.actions) {
            if (action.code.contains('percentage')) {
              final discountArg = action.args.firstWhereOrNull(
                (a) => a.name == 'discount',
              );
              if (discountArg != null) {
                discountPercentage = '${discountArg.value}%';
                break;
              }
            }
          }
        }
      }

      // Get coupon discount from cart discounts (updated after coupon application)
      // Vendure returns discount amounts as negative values, so use .abs()
      int couponDiscount = 0;
      if (cart != null && cart.discounts.isNotEmpty) {
        couponDiscount = cart.discounts
            .where((discount) => discount.type == Enum$AdjustmentType.PROMOTION ||
                                 discount.type == Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt().abs());
      }
      // Also check line-level discounts if order-level is 0
      // Some promotions (e.g. products_percentage_discount) apply at line level
      if (couponDiscount == 0 && cart != null && couponController.appliedCouponCodes.isNotEmpty) {
        for (final line in cart.lines) {
          if (line.discounts.isNotEmpty) {
            couponDiscount += line.discounts
                .where((d) => d.type == Enum$AdjustmentType.PROMOTION ||
                              d.type == Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
                .fold(0, (int sum, d) => sum + d.amountWithTax.toInt().abs());
          }
        }
      }
      // Final fallback: calculate from subtotal and total
      if (couponDiscount == 0 && couponController.appliedCouponCodes.isNotEmpty) {
        final totalDiscount = (subtotal + (hasFreeShipping ? 0 : shipping) - total);
        couponDiscount = (totalDiscount - loyaltyDiscountAmount).toInt().abs();
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
                  // Vendure's subTotalWithTax already has coupon & loyalty discount applied,
                  // so add them back to show the original subtotal before discounts
                  PriceFormatter.formatPrice(subtotal.toInt() + couponDiscount + loyaltyDiscountAmount),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.stars,
                            size: ResponsiveUtils.rp(16),
                            color: AppColors.info,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(6)),
                          Text(
                            'Points Applied',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '-${PriceFormatter.formatPrice(loyaltyDiscountAmount.toInt())}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ],
                if (couponController.appliedCouponCodes.isNotEmpty && couponDiscount > 0) ...[
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
                                    ? 'Coupon: $appliedCouponName${discountPercentage != null ? ' ($discountPercentage)' : ''}'
                                    : 'Coupon Discount${discountPercentage != null ? ' ($discountPercentage)' : ''}',
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
                // "You save" banner when coupon discount is applied
                if (couponDiscount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(12),
                      vertical: ResponsiveUtils.rp(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.savings_outlined, size: ResponsiveUtils.rp(16), color: AppColors.success),
                        SizedBox(width: ResponsiveUtils.rp(6)),
                        Text(
                          'You save ${PriceFormatter.formatPrice(couponDiscount)} with this coupon',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}
