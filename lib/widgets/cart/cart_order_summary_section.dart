import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CartOrderSummarySection extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final BannerController bannerController;

  const CartOrderSummarySection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.bannerController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = cartController.cart.value;
      final order = orderController.currentOrder.value;
      if (cart == null) return const SizedBox.shrink();
      final shippingCost = order?.shippingWithTax ?? cart.shippingWithTax;
      
      // Get total from cart (most up-to-date after coupon application)
      // Cart is updated directly from coupon response, order may have stale data
      final finalTotal = cart.totalWithTax.toInt();
      
      // Get loyalty discount from cart discounts first (updated after coupon), fallback to order
      int loyaltyDiscount = 0;
      if (cart.discounts.isNotEmpty) {
        loyaltyDiscount = cart.discounts
            .where((discount) => discount.adjustmentSource != 'PROMOTION' && 
                                 discount.adjustmentSource != 'COUPON_CODE' &&
                                 discount.adjustmentSource != 'DISTRIBUTED_ORDER_PROMOTION')
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt());
      } else if (order != null && order.discounts.isNotEmpty) {
        loyaltyDiscount = order.discounts
            .where((discount) => discount.adjustmentSource != 'PROMOTION' && 
                                 discount.adjustmentSource != 'COUPON_CODE' &&
                                 discount.adjustmentSource != 'DISTRIBUTED_ORDER_PROMOTION')
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt());
      }
      
      // Get coupon discount from cart discounts first (updated after coupon), fallback to order
      int couponDiscountTotal = 0;
      if (cart.discounts.isNotEmpty) {
        couponDiscountTotal = cart.discounts
            .where((discount) => discount.adjustmentSource == 'PROMOTION' || 
                                 discount.adjustmentSource == 'COUPON_CODE')
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt());
      } else if (order != null && order.discounts.isNotEmpty) {
        couponDiscountTotal = order.discounts
            .where((discount) => discount.adjustmentSource == 'PROMOTION' || 
                                 discount.adjustmentSource == 'COUPON_CODE')
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt());
      }
      
      // Get applied coupon name
      String? appliedCouponName;
      if (bannerController.appliedCouponCodes.isNotEmpty) {
        if (bannerController.availableCouponCodes.isNotEmpty) {
          final appliedCode = bannerController.appliedCouponCodes.first;
          final coupon = bannerController.availableCouponCodes.firstWhereOrNull(
            (c) => c.couponCode == appliedCode,
          );
          appliedCouponName = coupon?.name.isNotEmpty == true 
              ? coupon!.name 
              : appliedCode;
        } else {
          appliedCouponName = bannerController.appliedCouponCodes.first;
        }
      }
      
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  cartController.formatPrice(cart.subTotalWithTax.toInt()),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            // Loyalty Points Discount
            if (loyaltyDiscount > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Loyalty Points',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '-${cartController.formatPrice(loyaltyDiscount)}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ],
            // Delivery Charge
            if (order != null && order.shippingLines.isNotEmpty && shippingCost > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    cartController.formatPrice(shippingCost.toInt()),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
            // Coupon Discount
            if (couponDiscountTotal > 0 && appliedCouponName != null) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        size: ResponsiveUtils.rp(16),
                        color: AppColors.success,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      Text(
                        appliedCouponName,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '-${cartController.formatPrice(couponDiscountTotal)}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: ResponsiveUtils.rp(12)),
            Divider(
              color: AppColors.border.withValues(alpha: 0.3),
              height: 1,
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Total
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
                  cartController.formatPrice(finalTotal),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                    color: AppColors.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

