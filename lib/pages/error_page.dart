import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../utils/app_config.dart';
import '../utils/responsive.dart';
import '../theme/colors.dart';
import '../routes.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final bool isReleaseMode;

  const ErrorPage({
    Key? key,
    this.errorDetails,
    this.isReleaseMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: ResponsiveUtils.rp(80),
                  color: AppColors.error,
                ),
                SizedBox(height: ResponsiveUtils.rp(24)),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'Kindly call our customer support team',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Text(
                  AppConfig.phoneNumber,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.rp(32)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final phoneUri = Uri(scheme: 'tel', path: AppConfig.phoneNumber);
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        }
                      },
                      icon: Icon(Icons.phone, size: ResponsiveUtils.rp(20)),
                      label: Text(
                        'Call Support',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(24),
                          vertical: ResponsiveUtils.rp(16),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(16)),
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.home);
                      },
                      icon: Icon(Icons.home, size: ResponsiveUtils.rp(20)),
                      label: Text(
                        'Go Home',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.button,
                        side: BorderSide(color: AppColors.button),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(24),
                          vertical: ResponsiveUtils.rp(16),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



