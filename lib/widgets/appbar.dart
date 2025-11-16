import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/sizes.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  final bool centerTitle;
  final double elevation;
  final Color backgroundColor;

  AppBarWidget({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
    this.centerTitle = true,
    this.elevation = AppSizes.cardElevation,
    Color? backgroundColor,
  })  : backgroundColor = backgroundColor ?? AppColors.primary,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      elevation: elevation,
      backgroundColor: backgroundColor,
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: AppColors.icon,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
