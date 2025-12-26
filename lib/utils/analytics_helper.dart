import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

/// Helper class for adding analytics to button callbacks
class AnalyticsHelper {
  /// Wraps a callback with button click analytics
  /// Usage: onPressed: AnalyticsHelper.trackButton('Button Name', () { ... })
  static VoidCallback? trackButton(
    String buttonName, {
    VoidCallback? callback,
    String? screenName,
    Map<String, Object>? additionalParameters,
  }) {
    if (callback == null) return null;
    
    return () {
      AnalyticsService().logButtonClick(
        buttonName: buttonName,
        screenName: screenName,
        additionalParameters: additionalParameters,
      );
      callback();
    };
  }

  /// Wraps an async callback with button click analytics
  static Future<void> Function()? trackButtonAsync(
    String buttonName, {
    Future<void> Function()? callback,
    String? screenName,
    Map<String, Object>? additionalParameters,
  }) {
    if (callback == null) return null;
    
    return () async {
      AnalyticsService().logButtonClick(
        buttonName: buttonName,
        screenName: screenName,
        additionalParameters: additionalParameters,
      );
      await callback();
    };
  }
}
