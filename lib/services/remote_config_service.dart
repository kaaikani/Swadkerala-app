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
      debugPrint('[RemoteConfig] Skipping initialization on Web');
      return;
    }

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Set default values
      await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Set defaults
      await _remoteConfig!.setDefaults({
        'shipping_ticker_text': '',
      });

      // Fetch and activate
      await _remoteConfig!.fetchAndActivate();
      
      // Load shipping ticker text
      await _loadShippingTickerText();
      
      debugPrint('[RemoteConfig] Initialized successfully');
      debugPrint('[RemoteConfig] Shipping ticker text: ${shippingTickerText.value}');
    } catch (e, stackTrace) {
      debugPrint('[RemoteConfig] Initialization error: $e');
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
        debugPrint('[RemoteConfig] Loaded shipping ticker text: $text');
      } else {
        shippingTickerText.value = '';
        debugPrint('[RemoteConfig] Shipping ticker text is empty');
      }
    } catch (e, stackTrace) {
      debugPrint('[RemoteConfig] Error loading shipping ticker text: $e');
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
        debugPrint('[RemoteConfig] Config updated successfully');
      } else {
        debugPrint('[RemoteConfig] No config updates available');
      }
    } catch (e, stackTrace) {
      debugPrint('[RemoteConfig] Error fetching config: $e');
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
}

