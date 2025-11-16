import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Reusable responsive container widget
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
    this.alignment,
    this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        gradient: gradient,
        borderRadius:
            borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: border != null
            ? Border.all(
                color: border!.color,
                width: border!.width,
                style: border!.style,
              )
            : null,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: ResponsiveUtils.rp(8),
                offset: Offset(0, ResponsiveUtils.rp(2)),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(12)),
        child: container,
      );
    }

    return container;
  }
}
