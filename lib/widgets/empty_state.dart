import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/responsive.dart';
import '../theme/colors.dart';
import '../controllers/theme_controller.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    
    return Container(
      color: AppColors.background,
      child: Center(
      child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.rp(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
                size: ResponsiveUtils.rp(80),
              color: isDarkMode 
                  ? AppColors.textSecondary.withValues(alpha: 0.5)
                  : AppColors.textSecondary.withValues(alpha: 0.4),
            ),
              SizedBox(height: ResponsiveUtils.rp(24)),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(18),
                  ),
              textAlign: TextAlign.center,
            ),
              SizedBox(height: ResponsiveUtils.rp(12)),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(14),
                  ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
                SizedBox(height: ResponsiveUtils.rp(24)),
              action!,
            ],
          ],
          ),
        ),
      ),
    );
  }
}
