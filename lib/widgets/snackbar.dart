import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Centralized snackbar utility class
/// Use this class instead of calling Get.snackbar directly
class SnackBarWidget {
  /// Show a basic snackbar
  static void show(
    BuildContext? context,
    String message, {
    Color? backgroundColor,

    Duration duration = const Duration(seconds: 2),
  }) {
    _showWithGetX(

      message: message,
      backgroundColor: backgroundColor ?? AppColors.background,
      duration: duration,
    );
  }

  /// Show success snackbar
  static void showSuccess(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.TOP,
  }) {
    _showWithGetX(
      title: title ?? 'Success',
      message: message,
      backgroundColor: AppColors.success,
      textColor: AppColors.buttonText,
      duration: duration,
      position: position,
      icon: Icons.check_circle,
    );
  }

  /// Show error snackbar
  static void showError(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _showWithGetX(
      title: title ?? 'Error',
      message: message,
      backgroundColor: AppColors.error,
      textColor: AppColors.buttonText,
      duration: duration,
      position: position,
      icon: Icons.error,
    );
  }

  /// Show warning snackbar
  static void showWarning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _showWithGetX(
      title: title ?? 'Warning',
      message: message,
      backgroundColor: AppColors.warning,
      textColor: AppColors.buttonText,
      duration: duration,
      position: position,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// Show info snackbar
  static void showInfo(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _showWithGetX(
      title: title ?? 'Info',
      message: message,
      backgroundColor: AppColors.info,
      textColor: AppColors.buttonText,
      duration: duration,
      position: position,
      icon: Icons.info,
    );
  }

  /// Internal method to show snackbar using GetX
  static void _showWithGetX({
    String? title,
    required String message,
    required Color backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.TOP,
    IconData? icon,
  }) {
    Get.snackbar(
      title ?? '',
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor ?? AppColors.buttonText,
      duration: duration,
      margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
      borderRadius: ResponsiveUtils.rp(12),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      icon: icon != null
          ? Icon(
              icon,
              color: textColor ?? AppColors.buttonText,
              size: ResponsiveUtils.rp(24),
            )
          : null,
    );
  }
}

/// Helper function to show success snackbar (for backward compatibility)
void showSuccessSnackbar(String message) {
  SnackBarWidget.showSuccess(message);
}

/// Helper function to show error snackbar (for backward compatibility)
void showErrorSnackbar(String message) {
  SnackBarWidget.showError(message);
}
