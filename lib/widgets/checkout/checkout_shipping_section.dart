import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/order/ordermodels.dart';
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
        return SizedBox.shrink();
      }

      // Check if order has shipping lines first
      final order = orderController.currentOrder.value;
      final hasShippingLine = order?.shippingLines.isNotEmpty ?? false;
      String? appliedShippingMethodId;
      
      if (hasShippingLine) {
        // Get the applied shipping method ID from order
        final shippingLine = order!.shippingLines.first;
        appliedShippingMethodId = shippingLine.shippingMethod.id;
      }
      
      // Get currently selected method from dropdown
      final selectedMethod = orderController.selectedShippingMethod.value;
      ShippingMethod? validSelectedMethod = selectedMethod != null
          ? orderController.shippingMethods.firstWhereOrNull(
              (method) => method.id == selectedMethod.id)
          : null;
      
      // If order has shipping line but no method selected in dropdown, set it
      if (hasShippingLine && appliedShippingMethodId != null && validSelectedMethod == null) {
        validSelectedMethod = orderController.shippingMethods.firstWhereOrNull(
          (method) => method.id == appliedShippingMethodId,
        );
        
        // Set selected method if found and not already set
        if (validSelectedMethod != null && 
            orderController.selectedShippingMethod.value?.id != appliedShippingMethodId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            orderController.selectedShippingMethod.value = validSelectedMethod;
          });
        }
      }
      
      // If selected method doesn't exist in list, clear it
      if (selectedMethod != null && validSelectedMethod == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          orderController.selectedShippingMethod.value = null;
        });
      }

      // Check if shipping is applied: 
      // - Order has shipping line AND
      // - Selected method matches the applied shipping method
      final isApplied = hasShippingLine && 
          appliedShippingMethodId != null &&
          validSelectedMethod != null &&
          validSelectedMethod.id == appliedShippingMethodId;

      final hasSingleMethod = orderController.shippingMethods.length == 1;
      final singleMethod = hasSingleMethod ? orderController.shippingMethods.first : null;
      
      // Auto-select single method if not already selected
      if (hasSingleMethod && validSelectedMethod == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          orderController.selectedShippingMethod.value = singleMethod;
          // Auto-apply single method
          onShippingMethodSelected();
        });
      }
      
      // For UI display: if there's only one method, show it as selected even if not applied
      final displayAsSelected = hasSingleMethod && singleMethod != null;
      final displayMethod = displayAsSelected ? singleMethod : validSelectedMethod;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Delivery Method',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(10),
                  vertical: ResponsiveUtils.rp(4),
                ),
                decoration: BoxDecoration(
                  color: (isApplied || displayAsSelected)
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  border: Border.all(
                    color: (isApplied || displayAsSelected)
                        ? AppColors.success
                        : AppColors.error,
                    width: 1,
                  ),
                ),
                child: Text(
                  (isApplied || displayAsSelected) ? 'Selected' : 'Not Selected',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(12),
                    fontWeight: FontWeight.w600,
                    color: (isApplied || displayAsSelected)
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),

          // Single Method Display (no dropdown) or Dropdown (multiple methods)
          if (hasSingleMethod && singleMethod != null)
            // Single method - show as selected, no dropdown
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.5),
                  width: 1.5,
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
                          singleMethod.name,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(2)),
                        Text(
                          '${singleMethod.description} - ${cartController.formatPrice(singleMethod.priceWithTax)}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(11),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            // Multiple methods - show dropdown, auto-apply on selection
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: displayMethod != null
                      ? AppColors.success.withValues(alpha: 0.5)
                      : AppColors.border.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  value: displayMethod ?? validSelectedMethod,
                  isExpanded: true,
                  hint: Text(
                    'Select Shipping Method',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(24),
                  ),
                  items: orderController.shippingMethods.map((method) {
                    return DropdownMenuItem<dynamic>(
                      value: method,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            method.name,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: ResponsiveUtils.rp(2)),
                          Text(
                            '${method.description} - ${cartController.formatPrice(method.priceWithTax)}',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(11),
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (method) async {
                    if (method != null) {
                      orderController.selectedShippingMethod.value = method;
                      // Auto-apply when method is selected
                      await onShippingMethodSelected();
                    }
                  },
                ),
              ),
            ),
        ],
      );
    });
  }
}
