import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../utils/responsive.dart';
import '../../../services/analytics_service.dart';

/// Primary button widget with consistent styling
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? borderRadius;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  void _handleButtonClick() {
    // Track button click with analytics
    AnalyticsService().logButtonClick(
      buttonName: text,
      screenName: null, // Will be set by the screen if needed
    );
    // Execute the original callback
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : (onPressed != null ? _handleButtonClick : null),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.button,
        foregroundColor: textColor ?? AppColors.buttonText,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(24),
              vertical: ResponsiveUtils.rp(16),
            ),
        minimumSize: height != null
            ? Size(width ?? double.infinity, height!)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? ResponsiveUtils.rp(12),
          ),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? SizedBox(
              width: ResponsiveUtils.rp(20),
              height: ResponsiveUtils.rp(20),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  textColor ?? AppColors.buttonText,
                ),
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: ResponsiveUtils.rp(20)),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                ],
                Text(
                  text,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    if (width != null || isFullWidth) {
      return SizedBox(
        width: width ?? (isFullWidth ? double.infinity : null),
        child: button,
      );
    }

    return button;
  }
}
