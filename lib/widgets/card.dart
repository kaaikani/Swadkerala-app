import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';

// Re-including the utility card definitions (AppCard and AppSmallCard) from the original request
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? elevation;

  const AppCard({
    Key? key,
    required this.child,
    this.margin,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      elevation: elevation ?? AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      margin: margin ?? EdgeInsets.all(AppSizes.defaultMargin),
      child: child,
    );
  }
}

class AppSmallCard extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final Color? color;

  const AppSmallCard({
    Key? key,
    required this.child,
    this.elevation,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? AppColors.card,
      elevation: elevation ?? (AppSizes.cardElevation * 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius * 0.75),
      ),
      margin: EdgeInsets.zero,
      child: child,
    );
  }
}
