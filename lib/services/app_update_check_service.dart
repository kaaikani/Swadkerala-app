import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'crashlytics_service.dart';
import 'remote_config_service.dart';

/// Result of app update check
class AppUpdateResult {
  final bool needsMandatoryUpdate;
  final bool needsOptionalUpdate;
  final String currentVersion;
  final String minVersion;
  final String latestVersion;

  const AppUpdateResult({
    required this.needsMandatoryUpdate,
    required this.needsOptionalUpdate,
    required this.currentVersion,
    required this.minVersion,
    required this.latestVersion,
  });
}

/// Service to check app version against Firebase Remote Config (min_version, latest_version).
/// - current < min_version → mandatory update (blocking popup, cannot dismiss)
/// - current < latest_version → optional update (dismissible prompt)
class AppUpdateCheckService {
  /// Compare semantic versions. Returns: -1 if a < b, 0 if a == b, 1 if a > b
  static int _compareVersions(String a, String b) {
    try {
      final aParts = a.split('.').map((s) => int.tryParse(s.trim()) ?? 0).toList();
      final bParts = b.split('.').map((s) => int.tryParse(s.trim()) ?? 0).toList();
      final maxLen = aParts.length > bParts.length ? aParts.length : bParts.length;

      for (int i = 0; i < maxLen; i++) {
        final aVal = i < aParts.length ? aParts[i] : 0;
        final bVal = i < bParts.length ? bParts[i] : 0;
        if (aVal < bVal) return -1;
        if (aVal > bVal) return 1;
      }
      return 0;
    } catch (e) {
      return 0; // Treat parse errors as equal
    }
  }

  /// Check if version a is less than version b
  static bool isVersionLessThan(String a, String b) => _compareVersions(a, b) < 0;

  /// Check if update is required based on Remote Config
  Future<AppUpdateResult> checkForUpdate() async {
    String currentVersion = '0.0.0';
    String minVersion = '0.0.0';
    String latestVersion = '0.0.0';

    try {
      if (kIsWeb) {
        return AppUpdateResult(
          needsMandatoryUpdate: false,
          needsOptionalUpdate: false,
          currentVersion: currentVersion,
          minVersion: minVersion,
          latestVersion: latestVersion,
        );
      }

      final packageInfo = await PackageInfo.fromPlatform();
      // Include build number (e.g. 1.0.0.9) to distinguish 1.0.0 (7) vs 1.0.0 (9)
      currentVersion = '${packageInfo.version}.${packageInfo.buildNumber}';

      final remoteConfig = Get.find<RemoteConfigService>();
      minVersion = remoteConfig.getMinVersion();
      latestVersion = remoteConfig.getLatestVersion();

      // If defaults (0.0.0), no update required
      if (minVersion == '0.0.0' && latestVersion == '0.0.0') {
        return AppUpdateResult(
          needsMandatoryUpdate: false,
          needsOptionalUpdate: false,
          currentVersion: currentVersion,
          minVersion: minVersion,
          latestVersion: latestVersion,
        );
      }

      final needsMandatory = isVersionLessThan(currentVersion, minVersion);
      final needsOptional =
          !needsMandatory && isVersionLessThan(currentVersion, latestVersion);

      return AppUpdateResult(
        needsMandatoryUpdate: needsMandatory,
        needsOptionalUpdate: needsOptional,
        currentVersion: currentVersion,
        minVersion: minVersion,
        latestVersion: latestVersion,
      );
    } catch (e, stackTrace) {
      CrashlyticsService.instance.recordError(
        e,
        stackTrace,
        reason: 'App update check failed',
      );
      return AppUpdateResult(
        needsMandatoryUpdate: false,
        needsOptionalUpdate: false,
        currentVersion: currentVersion,
        minVersion: minVersion,
        latestVersion: latestVersion,
      );
    }
  }
}
