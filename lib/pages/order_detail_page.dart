import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/snackbar.dart';
import '../widgets/loading_dialog.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/theme_controller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/price_formatter.dart';
import '../utils/app_strings.dart';
import '../utils/bill_generator.dart';
import '../services/graphql_client.dart';
import '../graphql/banner.graphql.dart';
import '../graphql/order.graphql.dart';
import '../widgets/premium_card.dart';
import '../widgets/responsive_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../services/analytics_service.dart';
import '../widgets/cached_app_image.dart';

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
    AnalyticsService().logScreenView(screenName: 'OrderDetail');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderDetails();
    });
  }

  Future<void> _loadOrderDetails() async {
    try {
      final order = await orderController.getOrderByCode(widget.orderCode);
      if (order == null) {
      } else {
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = themeController.isDarkMode;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.card,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, 
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Order Details',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await orderController.getOrderByCode(widget.orderCode);
            },
            color: AppColors.button,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  
                  // Order Status Header Card
                  _buildStatusHeader(order),

                  SizedBox(height: ResponsiveUtils.rp(12)),

                  // Order Tracking Stepper
                  _buildOrderTracker(order.state),

                  SizedBox(height: ResponsiveUtils.rp(12)),

                  // Share Invoice Button - hide for cancelled or AddingItems state
                  if (order.state.toLowerCase() != 'cancelled' &&
                      order.state.toLowerCase() != 'addingitems')
                    _buildShareInvoiceButton(order),
                  
                  if (order.state.toLowerCase() != 'cancelled' &&
                      order.state.toLowerCase() != 'addingitems')
                    SizedBox(height: ResponsiveUtils.rp(12)),
                  
                  // Products Section
                  if (order.lines.isNotEmpty) _buildProductsCard(order),
                  
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  
                  // Price Breakdown
                  _buildPriceBreakdownCard(order),
                  
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  
                  // Delivery Information
                  if ((order is Query$GetOrderByCode$orderByCode && order.shippingAddress != null) || order.shippingLines.isNotEmpty)
                    _buildDeliveryCard(order),
                  
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  
                  // Payment Information
                  if (order is Query$GetOrderByCode$orderByCode && order.payments != null && order.payments!.isNotEmpty) 
                    _buildPaymentCard(order),
                  
                  // Cancel Order Button - only show if cancellation not already requested
                  if (_shouldShowCancelButton(order))
                    _buildCancelOrderButton(order),
                  
                  SizedBox(height: ResponsiveUtils.rp(20)),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_outlined,
                  size: ResponsiveUtils.rp(64),
                  color: AppColors.textSecondary),
            ),
            SizedBox(height: ResponsiveUtils.rp(24)),
            Text(
              'Order Not Found',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            Text(
              'The order you\'re looking for doesn\'t exist or has been removed.',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.rp(32)),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, size: ResponsiveUtils.rp(18)),
              label: Text(AppStrings.goBack),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(24),
                  vertical: ResponsiveUtils.rp(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareInvoiceButton(dynamic order) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _shareInvoice(order),
        icon: Icon(Icons.share, size: ResponsiveUtils.rp(20)),
        label: Text(AppStrings.shareInvoice),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _shareInvoice(dynamic order) async {
    // Don't allow sharing for cancelled orders
    final isCancelled = order.state?.toString().toLowerCase() == 'cancelled';
    if (isCancelled) {
      SnackBarWidget.showError('Cannot share invoice for cancelled orders');
      return;
    }
    
    try {
      LoadingDialog.show(message: 'Generating bill...');
      final orderModel = orderController.currentOrder.value;
      if (orderModel == null) {
        LoadingDialog.hide();
        SnackBarWidget.showError('Failed to load order details');
        return;
      }
      await BillGenerator.generateAndShare(orderModel);
    } catch (e) {
      SnackBarWidget.showError('Failed to generate invoice: $e');
    } finally {
      LoadingDialog.hide();
    }
  }

  Widget _buildStatusHeader(dynamic order) {
    final isCancelled = order.state.toLowerCase() == 'cancelled';
    final statusColor = isCancelled ? AppColors.grey600 : _getStatusColor(order.state);
    final statusText = _formatOrderStatus(order.state);

    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.code}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(6)),
                    Text(
                      _formatPrice(order.totalWithTax.toInt()),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(24),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(12),
                  vertical: ResponsiveUtils.rp(6),
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(11),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsCard(dynamic order) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: AppColors.button, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Items (${order.totalQuantity})',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          ...order.lines.asMap().entries.map((entry) {
            final index = entry.key;
            final line = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < order.lines.length - 1
                    ? ResponsiveUtils.rp(16)
                    : 0,
              ),
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
          width: ResponsiveUtils.rp(70),
          height: ResponsiveUtils.rp(70),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            color: AppColors.inputFill,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            child: line.featuredAsset?.preview != null
                ? CachedAppImage(
                    imageUrl: line.featuredAsset!.preview,
                    fit: BoxFit.cover,
                    cacheWidth: 140,
                    cacheHeight: 140,
                    errorWidget: Container(
                      color: AppColors.inputFill,
                      child: Icon(Icons.image_outlined,
                          color: AppColors.iconLight,
                          size: ResponsiveUtils.rp(28)),
                    ),
                  )
                : Container(
                    color: AppColors.inputFill,
                    child: Icon(Icons.image_outlined,
                        color: AppColors.iconLight,
                        size: ResponsiveUtils.rp(28)),
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
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.sp(15),
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ResponsiveUtils.rp(6)),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                    ),
                    child: Text(
                      'Qty: ${line.quantity}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtils.sp(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    PriceFormatter.formatPrice(line.linePriceWithTax.toInt()),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdownCard(dynamic order) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  color: AppColors.button, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Price Breakdown',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          _buildPriceRow('Subtotal', order.subTotalWithTax.toInt()),
          SizedBox(height: ResponsiveUtils.rp(10)),
          _buildPriceRow('Shipping', order.shippingWithTax.toInt()),
          // Loyalty Points Used
          if (order.customFields?.loyaltyPointsUsed != null &&
              order.customFields!.loyaltyPointsUsed! > 0) ...[
            SizedBox(height: ResponsiveUtils.rp(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars_outlined,
                        color: AppColors.success,
                        size: ResponsiveUtils.rp(16)),
                    SizedBox(width: ResponsiveUtils.rp(6)),
                    Text(
                      'Points Used',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${order.customFields!.loyaltyPointsUsed} points',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
          // Discounts
          if (order.discounts.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.rp(10)),
            ...order.discounts.map((discount) => Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(6)),
                  child: _buildPriceRow(
                    discount.description.isNotEmpty
                        ? discount.description
                        : 'Discount',
                    -discount.amountWithTax.toInt(),
                    isDiscount: true,
                  ),
                )),
          ],
          SizedBox(height: ResponsiveUtils.rp(12)),
          Divider(color: AppColors.border, height: 1),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _formatPrice(order.totalWithTax.toInt()),
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.button,
                ),
              ),
            ],
          ),
          // Loyalty Points Earned
          if (order.customFields?.loyaltyPointsEarned != null &&
              order.customFields!.loyaltyPointsEarned! > 0) ...[
            SizedBox(height: ResponsiveUtils.rp(12)),
            Divider(color: AppColors.border, height: 1),
            SizedBox(height: ResponsiveUtils.rp(12)),
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stars_rounded,
                          color: AppColors.success,
                          size: ResponsiveUtils.rp(20)),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Points Earned',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(15),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '+${order.customFields!.loyaltyPointsEarned} points',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isDiscount = false}) {
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
          isDiscount
              ? '-${PriceFormatter.formatPrice(amount.abs())}'
              : PriceFormatter.formatPrice(amount),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryCard(dynamic order) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  color: AppColors.button, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Delivery Information',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          if (order is Query$GetOrderByCode$orderByCode && order.shippingAddress != null) ...[
            _buildDeliverySection(
              'Delivery Address',
              Icons.location_on_outlined,
              _formatAddress(order.shippingAddress!),
            ),
            if (order.shippingLines.isNotEmpty) ...[
              SizedBox(height: ResponsiveUtils.rp(16)),
              Divider(color: AppColors.border, height: 1),
              SizedBox(height: ResponsiveUtils.rp(16)),
            ],
          ],
          if (order.shippingLines.isNotEmpty)
            _buildDeliverySection(
              'Shipping Method',
              Icons.delivery_dining_outlined,
              _formatShippingMethod(order.shippingLines.first),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(String title, IconData icon, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: ResponsiveUtils.rp(16)),
            SizedBox(width: ResponsiveUtils.rp(6)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(13),
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Text(
          content,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textPrimary,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatAddress(dynamic address) {
    List<String> parts = [];
    
    // Line 1: Name and Street Line 1
    String line1 = '';
    if (address.fullName != null && address.fullName.isNotEmpty) {
      line1 = address.fullName;
      if (address.streetLine1 != null && address.streetLine1.isNotEmpty) {
        line1 += ', ${address.streetLine1}';
      }
    } else if (address.streetLine1 != null && address.streetLine1.isNotEmpty) {
      line1 = address.streetLine1;
    }
    if (line1.isNotEmpty) parts.add(line1);
    
    // Line 2: Street Line 2 and City
    String line2 = '';
    if (address.streetLine2 != null && address.streetLine2!.isNotEmpty) {
      line2 = address.streetLine2!;
    }
    if (address.city != null && address.city.isNotEmpty) {
      if (line2.isNotEmpty) {
        line2 += ', ${address.city}';
      } else {
        line2 = address.city;
      }
    }
    if (line2.isNotEmpty) parts.add(line2);
    
    // Line 3: Postal Code, Country, and Phone
    String line3 = '';
    if (address.postalCode != null && address.postalCode!.isNotEmpty) {
      line3 = address.postalCode!;
    }
    if (address.country != null && address.country!.isNotEmpty) {
      if (line3.isNotEmpty) {
        line3 += ', ${address.country}';
      } else {
        line3 = address.country!;
      }
    }
    if (address.phoneNumber != null && address.phoneNumber!.isNotEmpty) {
      if (line3.isNotEmpty) {
        line3 += ' • ${address.phoneNumber}';
      } else {
        line3 = 'Phone: ${address.phoneNumber}';
      }
    }
    if (line3.isNotEmpty) parts.add(line3);
    
    // Ensure maximum 3 lines
    if (parts.length > 3) {
      parts = parts.take(3).toList();
    }
    
    return parts.join('\n');
  }

  String _formatShippingMethod(dynamic shippingLine) {
    final method = shippingLine.shippingMethod;
    final cost = shippingLine.priceWithTax;
    if (cost == 0) {
      return '${method.name.isNotEmpty ? method.name : "Standard Shipping"} - Free';
    }
    return '${method.name.isNotEmpty ? method.name : "Standard Shipping"} - ${PriceFormatter.formatPrice(cost.toInt())}';
  }

  Widget _buildPaymentCard(dynamic order) {
    if (order is! Query$GetOrderByCode$orderByCode || order.payments == null || order.payments!.isEmpty) {
      return const SizedBox.shrink();
    }
    final payment = order.payments!.first;
    final paymentMethod = _formatPaymentMethod(payment.method);
    final paymentStatus = _formatPaymentStatus(payment.state);
    final statusColor = _getPaymentStatusColor(payment.state);

    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment_outlined,
                  color: AppColors.button, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Payment Information',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          _buildInfoItem('Payment Method', paymentMethod),
          SizedBox(height: ResponsiveUtils.rp(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(10),
                  vertical: ResponsiveUtils.rp(4),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  paymentStatus,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(12),
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (payment.transactionId != null &&
              payment.transactionId!.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.rp(10)),
            _buildInfoItem('Transaction ID', payment.transactionId!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
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
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  bool _shouldShowCancelButton(dynamic order) {
    final orderState = order.state.toLowerCase();
    // Don't show for AddingItems state (cart still being built)
    if (orderState == 'addingitems') return false;
    final isCancellationRequested = orderState.contains('cancel') &&
                                     orderState.contains('request');
    return orderState != 'cancelled' &&
           orderState != 'fulfilled' &&
           orderState != 'delivered' &&
           !isCancellationRequested;
  }

  Widget _buildCancelOrderButton(dynamic order) {
    final isCancelled = order.state.toLowerCase() == 'cancelled';
    
    if (isCancelled) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showCancelOrderDialog(order),
          icon: Icon(Icons.cancel_outlined, size: ResponsiveUtils.rp(20)),
          label: Text(
            'Request Cancellation',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(15),
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
            side: BorderSide(color: Colors.red, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelOrderDialog(dynamic order) {
    Get.dialog(
      _CancelOrderDialogContent(
        order: order,
        onCancelRequested: (reason) => _requestOrderCancellation(order, reason),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  Widget _buildShimmerLoading() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Column(
          children: [
            Container(
              height: ResponsiveUtils.rp(120),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            ...List.generate(
              5,
              (index) => Container(
                height: ResponsiveUtils.rp(150),
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return PriceFormatter.formatPrice(price);
  }

  String _formatOrderStatus(String state) {
    final stateLower = state.toLowerCase();
    
    // Check for cancellation request first (before checking cancelled)
    if (stateLower.contains('cancel') && stateLower.contains('request')) {
      return 'Cancellation Requested';
    }
    
    switch (stateLower) {
      case 'paymentsettled':
        return 'Paid';
      case 'paymentauthorized':
        return 'Order Confirmed';
      case 'arrangingpayment':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return state;
    }
  }

  /// Returns the current step index (0-3) for the order tracking stepper.
  int _getTrackingStepIndex(String state) {
    final s = state.toLowerCase();
    if (s == 'cancelled' || (s.contains('cancel') && s.contains('request'))) return -2;
    if (s == 'addingitems') return -1;
    if (s == 'arrangingpayment') return 0;
    if (s == 'paymentauthorized' || s == 'paymentsettled') return 1;
    if (s == 'shipped' || s == 'partiallyshipped') return 2;
    if (s == 'fulfilled' || s == 'delivered' || s == 'partiallyfulfilled') return 3;
    return 0;
  }

  Widget _buildOrderTracker(String state) {
    final stepIndex = _getTrackingStepIndex(state);
    final isCancelled = stepIndex == -2;

    const steps = ['Placed', 'Confirmed', 'Shipped', 'Delivered'];
    const completedColor = Color(0xFF00B761);
    final upcomingColor = AppColors.border;

    if (isCancelled) {
      final stateLower = state.toLowerCase();
      final isCancellationRequested = stateLower.contains('cancel') && stateLower.contains('request');
      return PremiumCard(
        padding: ResponsiveSpacing.padding(all: 16),
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        child: Row(
          children: [
            Icon(
              isCancellationRequested ? Icons.pending_outlined : Icons.cancel_outlined,
              color: isCancellationRequested ? Colors.orange : AppColors.grey600,
              size: ResponsiveUtils.rp(22),
            ),
            SizedBox(width: ResponsiveUtils.rp(10)),
            Text(
              isCancellationRequested ? 'Cancellation Requested' : 'Order Cancelled',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(15),
                fontWeight: FontWeight.w600,
                color: isCancellationRequested ? Colors.orange : AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    return PremiumCard(
      padding: ResponsiveSpacing.padding(horizontal: 12, vertical: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  color: AppColors.button, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Order Tracking',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(4)),
            child: Row(
              children: List.generate(steps.length * 2 - 1, (i) {
                if (i.isOdd) {
                  final lineStepIndex = i ~/ 2;
                  final isCompleted = lineStepIndex < stepIndex;
                  return Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: isCompleted ? completedColor : upcomingColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }
                final idx = i ~/ 2;
                final isCompleted = idx < stepIndex;
                final isCurrent = idx == stepIndex;
                final circleColor = isCompleted || isCurrent ? completedColor : upcomingColor;
                final circleSize = isCurrent ? 26.0 : 22.0;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: ResponsiveUtils.rp(circleSize),
                      height: ResponsiveUtils.rp(circleSize),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isCurrent ? circleColor : Colors.transparent,
                        border: Border.all(
                          color: circleColor,
                          width: isCurrent ? 3 : 2,
                        ),
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, size: ResponsiveUtils.rp(14), color: Colors.white)
                          : isCurrent
                              ? Center(
                                  child: Container(
                                    width: ResponsiveUtils.rp(10),
                                    height: ResponsiveUtils.rp(10),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                    ),
                    SizedBox(height: ResponsiveUtils.rp(6)),
                    Text(
                      steps[idx],
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(11),
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        color: isCompleted || isCurrent ? completedColor : AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String state) {
    final stateLower = state.toLowerCase();

    // Check for cancellation request first
    if (stateLower.contains('cancel') && stateLower.contains('request')) {
      return Colors.orange; // Use orange for cancellation requested
    }

    switch (stateLower) {
      case 'paymentsettled':
      case 'paymentauthorized':
        return const Color(0xFF00B761); // Green for paid/confirmed
      case 'arrangingpayment':
        return Colors.orange;
      case 'cancelled':
        return AppColors.grey600;
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
        return const Color(0xFF00B761);
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return AppColors.grey600;
      default:
        return Colors.grey;
    }
  }

  Future<void> _requestOrderCancellation(dynamic order, String reason) async {
    try {
      utilityController.setLoadingState(true);
      
      try {
        final response = await GraphqlService.client.value.mutate$RequestOrderCancellation(
          Options$Mutation$RequestOrderCancellation(
            variables: Variables$Mutation$RequestOrderCancellation(
              orderId: order.id,
              reason: reason,
            ),
          ),
        );

        if (response.hasException) {
          final errorMessage = response.exception?.graphqlErrors.firstOrNull?.message ?? '';
          SnackBarWidget.showError(
            errorMessage.isNotEmpty ? errorMessage : 'Failed to request order cancellation. Please try again.',
          );
          return;
        }

        if (response.parsedData?.requestOrderCancellation == null) {
          SnackBarWidget.showError('Failed to request cancellation. Please try again.');
          return;
        }

        await orderController.getOrderByCode(widget.orderCode);
        
        SnackBarWidget.showSuccess('Cancellation request submitted successfully');
      } catch (e) {
        if (e.toString().contains('requestOrderCancellation') || 
            e.toString().contains('Cannot query field')) {
          SnackBarWidget.showWarning(
            'Order cancellation is not available on the server yet. Please contact support.',
            title: AppStrings.featureNotAvailable,
            duration: const Duration(seconds: 4),
          );
          return;
        }
        rethrow;
      }
    } catch (e) {
      SnackBarWidget.showError('Failed to request cancellation. Please try again.');
    } finally {
      utilityController.setLoadingState(false);
    }
  }
}

/// Separate StatefulWidget for cancel order dialog to properly manage TextEditingController lifecycle
class _CancelOrderDialogContent extends StatefulWidget {
  final dynamic order;
  final Function(String) onCancelRequested;

  const _CancelOrderDialogContent({
    required this.order,
    required this.onCancelRequested,
  });

  @override
  State<_CancelOrderDialogContent> createState() => _CancelOrderDialogContentState();
}

class _CancelOrderDialogContentState extends State<_CancelOrderDialogContent> {
  String? selectedReason;
  late final TextEditingController otherReasonController;
  bool showOtherTextField = false;

  @override
  void initState() {
    super.initState();
    otherReasonController = TextEditingController();
  }

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: ResponsiveUtils.rp(28)),
                SizedBox(width: ResponsiveUtils.rp(12)),
                Expanded(
                  child: Text(
                    'Request Order Cancellation',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please select a reason for cancellation:',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    // Reason 1: Changed my mind
                    _buildDialogReasonOption(
                      context,
                      setState,
                      'Changed my mind',
                      selectedReason,
                      (value) {
                        setState(() {
                          selectedReason = value;
                          showOtherTextField = false;
                          otherReasonController.clear();
                        });
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    // Reason 2: Found better price elsewhere
                    _buildDialogReasonOption(
                      context,
                      setState,
                      'Found better price elsewhere',
                      selectedReason,
                      (value) {
                        setState(() {
                          selectedReason = value;
                          showOtherTextField = false;
                          otherReasonController.clear();
                        });
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    // Reason 3: Delivery time too long
                    _buildDialogReasonOption(
                      context,
                      setState,
                      'Delivery time too long',
                      selectedReason,
                      (value) {
                        setState(() {
                          selectedReason = value;
                          showOtherTextField = false;
                          otherReasonController.clear();
                        });
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    // Reason 4: Ordered by mistake
                    _buildDialogReasonOption(
                      context,
                      setState,
                      'Ordered by mistake',
                      selectedReason,
                      (value) {
                        setState(() {
                          selectedReason = value;
                          showOtherTextField = false;
                          otherReasonController.clear();
                        });
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                    // Other option
                    _buildDialogReasonOption(
                      context,
                      setState,
                      'Other',
                      selectedReason,
                      (value) {
                        setState(() {
                          selectedReason = value;
                          showOtherTextField = true;
                        });
                      },
                    ),
                    // Other reason text field
                    if (showOtherTextField) ...[
                      SizedBox(height: ResponsiveUtils.rp(16)),
                      TextField(
                        controller: otherReasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: AppStrings.pleaseSpecifyReason,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                          ),
                          contentPadding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ],
                  ],
                ),
              ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ElevatedButton(
                  onPressed: (selectedReason != null && 
                              (selectedReason != 'Other' || 
                               (selectedReason == 'Other' && otherReasonController.text.trim().isNotEmpty)))
                      ? () async {
                          final reason = selectedReason == 'Other' 
                              ? otherReasonController.text.trim()
                              : selectedReason!;
                          Get.back();
                          // Request cancellation after dialog is closed
                          widget.onCancelRequested(reason);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  child: Text(
                    'Request Cancellation',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
  }

  Widget _buildDialogReasonOption(
    BuildContext context,
    StateSetter setState,
    String reason,
    String? selectedReason,
    Function(String) onTap,
  ) {
    final isSelected = selectedReason == reason;
    return InkWell(
      onTap: () => onTap(reason),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
        margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.button.withValues(alpha: 0.1)
              : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          border: Border.all(
            color: isSelected ? AppColors.button : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.button : AppColors.textSecondary,
              size: ResponsiveUtils.rp(20),
            ),
            SizedBox(width: ResponsiveUtils.rp(12)),
            Expanded(
              child: Text(
                reason,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: isSelected ? AppColors.button : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
