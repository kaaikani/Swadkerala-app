import 'package:flutter/material.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/checkout/checkout_shipping_section.dart';

class CartShippingSection extends StatelessWidget {
  final OrderController orderController;
  final CartController cartController;
  final Future<void> Function() onShippingMethodSelected;

  const CartShippingSection({
    super.key,
    required this.orderController,
    required this.cartController,
    required this.onShippingMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
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
      child: CheckoutShippingSection(
        orderController: orderController,
        cartController: cartController,
        onShippingMethodSelected: onShippingMethodSelected,
      ),
    );
  }
}

