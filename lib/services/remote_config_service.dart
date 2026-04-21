import 'dart:io' show Platform;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'crashlytics_service.dart';

class RemoteConfigService extends GetxController {
  static RemoteConfigService get instance => Get.find<RemoteConfigService>();

  FirebaseRemoteConfig? _remoteConfig;

  /// Platform suffix for Remote Config keys (_android or _ios)
  String get _platformSuffix => Platform.isIOS ? '_ios' : '_android';

  /// Initialize Firebase Remote Config
  Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Debug: fetch every time. Release: cache 1 hour.
      await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
      ));

      // Set defaults with platform-specific keys
      await _remoteConfig!.setDefaults({
        'min_version$_platformSuffix': '0.0.0',
        'latest_version$_platformSuffix': '0.0.0',
      });

      // Fetch and activate
      final updated = await _remoteConfig!.fetchAndActivate();
      if (kDebugMode) {
        final minV = _remoteConfig!.getString('min_version$_platformSuffix').trim();
        final latestV = _remoteConfig!.getString('latest_version$_platformSuffix').trim();
        // debugPrint('[RemoteConfig] Fetched: updated=$updated, min_version="$minV", latest_version="$latestV" (platform: $_platformSuffix)');
      }
    } catch (e, stackTrace) {
      CrashlyticsService.instance.recordError(
        e,
        stackTrace,
        reason: 'Remote Config initialization failed',
      );
    }
  }

  /// Fetch latest config from Firebase
  Future<void> fetchAndActivate() async {
    if (_remoteConfig == null || kIsWeb) return;

    try {
      await _remoteConfig!.fetchAndActivate();
    } catch (e, stackTrace) {
      CrashlyticsService.instance.recordError(
        e,
        stackTrace,
        reason: 'Failed to fetch Remote Config',
      );
    }
  }

  /// Get min required version (below this = mandatory update, cannot use app)
  String getMinVersion() {
    if (_remoteConfig == null) return '0.0.0';
    final v = _remoteConfig!.getString('min_version$_platformSuffix').trim();
    return v.isEmpty ? '0.0.0' : v;
  }

  /// Get latest available version (below this = optional update prompt)
  String getLatestVersion() {
    if (_remoteConfig == null) return '0.0.0';
    final v = _remoteConfig!.getString('latest_version$_platformSuffix').trim();
    return v.isEmpty ? '0.0.0' : v;
  }
}
