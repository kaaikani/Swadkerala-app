import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/price_formatter.dart';
import '../utils/app_strings.dart';
import 'premium_card.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';
import 'responsive_button.dart';
import '../graphql/banner.graphql.dart';

/// Premium order summary card like Amazon/Flipkart
class OrderSummaryCard extends StatelessWidget {
  final String? subtotal;
  final String shipping;
  final String? shippingNote;
  final String? shippingMethod;
  final String total;
  final VoidCallback? onProceedToCheckout;
  final String? buttonLabel;
  final bool isButtonEnabled;
  final bool isLoading;
  final String? warningMessage;
  final List<Query$GetCouponCodeList$getCouponCodeList$items>? applicableCoupons;
  final Function(String)? onApplyCoupon;
  final List<String>? appliedCouponCodes;
  final Query$GetCouponCodeList$getCouponCodeList$items? suggestedCoupon;
  final int? amountShort;
  final bool? loyaltyPointsApplied;
  final int? loyaltyPointsUsed;
  final VoidCallback? onToggleLoyaltyPoints;
  final int? couponDiscount; // Discount amount in paise
  final String? appliedCouponName; // Name of applied coupon
  final String? appliedCouponCode; // Code of applied coupon
  final bool? hasFreeShippingCoupon; // Whether coupon provides free shipping

