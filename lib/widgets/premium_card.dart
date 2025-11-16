import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Premium card with animations and modern design
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BorderSide? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final bool enableAnimation;

  const PremiumCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.backgroundColor,
    this.gradient,
    this.border,
    this.boxShadow,
    this.onTap,
    this.enableAnimation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin ?? EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius:
            borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(16)),
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
                blurRadius: ResponsiveUtils.rp(12),
                offset: Offset(0, ResponsiveUtils.rp(4)),
                spreadRadius: 0,
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius:
            borderRadius ?? BorderRadius.circular(ResponsiveUtils.rp(16)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: padding ?? EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (enableAnimation && onTap != null) {
      return Hero(
        tag: 'card_${hashCode}',
        child: card,
      );
    }

    return card;
  }
}
