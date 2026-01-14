import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
// import 'package:get/get.dart'; // Commented out - GraphQL query disabled
// import '../controllers/banner/bannercontroller.dart'; // Commented out - GraphQL query disabled
import '../services/in_app_update_service.dart';
import '../utils/responsive.dart';
import 'update_check_wrapper.dart';
import 'auth_wrapper.dart';

/// Smart initial route that decides whether to check for immediate updates
/// or proceed directly to authentication based on IMMEDIATE_UPDATE setting
class InitialRouteWrapper extends StatefulWidget {
  const InitialRouteWrapper({super.key});

  @override
  State<InitialRouteWrapper> createState() => _InitialRouteWrapperState();
}

class _InitialRouteWrapperState extends State<InitialRouteWrapper> {
  bool _isLoading = true;
  bool _shouldCheckImmediateUpdate = false;

  @override
  void initState() {
    super.initState();
    _checkUpdateSettings();
  }

  /// Check if immediate update is enabled - using Play Store version only (GraphQL disabled)
  Future<void> _checkUpdateSettings() async {
    try {
      final updateService = InAppUpdateService();

      // COMMENTED OUT: GraphQL query for update info (now using Play Store only)
      // Try to fetch app update information from GraphQL
      // debugPrint('[InitialRouteWrapper] Attempting to fetch app update information...');
      // try {
      //   final bannerController = Get.put(BannerController());
      //   // Wait for the update info to be fetched
      //   await bannerController.getAppUpdateInfo();
      //   debugPrint('[InitialRouteWrapper] Update info fetch completed');
      // } catch (e) {
      //   debugPrint('[InitialRouteWrapper] Update info fetch failed: $e');
      // }

      // Check Play Store for updates directly (GraphQL query disabled)
debugPrint('[InitialRouteWrapper] Checking Play Store for updates...');
      try {
        await updateService.checkForUpdatesAndDetermineType();
debugPrint('[InitialRouteWrapper] Play Store update check completed');
      } catch (e) {
debugPrint('[InitialRouteWrapper] Play Store update check failed: $e');
      }

      // Check if immediate update is enabled (based on Play Store only)
      if (updateService.isImmediateUpdateEnabled && updateService.isUpdateAvailable) {
        _shouldCheckImmediateUpdate = true;
debugPrint('[InitialRouteWrapper] IMMEDIATE UPDATE enabled - showing update page');
      } else {
        _shouldCheckImmediateUpdate = false;
debugPrint('[InitialRouteWrapper] No immediate update needed - proceeding to login');
      }

debugPrint(  '[InitialRouteWrapper] Final decision - Should check immediate update: $_shouldCheckImmediateUpdate');
    } catch (e) {
debugPrint('[InitialRouteWrapper] Error checking update settings: $e');
      _shouldCheckImmediateUpdate = false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
debugPrint(  '[InitialRouteWrapper] Build called - _isLoading: $_isLoading, _shouldCheckImmediateUpdate: $_shouldCheckImmediateUpdate');

    // Show loading while checking settings
    if (_isLoading) {
debugPrint('[InitialRouteWrapper] Showing loading screen');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replaced with shimmer
              SizedBox(height: ResponsiveUtils.rp(200), child: Skeletons.fullScreen()),
              SizedBox(height: ResponsiveUtils.rp(24)),
              Text(
                'Initializing app...',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Decide which wrapper to use based on IMMEDIATE_UPDATE setting
    if (_shouldCheckImmediateUpdate) {
debugPrint(  '[InitialRouteWrapper] Using UpdateCheckWrapper for immediate updates');
      return const UpdateCheckWrapper();
    } else {
debugPrint(  '[InitialRouteWrapper] Using AuthWrapper for flexible updates');
      return const AuthWrapper();
    }
  }
}
