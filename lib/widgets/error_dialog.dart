import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';

/// Centralized error dialog utility for controllers
/// No need to pass BuildContext - uses Get.context
class ErrorDialog {
  /// Show error dialog with custom message
  static void show({
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onClose,
  }) {
    // Use Get.context or Get.dialog
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'Error',
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
            fontSize: 15,
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
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
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
}
