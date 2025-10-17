import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/order/ordermodels.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';
import '../widgets/snackbar.dart';
import '../theme/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Order Confirmation',

      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return const Center(child: CircularProgressIndicator());
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Success Header
              _buildOrderSuccessHeader(order),
              const SizedBox(height: 24),
              
              // Order Details
              _buildOrderDetails(order),
              const SizedBox(height: 16),
              
              // Products Ordered
              _buildProductsSection(order),
              const SizedBox(height: 16),
              
              // Shipping Address
              _buildShippingAddressSection(order),
              const SizedBox(height: 16),
              
              // Payment Information
              _buildPaymentSection(order),
              const SizedBox(height: 16),
              
              // Loyalty Points
              _buildLoyaltyPointsSection(order),
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(order),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderSuccessHeader(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Order Placed Successfully!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order #${order.code}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total: ${cartController.formatPrice(order.totalWithTax.toInt())}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(dynamic order) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Order ID', order.code),
            _buildDetailRow('Date', order.orderPlacedAt?.toLocal().toString().split(' ')[0] ?? 'N/A'),
            _buildDetailRow('Status', order.state),
            _buildDetailRow('Total Items', '${order.totalQuantity}'),
            _buildDetailRow('Currency', order.currencyCode ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection(dynamic order) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products Ordered',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...order.lines.map((line) => _buildProductItem(line)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(dynamic line) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: line.featuredAsset?.preview != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      line.featuredAsset!.preview,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, color: Colors.grey);
                      },
                    ),
                  )
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productVariant?.name ?? 'Unknown Product',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${line.quantity}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: ${cartController.formatPrice(line.linePriceWithTax.toInt())}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddressSection(dynamic order) {
    final address = order.shippingAddress;
    if (address == null) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(address.streetLine1),
                      if (address.streetLine2.isNotEmpty) Text(address.streetLine2),
                      Text('${address.city}, ${address.province ?? ''} ${address.postalCode}'),
                      Text(address.country ?? ''),
                      if (address.phoneNumber.isNotEmpty)
                        Text('Phone: ${address.phoneNumber}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(dynamic order) {
    final payments = order.payments;
    if (payments.isEmpty) {
      return const SizedBox.shrink();
    }

    final payment = payments.first;
    final isOnlinePayment = payment.method.toLowerCase().contains('online') || 
                           payment.method.toLowerCase().contains('razorpay');

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isOnlinePayment ? Icons.credit_card : Icons.money,
                  color: isOnlinePayment ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnlinePayment ? 'Online Payment' : 'Cash on Delivery',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Method: ${payment.method}'),
                      Text('Status: ${payment.state}'),
                      Text('Amount: ${cartController.formatPrice(payment.amount.toInt())}'),
                      if (payment.transactionId != null)
                        Text('Transaction ID: ${payment.transactionId}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyPointsSection(dynamic order) {
    final customFields = order.customFields;
    final pointsUsed = customFields?.loyaltyPointsUsed ?? 0;
    final pointsEarned = customFields?.loyaltyPointsEarned ?? 0;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loyalty Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (pointsUsed > 0) ...[
              _buildLoyaltyPointRow('Points Used', '$pointsUsed', Icons.remove_circle, Colors.red),
              const SizedBox(height: 8),
            ],
            if (pointsEarned > 0) ...[
              _buildLoyaltyPointRow('Points Earned', '$pointsEarned', Icons.add_circle, Colors.green),
            ],
            if (pointsUsed == 0 && pointsEarned == 0)
              const Text('No loyalty points activity for this order', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyPointRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(dynamic order) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'Continue Shopping',
            onPressed: () async => Get.offAllNamed('/home'),
            backgroundColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'View Order Details',
            onPressed: () async => _viewOrderDetails(order),
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'Download Receipt',
            onPressed: () async => _downloadReceipt(order),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }


  Future<void> _shareReceipt(OrderModel order) async {
    try {
      // Generate text receipt
      final receiptText = _generateTextReceipt(order);
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: receiptText));
      
      // Show dialog with receipt
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Receipt for Order #${order.code}'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: SingleChildScrollView(
              child: Text(
                receiptText,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showSuccessSnackbar('Receipt copied to clipboard!');
              },
              child: const Text('Copy'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      showErrorSnackbar('Failed to generate receipt: $e');
    }
  }

  String _generateTextReceipt(OrderModel order) {
    final buffer = StringBuffer();
    
    buffer.writeln('ORDER RECEIPT');
    buffer.writeln('=============');
    buffer.writeln();
    buffer.writeln('Order #${order.code}');
    buffer.writeln('Date: ${order.orderPlacedAt?.toLocal().toString().split(' ')[0] ?? 'N/A'}');
    buffer.writeln('Status: ${order.state}');
    buffer.writeln('Total Items: ${order.totalQuantity}');
    if (order.currencyCode != null) {
      buffer.writeln('Currency: ${order.currencyCode}');
    }
    buffer.writeln();
    
    buffer.writeln('PRODUCTS');
    buffer.writeln('--------');
    for (final line in order.lines) {
      buffer.writeln('${line.productVariant.name}');
      buffer.writeln('Qty: ${line.quantity} x Rs.${(line.unitPriceWithTax / 100).toStringAsFixed(2)} = Rs.${(line.linePriceWithTax / 100).toStringAsFixed(2)}');
      buffer.writeln();
    }
    
    if (order.shippingAddress != null) {
      buffer.writeln('SHIPPING ADDRESS');
      buffer.writeln('---------------');
      final address = order.shippingAddress!;
      buffer.writeln(address.fullName);
      buffer.writeln(address.streetLine1);
      if (address.streetLine2?.isNotEmpty == true) {
        buffer.writeln(address.streetLine2!);
      }
      buffer.writeln('${address.city}, ${address.province ?? ''} ${address.postalCode}');
      if (address.country != null) {
        buffer.writeln(address.country!);
      }
      if (address.phoneNumber?.isNotEmpty == true) {
        buffer.writeln('Phone: ${address.phoneNumber!}');
      }
      buffer.writeln();
    }
    
    if (order.payments.isNotEmpty) {
      buffer.writeln('PAYMENT DETAILS');
      buffer.writeln('---------------');
      for (final payment in order.payments) {
        buffer.writeln('${payment.method.toUpperCase()} - Rs.${(payment.amount / 100).toStringAsFixed(2)} (${payment.state})');
      }
      buffer.writeln();
    }
    
    if (order.customFields != null) {
      buffer.writeln('LOYALTY POINTS');
      buffer.writeln('-------------');
      if (order.customFields!.loyaltyPointsUsed != null) {
        buffer.writeln('Points Used: ${order.customFields!.loyaltyPointsUsed}');
      }
      if (order.customFields!.loyaltyPointsEarned != null) {
        buffer.writeln('Points Earned: ${order.customFields!.loyaltyPointsEarned}');
      }
      buffer.writeln();
    }
    
    buffer.writeln('ORDER SUMMARY');
    buffer.writeln('-------------');
    buffer.writeln('Subtotal: Rs.${(order.subTotalWithTax / 100).toStringAsFixed(2)}');
    if (order.shippingWithTax > 0) {
      buffer.writeln('Shipping: Rs.${(order.shippingWithTax / 100).toStringAsFixed(2)}');
    }
    buffer.writeln('Total: Rs.${(order.totalWithTax / 100).toStringAsFixed(2)}');
    buffer.writeln();
    buffer.writeln('Thank you for your order!');
    
    return buffer.toString();
  }

  void _viewOrderDetails(dynamic order) {
    // TODO: Navigate to detailed order view
    Get.snackbar('Order Details', 'Detailed order view coming soon');
  }

  void _downloadReceipt(dynamic order) {
    // TODO: Implement receipt download
    Get.snackbar('Download', 'Receipt download feature coming soon');
  }
}
