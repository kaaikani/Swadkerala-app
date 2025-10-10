import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';

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
      color: AppColors.card,
      elevation: elevation ?? AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      margin: margin ?? EdgeInsets.all(AppSizes.defaultMargin),
      child: child,
    );
  }
}
