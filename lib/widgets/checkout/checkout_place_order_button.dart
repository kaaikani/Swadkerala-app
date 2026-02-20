import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/price_formatter.dart';
import '../../graphql/Customer.graphql.dart';
import 'slide_to_pay_button.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  final CartController cartController;
  final OrderController orderController;
  final UtilityController utilityController;
  final BannerController bannerController;
  final Query$GetActiveCustomer$activeCustomer$addresses? selectedAddress;
  final GlobalKey<SlideToPayButtonState> slideActionKey;
  final bool orderPlacedSuccessfully;
  final Future<void> Function() onPlaceOrder;

  const CheckoutPlaceOrderButton({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.utilityController,
    required this.bannerController,
    required this.selectedAddress,
    required this.slideActionKey,
    required this.orderPlacedSuccessfully,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final isEnabled = selectedAddress != null &&
          orderController.selectedShippingMethod.value != null &&
          orderController.selectedPaymentMethod.value != null;
      final cart = cartController.cart.value;
      final total = cart?.totalWithTax ?? 0;

      // LOW_STOCK does not block checkout; only OUT_OF_STOCK does
      final hasOutOfStockItems = cart?.lines.any((line) {
        final stockLevel = line.productVariant.stockLevel.toUpperCase();
        final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
        final isProductDisabled = line.productVariant.product.enabled == false;
        return !line.isAvailable || isOutOfStock || isProductDisabled;
      }) ?? false;

      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
              if (hasOutOfStockItems) ...[
                Container(
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
                ),
              ],

              RepaintBoundary(
                child: SlideToPayButton(
                  key: slideActionKey,
                  text: 'Slide to Pay',
                  amount: total > 0 ? PriceFormatter.formatPrice(total.toInt()) : '',
                  isEnabled: isEnabled && !orderPlacedSuccessfully,
                  isLoading: isLoading,
                  onSubmit: () {
                    if (!isLoading && isEnabled && !orderPlacedSuccessfully) {
                      onPlaceOrder();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