  const OrderSummaryCard({
    Key? key,
    this.subtotal,
    required this.shipping,
    this.shippingNote,
    this.shippingMethod,
    required this.total,
    this.onProceedToCheckout,
    this.buttonLabel,
    this.isButtonEnabled = true,
    this.isLoading = false,
    this.warningMessage,
    this.applicableCoupons,
    this.onApplyCoupon,
    this.appliedCouponCodes,
    this.suggestedCoupon,
    this.amountShort,
    this.loyaltyPointsApplied,
    this.loyaltyPointsUsed,
    this.onToggleLoyaltyPoints,
    this.couponDiscount,
    this.appliedCouponName,
    this.appliedCouponCode,
    this.hasFreeShippingCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(
        horizontal: 16,
        vertical: 12,
      ),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Suggested Coupon Banner - Show if user is close to qualifying
          if (suggestedCoupon != null && amountShort != null && amountShort! > 0) ...[
            _CouponSuggestionBanner(
              couponCode: suggestedCoupon!.couponCode ?? '',
              amountShort: amountShort!,
            ),
            SizedBox(height: ResponsiveUtils.rp(6)),
          ],
          // Applicable Coupon Codes - Small stripe above total
          if (applicableCoupons != null && applicableCoupons!.isNotEmpty) ...[
            ...applicableCoupons!.map((coupon) {
              final couponCode = coupon.couponCode ?? '';
              final couponName = coupon.name.isNotEmpty ? coupon.name : couponCode;
              final isApplied = appliedCouponCodes?.contains(couponCode) ?? false;
              
              // Get minimum order amount from coupon conditions
              int? minimumAmount;
              for (final condition in coupon.conditions) {
                if (condition.code == 'minimum_order_amount') {
                  for (final arg in condition.args) {
                    if (arg.name == 'amount') {
                      // arg.value is always String, so parse it directly
                      minimumAmount = int.tryParse(arg.value);
                      break;
                    }
                  }
                }
              }
              
              return Container(
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(6)),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(10),
                  vertical: ResponsiveUtils.rp(5),
                ),
                decoration: BoxDecoration(
                  color: isApplied
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.button.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                  border: Border.all(
                    color: isApplied
                        ? AppColors.success.withValues(alpha: 0.3)
                        : AppColors.button.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                isApplied ? Icons.check_circle : Icons.local_offer,
                                size: ResponsiveUtils.rp(14),
                                color: isApplied ? AppColors.success : AppColors.button,
                              ),
                              SizedBox(width: ResponsiveUtils.rp(6)),
                              Expanded(
                                child: ResponsiveText(
                                  couponName,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isApplied ? AppColors.success : AppColors.button,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: isApplied ? null : () => onApplyCoupon!(couponCode),
                          child: Container(
                            width: ResponsiveUtils.rp(40),
                            height: ResponsiveUtils.rp(20),
                            padding: EdgeInsets.all(ResponsiveUtils.rp(2)),
                            decoration: BoxDecoration(
                              color: isApplied ? AppColors.success : AppColors.textSecondary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: isApplied ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                width: ResponsiveUtils.rp(16),
                                height: ResponsiveUtils.rp(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (minimumAmount != null && !isApplied) ...[
                      SizedBox(height: ResponsiveUtils.rp(4)),
                      ResponsiveText(
                        'Min order ${PriceFormatter.formatPrice(minimumAmount)}',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
          // Loyalty Points Toggle
          if (loyaltyPointsUsed != null && loyaltyPointsUsed! > 0 && onToggleLoyaltyPoints != null) ...[
            Container(
              margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(6)),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(10),
                vertical: ResponsiveUtils.rp(5),
              ),
              decoration: BoxDecoration(
                color: (loyaltyPointsApplied ?? false)
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.button.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                border: Border.all(
                  color: (loyaltyPointsApplied ?? false)
                      ? AppColors.success.withValues(alpha: 0.3)
                      : AppColors.button.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        (loyaltyPointsApplied ?? false) ? Icons.check_circle : Icons.stars,
                        size: ResponsiveUtils.rp(14),
                        color: (loyaltyPointsApplied ?? false) ? AppColors.success : AppColors.button,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      ResponsiveText(
                        'Loyalty Points (${PriceFormatter.formatPrice(loyaltyPointsUsed ?? 0)})',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: (loyaltyPointsApplied ?? false) ? AppColors.success : AppColors.button,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onToggleLoyaltyPoints,
                    child: Container(
                      width: ResponsiveUtils.rp(40),
                      height: ResponsiveUtils.rp(20),
                      padding: EdgeInsets.all(ResponsiveUtils.rp(2)),
                      decoration: BoxDecoration(
                        color: (loyaltyPointsApplied ?? false) ? AppColors.success : AppColors.textSecondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: (loyaltyPointsApplied ?? false) ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: ResponsiveUtils.rp(16),
                          height: ResponsiveUtils.rp(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Subtotal - Show if provided
          if (subtotal != null && subtotal!.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ResponsiveText(
                  'Subtotal',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                ResponsiveText(
                  subtotal!,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
          ],
          // Loyalty Points Discount - Show below subtotal if applied
          if (loyaltyPointsUsed != null && loyaltyPointsUsed! > 0 && (loyaltyPointsApplied ?? false)) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.stars,
                      size: ResponsiveUtils.rp(16),
                      color: AppColors.info,
                    ),
                    SizedBox(width: ResponsiveUtils.rp(6)),
                    ResponsiveText(
                      'Loyalty Points',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                ResponsiveText(
                  '-${PriceFormatter.formatPrice(loyaltyPointsUsed!)}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
          ],
          // Shipping Cost Display - Show if shipping method is applied
          if (shippingMethod != null && shippingMethod!.isNotEmpty && shippingMethod == 'Applied') ...[
            // Show delivery charge with coupon code if free shipping from coupon
            if (hasFreeShippingCoupon == true && appliedCouponCode != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ResponsiveText(
                        'Shipping Cost',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      ResponsiveText(
                        'Free',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ],
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
                        child: ResponsiveText(
                          'Applied: $appliedCouponCode',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ResponsiveText(
                    'Shipping Cost',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  ResponsiveText(
                    shipping.isNotEmpty ? shipping : 'Free',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: (shipping.isEmpty || shipping.toLowerCase() == 'free') 
                        ? AppColors.success 
                        : AppColors.textPrimary,
                  ),
                ],
              ),
            ],
            SizedBox(height: ResponsiveUtils.rp(8)),
          ],
          // Coupon Discount - Show below shipping cost if applied
          if (couponDiscount != null && couponDiscount! > 0 && appliedCouponName != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: ResponsiveText(
                          'Coupon: $appliedCouponName',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveText(
                  '-${PriceFormatter.formatPrice(couponDiscount!)}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
          ],
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveText(
                'Total',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              ResponsiveText(
                total,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.button,
              ),
            ],
          ),
          if (onProceedToCheckout != null) ...[
            ResponsiveSpacing.vertical(12),
            if (warningMessage != null) ...[
              Container(
                width: double.infinity,
                padding: ResponsiveSpacing.padding(
                  horizontal: 10,
                  vertical: 8,
                ),
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(10)),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: ResponsiveUtils.rp(18),
                      color: AppColors.warning,
                    ),
                    ResponsiveSpacing.horizontal(8),
                    Expanded(
                      child: ResponsiveText(
                        warningMessage!,
                        fontSize: 12,
                        color: AppColors.warning,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ResponsiveElevatedButton(
              label: buttonLabel ?? AppStrings.proceedToCheckout,
              onPressed:
                  isButtonEnabled && !isLoading ? onProceedToCheckout : null,
              isFullWidth: true,
              isLoading: isLoading,
              icon: Icon(
                Icons.arrow_forward,
                size: ResponsiveUtils.rp(18),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
/// Coupon suggestion banner widget
/// Shows "Spend ₹X more to Apply 'COUPONCODE'"
class _CouponSuggestionBanner extends StatelessWidget {
  final String couponCode;
  final int amountShort; // in paise

  const _CouponSuggestionBanner({
    required this.couponCode,
    required this.amountShort,
  });

  @override
  Widget build(BuildContext context) {
    final amountInRupees = amountShort / 100.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(12),
        vertical: ResponsiveUtils.rp(6),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.button.withValues(alpha: 0.9),
            AppColors.button.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        border: Border.all(
          color: AppColors.button.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer,
            size: ResponsiveUtils.rp(18),
            color: Colors.deepOrange,
          ),
          SizedBox(width: ResponsiveUtils.rp(6)),
          Flexible(
            child: Text.rich(
              TextSpan(
                text: 'Spend ${PriceFormatter.formatPrice((amountInRupees * 100).toInt())} more to Apply ',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(13),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '"$couponCode"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

