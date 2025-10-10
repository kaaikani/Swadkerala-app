import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/sizes.dart';

class AppButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.buttonText,
    this.borderRadius,
    this.padding,
    this.elevation = AppSizes.cardElevation,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isWaiting = false;

  Future<void> _handlePress() async {
    if (_isWaiting || widget.onPressed == null) return;

    setState(() {
      _isWaiting = true;
    });

    try {
      await widget.onPressed!();
    } catch (e) {
      debugPrint('[AppButton] Error in onPressed: $e');
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
    return ElevatedButton(
      onPressed: _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.textColor,
        padding: widget.padding ??
            EdgeInsets.symmetric(
              vertical: AppSizes.buttonVerticalPadding,
              horizontal: AppSizes.buttonHorizontalPadding,
            ),
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSizes.cardRadius),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
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

  const AppTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = AppColors.primary,
    this.borderRadius,
    this.padding,
    required Color backgroundColor,
  }) : super(key: key);

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
      debugPrint('[AppTextButton] Error in onPressed: $e');
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
          borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSizes.cardRadius),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
