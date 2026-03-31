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
    return Obx(() {
      final eligibleMethods = orderController.paymentMethods
          .where((m) => m.isEligible)
          .toList();

      if (eligibleMethods.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: eligibleMethods.asMap().entries.map((entry) {
          final index = entry.key;
          final method = entry.value;
          final isSelected = orderController.selectedPaymentMethod.value?.id == method.id;
          final isLast = index == eligibleMethods.length - 1;

          return Column(
            children: [
              _buildPaymentOption(method, isSelected),
              if (!isLast) SizedBox(height: ResponsiveUtils.rp(10)),
            ],
          );
        }).toList(),
      );
    });
  }

  Widget _buildPaymentOption(
    Query$GetEligiblePaymentMethods$eligiblePaymentMethods method,
    bool isSelected,
  ) {
    final methodName = method.name.isNotEmpty ? method.name : _getPaymentMethodName(method.code);
    final icon = _getPaymentIcon(method.code);

    return InkWell(
      onTap: () {
        orderController.selectedPaymentMethod.value = method;
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
            // Payment icon
            Icon(
              icon,
              color: isSelected ? AppColors.button : AppColors.textSecondary,
              size: ResponsiveUtils.rp(20),
            ),
            SizedBox(width: ResponsiveUtils.rp(10)),
            // Method name and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    methodName,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  if (method.eligibilityMessage != null && method.eligibilityMessage!.isNotEmpty) ...[
                    SizedBox(height: ResponsiveUtils.rp(2)),
                    Text(
                      method.eligibilityMessage!,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
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

  IconData _getPaymentIcon(String code) {
    final lowerCode = code.toLowerCase();
    if (lowerCode.contains('razorpay') || lowerCode.contains('online')) {
      return Icons.credit_card_rounded;
    } else if (lowerCode.contains('cod') || lowerCode.contains('cash')) {
      return Icons.money_rounded;
    }
    return Icons.payment_rounded;
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
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(8)),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.textSecondary, size: ResponsiveUtils.rp(20)),
          SizedBox(width: ResponsiveUtils.rp(10)),
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
