import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import '../services/in_app_update_service.dart';
import 'auth_wrapper.dart';
import 'update_screen.dart';

/// Wrapper that checks for immediate updates before any navigation
/// This ensures updates are checked before login/home pages are shown
class UpdateCheckWrapper extends StatefulWidget {
  const UpdateCheckWrapper({super.key});

  @override
  State<UpdateCheckWrapper> createState() => _UpdateCheckWrapperState();
}

class _UpdateCheckWrapperState extends State<UpdateCheckWrapper> {
  bool _isCheckingUpdate = true;
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkForImmediateUpdate();
  }

  /// Check for immediate updates before any navigation
  Future<void> _checkForImmediateUpdate() async {
    try {
      final updateService = InAppUpdateService();

/// debugPrint(  '[UpdateCheckWrapper] isImmediateUpdateEnabled: ${updateService.isImmediateUpdateEnabled}');

      // Check Play Store for updates when immediate update is enabled
      if (updateService.isImmediateUpdateEnabled) {
/// debugPrint(  '[UpdateCheckWrapper] Update required - showing update screen...');

        // ALWAYS show update screen when update is required
        if (mounted) {
          setState(() {
            _updateAvailable = true;
            _isCheckingUpdate = false;
          });
        }

        // Optional: Still check Play Store for additional info (but don't change the decision)
        try {
          // final updateAvailable = await updateService.checkForUpdate(); // Unused variable
          await updateService.checkForUpdate();
/// debugPrint(  '[UpdateCheckWrapper] Play Store check completed');
        } catch (e) {
// debugPrint('[UpdateCheckWrapper] Play Store check failed: $e');
/// debugPrint(  '[UpdateCheckWrapper] This may happen if app is not installed from Play Store');
        }
      } else {
/// debugPrint(  '[UpdateCheckWrapper] No update required - proceeding to login');
        if (mounted) {
          setState(() {
            _updateAvailable = false;
            _isCheckingUpdate = false;
          });
        }
      }
    } catch (e) {
/// debugPrint(  '[UpdateCheckWrapper] Error checking for immediate update: $e');
    } finally {
      // Only set _isCheckingUpdate to false if no update is available
      if (mounted && !_updateAvailable) {
        setState(() {
          _isCheckingUpdate = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
/// debugPrint(  '[UpdateCheckWrapper] Build called - _updateAvailable: $_updateAvailable, _isCheckingUpdate: $_isCheckingUpdate');

    // Show update screen if update is available
    if (_updateAvailable) {
// debugPrint('[UpdateCheckWrapper] Showing UpdateScreen');
      return UpdateScreen();
    }

    // Show loading while checking for updates
    if (_isCheckingUpdate) {
// debugPrint('[UpdateCheckWrapper] Showing loading screen');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20, child: Skeletons.smallBox(size: 20)),
              const SizedBox(height: 24),
              const Text(
                'Checking for updates...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Proceed to auth wrapper if no update is needed
// debugPrint('[UpdateCheckWrapper] Showing AuthWrapper');
    return const AuthWrapper();
  }
}
