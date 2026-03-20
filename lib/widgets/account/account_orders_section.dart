import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../pages/orders_page.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class AccountOrdersSection extends StatelessWidget {
  final CustomerController customerController;

  const AccountOrdersSection({super.key, required this.customerController});

  @override
  Widget build(BuildContext context) {
    final ordersCount = customerController.orders.length;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: AppColors.iconLight, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'My Orders',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => Get.toNamed('/orders', arguments: OrderFilter.all),
                child: Text(
                  'View All ($ordersCount)',
                  style: TextStyle(
                    color: AppColors.button,
                    fontSize: ResponsiveUtils.sp(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatusItem(
                  Icons.payment_outlined,
                  'Order Confirmed',
                  Colors.green,
                  () => Get.toNamed('/orders', arguments: OrderFilter.paymentAuthorized)),
              _buildOrderStatusItem(
                  Icons.check_circle_outlined,
                  'Delivered',
                  Colors.blue,
                  () => Get.toNamed('/orders', arguments: OrderFilter.delivered)),
              _buildOrderStatusItem(
                  Icons.pending_actions_outlined,
                  'Cancellation Request',
                  Colors.orange,
                  () => Get.toNamed('/orders', arguments: OrderFilter.cancellationRequest)),
              _buildOrderStatusItem(
                  Icons.cancel_outlined,
                  'Cancelled',
                  Colors.red,
                  () => Get.toNamed('/orders', arguments: OrderFilter.cancelled)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusItem(
      IconData icon, String status, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ResponsiveUtils.rp(54),
            height: ResponsiveUtils.rp(54),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(27)),
            ),
            child: Icon(icon, color: color, size: ResponsiveUtils.rp(26)),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            status,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
