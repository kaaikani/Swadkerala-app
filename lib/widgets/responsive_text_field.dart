import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Reusable responsive text field widget
class ResponsiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final EdgeInsets? contentPadding;

  const ResponsiveTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.fillColor,
    this.borderRadius,
    this.textStyle,
    this.labelStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      readOnly: readOnly,
      style: textStyle ??
          TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textPrimary,
          ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? AppColors.inputFill,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(16),
            ),
        labelStyle: labelStyle ??
            TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
            ),
        hintStyle: TextStyle(
          fontSize: ResponsiveUtils.sp(14),
          color: AppColors.textTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(8)),
          borderSide:
              BorderSide(color: AppColors.border, width: ResponsiveUtils.rp(1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(8)),
          borderSide:
              BorderSide(color: AppColors.border, width: ResponsiveUtils.rp(1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(8)),
          borderSide:
              BorderSide(color: AppColors.button, width: ResponsiveUtils.rp(2)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(8)),
          borderSide:
              BorderSide(color: AppColors.error, width: ResponsiveUtils.rp(1)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(8)),
          borderSide:
              BorderSide(color: AppColors.error, width: ResponsiveUtils.rp(2)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(8)),
          borderSide: BorderSide(
              color: AppColors.borderLight, width: ResponsiveUtils.rp(1)),
        ),
      ),
    );
  }
}
