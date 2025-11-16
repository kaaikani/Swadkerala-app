import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Reusable responsive card widget
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final BorderSide? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const ResponsiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: backgroundColor ?? AppColors.surface,
      elevation: elevation ?? ResponsiveUtils.rp(2),
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(12)),
        side: border ?? BorderSide.none,
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius:
              borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: border != null
              ? Border.all(
                  color: border!.color,
                  width: border!.width,
                  style: border!.style,
                )
              : null,
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(12)),
        child: card,
      );
    }

    return card;
  }
}
