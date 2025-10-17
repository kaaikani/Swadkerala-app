import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

/// Helper function to show success snackbar using GetX
void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.BOTTOM,
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
