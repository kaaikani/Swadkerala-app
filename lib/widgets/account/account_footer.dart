import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/authentication/authenticationcontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../routes.dart';
import '../../widgets/snackbar.dart';

class AccountFooter extends StatelessWidget {
  final bool isGuest;

  const AccountFooter({super.key, this.isGuest = false});

  void _showLogoutDialog(BuildContext context) {
    final authController = Get.find<AuthController>();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Logout',
          style: TextStyle(fontSize: ResponsiveUtils.sp(18), fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Company Information
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Information',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: ResponsiveUtils.rp(16), color: AppColors.textSecondary),
                  SizedBox(width: ResponsiveUtils.rp(6)),
                  Expanded(
                    child: Text(
                      'Galaxy Traders, Karimannoor PO - 685581\nMannarathara - Kotta Road, Idukki Dist, Kerala',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(12),
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FSSAI License',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        Text(
                          '21325176000258',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GST No',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        Text(
                          '33BFHPS5919D2ZD',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: isGuest
              ? ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  icon: Icon(Icons.login, size: ResponsiveUtils.rp(20)),
                  label: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            return Center(
              child: Text(
                'App Version ${snapshot.data?.version ?? "1.0.0"}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: ResponsiveUtils.sp(12),
                ),
              ),
            );
          },
        ),
        SizedBox(height: ResponsiveUtils.rp(20)),
      ],
    );
  }
}

/// Utility methods for share/rate actions used across account components
class AccountActions {
  static const String appStoreId = '6759081528';

  static bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Rect? shareOrigin(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  static Future<void> shareApp(GlobalKey shareAppKey) async {
    try {
      String appLink;
      if (isIOS) {
        appLink = 'https://apps.apple.com/app/id$appStoreId';
      } else {
        final packageInfo = await PackageInfo.fromPlatform();
        appLink = 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      }
      await Share.share(appLink, sharePositionOrigin: shareOrigin(shareAppKey));
    } catch (e) {
      showErrorSnackbar('Could not share app');
    }
  }

  static Future<void> openStoreForRating() async {
    try {
      if (isIOS) {
        final appStoreUrl = Uri.parse('https://apps.apple.com/app/id$appStoreId');
        final itmsUrl = Uri.parse('itms-apps://apps.apple.com/app/id$appStoreId');
        if (await canLaunchUrl(itmsUrl)) {
          await launchUrl(itmsUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
        }
      } else if (isAndroid) {
        final packageInfo = await PackageInfo.fromPlatform();
        final packageName = packageInfo.packageName;
        final playStoreUrl = Uri.parse('market://details?id=$packageName');
        final webStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
        if (await canLaunchUrl(playStoreUrl)) {
          await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
        }
      } else {
        showErrorSnackbar('Please open the app on a phone to rate us.');
      }
    } catch (e) {
      showErrorSnackbar(
        isIOS ? 'Could not open App Store: $e' : 'Could not open Play Store: $e',
      );
    }
  }
}
