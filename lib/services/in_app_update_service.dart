import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import '../widgets/snackbar.dart';
import '../services/graphql_client.dart';

/// Service to handle in-app updates with flexible and immediate update modes
class InAppUpdateService {
  static final InAppUpdateService _instance = InAppUpdateService._internal();
  factory InAppUpdateService() => _instance;
  InAppUpdateService._internal();

  // Update information
  AppUpdateInfo? _updateInfo;
  bool _isUpdateAvailable = false;
  String _currentVersion = '';
  String _latestVersion = '';
  bool _isImmediateUpdateEnabled = false;
  bool _isCheckingUpdate = false;

  // Getters
  bool get isUpdateAvailable => _isUpdateAvailable;
  String get currentVersion => _currentVersion;
  String get latestVersion => _latestVersion;
  bool get isImmediateUpdateEnabled => _isImmediateUpdateEnabled;
  AppUpdateInfo? get updateInfo => _updateInfo;

  /// Initialize the service and load configuration
  Future<void> initialize() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;
      
      // Initialize with current version as default
      _latestVersion = _currentVersion;
      _isImmediateUpdateEnabled = false;
      
debugPrint('[InAppUpdate] Service initialized');
debugPrint('[InAppUpdate] Current version: $_currentVersion');
debugPrint('[InAppUpdate] Latest version: $_latestVersion');
debugPrint('[InAppUpdate] Immediate update enabled: $_isImmediateUpdateEnabled');
    } catch (e) {
debugPrint('[InAppUpdate] Error initializing service: $e');
    }
  }

  /// Check for available updates
  /// Returns true if an update is available
  Future<bool> checkForUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      debugPrint('[InAppUpdate] Skipping update check - not on Android platform');
      _isUpdateAvailable = false;
      return false;
    }

    if (_isCheckingUpdate) {
debugPrint('[InAppUpdate] Already checking for updates');
      return _isUpdateAvailable;
    }

    try {
      _isCheckingUpdate = true;
debugPrint('[InAppUpdate] Checking for updates...');

      // Check Play Store for updates first (Android only)
      _updateInfo = await InAppUpdate.checkForUpdate();
      
      if (_updateInfo != null) {
        _isUpdateAvailable = _updateInfo!.updateAvailability == UpdateAvailability.updateAvailable;
        
debugPrint('[InAppUpdate] Update available: $_isUpdateAvailable');
debugPrint('[InAppUpdate] Immediate update allowed: ${_updateInfo!.immediateUpdateAllowed}');
debugPrint('[InAppUpdate] Flexible update allowed: ${_updateInfo!.flexibleUpdateAllowed}');
        
        // Only check version comparison if we have a newer version configured
        if (_latestVersion != _currentVersion && _latestVersion.isNotEmpty) {
debugPrint('[InAppUpdate] Comparing versions: current=$_currentVersion, latest=$_latestVersion');
          bool hasNewerVersion = _currentVersion != _latestVersion;
debugPrint('[InAppUpdate] Has newer version available: $hasNewerVersion');
          
          if (hasNewerVersion) {
debugPrint('[InAppUpdate] Update available from config: $_currentVersion -> $_latestVersion');
          }
        }
      } else {
        _isUpdateAvailable = false;
debugPrint('[InAppUpdate] No update info available from Play Store');
      }

      return _isUpdateAvailable;
    } catch (e) {
debugPrint('[InAppUpdate] Error checking for update: $e');
      
      // Check if it's the "app not owned" error (development/debug build)
      if (e.toString().contains('ERROR_APP_NOT_OWNED') || e.toString().contains('-10')) {
debugPrint('[InAppUpdate] App not installed from Play Store (development build) - no update check needed');
        _isUpdateAvailable = false;
        return false;
      } else {
debugPrint('[InAppUpdate] Other error occurred during update check');
        _isUpdateAvailable = false;
        return false;
      }
    } finally {
      _isCheckingUpdate = false;
    }
  }

  /// Check Play Store directly for updates (fallback when GraphQL fails)
  /// Returns true if an update is available
  Future<bool> checkPlayStoreDirectly() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      debugPrint('[InAppUpdate] Skipping Play Store check - not on Android platform');
      return false;
    }

    try {
debugPrint('[InAppUpdate] Checking Play Store directly...');
      
      // Check Play Store for updates (Android only)
      final updateInfo = await InAppUpdate.checkForUpdate();
      
      final updateAvailable = updateInfo.updateAvailability == UpdateAvailability.updateAvailable;
debugPrint('[InAppUpdate] Play Store check result: updateAvailable=$updateAvailable');
debugPrint('[InAppUpdate] Immediate update allowed: ${updateInfo.immediateUpdateAllowed}');
debugPrint('[InAppUpdate] Flexible update allowed: ${updateInfo.flexibleUpdateAllowed}');
      
      // Store the update info for later use
      _updateInfo = updateInfo;
      _isUpdateAvailable = updateAvailable;
      
      return updateAvailable;
    } catch (e) {
debugPrint('[InAppUpdate] Error checking Play Store directly: $e');
      
      // Check if it's the "app not owned" error (development/debug build)
      if (e.toString().contains('ERROR_APP_NOT_OWNED') || e.toString().contains('-10')) {
debugPrint('[InAppUpdate] App not installed from Play Store (development build) - no update check needed');
        return false;
      } else {
debugPrint('[InAppUpdate] Other error occurred during Play Store check');
        return false;
      }
    }
  }

  /// Perform immediate update (blocks the app until update is installed)
  /// Use this when IMMEDIATE_UPDATE=true
  Future<void> performImmediateUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      debugPrint('[InAppUpdate] Skipping immediate update - not on Android platform');
      showErrorSnackbar('Updates are only available on Android. Please update from the App Store.');
      return;
    }

    try {
      if (_updateInfo == null || !_isUpdateAvailable) {
debugPrint('[InAppUpdate] No update available for immediate update');
        return;
      }

      if (!_updateInfo!.immediateUpdateAllowed) {
debugPrint('[InAppUpdate] Immediate update not allowed, falling back to flexible');
        await performFlexibleUpdate();
        return;
      }

debugPrint('[InAppUpdate] Starting immediate update...');
      
      await InAppUpdate.performImmediateUpdate();
      
debugPrint('[InAppUpdate] Immediate update completed');
    } catch (e) {
debugPrint('[InAppUpdate] Error performing immediate update: $e');
      showErrorSnackbar('Update failed: $e');
    }
  }

  /// Perform flexible update (downloads in background, user can continue using app)
  /// Use this when IMMEDIATE_UPDATE=false
  Future<void> performFlexibleUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      debugPrint('[InAppUpdate] Skipping flexible update - not on Android platform');
      showErrorSnackbar('Updates are only available on Android. Please update from the App Store.');
      return;
    }

    try {
      if (_updateInfo == null || !_isUpdateAvailable) {
debugPrint('[InAppUpdate] No update available for flexible update');
        return;
      }

      if (!_updateInfo!.flexibleUpdateAllowed) {
debugPrint('[InAppUpdate] Flexible update not allowed');
        showErrorSnackbar('Update not available at this time');
        return;
      }

debugPrint('[InAppUpdate] Starting flexible update...');
      
      // Start the flexible update
      await InAppUpdate.startFlexibleUpdate();
      
      // Show download progress
      showSuccessSnackbar('Update downloading in background...');
      
      // Listen for download completion (Android only)
      if (Platform.isAndroid && !kIsWeb) {
        InAppUpdate.completeFlexibleUpdate().then((_) {
debugPrint('[InAppUpdate] Flexible update completed, app will restart');
          _showUpdateCompleteDialog();
        }).catchError((e) {
debugPrint('[InAppUpdate] Error completing flexible update: $e');
        });
      }
    } catch (e) {
debugPrint('[InAppUpdate] Error performing flexible update: $e');
      showErrorSnackbar('Update failed: $e');
    }
  }

  /// Check and show flexible update dialog automatically (for account page)
  Future<void> checkAndShowFlexibleUpdateInAccount(BuildContext context) async {
    try {
      // First check for updates
      final updateAvailable = await checkForUpdate();
      
      if (updateAvailable && context.mounted) {
        // Check if this is a same major.minor update (should be flexible)
        if (_latestVersion.isNotEmpty) {
          bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, _latestVersion);
          
          if (isSameMajorMinor) {
debugPrint('[InAppUpdate] Same major.minor update detected - showing flexible dialog in account page');
            _showFlexibleUpdateDialog(context);
          } else {
debugPrint('[InAppUpdate] Different major.minor detected - not showing in account page (will show on app start)');
            // Don't show immediate updates in account page, let them show on app start
          }
        }
      } else {
debugPrint('[InAppUpdate] No update available for account page');
      }
    } catch (e) {
debugPrint('[InAppUpdate] Error checking flexible update for account page: $e');
    }
  }

  /// Show flexible update dialog (for manual trigger)
  Future<void> showFlexibleUpdateDialog(BuildContext context) async {
    try {
      // First check for updates
      final updateAvailable = await checkForUpdate();
      
      if (updateAvailable && context.mounted) {
        // Check if this is a same major.minor update (should be flexible)
        if (_latestVersion.isNotEmpty) {
          bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, _latestVersion);
          
          if (isSameMajorMinor) {
debugPrint('[InAppUpdate] Showing flexible update dialog for same major.minor update');
            _showFlexibleUpdateDialog(context);
          } else {
debugPrint('[InAppUpdate] Different major.minor detected - should use immediate update instead');
            // For different major.minor, show immediate dialog
            _showImmediateUpdateDialog(context);
          }
        }
      } else {
debugPrint('[InAppUpdate] No update available');
        showSuccessSnackbar('App is up to date');
      }
    } catch (e) {
debugPrint('[InAppUpdate] Error showing flexible update dialog: $e');
      showErrorSnackbar('Error checking for updates');
    }
  }

  /// Check and show update dialog on app start (for immediate updates)
  Future<void> checkAndShowUpdateOnStart(BuildContext context) async {
    try {
      // First check for updates and determine the correct update type
      final updateAvailable = await checkForUpdate();
      
      if (updateAvailable && context.mounted) {
        // Re-evaluate update type based on current version comparison
        if (_latestVersion.isNotEmpty) {
          bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, _latestVersion);
          
          if (isSameMajorMinor) {
debugPrint('[InAppUpdate] Same major.minor update detected on startup - skipping immediate dialog');
            return; // Don't show immediate dialog for same major.minor updates
          }
        }
        
        // Only show immediate dialog if it's actually an immediate update
        if (_isImmediateUpdateEnabled) {
          _showImmediateUpdateDialog(context);
        } else {
debugPrint('[InAppUpdate] Flexible update detected on startup - not showing immediate dialog');
        }
      }
    } catch (e) {
debugPrint('[InAppUpdate] Error checking update on start: $e');
    }
  }

  /// Show flexible update dialog (non-blocking)
  void _showFlexibleUpdateDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.system_update, color: Colors.blue[600], size: 32),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Update Available',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A new version of the app is available. You can update now or continue using the app.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Version:', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(_currentVersion, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('New Version:', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(_latestVersion, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Update Later',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              performFlexibleUpdate();
            },
            icon: const Icon(Icons.download),
            label: const Text('Update Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show immediate update dialog (blocking)
  void _showImmediateUpdateDialog(BuildContext context) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent dismissal
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.system_update, color: Colors.green[600], size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Update Required',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A new version of the app is available and must be installed to continue.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Version:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(_currentVersion, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('New Version:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(_latestVersion, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  performImmediateUpdate();
                },
                icon: const Icon(Icons.download),
                label: const Text('Update Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show update completion dialog
  void _showUpdateCompleteDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 32),
              const SizedBox(width: 12),
              const Text('Update Complete'),
            ],
          ),
          content: const Text(
            'The app has been updated successfully. Please restart the app to apply changes.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid && !kIsWeb) {
                    InAppUpdate.completeFlexibleUpdate();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Restart App'),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }





  /// Check for updates and determine update type (simplified flow)
  /// This replaces the BannerController logic
  Future<void> checkForUpdatesAndDetermineType() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      debugPrint('[InAppUpdate] Skipping update check flow - not on Android platform');
      _isUpdateAvailable = false;
      _isImmediateUpdateEnabled = false;
      return;
    }

    try {
debugPrint('[InAppUpdate] Starting simplified update check flow...');
      
      // STEP 1: Check Play Store for updates (Android only)
debugPrint('[InAppUpdate] Step 1: Checking Play Store for updates...');
      final updateInfo = await InAppUpdate.checkForUpdate();
      
      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
debugPrint('[InAppUpdate] No update available on Play Store');
        _isUpdateAvailable = false;
        _isImmediateUpdateEnabled = false;
        return;
      }
      
debugPrint('[InAppUpdate] Update available on Play Store');
debugPrint('[InAppUpdate] Immediate update allowed: ${updateInfo.immediateUpdateAllowed}');
debugPrint('[InAppUpdate] Flexible update allowed: ${updateInfo.flexibleUpdateAllowed}');
      
      // Store the update info
      _updateInfo = updateInfo;
      _isUpdateAvailable = true;
      
      // STEP 2: Get GraphQL version from API
debugPrint('[InAppUpdate] Step 2: Getting version from GraphQL API...');
      final graphqlVersion = await _getPlayStoreVersion();
      
      // Check if GraphQL version is valid (not null, not empty)
      if (graphqlVersion != null && graphqlVersion.isNotEmpty && graphqlVersion.trim().isNotEmpty) {
        _latestVersion = graphqlVersion.trim();
debugPrint('[InAppUpdate] Current app version: $_currentVersion');
debugPrint('[InAppUpdate] GraphQL API latest version: $_latestVersion');
        
        // STEP 3: Check update type based on 2nd digit (minor version)
        // If 2nd digit differs → IMMEDIATE UPDATE
        // If 2nd digit same → FLEXIBLE UPDATE
        
        bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, _latestVersion);
        
        if (isSameMajorMinor) {
debugPrint('[InAppUpdate] Same 2nd digit (minor version) - FLEXIBLE UPDATE');
          _isImmediateUpdateEnabled = false;
          updateConfigurationFromAppInfo(_latestVersion, 'FLEXIBLE');
        } else {
debugPrint('[InAppUpdate] Different 2nd digit (minor version) - IMMEDIATE UPDATE');
          _isImmediateUpdateEnabled = true;
        }
      } else {
        // GraphQL version is null, empty, or error occurred
debugPrint('[InAppUpdate] GraphQL version is null/empty or API error occurred');
debugPrint('[InAppUpdate] GraphQL version received: ${graphqlVersion ?? "null"}');
debugPrint('[InAppUpdate] Forcing IMMEDIATE UPDATE due to missing GraphQL version');
        
        // Force immediate update if GraphQL version is not available
        _isImmediateUpdateEnabled = true;
        _isUpdateAvailable = true;
      }

    } catch (e) {
debugPrint('[InAppUpdate] Update check flow error: $e');
      
      // Check if it's the "app not owned" error (development/debug build)
      if (e.toString().contains('ERROR_APP_NOT_OWNED') || e.toString().contains('-10')) {
debugPrint('[InAppUpdate] App not installed from Play Store (development build) - skipping update check');
        _isImmediateUpdateEnabled = false;
        _isUpdateAvailable = false;
      } else {
debugPrint('[InAppUpdate] Forcing immediate update due to error');
        _isImmediateUpdateEnabled = true;
        _isUpdateAvailable = true;
      }
    }
  }

  /// Get Play Store version from GraphQL API
  Future<String?> _getPlayStoreVersion() async {
    try {
debugPrint('[InAppUpdate] Getting latest version from GraphQL API...');
      
      final query = '''
        query GetAppUpdate {
          getUpdateInfoForChannel {
            latestVersion
            updateType
          }
        }
      ''';
      
      final result = await GraphqlService.client.value.query(
        graphql.QueryOptions(
          document: graphql.gql(query),
        ),
      );
      
      if (result.hasException) {
debugPrint('[InAppUpdate] GraphQL query exception: ${result.exception}');
debugPrint('[InAppUpdate] Error fetching version from API - will fallback to Play Store flags');
        return null;
      }
      
      final data = result.data?['getUpdateInfoForChannel'];
      if (data != null) {
        final latestVersion = data['latestVersion'] as String?;
        
debugPrint('[InAppUpdate] GraphQL API returned latestVersion: $latestVersion');
        
        // Check if version is valid (not null, not empty)
        if (latestVersion != null && latestVersion.isNotEmpty && latestVersion.trim().isNotEmpty) {
          return latestVersion.trim();
        } else {
debugPrint('[InAppUpdate] GraphQL API returned empty or null version');
          return null;
        }
      }
      
debugPrint('[InAppUpdate] No version data from GraphQL API - returning null');
      return null;
    } catch (e) {
debugPrint('[InAppUpdate] Error getting version from GraphQL API: $e');
      // If GraphQL error, force immediate update as requested
debugPrint('[InAppUpdate] GraphQL error occurred - will use immediate update as fallback');
      return null;
    }
  }

  /// Reset update check (useful for testing)
  void reset() {
    _updateInfo = null;
    _isUpdateAvailable = false;
    _isCheckingUpdate = false;
debugPrint('[InAppUpdate] Service reset');
  }

  /// Update configuration from external source (e.g., GraphQL)
  /// Call this method after getAppUpdateInfo() with the fetched data
  void updateConfigurationFromAppInfo(String latestVersion, String updateType) {
    try {
debugPrint('[InAppUpdate] Updating configuration from app info');
debugPrint('[InAppUpdate] Latest version: $latestVersion');
debugPrint('[InAppUpdate] Update type from API: $updateType');
debugPrint('[InAppUpdate] Current version: $_currentVersion');
      
      // Update latest version
      _latestVersion = latestVersion;
      
      // Determine update type based on current version and API update type
      // Priority: Current version logic > API update type
      
      // Only compare app version vs Play Store version
      bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, latestVersion);
      
      if (isSameMajorMinor) {
        // Same major.minor updates are always flexible (patch updates)
        _isImmediateUpdateEnabled = false;
debugPrint('[InAppUpdate] Same major.minor update - FLEXIBLE UPDATE');
      } else {
        // Different major.minor - IMMEDIATE UPDATE
        _isImmediateUpdateEnabled = true;
debugPrint('[InAppUpdate] Different major.minor - IMMEDIATE UPDATE');
      }
      
      // Reset update states to force re-check with new configuration
      _isUpdateAvailable = false;
      _updateInfo = null;
      _isCheckingUpdate = false;
      
debugPrint('[InAppUpdate] Final decision - Immediate update: $_isImmediateUpdateEnabled');
debugPrint('[InAppUpdate] Configuration updated successfully');
    } catch (e) {
debugPrint('[InAppUpdate] Error updating configuration from app info: $e');
    }
  }

  /// Check if this is a same major.minor update (patch update only)
  bool _isSameMajorMinorUpdate(String currentVersion, String latestVersion) {
    try {
      List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
      List<int> latestParts = latestVersion.split('.').map(int.parse).toList();
      
      // Pad with zeros if needed
      while (currentParts.length < 3) currentParts.add(0);
      while (latestParts.length < 3) latestParts.add(0);
      
      int currentMajor = currentParts[0];
      int currentMinor = currentParts[1];
      
      int latestMajor = latestParts[0];
      int latestMinor = latestParts[1];
      
      bool isSameMajorMinor = (currentMajor == latestMajor && currentMinor == latestMinor);
      
debugPrint('[InAppUpdate] Same major.minor check: $currentMajor.$currentMinor vs $latestMajor.$latestMinor = $isSameMajorMinor');
      
      return isSameMajorMinor;
    } catch (e) {
debugPrint('[InAppUpdate] Error checking same major.minor: $e');
      return false;
    }
  }


  /// Check if user is skipping versions that had immediate update requirements
  bool isSkippingImmediateVersions(String currentVersion, String latestVersion) {
    try {
      List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
      List<int> latestParts = latestVersion.split('.').map(int.parse).toList();
      
      // Pad with zeros if needed
      while (currentParts.length < 3) currentParts.add(0);
      while (latestParts.length < 3) latestParts.add(0);
      
      int currentMajor = currentParts[0];
      int currentMinor = currentParts[1];
      int currentPatch = currentParts[2];
      
      int latestMajor = latestParts[0];
      int latestMinor = latestParts[1];
      int latestPatch = latestParts[2];
      
debugPrint('[InAppUpdate] Checking version skipping: current=[$currentMajor.$currentMinor.$currentPatch], latest=[$latestMajor.$latestMinor.$latestPatch]');
      
      // Check if user is skipping any versions that had immediate update requirements
      bool isSkippingImmediate = _checkSkippedVersionsForImmediateUpdates(
        currentMajor, currentMinor, currentPatch,
        latestMajor, latestMinor, latestPatch
      );
      
      if (isSkippingImmediate) {
debugPrint('[InAppUpdate] User is skipping versions with immediate update requirements - forcing immediate update');
        return true;
      }
      
debugPrint('[InAppUpdate] No version skipping detected - using normal update strategy');
      return false;
    } catch (e) {
debugPrint('[InAppUpdate] Error checking version skipping: $e');
      return false;
    }
  }

  /// Check if any skipped versions had immediate update requirements by checking Play Store
  bool _checkSkippedVersionsForImmediateUpdates(
    int currentMajor, int currentMinor, int currentPatch,
    int latestMajor, int latestMinor, int latestPatch
  ) {
    try {
debugPrint('[InAppUpdate] ==========================================');
debugPrint('[InAppUpdate] Checking version requirements...');
debugPrint('[InAppUpdate] Current: $currentMajor.$currentMinor.$currentPatch');
debugPrint('[InAppUpdate] Latest: $latestMajor.$latestMinor.$latestPatch');
debugPrint('[InAppUpdate] ==========================================');
      
      // Simple logic: If second digit differs = IMMEDIATE UPDATE
      // - 2.0.5 → 2.0.6: Flexible update (same second digit)
      // - 2.0.5 → 2.1.3: Immediate update (second digit differs: 0 → 1)
      // - 2.0.5 → 2.2.4: Immediate update (second digit differs: 0 → 2)
      
      // Check if the SECOND DIGIT (minor version) differs - FORCE IMMEDIATE UPDATE
debugPrint('[InAppUpdate] Checking: currentMajor ($currentMajor) == latestMajor ($latestMajor)? ${currentMajor == latestMajor}');
debugPrint('[InAppUpdate] Checking: currentMinor ($currentMinor) != latestMinor ($latestMinor)? ${currentMinor != latestMinor}');
      
      if (currentMajor == latestMajor && currentMinor != latestMinor) {
debugPrint('[InAppUpdate] ✅ Second digit differs: $currentMinor → $latestMinor - IMMEDIATE UPDATE');
        return true;
      }
      
      // Check if major version differs - FORCE IMMEDIATE UPDATE
      if (latestMajor > currentMajor) {
debugPrint('[InAppUpdate] ✅ Major version differs: $currentMajor → $latestMajor - IMMEDIATE UPDATE');
        return true;
      }
      
      // Same major and minor version = FLEXIBLE UPDATE
      if (currentMajor == latestMajor && currentMinor == latestMinor) {
debugPrint('[InAppUpdate] ❌ Same major.minor version - FLEXIBLE UPDATE');
        return false;
      }
      
debugPrint('[InAppUpdate] ❌ Default: FLEXIBLE UPDATE');
      return false;
    } catch (e) {
debugPrint('[InAppUpdate] Error checking version requirements: $e');
      return false;
    }
  }

}

