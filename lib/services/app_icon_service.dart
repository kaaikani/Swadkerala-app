import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

/// Service for managing app icons and badge numbers
class AppIconService {
  static final AppIconService _instance = AppIconService._internal();
  factory AppIconService() => _instance;
  AppIconService._internal();

  static AppIconService get instance => _instance;

  /// Check if dynamic icon is supported on the current platform
  Future<bool> isDynamicIconSupported() async {
    try {
      return await FlutterDynamicIcon.supportsAlternateIcons;
    } catch (e) {
      return false;
    }
  }

  /// Change the app icon
  Future<bool> changeAppIcon(String iconName) async {
    try {
      if (!await isDynamicIconSupported()) {
        return false;
      }
      await FlutterDynamicIcon.setAlternateIconName(iconName);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reset app icon to default
  Future<bool> resetAppIcon() async {
    try {
      if (!await isDynamicIconSupported()) {
        return false;
      }
      await FlutterDynamicIcon.setAlternateIconName(null);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the current alternate icon name
  Future<String?> getAlternateIconName() async {
    try {
      if (!await isDynamicIconSupported()) {
        return null;
      }
      return await FlutterDynamicIcon.getAlternateIconName();
    } catch (e) {
      return null;
    }
  }

  /// Update the app badge count
  Future<bool> updateBadgeCount(int count) async {
    try {
      if (count > 0) {
        await FlutterAppBadger.updateBadgeCount(count);
      } else {
        await FlutterAppBadger.removeBadge();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove the app badge
  Future<bool> removeBadge() async {
    try {
      await FlutterAppBadger.removeBadge();
      return true;
    } catch (e) {
      return false;
    }
  }
}

