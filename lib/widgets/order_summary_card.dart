import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../controllers/banner/bannermodels.dart';
import 'premium_card.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';
import 'responsive_button.dart';

/// Premium order summary card like Amazon/Flipkart
class OrderSummaryCard extends StatelessWidget {
  final String subtotal;
  final String shipping;
  final String? shippingNote;
  final String total;
  final VoidCallback? onProceedToCheckout;
  final String? buttonLabel;
  final bool isButtonEnabled;
  final bool isLoading;
  final String? warningMessage;
  final List<CouponCodeModel>? applicableCoupons;
  final Function(String)? onApplyCoupon;
  final List<String>? appliedCouponCodes;
  final CouponCodeModel? suggestedCoupon;
  final int? amountShort;

  const OrderSummaryCard({
    Key? key,
    required this.subtotal,
    required this.shipping,
    this.shippingNote,
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
              couponCode: suggestedCoupon!.couponCode,
              amountShort: amountShort!,
            ),
            SizedBox(height: ResponsiveUtils.rp(6)),
          ],
          // Applicable Coupon Codes - Small stripe above total
          if (applicableCoupons != null && applicableCoupons!.isNotEmpty) ...[
            ...applicableCoupons!.map((coupon) {
              final couponCode = coupon.couponCode;
              final couponName = coupon.name.isNotEmpty ? coupon.name : couponCode;
              final isApplied = appliedCouponCodes?.contains(couponCode) ?? false;
              
              // Get minimum order amount from coupon conditions
              int? minimumAmount;
              for (final condition in coupon.conditions) {
                if (condition.code == 'minimum_order_amount') {
                  for (final arg in condition.args) {
                    if (arg.name == 'amount') {
                      final value = arg.value;
                      if (value is num) {
                        minimumAmount = value.toInt();
                      } else if (value is String) {
                        minimumAmount = int.tryParse(value);
                      }
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
                        if (!isApplied && onApplyCoupon != null)
                          GestureDetector(
                            onTap: () => onApplyCoupon!(couponCode),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(8),
                                vertical: ResponsiveUtils.rp(4),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.button,
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
                              ),
                              child: ResponsiveText(
                                'Apply',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (minimumAmount != null && !isApplied) ...[
                      SizedBox(height: ResponsiveUtils.rp(4)),
                      ResponsiveText(
                        'Min order ₹${minimumAmount.toString()}',
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
          // Total only
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
              label: buttonLabel ?? 'Proceed to Checkout',
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
                text: 'Spend ₹${amountInRupees.toStringAsFixed(2)} more to Apply ',
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

