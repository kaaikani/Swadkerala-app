import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

class NotificationPermissionDialog {
  static Future<void> show(BuildContext context) async {
    // Don't show if permission already granted (or provisional on iOS)
    final status = await Permission.notification.status;
    if (status.isGranted || status.isProvisional) {
      return;
    }
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        ),
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: AppColors.button,
                size: ResponsiveUtils.rp(28),
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(12)),
            Expanded(
              child: Text(
                'Enable Notifications',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stay updated with your orders, offers, and important updates!',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(15),
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
            _buildFeatureItem(
              icon: Icons.shopping_bag_rounded,
              text: 'Order status updates',
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            _buildFeatureItem(
              icon: Icons.local_offer_rounded,
              text: 'Exclusive offers & discounts',
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            _buildFeatureItem(
              icon: Icons.shopping_cart_rounded,
              text: 'Cart reminders',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(12),
              ),
            ),
            child: Text(
              'Not Now',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(15),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _requestNotificationPermission(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(20),
                vertical: ResponsiveUtils.rp(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              elevation: 0,
            ),
            child: Text(
              'Enable',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(15),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  static Widget _buildFeatureItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.rp(18),
          color: AppColors.button,
        ),
        SizedBox(width: ResponsiveUtils.rp(8)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> _requestNotificationPermission(BuildContext context) async {
    try {
      final status = await Permission.notification.request();
      final box = GetStorage();
      
      if (status.isGranted) {
        // Permission granted - reset dialog flags
        await box.remove('notification_permission_dialog_shown');
        await box.remove('notification_permission_dialog_last_shown');
        await box.remove('notification_settings_dialog_shown');
        await box.remove('notification_settings_dialog_last_shown');
        
        // Optionally show a success message
        Get.snackbar(
          'Notifications Enabled',
          'You\'ll now receive important updates!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.button,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
          borderRadius: ResponsiveUtils.rp(8),
        );
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied - show settings dialog
        _showSettingsDialog(context);
      } else {
        // Permission denied (but can be requested again)
      }
    } catch (e) {
    }
  }

  static void _showSettingsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        ),
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Icon(
              Icons.settings_rounded,
              color: AppColors.button,
              size: ResponsiveUtils.rp(24),
            ),
            SizedBox(width: ResponsiveUtils.rp(12)),
            Expanded(
              child: Text(
                'Enable in Settings',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Notification permission is disabled. Please enable it in your device settings to receive updates.',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
            ),
            child: Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
