import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/theme_controller.dart';
import '../utils/responsive.dart';
import '../utils/price_formatter.dart';
import '../utils/bill_generator.dart';
import '../theme/colors.dart';
import '../pages/orders_page.dart';

class OrdersComponent extends StatelessWidget {
  final CustomerController customerController;
  final OrderFilter filter;

  const OrdersComponent({
    super.key,
    required this.customerController,
    this.filter = OrderFilter.all,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      // Observe theme changes
      final _ = themeController.isDarkMode;
      final allOrders = customerController.orders;
      final filteredOrders = _filterOrders(allOrders);

      if (filteredOrders.isEmpty) {
        return _buildEmptyOrdersState(filter);
      }

        return RefreshIndicator(
        onRefresh: () async {
          await customerController.getActiveCustomer();
        },
        color: AppColors.refreshIndicator,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: filteredOrders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildOrderCard(filteredOrders[index]);
          },
        ),
      );
    });
  }

  List<dynamic> _filterOrders(List<dynamic> orders) {
    List<dynamic> filtered;
    
    // First, exclude cancelled orders from all filters
    final nonCancelledOrders = orders.where((order) {
      final state = order.state?.toString().toLowerCase() ?? '';
      return state != 'cancelled';
    }).toList();
    
    if (filter == OrderFilter.all) {
      filtered = nonCancelledOrders;
    } else {
      filtered = nonCancelledOrders.where((order) {
        final state = order.state?.toString().toLowerCase() ?? '';
        
        switch (filter) {
          case OrderFilter.paid:
            // Check for payment settled state only - fully paid orders
            return state == 'paymentsettled';
          
          case OrderFilter.paymentAuthorized:
            // Check for payment authorized state only - order confirmed but payment not yet settled
            return state == 'paymentauthorized';
          
          case OrderFilter.delivered:
            // Check for delivered/fulfilled/shipped states
            return state == 'fulfilled' || 
                   state == 'delivered' || 
                   state == 'shipped' ||
                   state == 'partiallyfulfilled';
          
          case OrderFilter.cancelled:
            // Cancelled orders are already filtered out, so return empty
            return false;
          
          case OrderFilter.all:
            return true;
        }
      }).toList();
    }
    
    // Sort by orderPlacedAt in descending order (most recent first)
    filtered.sort((a, b) {
      final dateA = a.orderPlacedAt ?? DateTime(1970);
      final dateB = b.orderPlacedAt ?? DateTime(1970);
      return dateB.compareTo(dateA); // Descending order
    });
    
    // Limit to 10 most recent orders
    return filtered.take(10).toList();
  }

  Widget _buildOrderCard(dynamic order) {
    final isCancelled = order.state.toLowerCase() == 'cancelled';
    
    return GestureDetector(
      onTap: () => _viewOrderDetails(order),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header - Compact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Order #${order.code}',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(15),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: 8),
                            // Status badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCancelled
                                    ? AppColors.grey600
                                    : _getStatusColor(order.state),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatOrderStatus(order.state),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(10),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          _formatDate(order.orderPlacedAt),
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Products Preview - Compact
              if (order.lines != null && order.lines.isNotEmpty) ...[
                _buildProductPreview(order),
                if (order.totalQuantity > 1) ...[
                  SizedBox(height: 4),
                  Text(
                    '+${order.totalQuantity - 1} more item${order.totalQuantity > 2 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 12),
              ],

              // Order Footer - Compact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        PriceFormatter.formatPrice(order.totalWithTax.round()),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Share Invoice Button - only show for non-cancelled orders
                      if (!isCancelled)
                        IconButton(
                          onPressed: () => _shareInvoice(order),
                          icon: Icon(
                            Icons.share_outlined,
                            size: ResponsiveUtils.rp(20),
                            color: AppColors.button,
                          ),
                          tooltip: 'Share Invoice',
                          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                          constraints: BoxConstraints(),
                        ),
                      if (!isCancelled) SizedBox(width: ResponsiveUtils.rp(8)),
                      // View Details Button
                      TextButton(
                        onPressed: () => _viewOrderDetails(order),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.button,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: AppColors.button, width: 1.5),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
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
        // Product Image - Smaller
        Container(
          width: ResponsiveUtils.rp(45),
          height: ResponsiveUtils.rp(45),
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
                            size: ResponsiveUtils.rp(18)),
                      );
                    },
                  )
                : Container(
                    color: AppColors.inputFill,
                    child: Icon(Icons.image,
                        color: AppColors.iconLight,
                        size: ResponsiveUtils.rp(18)),
                  ),
          ),
        ),
        SizedBox(width: 10),
        // Product Name
        Expanded(
          child: Text(
            firstLine.productVariant?.name ?? 'Unknown Product',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(13),
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

  Widget _buildEmptyOrdersState(OrderFilter currentFilter) {
    String title;
    String message;
    
    switch (currentFilter) {
      case OrderFilter.paid:
        title = 'No Paid Orders';
        message = 'You don\'t have any paid orders yet';
        break;
      case OrderFilter.paymentAuthorized:
        title = 'No Order Confirmed';
        message = 'You don\'t have any confirmed orders yet';
        break;
      case OrderFilter.delivered:
        title = 'No Delivered Orders';
        message = 'You don\'t have any delivered orders yet';
        break;
      case OrderFilter.cancelled:
        title = 'No Cancelled Orders';
        message = 'You don\'t have any cancelled orders';
        break;
      case OrderFilter.all:
        title = 'No Orders Yet';
        message = 'Start shopping to see your orders here';
        break;
    }

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
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (currentFilter != OrderFilter.all) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to orders page with all filter, replacing current page
                    Get.offNamed('/orders', arguments: OrderFilter.all);
                  },
                  icon: const Icon(Icons.list, size: 20),
                  label: const Text('View All Orders'),
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
              ] else ...[
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
debugPrint(        '[OrdersComponent] Viewing order details for code: ${order.code}');
    Get.toNamed('/order-detail', arguments: order.code);
  }

  Future<void> _shareInvoice(dynamic order) async {
    // Don't allow sharing for cancelled orders
    final isCancelled = order.state?.toString().toLowerCase() == 'cancelled';
    if (isCancelled) {
      Get.snackbar(
        'Error',
        'Cannot share invoice for cancelled orders',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      final orderController = Get.find<OrderController>();
      final utilityController = Get.find<UtilityController>();
      
      utilityController.setLoadingState(true);
      
      // Fetch full order details using order code
      final orderModel = await orderController.getOrderByCode(order.code);
      
      if (orderModel != null) {
        // Use BillGenerator to generate and share the invoice
        await BillGenerator.generateAndShare(orderModel);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load order details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
debugPrint('[OrdersComponent] Error sharing invoice: $e');
      Get.snackbar(
        'Error',
        'Failed to generate invoice: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      final utilityController = Get.find<UtilityController>();
      utilityController.setLoadingState(false);
    }
  }
}
