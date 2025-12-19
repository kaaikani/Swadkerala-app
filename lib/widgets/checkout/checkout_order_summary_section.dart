import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../controllers/banner/bannermodels.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CheckoutOrderSummarySection extends StatelessWidget {
  const CheckoutOrderSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final orderController = Get.find<OrderController>();
    final bannerController = Get.find<BannerController>();
    final utilityController = Get.find<UtilityController>();

    return Obx(() {
      final cart = cartController.cart.value;
      final isLoading = utilityController.isLoadingRx.value;

      if (cart == null && isLoading) {
        return _buildLoadingState();
      }

      final itemCount = cart?.lines.length ?? 0;
      final subtotal = cart?.subTotalWithTax ?? 0;
      final shipping =
          orderController.selectedShippingMethod.value?.priceWithTax ?? 0;
      final total = cart?.totalWithTax ?? 0;
      final hasFreeShipping = cartController.hasFreeShippingCoupon();

      // Get applied coupon details
      final appliedCouponCode = bannerController.getCurrentlyAppliedCoupon();
      String? appliedCouponName;
      bool hasFreeShippingInCoupon = false;

      if (appliedCouponCode != null) {
        final coupon = bannerController.availableCouponCodes.firstWhere(
          (c) => c.couponCode.toUpperCase() == appliedCouponCode.toUpperCase(),
          orElse: () => CouponCodeModel(
            id: '',
            name: '',
            couponCode: '',
            enabled: false,
            createdAt: '',
            updatedAt: '',
            description: '',
            startsAt: '',
            endsAt: '',
            perCustomerUsageLimit: 0,
            usageLimit: 0,
            actions: [],
            conditions: [],
          ),
        );

        if (coupon.id.isNotEmpty) {
          appliedCouponName = coupon.name;
          hasFreeShippingInCoupon = coupon.actions.any(
            (action) => action.code == 'free_shipping',
          );
        }
      }

      // Loyalty Points
      final loyaltyPointsUsed = bannerController.loyaltyPointsUsed.value;
      final loyaltyPointsApplied = bannerController.loyaltyPointsApplied.value;
      final config = bannerController.loyaltyPointsConfig.value;
      final rupeesPerPoint = config?.rupeesPerPoint ?? 0;

      final loyaltyDiscountAmount =
          loyaltyPointsApplied && loyaltyPointsUsed > 0 && rupeesPerPoint > 0
              ? (loyaltyPointsUsed * rupeesPerPoint).toInt()
              : 0;

      final totalDiscount = ((subtotal + (hasFreeShipping ? 0 : shipping) - total)).toInt();
      final couponDiscount = bannerController.appliedCouponCodes.isNotEmpty
          ? (totalDiscount - loyaltyDiscountAmount)
          : 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Text(
              'Order Summary',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Items ($itemCount)',
                  '₹${(subtotal / 100).toStringAsFixed(2)}',
                ),
                SizedBox(height: ResponsiveUtils.rp(12)),
                if (hasFreeShipping &&
                    hasFreeShippingInCoupon &&
                    appliedCouponCode != null)
                  _buildFreeShippingRow(appliedCouponCode)
                else
                  _buildSummaryRow(
                    'Delivery Charge',
                    hasFreeShipping
                        ? 'FREE'
                        : '₹${(shipping / 100).toStringAsFixed(2)}',
                    valueColor: hasFreeShipping ? AppColors.success : null,
                  ),
                if (loyaltyPointsApplied &&
                    loyaltyPointsUsed > 0 &&
                    loyaltyDiscountAmount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildSummaryRow(
                    'Loyalty Points Discount',
                    '-₹${(loyaltyDiscountAmount / 100).toStringAsFixed(2)}',
                    valueColor: AppColors.success,
                  ),
                ],
                if (bannerController.appliedCouponCodes.isNotEmpty &&
                    couponDiscount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildCouponDiscountRow(
                    appliedCouponName ?? 'Coupon Discount',
                    couponDiscount,
                  ),
                ],
                SizedBox(height: ResponsiveUtils.rp(16)),
                Divider(height: 1),
                SizedBox(height: ResponsiveUtils.rp(16)),
                _buildTotalRow(total),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(18),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(20)),
              child: CircularProgressIndicator(
                color: AppColors.button,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFreeShippingRow(String couponCode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Charge',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(15),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(4)),
              Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    size: ResponsiveUtils.rp(14),
                    color: AppColors.success,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(4)),
                  Flexible(
                    child: Text(
                      'Applied: $couponCode',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'FREE',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponDiscountRow(String couponName, num discountAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.local_offer,
                size: ResponsiveUtils.rp(16),
                color: AppColors.success,
              ),
              SizedBox(width: ResponsiveUtils.rp(6)),
              Flexible(
                child: Text(
                  'Coupon: $couponName',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(15),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Text(
          '-₹${(discountAmount / 100).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(num total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '₹${(total / 100).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(20),
            fontWeight: FontWeight.bold,
            color: AppColors.button,
          ),
        ),
      ],
    );
  }
}

