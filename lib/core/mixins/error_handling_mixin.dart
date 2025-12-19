import '../../widgets/error_dialog.dart';
import '../../widgets/snackbar.dart';

/// Mixin for handling errors and showing user feedback
mixin ErrorHandlingMixin {
  /// Handle error and show error dialog
  void handleError(dynamic error, {String? customMessage}) {
    final message = customMessage ?? _extractErrorMessage(error);
    ErrorDialog.showError(message);
  }

  /// Show warning dialog
  void showWarning(String message, {String? title}) {
    ErrorDialog.showWarning(
      message: message,
      title: title,
    );
  }

  /// Show success snackbar
  void showSuccess(String message, {String? title}) {
    SnackBarWidget.showSuccess(message, title: title);
  }

  /// Show error snackbar
  void showErrorSnackbar(String message, {String? title}) {
    SnackBarWidget.showError(message, title: title);
  }

  /// Show warning snackbar
  void showWarningSnackbar(String message, {String? title}) {
    SnackBarWidget.showWarning(message, title: title);
  }

  /// Show info snackbar
  void showInfoSnackbar(String message, {String? title}) {
    SnackBarWidget.showInfo(message, title: title);
  }

  /// Extract error message from various error types
  String _extractErrorMessage(dynamic error) {
    if (error == null) {
      return 'An unexpected error occurred';
    }

    if (error is Exception) {
      String message = error.toString();
      // Clean up common exception patterns
      message = message
          .replaceAll('Exception: ', '')
          .replaceAll('Error: ', '')
          .replaceAll('GraphQLException: ', '')
          .trim();

      if (message.isEmpty) {
        return 'An unexpected error occurred';
      }

      return message;
    }

    if (error is String) {
      return error;
    }

    return error.toString();
  }

  /// Handle GraphQL response errors
  bool handleGraphQLResponse(dynamic response, {String? customErrorMessage}) {
    if (response?.hasException == true) {
      final exception = response.exception;
      final message = customErrorMessage ?? _extractErrorMessage(exception);
      handleError(exception, customMessage: message);
      return true;
    }
    return false;
  }
}

