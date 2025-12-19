import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../utils/responsive.dart';

/// Secondary button widget with outlined style
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? borderRadius;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? AppColors.button,
        side: BorderSide(
          color: borderColor ?? AppColors.button,
          width: 1.5,
        ),
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
      ),
      child: isLoading
          ? SizedBox(
              width: ResponsiveUtils.rp(20),
              height: ResponsiveUtils.rp(20),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  textColor ?? AppColors.button,
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



