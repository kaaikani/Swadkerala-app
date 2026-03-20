import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../routes.dart';

class AccountGuestProfileCard extends StatelessWidget {
  const AccountGuestProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'Your Account',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(24),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Center(
            child: Text(
              'Sign up or log in to access your orders, wishlist, and more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(24)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveUtils.sp(15),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(12)),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.button,
                    side: BorderSide(color: AppColors.button),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveUtils.sp(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
