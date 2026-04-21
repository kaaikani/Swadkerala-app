import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../services/graphql_client.dart';
import 'dart:io';

/// Logger utility for structured debug output
/// Only logs in the allowed format: function name, query/mutation name, masked tokens, device medium, errors
class Logger {
  /// Get device medium
  static String get _deviceMedium {
    if (Platform.isAndroid) return 'mobile';
    if (Platform.isIOS) return 'mobile';
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) return 'web';
    return 'api';
  }

  /// Mask token - show only last 4 characters
  static String _maskToken(String? token) {
    if (token == null || token.isEmpty) return 'not_set';
    if (token.length <= 4) return token;
    return '****${token.substring(token.length - 4)}';
  }

  /// Get channel token from storage
  static String? _getChannelToken() {
    try {
      final storage = GetStorage();
      return storage.read('channel_token');
    } catch (e) {
      return null;
    }
  }

  /// Log function execution with query/mutation name
  static void logFunction({
    required String functionName,
    String? queryName,
    String? mutationName,
  }) {
    if (kDebugMode) {
      final authToken = _maskToken(GraphqlService.authToken);
      final channelToken = _maskToken(_getChannelToken());
      
      final parts = <String>[
        'Function: $functionName',
        if (queryName != null) 'Query: $queryName',
        if (mutationName != null) 'Mutation: $mutationName',
        'AuthToken: $authToken',
        'ChannelToken: $channelToken',
        'DeviceMedium: $_deviceMedium',
      ];
      
      // debugPrint('[${parts.join(' | ')}]');
    }
  }

  /// Log error with function name, error type, and error message
  static void logError({
    required String functionName,
    required dynamic error,
    String? errorType,
  }) {
    if (kDebugMode) {
      final type = errorType ?? error.runtimeType.toString();
      final message = error.toString()
          .replaceAll('Exception:', '')
          .replaceAll('Error:', '')
          .trim();
      
      // debugPrint('[Function: $functionName | ErrorType: $type | ErrorMessage: $message]');
    }
  }
}

