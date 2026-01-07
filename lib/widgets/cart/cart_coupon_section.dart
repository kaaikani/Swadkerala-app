import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/analytics_helper.dart';
import '../../widgets/snackbar.dart';
import '../../graphql/banner.graphql.dart';

class CartCouponSection extends StatelessWidget {
  final BannerController bannerController;
  final CartController cartController;
  final OrderController orderController;
  final VoidCallback onShowCouponBottomSheet;

  const CartCouponSection({
    super.key,
    required this.bannerController,
    required this.cartController,
    required this.orderController,
    required this.onShowCouponBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    // Hide coupon section if no coupons are available
    return Obx(() {
      if (bannerController.availableCouponCodes.isEmpty) {
        return const SizedBox.shrink();
      }
      
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Coupon Codes',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Obx(() {
                  final appliedCount = bannerController.appliedCouponCodes.length;
                  if (appliedCount > 0) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(10),
                        vertical: ResponsiveUtils.rp(6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      ),
                      child: Text(
                        '$appliedCount Applied',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveUtils.sp(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
        
            // Show applied coupon with remove button OR browse coupons button
            Obx(() {
              final isAnyCouponApplied = bannerController.isAnyCouponApplied();
              final appliedCouponCode = bannerController.getCurrentlyAppliedCoupon();
              
              if (isAnyCouponApplied && appliedCouponCode != null) {
                // Find the coupon details
                Query$GetCouponCodeList$getCouponCodeList$items? appliedCoupon;
                try {
                  appliedCoupon = bannerController.availableCouponCodes.firstWhere(
                    (c) => (c.couponCode ?? '').toLowerCase() == appliedCouponCode.toLowerCase(),
                  );
                } catch (e) {
                  // Coupon not found in list, show just the code
                }
                
                return Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: ResponsiveUtils.rp(20),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coupon Applied',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(12),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(4)),
                            Text(
                              appliedCoupon?.name ?? appliedCouponCode,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(14),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (appliedCouponCode != appliedCoupon?.name && appliedCoupon?.name != null)
                              Text(
                                appliedCouponCode,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(12),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: AnalyticsHelper.trackButtonAsync(
                          'Remove Coupon',
                          screenName: 'Cart',
                          callback: () async {
                            final success = await bannerController.removeCouponCode(appliedCouponCode);
                            if (success) {
                              await Future.delayed(const Duration(milliseconds: 500));
                              await Future.wait([
                                cartController.getActiveOrder(),
                                orderController.getActiveOrder(skipLoading: true),
                              ]);
                              showSuccessSnackbar('Coupon removed successfully');
                            } else {
                              showErrorSnackbar('Failed to remove coupon code');
                            }
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                          ),
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Show browse coupons button when no coupon is applied
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: AnalyticsHelper.trackButton(
                    'Browse Coupons',
                    screenName: 'Cart',
                    callback: onShowCouponBottomSheet,
                  ),
                  icon: Icon(Icons.local_offer, size: ResponsiveUtils.rp(20)),
                  label: const Text('Browse Coupons'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

