import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

/// Service for Firebase Crashlytics integration
/// Provides centralized error tracking and crash reporting
class CrashlyticsService {
  CrashlyticsService._();
  static final CrashlyticsService instance = CrashlyticsService._();

  bool _initialized = false;

  /// Initialize Crashlytics service
  Future<void> initialize() async {
    if (_initialized) return;

    if (kIsWeb) {
// debugPrint('[Crashlytics] Skipping initialization on Web');
      return;
    }

    try {
      // Pass all uncaught errors to Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      _initialized = true;
// debugPrint('[Crashlytics] Initialized successfully');
    } catch (e) {
// debugPrint('[Crashlytics] Initialization error: $e');
    }
  }

  /// Record a non-fatal error
  void recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? additionalData,
  }) {
    if (kIsWeb || !_initialized) return;

    try {
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
        });
      }

      if (reason != null) {
        FirebaseCrashlytics.instance.log(reason);
      }

      FirebaseCrashlytics.instance.recordError(
        exception,
        stackTrace,
        fatal: fatal,
        reason: reason,
      );
    } catch (e) {
// debugPrint('[Crashlytics] Error recording: $e');
    }
  }

  /// Log a message
  void log(String message) {
    if (kIsWeb || !_initialized) return;

    try {
      FirebaseCrashlytics.instance.log(message);
    } catch (e) {
// debugPrint('[Crashlytics] Error logging: $e');
    }
  }

  /// Set user identifier
  void setUserId(String userId) {
    if (kIsWeb || !_initialized) return;

    try {
      FirebaseCrashlytics.instance.setUserIdentifier(userId);
    } catch (e) {
// debugPrint('[Crashlytics] Error setting user ID: $e');
    }
  }

  /// Set custom key-value pair
  void setCustomKey(String key, dynamic value) {
    if (kIsWeb || !_initialized) return;

    try {
      if (value is String) {
        FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is int) {
        FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is double) {
        FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is bool) {
        FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else {
        FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
      }
    } catch (e) {
// debugPrint('[Crashlytics] Error setting custom key: $e');
    }
  }

  /// Set multiple custom keys
  void setCustomKeys(Map<String, dynamic> keys) {
    if (kIsWeb || !_initialized) return;

    try {
      keys.forEach((key, value) {
        setCustomKey(key, value);
      });
    } catch (e) {
// debugPrint('[Crashlytics] Error setting custom keys: $e');
    }
  }

  /// Force a crash for testing (only in debug mode)
  void testCrash() {
    if (kIsWeb || !_initialized) return;
    if (kDebugMode) {
      FirebaseCrashlytics.instance.crash();
    }
  }

  /// Record a caught exception with context
  void recordException(
    dynamic exception, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? context,
  }) {
    recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: false,
      additionalData: context,
    );
  }
}











