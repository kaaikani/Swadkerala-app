import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/authentication/authenticationcontroller.dart';
import '../../services/graphql_client.dart';
import '../../graphql/Customer.graphql.dart';
import '../../services/analytics_service.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../routes.dart';
import '../../widgets/snackbar.dart';

class AccountFooter extends StatelessWidget {
  final bool isGuest;

  const AccountFooter({super.key, this.isGuest = false});

  void _showDeleteAccountDialog(BuildContext context) {
    final reasonController = TextEditingController();
    AnalyticsService().logScreenView(screenName: 'DeleteAccountDialog');
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: AppColors.error, size: ResponsiveUtils.rp(24)),
            SizedBox(width: ResponsiveUtils.rp(8)),
            Expanded(
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account? This action cannot be undone after 3 days.',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(8)),
              Text(
                'You can cancel this request by logging back in within 3 days.',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(13),
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(16)),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: 'Reason for deletion (required)',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.rp(12),
                    vertical: ResponsiveUtils.rp(12),
                  ),
                ),
                maxLines: 3,
                style: TextStyle(fontSize: ResponsiveUtils.sp(14), color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                reasonController.dispose();
              });
            },
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final reasonText = reasonController.text.trim();
              if (reasonText.isEmpty) {
                showErrorSnackbar('Please enter a reason for account deletion');
                return;
              }
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                reasonController.dispose();
              });
              try {
                final response = await GraphqlService.client.value.mutate$RequestAccountDeletion(
                  Options$Mutation$RequestAccountDeletion(
                    variables: Variables$Mutation$RequestAccountDeletion(reason: reasonText),
                  ),
                );
                if (response.hasException) {
                  final msg = response.exception?.graphqlErrors.firstOrNull?.message ??
                      response.exception?.linkException?.toString() ??
                      'Failed to request account deletion';
                  showErrorSnackbar(msg.toString().replaceAll('Exception:', '').trim());
                  return;
                }
                final data = response.parsedData?.requestAccountDeletion;
                if (data == null) {
                  showErrorSnackbar('Failed to request account deletion');
                  return;
                }
                if (data.success) {
                  SnackBarWidget.showSuccess(data.message);
                  final authController = Get.find<AuthController>();
                  final ctx = Get.context;
                  if (ctx != null) {
                    await authController.logout(ctx);
                  } else {
                    await GraphqlService.clearToken('auth');
                    await GraphqlService.clearToken('channel');
                    await GraphqlService.clearGuestSession();
                    Get.offAllNamed(AppRoutes.home);
                  }
                } else {
                  showErrorSnackbar(data.message);
                }
              } catch (e) {
                showErrorSnackbar('Failed to request account deletion. Please try again.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

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
                          '32AASFG3196P1ZN',
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
              : Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        minimumSize: Size(double.infinity, 0),
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
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    TextButton(
                      onPressed: () {
                        _showDeleteAccountDialog(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        minimumSize: Size(double.infinity, 0),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                      ),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveUtils.sp(13),
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
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
