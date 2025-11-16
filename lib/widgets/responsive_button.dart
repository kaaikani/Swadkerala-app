import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'responsive_spacing.dart';

/// Reusable responsive elevated button
class ResponsiveElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? icon;
  final EdgeInsets? padding;
  final double? borderRadius;
  final bool isFullWidth;
  final bool isLoading;

  const ResponsiveElevatedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.padding,
    this.borderRadius,
    this.isFullWidth = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.button,
        foregroundColor: foregroundColor ?? AppColors.textLight,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(24),
              vertical: ResponsiveUtils.rp(14),
            ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? ResponsiveUtils.rp(8)),
        ),
        elevation: ResponsiveUtils.rp(2),
      ),
      child: isLoading
          ? SizedBox(
              height: ResponsiveUtils.rp(20),
              width: ResponsiveUtils.rp(20),
              child: CircularProgressIndicator(
                strokeWidth: ResponsiveUtils.rp(2),
                valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? AppColors.textLight),
              ),
            )
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon!,
                    ResponsiveSpacing.horizontal(8),
                    Text(
                      label,
                      style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
                ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// Reusable responsive outlined button
class ResponsiveOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;
  final EdgeInsets? padding;
  final double? borderRadius;
  final bool isFullWidth;

  const ResponsiveOutlinedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.icon,
    this.padding,
    this.borderRadius,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: borderColor ?? AppColors.button,
          width: ResponsiveUtils.rp(2),
        ),
        foregroundColor: textColor ?? AppColors.button,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(24),
              vertical: ResponsiveUtils.rp(14),
            ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? ResponsiveUtils.rp(8)),
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                ResponsiveSpacing.horizontal(8),
                Text(
                  label,
                  style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
                ),
              ],
            )
          : Text(
              label,
              style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
            ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// Reusable responsive text button
class ResponsiveTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Widget? icon;

  const ResponsiveTextButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.button,
        padding: ResponsiveSpacing.padding(horizontal: 12, vertical: 8),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                ResponsiveSpacing.horizontal(8),
                Text(
                  label,
                  style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
                ),
              ],
            )
          : Text(
              label,
              style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
            ),
    );
  }
}
