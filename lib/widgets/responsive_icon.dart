import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Reusable responsive icon widget
class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final VoidCallback? onTap;

  const ResponsiveIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: size != null ? ResponsiveUtils.rp(size!) : ResponsiveUtils.rp(24),
      color: color ?? AppColors.icon,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          child: iconWidget,
        ),
      );
    }

    return iconWidget;
  }
}
