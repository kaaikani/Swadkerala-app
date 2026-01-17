import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'shimmers.dart';
import '../theme/sizes.dart';

class AppButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final IconData? icon; // ✅ optional icon
  final Color backgroundColor;
  final Color textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    Color? backgroundColor,
    this.textColor = Colors.white,
    this.borderRadius,
    this.padding,
    this.elevation = 2,
  })  : backgroundColor = backgroundColor ?? AppColors.primary,
        super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;
    setState(() => _isLoading = true);
    await widget.onPressed!();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.textColor,
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(10), horizontal: ResponsiveUtils.rp(12)),
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(widget.borderRadius ?? 8)),
        ),
      ),
      child: _isLoading
          ? Skeletons.smallBox(size: 18)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, size: ResponsiveUtils.rp(16), color: widget.textColor),
                if (widget.icon != null) SizedBox(width: ResponsiveUtils.rp(6)),
                Text(
                  widget.text,
                  style: TextStyle(color: widget.textColor, fontSize: ResponsiveUtils.sp(14)),
                ),
              ],
            ),
    );
  }
}

class AppTextButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final Color textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  AppTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    Color? textColor,
    this.borderRadius,
    this.padding,
    required Color backgroundColor,
  })  : textColor = textColor ?? AppColors.primary,
        super(key: key);

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool _isWaiting = false;

  Future<void> _handlePress() async {
    if (_isWaiting || widget.onPressed == null) return;

    setState(() {
      _isWaiting = true;
    });

    try {
      await widget.onPressed!();
    } catch (e) {
    }

    // Wait 3 seconds before allowing next press
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isWaiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _handlePress,
      style: TextButton.styleFrom(
        foregroundColor: widget.textColor,
        padding: widget.padding ??
            EdgeInsets.symmetric(
              vertical: AppSizes.buttonVerticalPadding,
              horizontal: AppSizes.buttonHorizontalPadding,
            ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveUtils.rp(widget.borderRadius ?? AppSizes.cardRadius)),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CustomCheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;

  const CustomCheckboxTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      contentPadding: EdgeInsets.zero,
    );
  }
}
