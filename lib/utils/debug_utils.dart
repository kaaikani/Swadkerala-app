import 'package:flutter/foundation.dart';

class DebugUtils {
  /// Print debug information only in debug mode
  static void debugPrint(String message) {
    if (kDebugMode) {
      print('[DEBUG] $message');
    }
  }

  /// Print error information (always prints in debug, conditional in release)
  static void errorPrint(String message) {
    if (kDebugMode) {
      print('[ERROR] $message');
    }
  }

  /// Print info information (only in debug mode)
  static void infoPrint(String message) {
    if (kDebugMode) {
      print('[INFO] $message');
    }
  }

  /// Print warning information (only in debug mode)
  static void warningPrint(String message) {
    if (kDebugMode) {
      print('[WARNING] $message');
    }
  }

  /// Conditional print based on build mode
  static void conditionalPrint(String message, {bool forcePrint = false}) {
    if (kDebugMode || forcePrint) {
      print(message);
    }
  }

  /// Print with timestamp (debug only)
  static void debugPrintWithTime(String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('[DEBUG $timestamp] $message');
    }
  }
}
