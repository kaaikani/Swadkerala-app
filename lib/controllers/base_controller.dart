import 'dart:async';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../widgets/error_dialog.dart';
import '../../utils/logger.dart';

/// Base controller with centralized error handling
/// All controllers should extend this to get automatic error dialog handling
abstract class BaseController extends GetxController {
  /// Handle GraphQL response errors and show error dialog
  bool handleGraphQLError(QueryResult response, {String? customErrorMessage}) {
    if (response.hasException) {
      
      // Early check: Suppress ResponseFormatException (JSON parsing errors) - don't show dialog
      final exceptionStr = response.exception.toString();
      if (exceptionStr.contains('ResponseFormatException') ||
          exceptionStr.contains('FormatException') ||
          exceptionStr.contains('Unexpected character') ||
          exceptionStr.contains('CacheMissException') ||
          exceptionStr.contains('cache.readQuery')) {
        return true;
      }
      
      // Check linkException for cache errors
      if (response.exception?.linkException != null) {
        final linkExceptionStr = response.exception!.linkException.toString();
        if (linkExceptionStr.contains('CacheMissException') ||
            linkExceptionStr.contains('cache.readQuery')) {
          return true;
        }
      }
      
      String errorMessage = customErrorMessage ?? 'An error occurred';
      
      // Try to extract meaningful error message from GraphQL errors
      if (response.exception?.graphqlErrors.isNotEmpty == true) {
        final graphQLError = response.exception!.graphqlErrors.first;
        errorMessage = graphQLError.message;
        
        // Handle special error cases
        if (errorMessage.toLowerCase().contains('user not found') ||
            errorMessage.toLowerCase().contains('unauthorized') ||
            errorMessage.toLowerCase().contains('authentication')) {
          // Don't show dialog for auth errors, let specific controllers handle it
          return false;
        }
      } else if (response.exception?.linkException != null) {
        final linkException = response.exception!.linkException;

        // Suppress ResponseFormatException (JSON parsing errors) - these are typically network/parsing issues
        if (linkException.toString().contains('ResponseFormatException') ||
            linkException.toString().contains('FormatException')) {
          return true;
        }

        if (linkException is NetworkException || linkException is ServerException) {
          // Connection or server issues shouldn't display a dialog
          
          // Check for specific connection errors
          final exceptionStr = linkException.toString();
          if (exceptionStr.contains('Connection closed before full header was received') ||
              exceptionStr.contains('Connection closed') ||
              exceptionStr.contains('SocketException')) {
          }
          
          return true;
        }

        if (linkException is NetworkException) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else {
          errorMessage = linkException.toString();
        }
      } else {
        errorMessage = response.exception.toString();
      }

      // Clean up error message
      errorMessage = errorMessage
          .replaceAll('Exception:', '')
          .replaceAll('GraphQLException:', '')
          .trim();

      if (errorMessage.isEmpty) {
        errorMessage = customErrorMessage ?? 'An error occurred';
      }

      // Avoid showing dialog for timeout-specific link exceptions
      final linkException = response.exception?.linkException;
      final isTimeout = linkException is UnknownException &&
          linkException.originalException is TimeoutException;

      if (isTimeout) {
        return true;
      }

      // Additional check: Suppress ResponseFormatException (JSON parsing errors)
      if (linkException != null) {
        final linkExceptionStr = linkException.toString();
        if (linkExceptionStr.contains('ResponseFormatException') ||
            linkExceptionStr.contains('FormatException') ||
            linkExceptionStr.contains('Unexpected character')) {
          return true;
        }
      }

      // Show warning dialog for query errors
      ErrorDialog.showWarning(message: errorMessage);
      return true;
    }
    return false;
  }

  /// Handle generic exceptions and show error dialog
  void handleException(dynamic exception, {String? customErrorMessage, String? functionName}) {
    // Log error in allowed format
    final funcName = functionName ?? runtimeType.toString();
    Logger.logError(functionName: funcName, error: exception);
    
    String errorMessage = customErrorMessage ?? 'An unexpected error occurred';
    
    if (exception != null) {
      errorMessage = exception.toString();
      
      // Clean up common exception patterns
      errorMessage = errorMessage
          .replaceAll('Exception:', '')
          .replaceAll('Error:', '')
          .trim();

      if (errorMessage.isEmpty) {
        errorMessage = customErrorMessage ?? 'An unexpected error occurred';
      }
    }

    final isTimeout = exception is TimeoutException;
    if (isTimeout) {
      return;
    }

    // Show error dialog
    ErrorDialog.showException(errorMessage);
  }

  /// Handle GraphQL response with automatic error handling
  /// Returns true if error occurred and was handled
  bool checkResponseForErrors(QueryResult response, {String? customErrorMessage}) {
    return handleGraphQLError(response, customErrorMessage: customErrorMessage);
  }
}

