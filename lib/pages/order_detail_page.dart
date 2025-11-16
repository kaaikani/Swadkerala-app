import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/theme_controller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/price_formatter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderCode;

  const OrderDetailPage({
    super.key,
    required this.orderCode,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderController orderController = Get.find<OrderController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final UtilityController utilityController = Get.find<UtilityController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderDetails();
    });
  }

  Future<void> _loadOrderDetails() async {
    try {
      debugPrint('[OrderDetail] Loading order with code: ${widget.orderCode}');
      final order = await orderController.getOrderByCode(widget.orderCode);
      if (order == null) {
        debugPrint(
            '[OrderDetail] Order not found for code: ${widget.orderCode}');
      } else {
        debugPrint('[OrderDetail] Order loaded successfully: ${order.code}');
      }
    } catch (e) {
      debugPrint('[OrderDetail] Error loading order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Observe theme changes
      final _ = themeController.isDarkMode;

      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Order Details',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: Obx(() {
          if (utilityController.isLoadingRx.value) {
            return _buildShimmerLoading();
          }

          final order = orderController.currentOrder.value;
          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: AppColors.iconLight),
                  const SizedBox(height: 16),
                  Text(
                    'Order not found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await orderController.getOrderByCode(widget.orderCode);
            },
            color: AppColors.button,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID and Total Header
                  _buildOrderHeader(order),

                  // Products Section
                  if (order.lines.isNotEmpty) _buildProductsSection(order),

                  // Shipping Address
                  if (order.shippingAddress != null)
                    _buildShippingAddressSection(order),

                  // Shipping Method
                  if (order.shippingLines.isNotEmpty)
                    _buildShippingMethodSection(order),

                  // Payment Information
                  if (order.payments.isNotEmpty) _buildPaymentSection(order),

                  // Order Information
                  _buildOrderInfoSection(order),

                  SizedBox(height: ResponsiveUtils.rp(20)),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildOrderHeader(dynamic order) {
    return Container(
      width: double.infinity,
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(20),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.code,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(6)),
                Text(
                  _formatPrice(order.totalWithTax),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(20),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(14),
              vertical: ResponsiveUtils.rp(6),
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(order.state),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
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
    );
  }

  Widget _buildProductsSection(dynamic order) {
    return Container(
      margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ordered Products',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          ...order.lines.asMap().entries.map((entry) {
            final index = entry.key;
            final line = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < order.lines.length - 1
                      ? ResponsiveUtils.rp(16)
                      : 0),
              child: _buildProductItem(line),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic line) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          width: ResponsiveUtils.rp(60),
          height: ResponsiveUtils.rp(60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
            color: AppColors.inputFill,
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
            child: line.featuredAsset?.preview != null
                ? Image.network(
                    line.featuredAsset!.preview,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.inputFill,
                        child: Icon(Icons.image,
                            color: AppColors.iconLight,
                            size: ResponsiveUtils.rp(24)),
                      );
                    },
                  )
                : Container(
                    color: AppColors.inputFill,
                    child: Icon(Icons.image,
                        color: AppColors.iconLight,
                        size: ResponsiveUtils.rp(24)),
                  ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.rp(12)),
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.productVariant?.name ?? 'Unknown Product',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveUtils.sp(15),
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ResponsiveUtils.rp(4)),
              Text(
                'Quantity: ${line.quantity}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: ResponsiveUtils.sp(13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingAddressSection(dynamic order) {
    final address = order.shippingAddress;
    if (address == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Text(
            address.fullName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(4)),
          Text(
            address.streetLine1,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
          if (address.streetLine2 != null &&
              address.streetLine2!.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.rp(2)),
            Text(
              address.streetLine2!,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textPrimary,
              ),
            ),
          ],
          SizedBox(height: ResponsiveUtils.rp(2)),
          Text(
            '${address.city}, ${address.province ?? ''} ${address.postalCode}',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
          if (address.country != null && address.country!.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.rp(2)),
            Text(
              address.country!,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textPrimary,
              ),
            ),
          ],
          if (address.phoneNumber != null &&
              address.phoneNumber!.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.rp(6)),
            Text(
              address.phoneNumber!,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(13),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingMethodSection(dynamic order) {
    if (order.shippingLines.isEmpty) {
      return const SizedBox.shrink();
    }

    final shippingLine = order.shippingLines.first;
    final shippingMethod = shippingLine.shippingMethod;
    final shippingCost = shippingLine.priceWithTax;

    return Container(
      margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Method',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Text(
            shippingMethod.name.isNotEmpty
                ? '${shippingMethod.name} (${_formatPrice(shippingCost)} incl.Tax)'
                : 'Standard Shipping (${_formatPrice(shippingCost)} incl.Tax)',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(4)),
          Text(
            '${_formatPrice(shippingCost)} incl. Tax',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(13),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(dynamic order) {
    if (order.payments.isEmpty) {
      return const SizedBox.shrink();
    }

    final payment = order.payments.first;
    final paymentMethod = _formatPaymentMethod(payment.method);
    final paymentStatus = _formatPaymentStatus(payment.state);
    final statusColor = _getPaymentStatusColor(payment.state);

    return Container(
      margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Text(
            paymentMethod,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(6)),
          Text(
            'Status: $paymentStatus',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (payment.transactionId != null &&
              payment.transactionId!.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.rp(6)),
            Text(
              'Transaction ID: ${payment.transactionId}',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderInfoSection(dynamic order) {
    return Container(
      margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          _buildInfoRow(
              'Order Date',
              order.orderPlacedAt != null
                  ? _formatDate(order.orderPlacedAt!)
                  : 'N/A'),
          SizedBox(height: ResponsiveUtils.rp(10)),
          if (order.orderPlacedAt != null) ...[
            _buildInfoRow('Order Time', _formatTime(order.orderPlacedAt!)),
            SizedBox(height: ResponsiveUtils.rp(10)),
          ],
          _buildInfoRow('Total Items', '${order.totalQuantity}'),
          SizedBox(height: ResponsiveUtils.rp(10)),
          _buildInfoRow('Currency', order.currencyCode ?? 'INR'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: ResponsiveUtils.rp(100),
              color: AppColors.card,
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            ...List.generate(
                4,
                (index) => Container(
                      height: ResponsiveUtils.rp(120),
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                      color: AppColors.card,
                    )),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return PriceFormatter.formatPrice(price);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatOrderStatus(String state) {
    switch (state.toLowerCase()) {
      case 'paymentauthorized':
        return 'Confirmed';
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

  String _formatPaymentMethod(String method) {
    final methodLower = method.toLowerCase();
    if (methodLower.contains('razorpay') ||
        methodLower.contains('online') ||
        methodLower.contains('card')) {
      return 'Online Payment';
    } else if (methodLower.contains('cod') ||
        methodLower.contains('cash') ||
        methodLower.contains('offline')) {
      return 'Cash on Delivery';
    }
    return method;
  }

  String _formatPaymentStatus(String state) {
    switch (state.toLowerCase()) {
      case 'authorized':
      case 'settled':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return state;
    }
  }

  Color _getPaymentStatusColor(String state) {
    switch (state.toLowerCase()) {
      case 'authorized':
      case 'settled':
        return const Color(0xFF00B761); // Green
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return AppColors.grey600; // Grey instead of red
      default:
        return Colors.grey;
    }
  }
}
