import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../graphql/order.graphql.dart';
import '../../utils/responsive.dart';
import '../../theme/colors.dart';
import '../../services/graphql_client.dart';

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

      final borderColor = AppColors.border;

      final hasSingleMethod = orderController.shippingMethods.length == 1;
      final singleMethod = hasSingleMethod ? orderController.shippingMethods.first : null;
      final selectedMethod = orderController.selectedShippingMethod.value;
      
      // Find the matching method from the list to ensure object equality
      // DropdownButton requires the value to be the same instance as in items list
      Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled? matchingSelectedMethod;
      if (selectedMethod != null) {
        try {
          matchingSelectedMethod = orderController.shippingMethods.firstWhere(
            (method) => method.id == selectedMethod.id,
          );
        } catch (e) {
          // Method not found in list, set to null
          matchingSelectedMethod = null;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Container(
            padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
            child: Text(
              hasSingleMethod ? 'Delivery Method' : 'Select Delivery Method',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Show simple card for single method, dropdown for multiple methods
          if (hasSingleMethod && singleMethod != null)
            // Single method - show as simple card (no dropdown)
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(24),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          singleMethod.name,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            // Multiple methods - show dropdown
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled>(
                  value: matchingSelectedMethod,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: ResponsiveUtils.rp(24),
                    color: AppColors.icon,
                  ),
                  hint: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(16),
                      vertical: ResponsiveUtils.rp(12),
                    ),
                    child: Text(
                      'Select delivery method',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(15),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  items: orderController.shippingMethods.map((method) {
                    return DropdownMenuItem<Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled>(
                      value: method,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(16),
                          vertical: ResponsiveUtils.rp(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                method.name,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(13),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled? newMethod) async {
                    if (newMethod == null) return;
                    if (orderController.selectedShippingMethod.value?.id == newMethod.id) {
                      return;
                    }
                    orderController.selectedShippingMethod.value = newMethod;
                    await onShippingMethodSelected();
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return orderController.shippingMethods.map((method) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(16),
                          vertical: ResponsiveUtils.rp(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                method.name,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(15),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
        ],
      );
    });
  }
}
