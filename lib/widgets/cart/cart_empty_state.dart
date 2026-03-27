import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../services/graphql_client.dart';
import '../../utils/analytics_helper.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.button;
    final buttonColor = AppColors.button;

    return Container(
        width: double.infinity,
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large animated cart icon with background circle
              Container(
                width: ResponsiveUtils.rp(180),
                height: ResponsiveUtils.rp(180),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: ResponsiveUtils.rp(100),
                  color: iconColor,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(32)),
              
              // Title
              Text(
                'Your Cart is Empty',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(24),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              
              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(48),
                ),
                child: Text(
                  'Looks like you haven\'t added anything to your cart yet',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(48)),
              
              // CTA Button with icon
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(32),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: AnalyticsHelper.trackButtonAsync(
                      'Close Empty Cart',
                      screenName: 'Cart',
                      callback: () async {
                        Get.back();
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.rp(16),
                        horizontal: ResponsiveUtils.rp(24),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.rp(12),
                        ),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          size: ResponsiveUtils.rp(20),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        Text(
                          'Start Shopping',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: ResponsiveUtils.rp(24)),
              
              // Additional helpful text
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/home');
                },
                child: Text(
                  'Browse Products',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    color: buttonColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

