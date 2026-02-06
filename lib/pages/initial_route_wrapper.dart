import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/shimmers.dart';
import '../services/in_app_update_service.dart';
import '../utils/responsive.dart';
import '../theme/colors.dart';
import 'update_check_wrapper.dart';
import 'update_screen.dart';
import 'auth_wrapper.dart';
import '../routes.dart';

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
    debugPrint('[InitialRouteWrapper] initState called');
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
      // Add timeout to prevent blocking
      debugPrint('[InitialRouteWrapper] Starting update check...');
      try {
        await updateService.checkForUpdatesAndDetermineType().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint('[InitialRouteWrapper] Update check timed out');
            // If update check times out, continue anyway
          },
        );
        debugPrint('[InitialRouteWrapper] Update check completed');
      } catch (e) {
        debugPrint('[InitialRouteWrapper] Update check error: $e');
        // Continue even if update check fails
      }

      // Check if immediate update is enabled (based on Play Store only)
      if (updateService.isImmediateUpdateEnabled && updateService.isUpdateAvailable) {
        _shouldCheckImmediateUpdate = true;
      } else {
        _shouldCheckImmediateUpdate = false;
      }

    } catch (e) {
      debugPrint('[InitialRouteWrapper] Update check error: $e');
      _shouldCheckImmediateUpdate = false;
    } finally {
      if (mounted) {
        debugPrint('[InitialRouteWrapper] Setting _isLoading = false');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // Show loading while checking settings
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
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
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If main.dart set the flag (update required from startup check), open update screen
    if (GetStorage().read<bool>('show_update_screen') == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Get.offAllNamed(AppRoutes.update);
      });
      return UpdateScreen();
    }
    if (_shouldCheckImmediateUpdate) {
      return const UpdateCheckWrapper();
    }
    return const AuthWrapper();
  }
}
