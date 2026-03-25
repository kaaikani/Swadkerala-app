import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/coupon/coupon_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../graphql/schema.graphql.dart';

class CartOrderSummarySection extends StatefulWidget {
  final CartController cartController;
  final OrderController orderController;
  final BannerController bannerController;
  final CouponController couponController;

  const CartOrderSummarySection({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.bannerController,
    required this.couponController,
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
      // Vendure returns discount amounts as negative values, so use .abs()
      int loyaltyDiscount = 0;
      if (cart.discounts.isNotEmpty) {
        loyaltyDiscount = cart.discounts
            .where((discount) => discount.type != Enum$AdjustmentType.PROMOTION &&
                                 discount.type != Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt().abs());
      } else if (order != null && order.discounts.isNotEmpty) {
        loyaltyDiscount = order.discounts
            .where((discount) => discount.type != Enum$AdjustmentType.PROMOTION &&
                                 discount.type != Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt().abs());
      }

      // Get coupon discount from cart discounts first (updated after coupon), fallback to order
      // Vendure returns discount amounts as negative values, so use .abs() to get positive total
      int couponDiscountTotal = 0;
      if (cart.discounts.isNotEmpty) {
        couponDiscountTotal = cart.discounts
            .where((discount) => discount.type == Enum$AdjustmentType.PROMOTION ||
                                 discount.type == Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt().abs());
      } else if (order != null && order.discounts.isNotEmpty) {
        couponDiscountTotal = order.discounts
            .where((discount) => discount.type == Enum$AdjustmentType.PROMOTION ||
                                 discount.type == Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
            .fold(0, (sum, discount) => sum + discount.amountWithTax.toInt().abs());
      }
      // Also check line-level discounts if order-level discounts are 0
      // Some promotions (e.g. products_percentage_discount) apply at the line level
      if (couponDiscountTotal == 0 && widget.couponController.appliedCouponCodes.isNotEmpty) {
        for (final line in cart.lines) {
          if (line.discounts.isNotEmpty) {
            couponDiscountTotal += line.discounts
                .where((d) => d.type == Enum$AdjustmentType.PROMOTION ||
                              d.type == Enum$AdjustmentType.DISTRIBUTED_ORDER_PROMOTION)
                .fold(0, (int sum, d) => sum + d.amountWithTax.toInt().abs());
          }
        }
      }
      
      // Get applied coupon name and discount percentage
      String? appliedCouponName;
      String? discountPercentage;
      if (widget.couponController.appliedCouponCodes.isNotEmpty) {
        final appliedCode = widget.couponController.appliedCouponCodes.first;
        if (widget.couponController.availableCouponCodes.isNotEmpty) {
          final coupon = widget.couponController.availableCouponCodes.firstWhereOrNull(
            (c) => c.promotion.couponCode == appliedCode,
          );
          appliedCouponName = coupon?.promotion.name.isNotEmpty == true
              ? coupon!.promotion.name
              : appliedCode;
        } else {
          appliedCouponName = appliedCode;
        }
        // Extract discount percentage from cart promotions
        final promo = cart.promotions.firstWhereOrNull(
          (p) => (p.couponCode ?? '').toUpperCase() == appliedCode.toUpperCase(),
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
            // When collapsed: show Subtotal, coupon discount, and Total with Tax
            if (!_isExpanded) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal with Tax',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    // Vendure's subTotalWithTax already has coupon discount applied,
                    // so add it back to show the original subtotal before discount
                    widget.cartController.formatPrice(cart.subTotalWithTax.toInt() + couponDiscountTotal),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              // Coupon discount in collapsed view
              if (couponDiscountTotal > 0 && appliedCouponName != null) ...[
                SizedBox(height: ResponsiveUtils.rp(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_offer, size: ResponsiveUtils.rp(14), color: AppColors.success),
                        SizedBox(width: ResponsiveUtils.rp(4)),
                        Text(
                          'Coupon Discount${discountPercentage != null ? ' ($discountPercentage)' : ''}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      ],
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
              SizedBox(height: ResponsiveUtils.rp(8)),
            ],
            // Show full breakdown only if expanded
            if (_isExpanded) ...[
              // Subtotal (without tax) — add back coupon discount to show original
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
                    widget.cartController.formatPrice(cart.subTotal.toInt() + couponDiscountTotal + loyaltyDiscount),
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
              // Delivery Charge
              if (order != null && order.shippingLines.isNotEmpty) ...[
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
              if (widget.couponController.appliedCouponCodes.isNotEmpty && appliedCouponName != null) ...[
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
                      'Coupon Discount${discountPercentage != null ? ' ($discountPercentage)' : ''}',
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
            // "You save" banner when coupon discount is applied
            if (couponDiscountTotal > 0) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
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
                      'You save ${widget.cartController.formatPrice(couponDiscountTotal)} with this coupon',
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
      );
    });
  }
}

