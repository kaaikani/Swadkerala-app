import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/theme_controller.dart';
import '../components/orders_component.dart';
import '../theme/colors.dart';
import '../services/analytics_service.dart';

enum OrderFilter { all, delivered, paid, paymentAuthorized, cancellationRequest, cancelled }

class OrdersPage extends StatefulWidget {
  final OrderFilter? initialFilter;

  const OrdersPage({super.key, this.initialFilter});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'Orders');
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
        body: OrdersComponent(
          customerController: customerController,
          filter: widget.initialFilter ?? OrderFilter.all,
        ),
      );
    });
  }
}
