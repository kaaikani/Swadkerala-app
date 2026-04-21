import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/authentication/authenticationcontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/snackbar.dart';
import '../routes.dart';
import '../services/remote_config_service.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  /// Mandatory = cannot dismiss (current < min_version from Remote Config)
  bool get _isMandatory => GetStorage().read<bool>('update_mandatory') ?? true;
  bool _updateInProgress = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      PackageInfo.fromPlatform().then((info) {
        final current = '${info.version}.${info.buildNumber}';
        String minV = 'N/A';
        String latestV = 'N/A';
        try {
          final rc = Get.find<RemoteConfigService>();
          minV = rc.getMinVersion();
          latestV = rc.getLatestVersion();
        } catch (_) {}
        // debugPrint('[UpdateScreen] App version: ${info.version} (${info.buildNumber}) → $current');
        // debugPrint('[UpdateScreen] Firebase: min_version=$minV, latest_version=$latestV');
        // debugPrint('[UpdateScreen] Mandatory update: $_isMandatory (from Firebase Remote Config)');
      });
    }
  }
  int _retryCount = 0;
  final AuthController authController = Get.find<AuthController>();

  void _performImmediateUpdate() async {
    if (!Platform.isAndroid || kIsWeb) {
      await _openAppStoreForUpdate();
      return;
    }

    setState(() {
      _updateInProgress = true;
    });

    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      setState(() {
        _updateInProgress = false;
      });

      try {
        await _openPlayStoreForUpdate();
      } catch (playStoreError) {
        showDialog(
          context: context,
          barrierDismissible: !_isMandatory,
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
                    _performImmediateUpdate();
                  },
                  child: Text('Retry Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openPlayStoreForUpdate();
                  },
                  child: Text('Open Play Store'),
                ),
                if (_retryCount >= 3 && !_isMandatory)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _dismissOptionalUpdate();
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

  Future<void> _openPlayStoreForUpdate() async {
    try {
      const packageName = 'com.Swadkerala.Swadkerala';
      final Uri playStoreUrl = Uri.parse('market://details?id=$packageName');
      final Uri webStoreUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName');

      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
      }

      SnackBarWidget.showInfo(
        'Please update the app and return to continue',
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      rethrow;
    }
  }

  void _dismissOptionalUpdate() {
    GetStorage().remove('show_update_screen');
    GetStorage().remove('update_mandatory');
    Get.offAllNamed(AppRoutes.initial);
  }

  Future<void> _openAppStoreForUpdate() async {
    try {
      const appId = '6759081528';
      final Uri appStoreUrl = Uri.parse('https://apps.apple.com/app/id$appId');
      final Uri itmsUrl = Uri.parse('itms-apps://apps.apple.com/app/id$appId');

      if (await canLaunchUrl(itmsUrl)) {
        await launchUrl(itmsUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
      }

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isMandatory,
      child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen image, edge to edge
          Image.asset(
            'assets/images/update_fresh.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.background,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.system_update_alt,
                        size: 80, color: AppColors.button),
                    SizedBox(height: ResponsiveUtils.rp(24)),
                    Text(
                      'Fresh Update Ready!',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(26),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(24)),
                      child: Text(
                        "We've cleaned out all the old bugs.\nUpdate now for an even faster and fresher experience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Dark gradient at bottom so button is readable on image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
            ),
          ),
          // Update button overlaid on image at bottom
          Positioned(
            left: ResponsiveUtils.rp(24),
            right: ResponsiveUtils.rp(24),
            bottom: ResponsiveUtils.rp(32),
            child: _updateInProgress
                ? Center(
                    child: SizedBox(
                      width: ResponsiveUtils.rp(32),
                      height: ResponsiveUtils.rp(32),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.rp(56),
                        child: ElevatedButton.icon(
                          onPressed: _performImmediateUpdate,
                          icon: Icon(Icons.system_update_alt,
                              color: Colors.black, size: ResponsiveUtils.rp(22)),
                          label: Text(
                            _isMandatory ? 'Update Now' : 'Update',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ResponsiveUtils.sp(17),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(ResponsiveUtils.rp(28)),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      if (!_isMandatory) ...[
                        SizedBox(height: ResponsiveUtils.rp(12)),
                        TextButton(
                          onPressed: _dismissOptionalUpdate,
                          child: Text(
                            'Later',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveUtils.sp(16),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    ),
    );
  }
}
