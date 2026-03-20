import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/coupon_validation_helper.dart';
import '../utils/responsive.dart';

/// Centralized error dialog utility for controllers
/// No need to pass BuildContext - uses Get.context
class ErrorDialog {
  /// Show error dialog with custom message
  static void show({
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onClose,
    String? secondButtonText,
    VoidCallback? onSecondButtonPressed,
  }) {
    // Use Get.context or Get.dialog
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.button,
              size: ResponsiveUtils.rp(28),
            ),
            SizedBox(width: ResponsiveUtils.rp(12)),
            Expanded(
              child: Text(
                title ?? 'Warning',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          // Second button (if provided)
          if (secondButtonText != null && onSecondButtonPressed != null)
            TextButton(
              onPressed: () {
                // Close dialog first, then execute callback in next frame
                Get.back();
                // Use Future.microtask to ensure dialog is closed before navigation
                Future.microtask(() {
                  onSecondButtonPressed();
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              child: Text(secondButtonText),
            ),
          // Primary button
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (onClose != null) {
                onClose();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: AppColors.buttonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Show error from GraphQL exception
  static void showGraphQLError(dynamic exception) {
    String errorMessage = 'An error occurred';

    if (exception != null) {
      // Try to extract GraphQL error message
      if (exception.toString().contains('graphqlErrors')) {
        try {
          // Extract from GraphQL errors if available
          final errorString = exception.toString();
          final match =
              RegExp(r'message[:\s]+([^,}\n]+)').firstMatch(errorString);
          if (match != null) {
            errorMessage = match.group(1)?.trim() ?? errorMessage;
          } else {
            errorMessage = errorString;
          }
        } catch (e) {
          errorMessage = exception.toString();
        }
      } else {
        errorMessage = exception.toString();
      }

      // Clean up the error message
      errorMessage = errorMessage
          .replaceAll('Exception:', '')
          .replaceAll('GraphQLException:', '')
          .trim();

      if (errorMessage.isEmpty) {
        errorMessage = 'An error occurred';
      }

      // Limit message length
      if (errorMessage.length > 200) {
        errorMessage = '${errorMessage.substring(0, 200)}...';
      }
    }

    show(message: errorMessage);
  }

  /// Show error from string
  static void showError(String message) {
    show(message: message);
  }

  /// Show error from exception
  static void showException(dynamic exception) {
    String errorMessage = 'An unexpected error occurred';

    if (exception != null) {
      errorMessage = exception.toString();

      // Clean up common exception patterns
      errorMessage = errorMessage
          .replaceAll('Exception:', '')
          .replaceAll('Error:', '')
          .trim();

      if (errorMessage.isEmpty) {
        errorMessage = 'An unexpected error occurred';
      }

      // Limit message length
      if (errorMessage.length > 200) {
        errorMessage = '${errorMessage.substring(0, 200)}...';
      }
    }

    show(message: errorMessage);
  }

  /// Show warning dialog with custom message (for coupon errors, etc.)
  static void showWarning({
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onClose,
  }) {
    // Use Get.context or Get.dialog
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.button,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'Warning',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (onClose != null) {
                onClose();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: AppColors.buttonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Show warning from string
  static void showWarningMessage(String message) {
    showWarning(message: message);
  }

  /// Show dialog listing all coupon conditions with met/unmet/unknown status.
  /// Called when coupon was accepted by server but produced no discount.
  static void showConditionsNotMet({
    required String couponCode,
    required List<CouponConditionInfo> conditions,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.orange,
              size: ResponsiveUtils.rp(26),
            ),
            SizedBox(width: ResponsiveUtils.rp(10)),
            Expanded(
              child: Text(
                'Coupon Not Applied',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(17),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conditions not satisfied for "$couponCode":',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(13),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            ...conditions.map((c) => _buildConditionRow(c)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: AppColors.buttonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  static Widget _buildConditionRow(CouponConditionInfo c) {
    final IconData icon;
    final Color color;
    if (!c.canValidate) {
      icon = Icons.help_outline_rounded;
      color = Colors.orange;
    } else if (c.isMet) {
      icon = Icons.check_circle_outline_rounded;
      color = Colors.green;
    } else {
      icon = Icons.cancel_outlined;
      color = Colors.red;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: ResponsiveUtils.rp(18), color: color),
          SizedBox(width: ResponsiveUtils.rp(8)),
          Expanded(
            child: Text(
              c.displayText,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
