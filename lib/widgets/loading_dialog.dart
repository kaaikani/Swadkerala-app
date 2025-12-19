import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Loading dialog utility for showing "Please wait" with circular progress
class LoadingDialog {
  static bool _isShowing = false;

  /// Show loading dialog with "Please wait" message
  static void show({String? message}) {
    // Prevent showing multiple dialogs
    if (_isShowing) {
      return;
    }
    
    _isShowing = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent dismissing by back button
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(40)),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(32)),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: ResponsiveUtils.rp(20),
                          offset: Offset(0, ResponsiveUtils.rp(10)),
                          spreadRadius: ResponsiveUtils.rp(2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated circular progress indicator
                        SizedBox(
                          width: ResponsiveUtils.rp(56),
                          height: ResponsiveUtils.rp(56),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring with subtle animation
                              Container(
                                width: ResponsiveUtils.rp(56),
                                height: ResponsiveUtils.rp(56),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.button.withOpacity(0.1),
                                ),
                              ),
                              // Main progress indicator
                              CircularProgressIndicator(
                                strokeWidth: ResponsiveUtils.rp(4),
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                                backgroundColor: AppColors.button.withOpacity(0.1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(24)),
                        // Message text with better typography
                        Text(
                          message ?? 'Please wait',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(8)),
                        // Subtle hint text
                        Text(
                          'This may take a moment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    ).then((_) {
      _isShowing = false;
    });
  }

  /// Hide loading dialog
  static void hide() {
    if (_isShowing) {
      final isDialogOpen = Get.isDialogOpen;
      if (isDialogOpen == true) {
        _isShowing = false;
        Get.back();
      }
    }
  }
}

