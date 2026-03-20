import 'dart:async';
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
      _NotificationDialogContent(context: context),
      barrierDismissible: true,
    );
  }

  static Future<void> _requestNotificationPermission(BuildContext context) async {
    try {
      final status = await Permission.notification.request();
      final box = GetStorage();

      if (status.isGranted) {
        await box.remove('notification_permission_dialog_shown');
        await box.remove('notification_permission_dialog_last_shown');
        await box.remove('notification_settings_dialog_shown');
        await box.remove('notification_settings_dialog_last_shown');

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
        _showSettingsDialog(context);
      }
    } catch (e) {}
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
            onPressed: () => Get.back(),
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

class _NotificationDialogContent extends StatefulWidget {
  final BuildContext context;
  const _NotificationDialogContent({required this.context});

  @override
  State<_NotificationDialogContent> createState() =>
      _NotificationDialogContentState();
}

class _NotificationDialogContentState
    extends State<_NotificationDialogContent> {
  static const int _countdownSeconds = 5;
  int _elapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_elapsed >= _countdownSeconds - 1) {
        t.cancel();
        setState(() => _elapsed = _countdownSeconds);
      } else {
        setState(() => _elapsed++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDismiss = _elapsed >= _countdownSeconds;

    return AlertDialog(
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
          onPressed: canDismiss ? () => Get.back() : null,
          style: TextButton.styleFrom(
            foregroundColor:
                canDismiss ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.4),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(12),
            ),
          ),
          child: Text(
            canDismiss ? 'Not Now' : 'Not Now ($_elapsed)',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(15),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await NotificationPermissionDialog._requestNotificationPermission(
                widget.context);
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
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: ResponsiveUtils.rp(18), color: AppColors.button),
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
}
