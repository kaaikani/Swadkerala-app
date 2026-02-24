import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Stock level values from Vendure (IN_STOCK, LOW_STOCK, OUT_OF_STOCK).
typedef StockLevel = String;

/// Reusable badge showing stock status - matches React StockLevelLabel concept.
/// - IN_STOCK: Green badge
/// - LOW_STOCK: Yellow badge
/// - OUT_OF_STOCK: Red badge
class StockLevelLabel extends StatelessWidget {
  const StockLevelLabel({
    super.key,
    this.stockLevel,
    this.compact = false,
  });

  /// Raw stock level string from GraphQL (e.g. 'IN_STOCK', 'LOW_STOCK', 'OUT_OF_STOCK').
  final String? stockLevel;

  /// If true, use smaller padding and font size.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final level = (stockLevel ?? '').toUpperCase().trim();
    String label;
    Color bgColor;
    Color textColor;

    switch (level) {
      case 'IN_STOCK':
        label = 'In Stock';
        bgColor = AppColors.success.withValues(alpha: 0.12);
        textColor = AppColors.success;
        break;
      case 'OUT_OF_STOCK':
        label = 'Out of Stock';
        bgColor = AppColors.error.withValues(alpha: 0.12);
        textColor = AppColors.error;
        break;
      case 'LOW_STOCK':
        label = 'Low Stock';
        bgColor = AppColors.warning.withValues(alpha: 0.12);
        textColor = AppColors.warning;
        break;
      default:
        label = 'In Stock';
        bgColor = AppColors.grey200;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? ResponsiveUtils.rp(6) : ResponsiveUtils.rp(8),
        vertical: compact ? ResponsiveUtils.rp(2) : ResponsiveUtils.rp(4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
          color: textColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: compact ? ResponsiveUtils.sp(10) : ResponsiveUtils.sp(11),
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
