import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CartOrderSummarySection extends StatefulWidget {
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
  State<CartOrderSummarySection> createState() => _CartOrderSummarySectionState();
}

class _CartOrderSummarySectionState extends State<CartOrderSummarySection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = widget.cartController.cart.value;
      final order = widget.orderController.currentOrder.value;
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
      if (widget.bannerController.appliedCouponCodes.isNotEmpty) {
        if (widget.bannerController.availableCouponCodes.isNotEmpty) {
          final appliedCode = widget.bannerController.appliedCouponCodes.first;
          final coupon = widget.bannerController.availableCouponCodes.firstWhereOrNull(
            (c) => c.couponCode == appliedCode,
          );
          appliedCouponName = coupon?.name.isNotEmpty == true 
              ? coupon!.name 
              : appliedCode;
        } else {
          appliedCouponName = widget.bannerController.appliedCouponCodes.first;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(4),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _isExpanded ? 'Show Less' : 'Show More',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.button,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Show full breakdown only if expanded
            if (_isExpanded) ...[
              // Subtotal (without tax)
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
                    widget.cartController.formatPrice(cart.subTotal.toInt()),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              // Points Applied
              if (widget.bannerController.loyaltyPointsApplied.value && widget.bannerController.loyaltyPointsUsed.value > 0) ...[
                SizedBox(height: ResponsiveUtils.rp(8)),
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
                      '${widget.bannerController.loyaltyPointsUsed.value} pts',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
              // Loyalty Points Discount
              if (loyaltyDiscount > 0) ...[
                SizedBox(height: ResponsiveUtils.rp(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Loyalty Points Discount',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '-${widget.cartController.formatPrice(loyaltyDiscount)}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
              // Shipping with Tax
              if (order != null && order.shippingLines.isNotEmpty) ...[
                SizedBox(height: ResponsiveUtils.rp(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping with Tax',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      widget.orderController.hasFreeShippingCoupon() 
                          ? 'Free' 
                          : '+${widget.cartController.formatPrice(shippingCost.toInt())}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: widget.orderController.hasFreeShippingCoupon() 
                            ? AppColors.success 
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
              // Coupon Code Used
              if (widget.bannerController.appliedCouponCodes.isNotEmpty && appliedCouponName != null) ...[
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
                          'Coupon Code Used',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      appliedCouponName,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
              // Coupon Discount
              if (couponDiscountTotal > 0) ...[
                SizedBox(height: ResponsiveUtils.rp(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coupon Discount',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '-${widget.cartController.formatPrice(couponDiscountTotal)}',
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
              // Total (without tax)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.cartController.formatPrice(cart.total.toInt()),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              // Tax on Total (always show, even if 0)
              SizedBox(height: ResponsiveUtils.rp(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax on Total',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '+${widget.cartController.formatPrice((cart.totalWithTax - cart.total).toInt())}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(8)),
            ],
            // Total with Tax (always shown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total with Tax',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  widget.cartController.formatPrice(finalTotal),
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

