import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CheckoutShimmerLoading extends StatelessWidget {
  const CheckoutShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDarkMode = themeController.isDarkMode;
      return Skeletonizer(
        enabled: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ResponsiveUtils.rp(120),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(16)),
              Container(
                height: ResponsiveUtils.rp(20),
                width: ResponsiveUtils.rp(150),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              ...List.generate(
                2,
                (index) => Container(
                  height: ResponsiveUtils.rp(60),
                  margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(24)),
              Container(
                height: ResponsiveUtils.rp(20),
                width: ResponsiveUtils.rp(150),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              ...List.generate(
                4,
                (index) => Container(
                  height: ResponsiveUtils.rp(40),
                  margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(24)),
              Container(
                height: ResponsiveUtils.rp(48),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

