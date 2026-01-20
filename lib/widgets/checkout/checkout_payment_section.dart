import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../graphql/order.graphql.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class CheckoutPaymentSection extends StatelessWidget {
  final OrderController orderController;

  const CheckoutPaymentSection({
    Key? key,
    required this.orderController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(12)),
        Obx(() {
          final eligibleMethods = orderController.paymentMethods
              .where((m) => m.isEligible)
              .toList();

          if (eligibleMethods.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: eligibleMethods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              final isLast = index == eligibleMethods.length - 1;

              return Column(
                children: [
                  _buildPaymentOption(method),
                  if (!isLast)
                    SizedBox(height: ResponsiveUtils.rp(12)),
                ],
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildPaymentOption(Query$GetEligiblePaymentMethods$eligiblePaymentMethods method) {
    return Obx(() {
      final isSelected =
          orderController.selectedPaymentMethod.value?.id == method.id;

      return InkWell(
        onTap: () {
          orderController.selectedPaymentMethod.value = method;
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.rp(12),
            horizontal: ResponsiveUtils.rp(0),
          ),
          child: Row(
            children: [
              _buildRadio(isSelected),
              SizedBox(width: ResponsiveUtils.rp(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name.isNotEmpty ? method.name : _getPaymentMethodName(method.code),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (method.eligibilityMessage != null && method.eligibilityMessage!.isNotEmpty) ...[
                      SizedBox(height: ResponsiveUtils.rp(4)),
                      Text(
                        method.eligibilityMessage!,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: ResponsiveUtils.rp(22),
      height: ResponsiveUtils.rp(22),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.button : AppColors.border,
          width: 2,
        ),
        color: isSelected ? AppColors.button : Colors.transparent,
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: ResponsiveUtils.rp(14),
              color: Colors.white,
            )
          : null,
    );
  }

  String _getPaymentMethodName(String code) {
    switch (code.toLowerCase()) {
      case 'cod':
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      case 'razorpay':
      case 'online':
        return 'Online Payment';
      default:
        return code.toUpperCase();
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: ResponsiveUtils.rp(20)),
          SizedBox(width: ResponsiveUtils.rp(12)),
          Expanded(
            child: Text(
              'No payment methods available.',
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
