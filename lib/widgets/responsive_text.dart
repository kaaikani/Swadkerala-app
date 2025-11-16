import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Reusable responsive text widget
class ResponsiveText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? height;
  final TextStyle? style;

  const ResponsiveText(
    this.text, {
    Key? key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.letterSpacing,
    this.height,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textAlign: textAlign,
      style: style ??
          TextStyle(
            fontSize: fontSize != null
                ? ResponsiveUtils.sp(fontSize!)
                : ResponsiveUtils.sp(14),
            fontWeight: fontWeight,
            color: color ?? AppColors.textPrimary,
            letterSpacing: letterSpacing,
            height: height,
          ),
    );
  }
}

/// Predefined text styles
class ResponsiveTextStyles {
  static TextStyle heading1({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(28),
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle heading2({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(24),
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle heading3({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(20),
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle heading4({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(18),
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodyLarge({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(16),
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(14),
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodySmall({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(12),
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: ResponsiveUtils.sp(11),
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textTertiary,
      );
}
