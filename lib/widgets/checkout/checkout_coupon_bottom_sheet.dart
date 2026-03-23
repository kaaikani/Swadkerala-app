import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/html_utils.dart';
import '../../widgets/snackbar.dart';

class CheckoutCouponBottomSheet {
  static void show({
    required BuildContext context,
    required BannerController bannerController,
    required CartController cartController,
    required OrderController orderController,
    required VoidCallback onStateChanged,
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
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
              width: ResponsiveUtils.rp(40),
              height: ResponsiveUtils.rp(4),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
              ),
            ),

            // Header
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

            // Coupon codes list
            Expanded(
              child: Obx(() {
                if (!bannerController.couponCodesLoaded.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.button),
                  );
                }

                final enabledCoupons = bannerController.availableCouponCodes.toList();

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
                    final descriptionText =
                        HtmlUtils.stripHtmlTags(coupon.promotion.description);

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
                            // Coupon header
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

                            SizedBox(height: ResponsiveUtils.rp(8)),

                            // Condition requirements with met/unmet status
                            Obx(() {
                              // Access reactive cart to trigger rebuild on changes
                              cartController.cart.value;
                              final conditions = bannerController.getCouponConditionStatus(coupon);
                              if (conditions.isEmpty) return SizedBox.shrink();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: conditions.map((cond) {
                                  // If coupon is applied, all conditions are met (server validated)
                                  final effectivelyMet = isApplied || (cond.canValidate && cond.isMet);
                                  final showAsInfo = !isApplied && !cond.canValidate;
                                  return Padding(
                                  padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(4)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        showAsInfo
                                          ? Icons.info_outline
                                          : (effectivelyMet ? Icons.check_circle : Icons.cancel),
                                        size: ResponsiveUtils.rp(16),
                                        color: showAsInfo
                                          ? AppColors.textSecondary
                                          : (effectivelyMet ? AppColors.success : AppColors.error),
                                      ),
                                      SizedBox(width: ResponsiveUtils.rp(6)),
                                      Expanded(child: Text(
                                        cond.displayText,
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(12),
                                          fontWeight: FontWeight.w500,
                                          color: showAsInfo
                                            ? AppColors.textSecondary
                                            : (effectivelyMet ? AppColors.success : AppColors.error),
                                        ),
                                      )),
                                    ],
                                  ),
                                );
                                }).toList(),
                              );
                            }),

                            SizedBox(height: ResponsiveUtils.rp(8)),

                            // Description
                            if (descriptionText.isNotEmpty) ...[
                              Text(
                                descriptionText,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.sp(14),
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.rp(8)),
                            ],

                            // Usage limits display
                            if (coupon.promotion.usageLimit != null || coupon.promotion.perCustomerUsageLimit != null) ...[
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
                              SizedBox(height: ResponsiveUtils.rp(8)),
                            ],

                            // Expiry date
                            if (coupon.promotion.endsAt != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: ResponsiveUtils.rp(16),
                                    color: AppColors.error,
                                  ),
                                  SizedBox(width: ResponsiveUtils.rp(4)),
                                  Text(
                                    'Expires: ${coupon.promotion.endsAt != null ? coupon.promotion.endsAt!.toString().split(' ')[0] : 'N/A'}',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: ResponsiveUtils.sp(12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveUtils.rp(8)),
                            ],

                            // Validation status
                            if (!isApplied) ...[
                              FutureBuilder<Map<String, dynamic>>(
                                future:
                                    bannerController.getCouponValidationStatus(
                                        coupon.promotion.couponCode ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final validation = snapshot.data!;
                                    if (!validation['valid']) {
                                      Color errorColor = AppColors.warning;
                                      if (validation['error'] ==
                                          'MINIMUM_ORDER_AMOUNT_NOT_MET') {
                                        errorColor = AppColors.error;
                                      } else if (validation['error'] ==
                                              'COUPON_EXPIRED' ||
                                          validation['error'] ==
                                              'COUPON_DISABLED') {
                                        errorColor = AppColors.textSecondary;
                                      } else if (validation['error'] ==
                                          'ANOTHER_COUPON_APPLIED') {
                                        errorColor = AppColors.info;
                                      }

                                      return Container(
                                        padding: EdgeInsets.all(
                                            ResponsiveUtils.rp(8)),
                                        decoration: BoxDecoration(
                                          color:
                                              errorColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveUtils.rp(6)),
                                          border: Border.all(
                                              color: errorColor.withValues(
                                                  alpha: 0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: errorColor,
                                              size: ResponsiveUtils.rp(16),
                                            ),
                                            SizedBox(
                                                width: ResponsiveUtils.rp(8)),
                                            Expanded(
                                              child: Text(
                                                validation['message'],
                                                style: TextStyle(
                                                  color: errorColor,
                                                  fontSize:
                                                      ResponsiveUtils.sp(11),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                              SizedBox(height: ResponsiveUtils.rp(12)),
                            ],

                            // Apply/Remove button
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                final anyCouponApplied =
                                    bannerController.isAnyCouponApplied();
                                final currentlyAppliedCoupon = bannerController
                                    .getCurrentlyAppliedCoupon();
                                final isAnotherCouponApplied =
                                    anyCouponApplied &&
                                        currentlyAppliedCoupon !=
                                            coupon.promotion.couponCode;
                                final appliedCouponCount = bannerController.appliedCouponCodes.length;
                                final canRemoveCoupon = appliedCouponCount < 2;

                                final allConditionsMet = bannerController.areAllConditionsMet(coupon);

                                return ElevatedButton(
                                  onPressed: (isAnotherCouponApplied || (isApplied && !canRemoveCoupon) || (!isApplied && !allConditionsMet))
                                      ? null
                                      : () async {
                                          if (isApplied) {
                                            if (!canRemoveCoupon) {
                                              showErrorSnackbar(
                                                  'Cannot remove coupon when 2 or more coupons are applied');
                                              return;
                                            }
                                            final couponCodeToRemove = coupon.promotion.couponCode;
                                            final hadProducts = bannerController.couponAddedProducts.containsKey(couponCodeToRemove);
                                            
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
                                            
                                            final success =
                                                await bannerController
                                                    .removeCouponCode(
                                                        couponCodeToRemove ?? '');
                                            if (success) {
                                              await Future.delayed(Duration(milliseconds: 500));
                                              
                                              await Future.wait([
                                                cartController.getActiveOrder(),
                                                orderController.getActiveOrder(skipLoading: true),
                                              ]);
                                              
                                              final message = hadProducts
                                                  ? 'Coupon code and associated products removed successfully'
                                                  : 'Coupon code removed successfully';
                                              
                                              showSuccessSnackbar(message);
                                              onStateChanged();
                                            } else {
                                              showErrorSnackbar(
                                                  'Failed to remove coupon code');
                                            }
                                          } else {
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
                                            
                                            final hasProducts = bannerController
                                                .hasCouponProducts(couponCode);
                                            
                                            if (hasProducts) {
                                              final result = await bannerController
                                                  .applyCouponCodeWithProducts(couponCode);
                                              if (result['success']) {
                                                showSuccessSnackbar(result[
                                                        'message'] ??
                                                    'Coupon applied successfully with products added!');
                                                onStateChanged();
                                              } else if (result['dialogShown'] != true && result['suppressSnackbar'] != true) {
                                                if (result[
                                                        'rollbackPerformed'] ==
                                                    true) {
                                                  showErrorSnackbar(result[
                                                          'message'] ??
                                                      'Failed to apply coupon. Added products have been removed.');
                                                } else {
                                                  showErrorSnackbar(result[
                                                          'message'] ??
                                                      'Failed to apply coupon code');
                                                }
                                              }
                                            } else {
                                              final result =
                                                  await bannerController
                                                      .applyCouponCode(couponCode);
                                              if (result['success']) {
                                                showSuccessSnackbar(result[
                                                        'message'] ??
                                                    'Coupon applied successfully!');
                                                onStateChanged();
                                              } else {
                                                showErrorSnackbar(result[
                                                        'message'] ??
                                                    'Failed to apply coupon code');
                                              }
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: (isAnotherCouponApplied || (isApplied && !canRemoveCoupon) || (!isApplied && !allConditionsMet))
                                        ? AppColors.grey300
                                        : (isApplied
                                            ? AppColors.error
                                            : AppColors.success),
                                    foregroundColor: AppColors.textLight,
                                    padding: EdgeInsets.symmetric(
                                        vertical: ResponsiveUtils.rp(12)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.rp(8)),
                                    ),
                                  ),
                                  child: Text(
                                    isAnotherCouponApplied
                                        ? 'Another Coupon Applied'
                                        : (isApplied && !canRemoveCoupon)
                                            ? 'Cannot Remove'
                                            : (!isApplied && !allConditionsMet)
                                                ? 'Conditions Not Met'
                                            : (isApplied
                                                ? 'Remove Coupon'
                                                : 'Apply Coupon'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveUtils.sp(14),
                                    ),
                                  ),
                                );
                              }),
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


