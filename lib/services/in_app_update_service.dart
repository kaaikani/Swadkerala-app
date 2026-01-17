import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:graphql_flutter/graphql_flutter.dart' as graphql; // Commented out - GraphQL query disabled
import '../widgets/snackbar.dart';
import '../utils/responsive.dart';
// import '../services/graphql_client.dart'; // Commented out - GraphQL query disabled

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
      
    } catch (e) {
    }
  }

  /// Check for available updates
  /// Returns true if an update is available
  Future<bool> checkForUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      _isUpdateAvailable = false;
      return false;
    }

    if (_isCheckingUpdate) {
      return _isUpdateAvailable;
    }

    try {
      _isCheckingUpdate = true;

      // Check Play Store for updates first (Android only)
      _updateInfo = await InAppUpdate.checkForUpdate();
      
      if (_updateInfo != null) {
        _isUpdateAvailable = _updateInfo!.updateAvailability == UpdateAvailability.updateAvailable;
        
        
        // Only check version comparison if we have a newer version configured
        if (_latestVersion != _currentVersion && _latestVersion.isNotEmpty) {
          bool hasNewerVersion = _currentVersion != _latestVersion;
          
          if (hasNewerVersion) {
          }
        }
      } else {
        _isUpdateAvailable = false;
      }

      return _isUpdateAvailable;
    } catch (e) {
      
      // Check if it's the "app not owned" error (development/debug build)
      if (e.toString().contains('ERROR_APP_NOT_OWNED') || e.toString().contains('-10')) {
        _isUpdateAvailable = false;
        return false;
      } else {
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
      return false;
    }

    try {
      
      // Check Play Store for updates (Android only)
      final updateInfo = await InAppUpdate.checkForUpdate();
      
      final updateAvailable = updateInfo.updateAvailability == UpdateAvailability.updateAvailable;
      
      // Store the update info for later use
      _updateInfo = updateInfo;
      _isUpdateAvailable = updateAvailable;
      
      return updateAvailable;
    } catch (e) {
      
      // Check if it's the "app not owned" error (development/debug build)
      if (e.toString().contains('ERROR_APP_NOT_OWNED') || e.toString().contains('-10')) {
        return false;
      } else {
        return false;
      }
    }
  }

  /// Perform immediate update (blocks the app until update is installed)
  /// Use this when IMMEDIATE_UPDATE=true
  Future<void> performImmediateUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      showErrorSnackbar('Updates are only available on Android. Please update from the App Store.');
      return;
    }

    try {
      if (_updateInfo == null || !_isUpdateAvailable) {
        return;
      }

      if (!_updateInfo!.immediateUpdateAllowed) {
        await performFlexibleUpdate();
        return;
      }

      
      await InAppUpdate.performImmediateUpdate();
      
    } catch (e) {
      showErrorSnackbar('Update failed: $e');
    }
  }

  /// Perform flexible update (downloads in background, user can continue using app)
  /// Use this when IMMEDIATE_UPDATE=false
  Future<void> performFlexibleUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      showErrorSnackbar('Updates are only available on Android. Please update from the App Store.');
      return;
    }

    try {
      if (_updateInfo == null || !_isUpdateAvailable) {
        return;
      }

      if (!_updateInfo!.flexibleUpdateAllowed) {
        showErrorSnackbar('Update not available at this time');
        return;
      }

      
      // Start the flexible update
      await InAppUpdate.startFlexibleUpdate();
      
      // Show download progress
      showSuccessSnackbar('Update downloading in background...');
      
      // Listen for download completion (Android only)
      if (Platform.isAndroid && !kIsWeb) {
        InAppUpdate.completeFlexibleUpdate().then((_) {
          _showUpdateCompleteDialog();
        }).catchError((e) {
        });
      }
    } catch (e) {
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
            _showFlexibleUpdateDialog(context);
          } else {
            // Don't show immediate updates in account page, let them show on app start
          }
        }
      } else {
      }
    } catch (e) {
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
            _showFlexibleUpdateDialog(context);
          } else {
            // For different major.minor, show immediate dialog
            _showImmediateUpdateDialog(context);
          }
        }
      } else {
        showSuccessSnackbar('App is up to date');
      }
    } catch (e) {
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
            return; // Don't show immediate dialog for same major.minor updates
          }
        }
        
        // Only show immediate dialog if it's actually an immediate update
        if (_isImmediateUpdateEnabled) {
          _showImmediateUpdateDialog(context);
        } else {
        }
      }
    } catch (e) {
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
            SizedBox(width: ResponsiveUtils.rp(12)),
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
            SizedBox(height: ResponsiveUtils.rp(16)),
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
                  SizedBox(height: ResponsiveUtils.rp(8)),
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
              SizedBox(width: ResponsiveUtils.rp(12)),
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
              SizedBox(height: ResponsiveUtils.rp(16)),
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
                    SizedBox(height: ResponsiveUtils.rp(8)),
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
              SizedBox(width: ResponsiveUtils.rp(12)),
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
      _isUpdateAvailable = false;
      _isImmediateUpdateEnabled = false;
      return;
    }

    try {
      
      // STEP 1: Check Play Store for updates (Android only)
      final updateInfo = await InAppUpdate.checkForUpdate();
      
      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
        _isUpdateAvailable = false;
        _isImmediateUpdateEnabled = false;
        return;
      }
      
      
      // Store the update info
      _updateInfo = updateInfo;
      _isUpdateAvailable = true;
      
      // STEP 2: Use Play Store update info only (GraphQL query commented out)
      // Compare Play Store version with installed app version
        
      // Use Play Store's update availability to determine if update is needed
      // Only show update if Play Store actually has an update available
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Use Play Store's immediate update flag
        _isImmediateUpdateEnabled = updateInfo.immediateUpdateAllowed;
        _isUpdateAvailable = true;
        
        // Set latest version to current version (since we're not using GraphQL)
        // Play Store will handle the actual version comparison
        _latestVersion = _currentVersion;
        
        } else {
        // No update available on Play Store
        _isImmediateUpdateEnabled = false;
        _isUpdateAvailable = false;
      }
      
      // COMMENTED OUT: GraphQL version query logic
      // STEP 2: Get GraphQL version from API
      // debugPrint('[InAppUpdate] Step 2: Getting version from GraphQL API...');
      // final graphqlVersion = await _getPlayStoreVersion();
      // 
      // // Check if GraphQL version is valid (not null, not empty)
      // if (graphqlVersion != null && graphqlVersion.isNotEmpty && graphqlVersion.trim().isNotEmpty) {
      //   _latestVersion = graphqlVersion.trim();
      //   debugPrint('[InAppUpdate] Current app version: $_currentVersion');
      //   debugPrint('[InAppUpdate] GraphQL API latest version: $_latestVersion');
      //   
      //   // STEP 3: Check update type based on 2nd digit (minor version)
      //   // If 2nd digit differs → IMMEDIATE UPDATE
      //   // If 2nd digit same → FLEXIBLE UPDATE
      //   
      //   bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, _latestVersion);
      //   
      //   if (isSameMajorMinor) {
      //     debugPrint('[InAppUpdate] Same 2nd digit (minor version) - FLEXIBLE UPDATE');
      //     _isImmediateUpdateEnabled = false;
      //     updateConfigurationFromAppInfo(_latestVersion, 'FLEXIBLE');
      //   } else {
      //     debugPrint('[InAppUpdate] Different 2nd digit (minor version) - IMMEDIATE UPDATE');
      //     _isImmediateUpdateEnabled = true;
      //   }
      // } else {
      //   // GraphQL version is null, empty, or error occurred
      //   debugPrint('[InAppUpdate] GraphQL version is null/empty or API error occurred');
      //   debugPrint('[InAppUpdate] GraphQL version received: ${graphqlVersion ?? "null"}');
      //   debugPrint('[InAppUpdate] Forcing IMMEDIATE UPDATE due to missing GraphQL version');
      //   
      //   // Force immediate update if GraphQL version is not available
      //   _isImmediateUpdateEnabled = true;
      //   _isUpdateAvailable = true;
      // }

    } catch (e) {
      
      // Check if it's the "app not owned" error (development/debug build)
      if (e.toString().contains('ERROR_APP_NOT_OWNED') || e.toString().contains('-10')) {
        _isImmediateUpdateEnabled = false;
        _isUpdateAvailable = false;
      } else if (e.toString().contains('ERROR_INSTALL_NOT_ALLOWED') || e.toString().contains('-6')) {
        // Device state error (low battery, low disk space, etc.) - don't force update
        _isImmediateUpdateEnabled = false;
        _isUpdateAvailable = false;
      } else {
        // Other errors - don't force update, just disable it
        _isImmediateUpdateEnabled = false;
        _isUpdateAvailable = false;
      }
    }
  }

  /// COMMENTED OUT: Get Play Store version from GraphQL API (no longer used)
  // Future<String?> _getPlayStoreVersion() async {
  //   try {
  //     debugPrint('[InAppUpdate] Getting latest version from GraphQL API...');
  //     
  //     final query = '''
  //       query GetAppUpdate {
  //         getUpdateInfoForChannel {
  //           latestVersion
  //           updateType
  //         }
  //       }
  //     ''';
  //     
  //     final result = await GraphqlService.client.value.query(
  //       graphql.QueryOptions(
  //         document: graphql.gql(query),
  //       ),
  //     );
  //     
  //     if (result.hasException) {
  //       debugPrint('[InAppUpdate] GraphQL query exception: ${result.exception}');
  //       debugPrint('[InAppUpdate] Error fetching version from API - will fallback to Play Store flags');
  //       return null;
  //     }
  //     
  //     final data = result.data?['getUpdateInfoForChannel'];
  //     if (data != null) {
  //       final latestVersion = data['latestVersion'] as String?;
  //       
  //       debugPrint('[InAppUpdate] GraphQL API returned latestVersion: $latestVersion');
  //       
  //       // Check if version is valid (not null, not empty)
  //       if (latestVersion != null && latestVersion.isNotEmpty && latestVersion.trim().isNotEmpty) {
  //         return latestVersion.trim();
  //       } else {
  //         debugPrint('[InAppUpdate] GraphQL API returned empty or null version');
  //         return null;
  //       }
  //     }
  //     
  //     debugPrint('[InAppUpdate] No version data from GraphQL API - returning null');
  //     return null;
  //   } catch (e) {
  //     debugPrint('[InAppUpdate] Error getting version from GraphQL API: $e');
  //     // If GraphQL error, force immediate update as requested
  //     debugPrint('[InAppUpdate] GraphQL error occurred - will use immediate update as fallback');
  //     return null;
  //   }
  // }

  /// Reset update check (useful for testing)
  void reset() {
    _updateInfo = null;
    _isUpdateAvailable = false;
    _isCheckingUpdate = false;
  }

  /// Update configuration from external source (e.g., GraphQL)
  /// Call this method after getAppUpdateInfo() with the fetched data
  void updateConfigurationFromAppInfo(String latestVersion, String updateType) {
    try {
      
      // Update latest version
      _latestVersion = latestVersion;
      
      // Determine update type based on current version and API update type
      // Priority: Current version logic > API update type
      
      // Only compare app version vs Play Store version
      bool isSameMajorMinor = _isSameMajorMinorUpdate(_currentVersion, latestVersion);
      
      if (isSameMajorMinor) {
        // Same major.minor updates are always flexible (patch updates)
        _isImmediateUpdateEnabled = false;
      } else {
        // Different major.minor - IMMEDIATE UPDATE
        _isImmediateUpdateEnabled = true;
      }
      
      // Reset update states to force re-check with new configuration
      _isUpdateAvailable = false;
      _updateInfo = null;
      _isCheckingUpdate = false;
      
    } catch (e) {
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
      
      
      return isSameMajorMinor;
    } catch (e) {
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
      
      
      // Check if user is skipping any versions that had immediate update requirements
      bool isSkippingImmediate = _checkSkippedVersionsForImmediateUpdates(
        currentMajor, currentMinor, currentPatch,
        latestMajor, latestMinor, latestPatch
      );
      
      if (isSkippingImmediate) {
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if any skipped versions had immediate update requirements by checking Play Store
  bool _checkSkippedVersionsForImmediateUpdates(
    int currentMajor, int currentMinor, int currentPatch,
    int latestMajor, int latestMinor, int latestPatch
  ) {
    try {
      
      // Simple logic: If second digit differs = IMMEDIATE UPDATE
      // - 2.0.5 → 2.0.6: Flexible update (same second digit)
      // - 2.0.5 → 2.1.3: Immediate update (second digit differs: 0 → 1)
      // - 2.0.5 → 2.2.4: Immediate update (second digit differs: 0 → 2)
      
      // Check if the SECOND DIGIT (minor version) differs - FORCE IMMEDIATE UPDATE
      
      if (currentMajor == latestMajor && currentMinor != latestMinor) {
        return true;
      }
      
      // Check if major version differs - FORCE IMMEDIATE UPDATE
      if (latestMajor > currentMajor) {
        return true;
      }
      
      // Same major and minor version = FLEXIBLE UPDATE
      if (currentMajor == latestMajor && currentMinor == latestMinor) {
        return false;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

}

