import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/theme_controller.dart';
import '../components/orders_component.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

enum OrderFilter { all, delivered, paid, paymentAuthorized, cancelled }

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, this.initialFilter});

  final OrderFilter? initialFilter;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrderFilter _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? OrderFilter.all;
  }

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController =
        Get.find<CustomerController>();
    final ThemeController themeController = Get.find<ThemeController>();

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
            'My Orders',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            _buildFilterTabs(),
            Expanded(
              child: OrdersComponent(
                customerController: customerController,
                filter: _selectedFilter,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterTabs() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.rp(12),
        horizontal: ResponsiveUtils.rp(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', OrderFilter.all),
            SizedBox(width: ResponsiveUtils.rp(8)),
            _buildFilterChip('Order Confirmed', OrderFilter.paymentAuthorized),
            SizedBox(width: ResponsiveUtils.rp(8)),
            _buildFilterChip('Paid', OrderFilter.paid),
            SizedBox(width: ResponsiveUtils.rp(8)),
            _buildFilterChip('Delivered', OrderFilter.delivered),
            SizedBox(width: ResponsiveUtils.rp(8)),
            _buildFilterChip('Cancelled', OrderFilter.cancelled),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, OrderFilter filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(8),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.button
              : AppColors.inputFill,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          border: Border.all(
            color: isSelected
                ? AppColors.button
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(13),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
