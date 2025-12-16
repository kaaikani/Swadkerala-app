import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../utils/responsive.dart';
import '../utils/bill_generator.dart';

class OrderConfirmationPage extends StatefulWidget {
  final String orderId;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final UtilityController utilityController = Get.find<UtilityController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderDetails();
    });
  }

  Future<void> _loadOrderDetails() async {
    try {
      await orderController.getOrderByCode(widget.orderId);
    } catch (e) {
debugPrint('[OrderConfirmation] Error loading order details: $e');
    }
  }

  Future<void> _shareBill() async {
    final orderModel = orderController.currentOrder.value;
    if (orderModel != null) {
      try {
        utilityController.setLoadingState(true);
        // Pass OrderModel directly to BillGenerator
        await BillGenerator.generateAndShare(orderModel);
      } catch (e) {
        Get.snackbar('Error', 'Failed to generate bill: $e',
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        utilityController.setLoadingState(false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        title: Text(
          'Order Confirmation',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerOrderConfirmation();
        }

        final order = orderController.currentOrder.value;
        if (order == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Order not found'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await orderController.getOrderByCode(widget.orderId);
          },
          color: AppColors.refreshIndicator,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success Animation/Icon
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: ResponsiveUtils.rp(64),
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Text(
                  'Order #${order.code}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(24)),

             /*   // Share Bill Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _shareBill,
                    icon: Icon(Icons.share, size: ResponsiveUtils.rp(20)),
                    label: Text('Share Bill'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.rp(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(24)),
*/
                // Order Details Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(16)),
                      ...order.lines.map((line) => _buildProductItem(line)).toList(),
                      Divider(height: ResponsiveUtils.rp(32), color: AppColors.divider),
                      _buildSummaryRow('Subtotal', order.subTotalWithTax.toDouble()),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      _buildSummaryRow('Shipping', order.shippingWithTax.toDouble()),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      _buildSummaryRow('Total', order.totalWithTax.toDouble(), isBold: true),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(24)),

                // Continue Shopping Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.offAllNamed('/home'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.border),
                      padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.rp(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Continue Shopping'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProductItem(dynamic line) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.rp(50),
            height: ResponsiveUtils.rp(50),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: line.featuredAsset?.preview != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      line.featuredAsset!.preview,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image, color: AppColors.textSecondary),
                    ),
                  )
                : Icon(Icons.image, color: AppColors.textSecondary),
          ),
          SizedBox(width: ResponsiveUtils.rp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productVariant?.name ?? 'Unknown Product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.sp(14),
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Qty: ${line.quantity}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.sp(12),
                  ),
                ),
              ],
            ),
          ),
          Text(
            cartController.formatPrice(line.linePriceWithTax.toInt()),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? ResponsiveUtils.sp(16) : ResponsiveUtils.sp(14),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          cartController.formatPrice(amount.toInt()),
          style: TextStyle(
            fontSize: isBold ? ResponsiveUtils.sp(18) : ResponsiveUtils.sp(14),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerOrderConfirmation() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Column(
          children: [
            Container(
              height: ResponsiveUtils.rp(100),
              width: ResponsiveUtils.rp(100),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(24)),
            Container(height: 20, width: 200, color: Colors.white),
            SizedBox(height: ResponsiveUtils.rp(24)),
            Container(height: 300, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
