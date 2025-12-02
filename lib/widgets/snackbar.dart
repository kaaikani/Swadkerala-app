import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';

class SnackBarWidget {
  static void show(
    BuildContext? context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    // If context is null or widget is disposed, use GetX snackbar instead
    if (context == null || !context.mounted) {
      _showWithGetX(message, backgroundColor: backgroundColor, duration: duration);
      return;
    }

    try {
      final bgColor = backgroundColor ?? AppColors.background;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: AppColors.buttonText),
          ),
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      // If ScaffoldMessenger fails, fallback to GetX
      _showWithGetX(message, backgroundColor: backgroundColor, duration: duration);
    }
  }

  static void _showWithGetX(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final bgColor = backgroundColor ?? AppColors.background;
    Get.snackbar(
      '',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: AppColors.buttonText,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
    );
  }
}

/// Helper function to show success snackbar using GetX
void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    icon: const Icon(Icons.check_circle, color: Colors.white),
  );
}

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    icon: const Icon(Icons.error, color: Colors.white),
  );
}
