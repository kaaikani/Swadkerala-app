import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/theme_controller.dart';
import '../utils/responsive.dart';
import '../utils/price_formatter.dart';
import '../theme/colors.dart';

class OrdersComponent extends StatelessWidget {
  final CustomerController customerController;

  const OrdersComponent({
    super.key,
    required this.customerController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      // Observe theme changes
      final _ = themeController.isDarkMode;
      final orders = customerController.orders;

      if (orders.isEmpty) {
        return _buildEmptyOrdersState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          await customerController.getActiveCustomer();
        },
        color: AppColors.button,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildOrderCard(orders[index]);
          },
        ),
      );
    });
  }

  Widget _buildOrderCard(dynamic order) {
    return GestureDetector(
      onTap: () => _viewOrderDetails(order),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.code}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(order.orderPlacedAt),
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge - only show if not cancelled
                  if (order.state.toLowerCase() != 'cancelled')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.state),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatOrderStatus(order.state),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, color: AppColors.divider),

            // Products Preview
            if (order.lines != null && order.lines.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show first product or summary
                    _buildProductPreview(order),
                    if (order.totalQuantity > 1) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+${order.totalQuantity - 1} more item${order.totalQuantity > 2 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.divider),
            ],

            // Order Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        PriceFormatter.formatPrice(order.totalWithTax.round()),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _viewOrderDetails(order),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.button,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: AppColors.button, width: 1),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductPreview(dynamic order) {
    if (order.lines == null || order.lines.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstLine = order.lines.first;

    return Row(
      children: [
        // Product Image
        Container(
          width: ResponsiveUtils.rp(50),
          height: ResponsiveUtils.rp(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.inputFill,
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: firstLine.featuredAsset?.preview != null
                ? Image.network(
                    firstLine.featuredAsset!.preview,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.inputFill,
                        child: Icon(Icons.image,
                            color: AppColors.iconLight,
                            size: ResponsiveUtils.rp(20)),
                      );
                    },
                  )
                : Container(
                    color: AppColors.inputFill,
                    child: Icon(Icons.image,
                        color: AppColors.iconLight,
                        size: ResponsiveUtils.rp(20)),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        // Product Name
        Expanded(
          child: Text(
            firstLine.productVariant?.name ?? 'Unknown Product',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyOrdersState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: AppColors.iconLight,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Orders Yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start shopping to see your orders here',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed('/home'),
                icon: const Icon(Icons.shopping_cart, size: 20),
                label: const Text('Start Shopping'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String state) {
    switch (state.toLowerCase()) {
      case 'paymentauthorized':
      case 'paymentsettled':
        return const Color(0xFF00B761); // Green
      case 'arrangingpayment':
        return Colors.orange;
      case 'cancelled':
        return AppColors.grey600; // Grey instead of red
      default:
        return Colors.blue;
    }
  }

  String _formatOrderStatus(String state) {
    switch (state.toLowerCase()) {
      case 'paymentauthorized':
      case 'paymentsettled':
        return 'Confirmed';
      case 'arrangingpayment':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return state;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _viewOrderDetails(dynamic order) {
    debugPrint(
        '[OrdersComponent] Viewing order details for code: ${order.code}');
    Get.toNamed('/order-detail', arguments: order.code);
  }
}
