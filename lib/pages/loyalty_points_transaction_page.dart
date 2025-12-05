import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

class LoyaltyPointsTransactionPage extends StatefulWidget {
  const LoyaltyPointsTransactionPage({super.key});

  @override
  State<LoyaltyPointsTransactionPage> createState() =>
      _LoyaltyPointsTransactionPageState();
}

class _LoyaltyPointsTransactionPageState
    extends State<LoyaltyPointsTransactionPage> {
  final CustomerController customerController = Get.find<CustomerController>();
  List<LoyaltyTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch orders with loyalty points data
      await customerController.getActiveCustomer();

      // Build transactions from orders
      final orders = customerController.orders;
      final transactions = <LoyaltyTransaction>[];

      for (final order in orders) {
        final loyaltyPointsEarned =
            order.customFields?.loyaltyPointsEarned ?? 0;
        final loyaltyPointsUsed = order.customFields?.loyaltyPointsUsed ?? 0;
        final orderPlacedAt = order.orderPlacedAt;
        final orderCode = order.code;
        final orderState = order.state;

        // Add earned transaction
        if (loyaltyPointsEarned > 0) {
          transactions.add(LoyaltyTransaction(
            type: TransactionType.earned,
            points: loyaltyPointsEarned,
            date: orderPlacedAt,
            description: 'Earned on Order #$orderCode',
            orderCode: orderCode,
            orderState: orderState,
          ));
        }

        // Add used transaction
        if (loyaltyPointsUsed > 0) {
          transactions.add(LoyaltyTransaction(
            type: TransactionType.used,
            points: loyaltyPointsUsed,
            date: orderPlacedAt,
            description: 'Used on Order #$orderCode',
            orderCode: orderCode,
            orderState: orderState,
          ));
        }
      }

      // Sort by date (newest first)
      transactions.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
debugPrint('[LoyaltyPoints] Error fetching transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = customerController.activeCustomer.value;
    final availablePoints = customer?.customFields?.loyaltyPointsAvailable ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          'Loyalty Points',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Balance Card
          Container(
            margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.button,
                  AppColors.button.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.button.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Available Points',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: ResponsiveUtils.sp(14),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Text(
                  '$availablePoints',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.sp(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.button,
                    ),
                  )
                : _transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: ResponsiveUtils.rp(16)),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchTransactions,
                        color: AppColors.refreshIndicator,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(8),
                          ),
                          itemCount: _transactions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: ResponsiveUtils.rp(8)),
                          itemBuilder: (context, index) {
                            return _buildTransactionCard(_transactions[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(LoyaltyTransaction transaction) {
    final isEarned = transaction.type == TransactionType.earned;
    final color = isEarned ? Colors.green : Colors.red;
    final icon = isEarned ? Icons.add_circle : Icons.remove_circle;
    final prefix = isEarned ? '+' : '-';

    // Format date and time
    final formattedDate = _formatDate(transaction.date);
    final formattedTime = _formatTime(transaction.date);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveUtils.rp(24),
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.rp(12),
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(4)),
                      Text(
                        '$formattedDate • $formattedTime',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (transaction.orderCode != null) ...[
                    SizedBox(height: ResponsiveUtils.rp(4)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(8),
                        vertical: ResponsiveUtils.rp(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                      ),
                      child: Text(
                        'Order: ${transaction.orderCode}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(11),
                          color: AppColors.button,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Points Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix${transaction.points}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  'points',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(11),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12;
    final hour12 = hour == 0 ? 12 : hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour < 12 ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:$minute $amPm';
  }
}

class LoyaltyTransaction {
  final TransactionType type;
  final int points;
  final DateTime date;
  final String description;
  final String? orderCode;
  final String? orderState;

  LoyaltyTransaction({
    required this.type,
    required this.points,
    required this.date,
    required this.description,
    this.orderCode,
    this.orderState,
  });
}

enum TransactionType {
  earned,
  used,
}

