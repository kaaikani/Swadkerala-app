import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'premium_card.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';
import 'responsive_icon.dart';

/// Premium address card like Amazon/Flipkart
class AddressCardPremium extends StatelessWidget {
  final String fullName;
  final String streetLine1;
  final String streetLine2;
  final String city;
  final String postalCode;
  final String? phoneNumber;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback? onTap;

  const AddressCardPremium({
    Key? key,
    required this.fullName,
    required this.streetLine1,
    this.streetLine2 = '',
    required this.city,
    required this.postalCode,
    this.phoneNumber,
    this.isSelected = false,
    this.isDefault = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PremiumCard(
        padding: ResponsiveSpacing.padding(all: 16),
        margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        backgroundColor: AppColors.surface,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.button.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.rp(8),
                  offset: Offset(0, ResponsiveUtils.rp(2)),
                  spreadRadius: ResponsiveUtils.rp(1),
                ),
              ]
            : [],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio Button
            Container(
              width: ResponsiveUtils.rp(24),
              height: ResponsiveUtils.rp(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.button : AppColors.border,
                  width: ResponsiveUtils.rp(2),
                ),
                color: isSelected ? AppColors.button : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: ResponsiveUtils.rp(8),
                        height: ResponsiveUtils.rp(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textLight,
                        ),
                      ),
                    )
                  : null,
            ),
            ResponsiveSpacing.horizontal(16),
            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  ResponsiveText(
                    fullName,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ResponsiveSpacing.vertical(8),
                  // Address Lines
                  ResponsiveText(
                    streetLine1,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  if (streetLine2.isNotEmpty) ...[
                    ResponsiveSpacing.vertical(4),
                    ResponsiveText(
                      streetLine2,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                  ResponsiveSpacing.vertical(4),
                  ResponsiveText(
                    '$city, $postalCode',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                    ResponsiveSpacing.vertical(8),
                    Row(
                      children: [
                        ResponsiveIcon(
                          Icons.phone,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        ResponsiveSpacing.horizontal(6),
                        ResponsiveText(
                          phoneNumber!,
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                  if (isDefault) ...[
                    ResponsiveSpacing.vertical(8),
                    Container(
                      padding:
                          ResponsiveSpacing.padding(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.rp(6)),
                        border: Border.all(
                          color: AppColors.button.withValues(alpha: 0.3),
                          width: ResponsiveUtils.rp(1),
                        ),
                      ),
                      child: ResponsiveText(
                        'Default Address',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.button,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
