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
    extends State<LoyaltyPointsTransactionPage> with SingleTickerProviderStateMixin {
  final CustomerController customerController = Get.find<CustomerController>();
  List<LoyaltyTransaction> _transactions = [];
  List<LoyaltyTransaction> _filteredTransactions = [];
  bool _isLoading = true;
  late TabController _tabController;
  TransactionFilter _currentFilter = TransactionFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchTransactions();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _currentFilter = TransactionFilter.values[_tabController.index];
      _applyFilter();
    });
  }

  void _applyFilter() {
    switch (_currentFilter) {
      case TransactionFilter.all:
        _filteredTransactions = _transactions;
        break;
      case TransactionFilter.earned:
        _filteredTransactions = _transactions
            .where((t) => t.type == TransactionType.earned)
            .toList();
        break;
      case TransactionFilter.used:
        _filteredTransactions = _transactions
            .where((t) => t.type == TransactionType.used)
            .toList();
        break;
    }
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await customerController.getActiveCustomer();

      final orders = customerController.orders;
      final transactions = <LoyaltyTransaction>[];

      for (final order in orders) {
        final loyaltyPointsEarned =
            order.customFields?.loyaltyPointsEarned ?? 0;
        final loyaltyPointsUsed = order.customFields?.loyaltyPointsUsed ?? 0;
        final orderPlacedAt = order.orderPlacedAt;
        final orderCode = order.code;
        final orderState = order.state;

        if (loyaltyPointsEarned > 0) {
          transactions.add(LoyaltyTransaction(
            type: TransactionType.earned,
            points: loyaltyPointsEarned,
            date: orderPlacedAt,
            description: 'Earned from Order',
            orderCode: orderCode,
            orderState: orderState,
          ));
        }

        if (loyaltyPointsUsed > 0) {
          transactions.add(LoyaltyTransaction(
            type: TransactionType.used,
            points: loyaltyPointsUsed,
            date: orderPlacedAt,
            description: 'Redeemed for Order',
            orderCode: orderCode,
            orderState: orderState,
          ));
        }
      }

      transactions.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _transactions = transactions;
        _applyFilter();
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
    final totalEarned = _transactions
        .where((t) => t.type == TransactionType.earned)
        .fold<int>(0, (sum, t) => sum + t.points);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Loyalty Points',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(20),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Enhanced Balance Card
          _buildBalanceCard(availablePoints, totalEarned),
          
          // Filter Tabs
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.button,
              indicatorWeight: 3,
              labelColor: AppColors.button,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Earned'),
                Tab(text: 'Used'),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredTransactions.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _fetchTransactions,
                        color: AppColors.button,
                        child: _buildTransactionsList(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(int availablePoints, int totalEarned) {
    return Container(
      margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.button,
            AppColors.button.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Points',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$availablePoints',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveUtils.sp(40),
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(6)),
                          child: Text(
                            'pts',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  ),
                  child: Icon(
                    Icons.stars_rounded,
                    color: Colors.white,
                    size: ResponsiveUtils.rp(32),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(20)),
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: ResponsiveUtils.rp(20),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Text(
                    'Total Earned: $totalEarned pts',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: ResponsiveUtils.sp(13),
                      fontWeight: FontWeight.w500,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.button,
            strokeWidth: 3,
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Text(
            'Loading transactions...',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: ResponsiveUtils.rp(64),
              color: AppColors.button,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(24)),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(18),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            _currentFilter == TransactionFilter.all
                ? 'Your loyalty points transactions will appear here'
                : _currentFilter == TransactionFilter.earned
                    ? 'You haven\'t earned any points yet'
                    : 'You haven\'t used any points yet',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    // Group transactions by date
    final groupedTransactions = <String, List<LoyaltyTransaction>>{};
    
    for (final transaction in _filteredTransactions) {
      final dateKey = _getDateKey(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(16),
        vertical: ResponsiveUtils.rp(12),
      ),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final transactions = groupedTransactions[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Padding(
              padding: EdgeInsets.only(
                left: ResponsiveUtils.rp(4),
                top: index == 0 ? 0 : ResponsiveUtils.rp(16),
                bottom: ResponsiveUtils.rp(12),
              ),
              child: Text(
                _formatDateHeader(transactions.first.date),
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Transactions for this date
            ...transactions.map((transaction) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
              child: _buildTransactionCard(transaction),
            )),
          ],
        );
      },
    );
  }

  Widget _buildTransactionCard(LoyaltyTransaction transaction) {
    final isEarned = transaction.type == TransactionType.earned;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        border: Border.all(
          color: isEarned
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.orange.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          onTap: () {
            // Could show transaction details
          },
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: ResponsiveUtils.rp(48),
                  height: ResponsiveUtils.rp(48),
                  decoration: BoxDecoration(
                    color: isEarned
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  ),
                  child: Icon(
                    isEarned ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
                    color: isEarned ? Colors.green.shade700 : Colors.orange.shade700,
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
                      SizedBox(height: ResponsiveUtils.rp(6)),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: ResponsiveUtils.rp(14),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(4)),
                          Text(
                            _formatTime(transaction.date),
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(12),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (transaction.orderCode != null) ...[
                            SizedBox(width: ResponsiveUtils.rp(12)),
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
                                '#${transaction.orderCode}',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(11),
                                  color: AppColors.button,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Points Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isEarned ? '+' : '-',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(18),
                            fontWeight: FontWeight.bold,
                            color: isEarned ? Colors.green.shade700 : Colors.orange.shade700,
                            height: 1,
                          ),
                        ),
                        Text(
                          '${transaction.points}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(20),
                            fontWeight: FontWeight.bold,
                            color: isEarned ? Colors.green.shade700 : Colors.orange.shade700,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(2)),
                    Text(
                      'points',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(11),
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
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

enum TransactionFilter {
  all,
  earned,
  used,
}
