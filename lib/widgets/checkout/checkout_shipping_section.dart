import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../graphql/order.graphql.dart';
import '../../utils/responsive.dart';
import '../../theme/colors.dart';

class CheckoutShippingSection extends StatelessWidget {
  final OrderController orderController;
  final CartController cartController;
  final Future<void> Function() onShippingMethodSelected;

  const CheckoutShippingSection({
    Key? key,
    required this.orderController,
    required this.cartController,
    required this.onShippingMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderController.shippingMethods.isEmpty) {
        return _buildEmptyState();
      }

      final methods = orderController.shippingMethods;
      final selectedMethod = orderController.selectedShippingMethod.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: methods.asMap().entries.map((entry) {
          final index = entry.key;
          final method = entry.value;
          final isSelected = selectedMethod?.id == method.id;
          final isLast = index == methods.length - 1;

          return Column(
            children: [
              _buildShippingOption(method, isSelected),
              if (!isLast) SizedBox(height: ResponsiveUtils.rp(10)),
            ],
          );
        }).toList(),
      );
    });
  }

  Widget _buildShippingOption(
    Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled method,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () async {
        if (orderController.selectedShippingMethod.value?.id == method.id) return;
        orderController.selectedShippingMethod.value = method;
        await onShippingMethodSelected();
      },
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(14),
          vertical: ResponsiveUtils.rp(14),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.button.withValues(alpha: 0.06)
              : AppColors.background,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
          border: Border.all(
            color: isSelected
                ? AppColors.button.withValues(alpha: 0.5)
                : AppColors.border.withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: ResponsiveUtils.rp(22),
              height: ResponsiveUtils.rp(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.button : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.button : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: ResponsiveUtils.rp(14), color: Colors.white)
                  : null,
            ),
            SizedBox(width: ResponsiveUtils.rp(12)),
            // Shipping icon
            Icon(
              Icons.local_shipping_outlined,
              color: isSelected ? AppColors.button : AppColors.textSecondary,
              size: ResponsiveUtils.rp(20),
            ),
            SizedBox(width: ResponsiveUtils.rp(10)),
            // Method name
            Expanded(
              child: Text(
                method.name,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.button,
                size: ResponsiveUtils.rp(18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(8)),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.textSecondary, size: ResponsiveUtils.rp(20)),
          SizedBox(width: ResponsiveUtils.rp(10)),
          Expanded(
            child: Text(
              'No shipping methods available.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.sp(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
