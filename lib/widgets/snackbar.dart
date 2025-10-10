import 'package:flutter/material.dart';

import '../theme/colors.dart';

class SnackBarWidget {
  static void show(
      BuildContext context,
      String message, {
        Color backgroundColor = AppColors.background, // default from AppColors
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: AppColors.buttonText), // use AppColors
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
