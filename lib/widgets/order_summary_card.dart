import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Order Summary',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          ResponsiveSpacing.vertical(16),
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                'Subtotal',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              ResponsiveText(
                subtotal,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          ResponsiveSpacing.vertical(12),
          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                'Shipping',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ResponsiveText(
                    shipping,
                    fontSize: 14,
                    color: shipping.toLowerCase().contains('free')
                        ? AppColors.success
                        : AppColors.textPrimary,
                    fontWeight: shipping.toLowerCase().contains('free')
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  if (shippingNote != null) ...[
                    ResponsiveSpacing.vertical(2),
                    ResponsiveText(
                      shippingNote!,
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ],
              ),
            ],
          ),
          Divider(
            color: AppColors.divider,
            height: ResponsiveUtils.rp(24),
            thickness: ResponsiveUtils.rp(1),
          ),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                'Total',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              ResponsiveText(
                total,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.button,
              ),
            ],
          ),
          if (onProceedToCheckout != null) ...[
            ResponsiveSpacing.vertical(16),
            if (warningMessage != null) ...[
              Container(
                width: double.infinity,
                padding: ResponsiveSpacing.padding(all: 10),
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
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
