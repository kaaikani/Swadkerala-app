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
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        backgroundColor: AppColors.surface,
        boxShadow: [],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio Button
            Container(
              width: ResponsiveUtils.rp(20),
              height: ResponsiveUtils.rp(20),
              margin: EdgeInsets.only(top: ResponsiveUtils.rp(2)),
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
                        width: ResponsiveUtils.rp(6),
                        height: ResponsiveUtils.rp(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textLight,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: ResponsiveUtils.rp(12)),
            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
                  ResponsiveText(
                    fullName,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  ResponsiveSpacing.vertical(4),
                  // Address Lines - Combined to fit in max 3 lines
                  _buildCompactAddress(
                    streetLine1: streetLine1,
                    streetLine2: streetLine2,
                    city: city,
                    postalCode: postalCode,
                    phoneNumber: phoneNumber,
                    isDefault: isDefault,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactAddress({
    required String streetLine1,
    required String streetLine2,
    required String city,
    required String postalCode,
    String? phoneNumber,
    required bool isDefault,
  }) {
    // Build address parts list
    List<String> addressParts = [];
    
    // Add street lines
    if (streetLine1.isNotEmpty) {
      addressParts.add(streetLine1);
    }
    if (streetLine2.isNotEmpty) {
      addressParts.add(streetLine2);
    }
    
    // Add city and postal code
    String cityPostal = '$city, $postalCode'.trim();
    if (cityPostal.isNotEmpty && cityPostal != ',') {
      addressParts.add(cityPostal);
    }
    
    // Combine address parts with comma separator
    String combinedAddress = addressParts.join(', ');
    
    // Build phone and default badge row
    List<Widget> bottomRow = [];
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      bottomRow.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResponsiveIcon(
              Icons.phone,
              size: 12,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: ResponsiveUtils.rp(4)),
            ResponsiveText(
              phoneNumber,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      );
    }
    
    if (isDefault) {
      if (bottomRow.isNotEmpty) {
        bottomRow.add(SizedBox(width: ResponsiveUtils.rp(8)));
      }
      bottomRow.add(
        Container(
          padding: ResponsiveSpacing.padding(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.button.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
            border: Border.all(
              color: AppColors.button.withValues(alpha: 0.3),
              width: ResponsiveUtils.rp(1),
            ),
          ),
          child: ResponsiveText(
            'Default Address',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.button,
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Address text with max 3 lines
        Text(
          combinedAddress,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(12),
            color: AppColors.textSecondary,
            height: 1.3,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (bottomRow.isNotEmpty) ...[
          ResponsiveSpacing.vertical(4),
          Wrap(
            spacing: ResponsiveUtils.rp(8),
            crossAxisAlignment: WrapCrossAlignment.center,
            children: bottomRow,
          ),
        ],
      ],
    );
  }
}
