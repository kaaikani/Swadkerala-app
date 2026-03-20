import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/analytics_helper.dart';
import '../../widgets/snackbar.dart';

class CartCouponBottomSheet {
  static void show({
    required BuildContext context,
    required BannerController bannerController,
    required CartController cartController,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.rp(20)),
            topRight: Radius.circular(ResponsiveUtils.rp(20)),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
              width: ResponsiveUtils.rp(40),
              height: ResponsiveUtils.rp(4),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Coupon Codes',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: ResponsiveUtils.rp(24),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: ResponsiveUtils.rp(1), color: AppColors.divider),
            Expanded(
              child: Obx(() {
                if (!bannerController.couponCodesLoaded.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.button),
                  );
                }

                final enabledCoupons = bannerController.availableCouponCodes
                    .where((coupon) => coupon.promotion.enabled)
                    .toList();

                if (enabledCoupons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: ResponsiveUtils.rp(64),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: ResponsiveUtils.rp(16)),
                        Text(
                          'No coupon codes available',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.extentAfter < 200 &&
                        !bannerController.isLoadingMoreCoupons.value &&
                        bannerController.hasMoreCoupons.value) {
                      bannerController.loadMoreCoupons();
                    }
                    return false;
                  },
                  child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                  itemCount: enabledCoupons.length + (bannerController.hasMoreCoupons.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= enabledCoupons.length) {
                      return Padding(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                        child: Center(
                          child: bannerController.isLoadingMoreCoupons.value
                              ? CircularProgressIndicator(color: AppColors.button)
                              : SizedBox.shrink(),
                        ),
                      );
                    }
                    final coupon = enabledCoupons[index];
                    final isApplied =
                        bannerController.isCouponCodeApplied(coupon.promotion.couponCode ?? '');
                    final descriptionText = coupon.promotion.description.replaceAll(RegExp(r'<[^>]*>'), '');

                    return Card(
                      color: AppColors.surface,
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                      elevation: ResponsiveUtils.rp(2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.rp(12)),
                        side: BorderSide(
                          color:
                              isApplied ? AppColors.success : AppColors.border,
                          width: isApplied
                              ? ResponsiveUtils.rp(2)
                              : ResponsiveUtils.rp(1),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.rp(8),
                                    vertical: ResponsiveUtils.rp(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isApplied
                                        ? AppColors.success
                                        : AppColors.button,
                                    borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.rp(6)),
                                  ),
                                  child: Text(
                                    coupon.promotion.couponCode ?? '',
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveUtils.sp(12),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                if (isApplied)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.rp(8),
                                      vertical: ResponsiveUtils.rp(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.rp(6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: AppColors.textLight,
                                          size: ResponsiveUtils.rp(14),
                                        ),
                                        SizedBox(width: ResponsiveUtils.rp(4)),
                                        Text(
                                          'APPLIED',
                                          style: TextStyle(
                                            color: AppColors.textLight,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveUtils.sp(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: ResponsiveUtils.rp(12)),

                            // Action info (what discount the user gets)
                            Builder(builder: (context) {
                              final actions = bannerController.getCouponActionInfo(coupon);
                              if (actions.isEmpty) return SizedBox.shrink();
                              return Padding(
                                padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
                                child: Wrap(
                                  spacing: ResponsiveUtils.rp(6),
                                  runSpacing: ResponsiveUtils.rp(6),
                                  children: actions.map((action) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.rp(8),
                                      vertical: ResponsiveUtils.rp(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                      border: Border.all(
                                        color: AppColors.success.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.local_offer, size: ResponsiveUtils.rp(14), color: AppColors.success),
                                        SizedBox(width: ResponsiveUtils.rp(4)),
                                        Text(
                                          action.displayText,
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(11),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ),
                              );
                            }),

                            if (descriptionText.isNotEmpty) ...[
                              SizedBox(height: ResponsiveUtils.rp(8)),
                              Text(
                                descriptionText,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.sp(14),
                                ),
                              ),
                            ],

                            // Condition requirements with met/unmet status
                            Builder(builder: (context) {
                              final conditions = bannerController.getCouponConditionStatus(coupon);
                              if (conditions.isEmpty) return SizedBox.shrink();
                              return Padding(
                                padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: conditions.map((cond) => Padding(
                                    padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(4)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          cond.canValidate
                                            ? (cond.isMet ? Icons.check_circle : Icons.cancel)
                                            : Icons.info_outline,
                                          size: ResponsiveUtils.rp(16),
                                          color: cond.canValidate
                                            ? (cond.isMet ? AppColors.success : AppColors.error)
                                            : AppColors.textSecondary,
                                        ),
                                        SizedBox(width: ResponsiveUtils.rp(6)),
                                        Expanded(child: Text(
                                          cond.displayText,
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(12),
                                            fontWeight: FontWeight.w500,
                                            color: cond.canValidate
                                              ? (cond.isMet ? AppColors.success : AppColors.error)
                                              : AppColors.textSecondary,
                                          ),
                                        )),
                                      ],
                                    ),
                                  )).toList(),
                                ),
                              );
                            }),

                            // Usage limits display
                            if (coupon.promotion.usageLimit != null || coupon.promotion.perCustomerUsageLimit != null) ...[
                              SizedBox(height: ResponsiveUtils.rp(8)),
                              Wrap(
                                spacing: ResponsiveUtils.rp(8),
                                runSpacing: ResponsiveUtils.rp(8),
                                children: [
                                  if (coupon.promotion.usageLimit != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUtils.rp(8),
                                        vertical: ResponsiveUtils.rp(4),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.info.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                        border: Border.all(
                                          color: AppColors.info.withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.people_outline,
                                            size: ResponsiveUtils.rp(14),
                                            color: AppColors.info,
                                          ),
                                          SizedBox(width: ResponsiveUtils.rp(4)),
                                          Text(
                                            'Total uses: ${coupon.promotion.usageLimit}',
                                            style: TextStyle(
                                              fontSize: ResponsiveUtils.sp(11),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.info,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (coupon.promotion.perCustomerUsageLimit != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUtils.rp(8),
                                        vertical: ResponsiveUtils.rp(4),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.button.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                        border: Border.all(
                                          color: AppColors.button.withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.person_outline,
                                            size: ResponsiveUtils.rp(14),
                                            color: AppColors.button,
                                          ),
                                          SizedBox(width: ResponsiveUtils.rp(4)),
                                          Text(
                                            'Per customer: ${coupon.promotion.perCustomerUsageLimit}',
                                            style: TextStyle(
                                              fontSize: ResponsiveUtils.sp(11),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.button,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                            
                            SizedBox(height: ResponsiveUtils.rp(12)),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isApplied
                                    ? AnalyticsHelper.trackButtonAsync(
                                        'Remove Coupon - List',
                                        screenName: 'Cart',
                                        callback: () async {
                                          final canRemove = bannerController.appliedCouponCodes.length < 2;
                                          if (!canRemove) {
                                            showErrorSnackbar('Cannot remove coupon when multiple coupons are applied');
                                            return;
                                          }
                                          
                                          // Show loading dialog
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (dialogContext) => WillPopScope(
                                              onWillPop: () async => false,
                                              child: Dialog(
                                                backgroundColor: Colors.transparent,
                                                elevation: 0,
                                                child: Container(
                                                  padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.surface,
                                                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: AppColors.button,
                                                      ),
                                                      SizedBox(height: ResponsiveUtils.rp(16)),
                                                      Text(
                                                        'Removing coupon code...',
                                                        style: TextStyle(
                                                          fontSize: ResponsiveUtils.sp(16),
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.textPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                          
                                          // Wait for 2 seconds
                                          await Future.delayed(const Duration(seconds: 2));
                                          
                                          // Close the dialog
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          
                                          // Close the bottom sheet after dialog closes
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          
                                          await bannerController.removeCouponCode(coupon.promotion.couponCode ?? '');
                                        },
                                      )
                                    : AnalyticsHelper.trackButtonAsync(
                                        'Apply Coupon - List',
                                        screenName: 'Cart',
                                        callback: () async {
                                          final couponCode = coupon.promotion.couponCode ?? '';

                                          // Show loading dialog
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (dialogContext) => WillPopScope(
                                              onWillPop: () async => false,
                                              child: Dialog(
                                                backgroundColor: Colors.transparent,
                                                elevation: 0,
                                                child: Container(
                                                  padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.surface,
                                                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: AppColors.button,
                                                      ),
                                                      SizedBox(height: ResponsiveUtils.rp(16)),
                                                      Text(
                                                        'Applying coupon code...',
                                                        style: TextStyle(
                                                          fontSize: ResponsiveUtils.sp(16),
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.textPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                          
                                          // Wait for 2 seconds
                                          await Future.delayed(const Duration(seconds: 2));
                                          
                                          // Close the dialog
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          
                                          // Close the bottom sheet after dialog closes
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          
                                          // Now apply the coupon
                                          final hasProducts = bannerController.hasCouponProducts(couponCode);
                                          
                                          final result = hasProducts
                                              ? await bannerController.applyCouponCodeWithProducts(couponCode)
                                              : await bannerController.applyCouponCode(couponCode);
                                          
                                          if (result['success'] == true) {
                                            // Success message already handled by controller
                                          } else if (result['dialogShown'] != true && result['suppressSnackbar'] != true) {
                                            if (result['rollbackPerformed'] == true) {
                                              showErrorSnackbar(result['message'] ?? 'Failed to apply coupon. Added products have been removed.');
                                            } else {
                                              showErrorSnackbar(result['message'] ?? 'Failed to apply coupon');
                                            }
                                          }
                                        },
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isApplied
                                      ? AppColors.error
                                      : AppColors.button,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveUtils.rp(12)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(ResponsiveUtils.rp(8))),
                                ),
                                child: Text(
                                  isApplied ? 'Remove Coupon' : 'Apply Coupon',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveUtils.sp(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

