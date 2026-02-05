import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/authentication/authenticationcontroller.dart';
import '../widgets/snackbar.dart';
import 'auth_wrapper.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool _updateInProgress = false;
  int _retryCount = 0;
  final AuthController authController = Get.find<AuthController>();

  void _performImmediateUpdate() async {
    // Platform check: in_app_update only works on Android
    if (!Platform.isAndroid || kIsWeb) {
      // For iOS, open App Store instead
      await _openAppStoreForUpdate();
      return;
    }

    // Clear cache or perform logout before starting the update
    /*
 await _clearCacheOrLogout();
*/

    setState(() {
      _updateInProgress = true;
    });

    try {
      // First try to perform immediate update (Android only)
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      setState(() {
        _updateInProgress = false;
      });

      // If immediate update fails (e.g., app not from Play Store), open Play Store

      try {
        await _openPlayStoreForUpdate();
      } catch (playStoreError) {

        // Show error dialog with only retry option (no bypass)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            _retryCount++;
            return AlertDialog(
              title: Text('Update Required'),
              content: Text(
                  'Unable to update the app. This may happen if the app is not installed from Play Store.\n\nPlease try again or install the app from Play Store.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performImmediateUpdate(); // Retry update
                  },
                  child: Text('Retry Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openPlayStoreForUpdate(); // Open Play Store
                  },
                  child: Text('Open Play Store'),
                ),
                // Only show skip option after 3 failed attempts
                if (_retryCount >= 3)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to login/auth wrapper
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AuthWrapper()),
                      );
                    },
                    child: Text('Skip (Not Recommended)',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            );
          },
        );
      }
    }
  }

  /// Open Play Store to update the app (Android)
  Future<void> _openPlayStoreForUpdate() async {
    try {
      const packageName = 'com.kaaikani.kaaikani';
      final Uri playStoreUrl = Uri.parse('market://details?id=$packageName');
      final Uri webStoreUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName');


      // Try to open Play Store app
      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web browser
        await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
      }

      // Show message that user should return after updating
      SnackBarWidget.showInfo(
        'Please update the app and return to continue',
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      rethrow; // Re-throw to be caught by the calling method
    }
  }

  /// Open App Store to update the app (iOS)
  Future<void> _openAppStoreForUpdate() async {
    try {
      // Replace with your actual App Store app ID
      const appId = 'YOUR_APP_STORE_ID'; // TODO: Replace with actual App Store ID
      final Uri appStoreUrl = Uri.parse('https://apps.apple.com/app/id$appId');
      final Uri itmsUrl = Uri.parse('itms-apps://apps.apple.com/app/id$appId');


      // Try to open App Store app
      if (await canLaunchUrl(itmsUrl)) {
        await launchUrl(itmsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web browser
        await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
      }

      // Show message that user should return after updating
      SnackBarWidget.showInfo(
        'Please update the app and return to continue',
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      SnackBarWidget.showInfo(
        'Unable to open App Store. Please update manually from the App Store.',
        duration: const Duration(seconds: 5),
      );
    }
  }

  /*  Future<void> _clearCacheOrLogout() async {
    // Example: Log out the user
    loginPageController.onUserLogout(context);

    // Example: Clear cache (if applicable)
    // await someCacheClearingFunction();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Center(
            child: _updateInProgress
                ? SizedBox(height: 20, child: Skeletons.smallBox(size: 20))
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Update.png', // Replace with your image path
                          height: 300,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Update Required!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 15),
                        const Text(
                          'A new version is available and must be installed to continue using the app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 15),
                        const Text(
                          'This update includes important bug fixes, security improvements, and new features.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _performImmediateUpdate,
                    icon: Icon(Icons.system_update_alt, color: Colors.white),
                    label: const Text(
                      'Update Now',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 10,
                      minimumSize: const Size(double.infinity,
                          60), // Full width button with more height
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'T&C apply',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

