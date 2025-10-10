import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/sizes.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Color backgroundColor;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.elevation = AppSizes.cardElevation,
    this.backgroundColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.buttonText,
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle location button press
            },
            icon: const Icon(Icons.location_on_outlined),
          )

        ],
      ),
      elevation: elevation,
      backgroundColor: backgroundColor,
      actions: actions,
      iconTheme: IconThemeData(
        color: AppColors.icon,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
