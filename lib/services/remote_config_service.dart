import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'crashlytics_service.dart';

class RemoteConfigService extends GetxController {
  static RemoteConfigService get instance => Get.find<RemoteConfigService>();
  
  FirebaseRemoteConfig? _remoteConfig;
  final RxString shippingTickerText = ''.obs;

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

      // Set defaults (app update: min_version = force update, latest_version = optional)
      await _remoteConfig!.setDefaults({
        'shipping_ticker_text': '',
        'min_version': '0.0.0',
        'latest_version': '0.0.0',
      });

      // Fetch and activate
      final updated = await _remoteConfig!.fetchAndActivate();
      if (kDebugMode) {
        final minV = _remoteConfig!.getString('min_version').trim();
        final latestV = _remoteConfig!.getString('latest_version').trim();
        debugPrint('[RemoteConfig] Fetched: updated=$updated, min_version="$minV", latest_version="$latestV"');
      }

      // Load shipping ticker text
      await _loadShippingTickerText();
      
    } catch (e, stackTrace) {
      CrashlyticsService.instance.recordError(
        e,
        stackTrace,
        reason: 'Remote Config initialization failed',
      );
    }
  }

  /// Load shipping ticker text from Remote Config
  Future<void> _loadShippingTickerText() async {
    try {
      if (_remoteConfig == null) return;
      
      final text = _remoteConfig!.getString('shipping_ticker_text');
      if (text.isNotEmpty) {
        shippingTickerText.value = text;
      } else {
        shippingTickerText.value = '';
      }
    } catch (e, stackTrace) {
      CrashlyticsService.instance.recordError(
        e,
        stackTrace,
        reason: 'Failed to load shipping ticker text',
      );
      shippingTickerText.value = '';
    }
  }

  /// Fetch latest config from Firebase
  Future<void> fetchAndActivate() async {
    if (_remoteConfig == null || kIsWeb) return;

    try {
      final updated = await _remoteConfig!.fetchAndActivate();
      
      if (updated) {
        await _loadShippingTickerText();
      } else {
      }
    } catch (e, stackTrace) {
      CrashlyticsService.instance.recordError(
        e,
        stackTrace,
        reason: 'Failed to fetch Remote Config',
      );
    }
  }

  /// Get shipping ticker text
  String getShippingTickerText() {
    return shippingTickerText.value;
  }

  /// Check if shipping ticker text is available
  bool hasShippingTickerText() {
    return shippingTickerText.value.isNotEmpty;
  }

  /// Get min required version (below this = mandatory update, cannot use app)
  String getMinVersion() {
    if (_remoteConfig == null) return '0.0.0';
    final v = _remoteConfig!.getString('min_version').trim();
    return v.isEmpty ? '0.0.0' : v;
  }

  /// Get latest available version (below this = optional update prompt)
  String getLatestVersion() {
    if (_remoteConfig == null) return '0.0.0';
    final v = _remoteConfig!.getString('latest_version').trim();
    return v.isEmpty ? '0.0.0' : v;
  }
}

