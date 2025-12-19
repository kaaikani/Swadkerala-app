import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/banner/bannermodels.dart';
import '../../controllers/customer/customer_models.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  final AddressModel? selectedAddress;
  final Function() onPlaceOrder;
  final GlobalKey<SlideActionState> slideActionKey;
  final bool orderPlacedSuccessfully;

  const CheckoutPlaceOrderButton({
    Key? key,
    required this.selectedAddress,
    required this.onPlaceOrder,
    required this.slideActionKey,
    this.orderPlacedSuccessfully = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final orderController = Get.find<OrderController>();
    final bannerController = Get.find<BannerController>();
    final utilityController = Get.find<UtilityController>();

    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final isEnabled = selectedAddress != null &&
          orderController.selectedShippingMethod.value != null &&
          orderController.selectedPaymentMethod.value != null;
      final cart = cartController.cart.value;
      final total = cart?.totalWithTax ?? 0;

      // Check for out of stock items
      final hasOutOfStockItems = cart?.lines.any((line) {
        final stockLevel = line.productVariant.stockLevel?.toUpperCase();
        final isLowStock = stockLevel == 'LOW_STOCK';
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isProductDisabled = line.productVariant.productEnabled == false;
        return !line.isAvailable ||
            isLowStock ||
            isOutOfStock ||
            isProductDisabled;
      }) ?? false;

      // Get eligible coupons
      final subTotalValue = orderController.currentOrder.value?.subTotalWithTax ?? 0;
      final subTotal = (subTotalValue as num).toInt();
      final eligibleCoupons = bannerController.getEligibleCoupons(subTotal);

      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: ResponsiveUtils.rp(20),
              offset: Offset(0, -ResponsiveUtils.rp(4)),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasOutOfStockItems) _buildOutOfStockBanner(),
              if (!hasOutOfStockItems && eligibleCoupons.isNotEmpty)
                _buildCouponUnlockBanner(eligibleCoupons.first, subTotal),
              isLoading ? _buildLoadingButton() : _buildPlaceOrderButton(isEnabled, total.toInt()),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOutOfStockBanner() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: AppColors.error,
            size: ResponsiveUtils.rp(20),
          ),
          SizedBox(width: ResponsiveUtils.rp(8)),
          Expanded(
            child: Text(
              'Some items are out of stock. Please remove them to proceed.',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponUnlockBanner(CouponCodeModel coupon, int currentSubTotal) {
    final bannerController = Get.find<BannerController>();
    return Obx(() {
      final requiredAmount = bannerController.getRequiredAmount(coupon);
      final difference = requiredAmount - currentSubTotal;

      if (difference > 0) {
        final differenceInRupees = difference / 100.0;
        return Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1a1a2e),
                const Color(0xFF16213e),
                const Color(0xFF0f3460),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: ResponsiveUtils.rp(8),
                offset: Offset(0, ResponsiveUtils.rp(4)),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_offer_rounded,
                color: AppColors.buttonText,
                size: ResponsiveUtils.rp(18),
              ),
              Expanded(
                child: Text(
                  'Add ₹${differenceInRupees.toStringAsFixed(2)} more to unlock coupon \'${coupon.couponCode}\'',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonText,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _buildLoadingButton() {
    return Container(
      height: ResponsiveUtils.rp(60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        color: AppColors.inputBorder,
      ),
      child: Center(
        child: SizedBox(
          width: ResponsiveUtils.rp(24),
          height: ResponsiveUtils.rp(24),
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonText),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton(bool isEnabled, int total) {
    return SlideAction(
      key: slideActionKey,
      height: ResponsiveUtils.rp(60),
      borderRadius: ResponsiveUtils.rp(16),
      innerColor: AppColors.buttonText,
      outerColor: isEnabled ? AppColors.button : AppColors.inputBorder,
      text: isEnabled && total > 0
          ? 'Place Order - ₹${(total / 100).toStringAsFixed(2)}'
          : 'Place Order',
      textStyle: TextStyle(
        fontSize: ResponsiveUtils.sp(16),
        fontWeight: FontWeight.bold,
        color: isEnabled ? AppColors.buttonText : AppColors.textSecondary,
      ),
      sliderButtonIcon: Icon(
        Icons.arrow_forward_ios_rounded,
        color: isEnabled ? AppColors.button : AppColors.textSecondary,
        size: ResponsiveUtils.rp(20),
      ),
      sliderButtonIconPadding: ResponsiveUtils.rp(12),
      submittedIcon: Icon(
        Icons.check_circle_rounded,
        color: AppColors.buttonText,
        size: ResponsiveUtils.rp(20),
      ),
      onSubmit: () {
        final utilityController = Get.find<UtilityController>();
        if (!utilityController.isLoadingRx.value &&
            isEnabled &&
            !orderPlacedSuccessfully) {
          onPlaceOrder();
        }
        return null;
      },
    );
  }
}

