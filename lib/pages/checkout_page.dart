import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/theme_controller.dart';
import '../services/razorpay_service.dart';
import '../widgets/snackbar.dart';
import '../theme/colors.dart';
import '../utils/html_utils.dart';
import '../utils/responsive.dart';
import '../widgets/address_card_premium.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final UtilityController utilityController = Get.find<UtilityController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final BannerController bannerController = Get.find<BannerController>();
  final ThemeController themeController = Get.find<ThemeController>();

  late RazorpayService _razorpayService;

  // Address selection
  AddressModel? _selectedAddress;

  // Loyalty Points
  final _loyaltyPointsController = TextEditingController();

  // Other Instructions
  final _otherInstructionsController = TextEditingController();
  Timer? _instructionsDebounceTimer;

  String? _lastAppliedShippingMethodId;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();
    debugPrint('[CheckoutPage] initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[CheckoutPage] PostFrameCallback executing...');
      _loadCustomerAddresses();
      _loadShippingMethods();
      debugPrint('[CheckoutPage] About to call _loadCouponCodes()');
      _loadCouponCodes();
      debugPrint('[CheckoutPage] _loadCouponCodes() call completed');
      debugPrint('[CheckoutPage] About to call _loadLoyaltyPointsConfig()');
      _loadLoyaltyPointsConfig();
      debugPrint('[CheckoutPage] _loadLoyaltyPointsConfig() call completed');
      _loadExistingInstructions();
    });
  }

  Future<void> _refreshPaymentMethods() async {
    await orderController.getEligiblePaymentMethods();
    if (!mounted) return;
    final eligibleMethods =
        orderController.paymentMethods.where((m) => m.isEligible).toList();
    if (eligibleMethods.isEmpty) {
      orderController.selectedPaymentMethod.value = null;
      return;
    }

    final previouslySelectedId =
        orderController.selectedPaymentMethod.value?.id;
    final stillAvailable = eligibleMethods
        .firstWhereOrNull((method) => method.id == previouslySelectedId);

    orderController.selectedPaymentMethod.value =
        stillAvailable ?? eligibleMethods.first;
  }

  @override
  void dispose() {
    _instructionsDebounceTimer?.cancel();
    _loyaltyPointsController.dispose();
    _otherInstructionsController.dispose();
    _razorpayService.dispose();
    super.dispose();
  }

  Future<void> _loadCustomerAddresses() async {
    await customerController.getActiveCustomer();
    AddressModel? defaultShipping;
    for (final address in customerController.addresses) {
      if (address.defaultShippingAddress) {
        defaultShipping = address;
        break;
      }
    }
    if (!mounted) return;
    setState(() {
      _selectedAddress = defaultShipping;
    });
  }

  Future<void> _loadShippingMethods() async {
    await orderController.getEligibleShippingMethods();

    if (orderController.shippingMethods.isEmpty) {
      orderController.selectedShippingMethod.value = null;
      _lastAppliedShippingMethodId = null;
      await _refreshPaymentMethods();
      return;
    }

    final currentId = orderController.selectedShippingMethod.value?.id;
    final existingSelection = orderController.shippingMethods
        .firstWhereOrNull((method) => method.id == currentId);
    final methodToApply =
        existingSelection ?? orderController.shippingMethods.first;

    if (orderController.selectedShippingMethod.value?.id != methodToApply.id) {
      orderController.selectedShippingMethod.value = methodToApply;
    }

    await _applyShippingMethod(force: true);
  }

  Future<void> _applyShippingMethod(
      {bool showFeedback = false, bool force = false}) async {
    final selected = orderController.selectedShippingMethod.value;
    if (selected == null) return;

    if (!force && _lastAppliedShippingMethodId == selected.id) {
      if (orderController.paymentMethods.isEmpty) {
        await _refreshPaymentMethods();
      }
      return;
    }

    final success = await orderController.setShippingMethod(selected.id);

    if (success) {
      _lastAppliedShippingMethodId = selected.id;
      if (showFeedback) {
        showSuccessSnackbar('Shipping method selected');
      }
      await cartController.getActiveOrder();
      await _refreshPaymentMethods();
    } else {
      showErrorSnackbar('Failed to set shipping method');
    }
  }

  Future<void> _loadCouponCodes() async {
    debugPrint('[CheckoutPage] ===== LOADING COUPON CODES =====');
    debugPrint('[CheckoutPage] BannerController available: true');
    debugPrint(
        '[CheckoutPage] Current coupon codes count: ${bannerController.availableCouponCodes.length}');
    debugPrint(
        '[CheckoutPage] Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');

    try {
      debugPrint(
          '[CheckoutPage] Calling bannerController.getCouponCodeList()...');
      await bannerController.getCouponCodeList();
      debugPrint(
          '[CheckoutPage] bannerController.getCouponCodeList() completed');

      debugPrint(
          '[CheckoutPage] After loading - Coupon codes count: ${bannerController.availableCouponCodes.length}');
      debugPrint(
          '[CheckoutPage] After loading - Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');

      if (bannerController.availableCouponCodes.isNotEmpty) {
        debugPrint(
            '[CheckoutPage] ✅ Successfully loaded ${bannerController.availableCouponCodes.length} coupon codes');
        for (int i = 0; i < bannerController.availableCouponCodes.length; i++) {
          final coupon = bannerController.availableCouponCodes[i];
          debugPrint(
              '[CheckoutPage] Coupon $i: ${coupon.name} (${coupon.couponCode}) - Enabled: ${coupon.enabled}');
        }
      } else {
        debugPrint('[CheckoutPage] ❌ No coupon codes loaded');
      }
    } catch (e) {
      debugPrint('[CheckoutPage] ❌ Error loading coupon codes: $e');
      debugPrint('[CheckoutPage] Error type: ${e.runtimeType}');
      debugPrint('[CheckoutPage] Stack trace: ${StackTrace.current}');
    }

    debugPrint('[CheckoutPage] ===== COUPON CODE LOADING COMPLETED =====');
  }

  Future<void> _loadLoyaltyPointsConfig() async {
    debugPrint('[CheckoutPage] ===== LOADING LOYALTY POINTS CONFIG =====');

    try {
      debugPrint(
          '[CheckoutPage] Calling bannerController.fetchLoyaltyPointsConfig()...');
      await bannerController.fetchLoyaltyPointsConfig();
      debugPrint(
          '[CheckoutPage] bannerController.fetchLoyaltyPointsConfig() completed');

      final config = bannerController.loyaltyPointsConfig.value;
      if (config != null) {
        debugPrint(
            '[CheckoutPage] ✅ Successfully loaded loyalty points config');
        debugPrint('[CheckoutPage] Rupees per point: ${config.rupeesPerPoint}');
        debugPrint('[CheckoutPage] Points per rupee: ${config.pointsPerRupee}');
      } else {
        debugPrint('[CheckoutPage] ❌ No loyalty points config loaded');
      }
    } catch (e) {
      debugPrint('[CheckoutPage] ❌ Error loading loyalty points config: $e');
      debugPrint('[CheckoutPage] Error type: ${e.runtimeType}');
      debugPrint('[CheckoutPage] Stack trace: ${StackTrace.current}');
    }

    debugPrint(
        '[CheckoutPage] ===== LOYALTY POINTS CONFIG LOADING COMPLETED =====');
  }

  Future<void> _loadExistingInstructions() async {
    try {
      await orderController.getActiveOrder();
      if (orderController.currentOrder.value?.customFields?.otherInstructions != null) {
        final instructions = orderController.currentOrder.value!.customFields!.otherInstructions!;
        if (instructions.isNotEmpty && mounted) {
          _otherInstructionsController.text = instructions;
          debugPrint('[CheckoutPage] Loaded existing instructions: $instructions');
        }
      }
    } catch (e) {
      debugPrint('[CheckoutPage] Error loading existing instructions: $e');
    }
  }

  Future<void> _handleAddressSubmit() async {
    // Use selected existing address
    if (_selectedAddress == null) {
      showErrorSnackbar('Please select a delivery address');
      return;
    }

    final success = await orderController.setShippingAddress(
      fullName: _selectedAddress!.fullName,
      phoneNumber: _selectedAddress!.phoneNumber,
      streetLine1: _selectedAddress!.streetLine1,
      streetLine2: _selectedAddress!.streetLine2,
      city: _selectedAddress!.city,
      province: _selectedAddress!.province,
      postalCode: _selectedAddress!.postalCode,
      countryCode: _selectedAddress!.country.code,
    );

    if (success) {
      showSuccessSnackbar('Address saved successfully');
      await _loadShippingMethods();
    } else {
      showErrorSnackbar('Failed to save address');
    }
  }

  Future<void> _handleShippingMethodSubmit() async {
    if (orderController.selectedShippingMethod.value == null) {
      showErrorSnackbar('Please select a shipping method');
      return;
    }

    await _applyShippingMethod(showFeedback: true, force: true);
  }

  Future<void> _handlePayment() async {
    if (orderController.selectedPaymentMethod.value == null) {
      showErrorSnackbar('Please select a payment method');
      return;
    }

    final paymentMethod = orderController.selectedPaymentMethod.value!;
    final paymentCode = paymentMethod.code.toLowerCase();

    // Check if it's online payment (Razorpay)
    if (paymentCode.contains('razorpay') || paymentCode.contains('online')) {
      await _handleRazorpayPayment();
    } else {
      // Cash on Delivery or other methods
      await _handleCODPayment();
    }
  }

  /// Handle Razorpay online payment
  Future<void> _handleRazorpayPayment() async {
    // Transition to ArrangingPayment state
    final transitioned = await orderController.transitionToArrangingPayment();
    if (!transitioned) {
      showErrorSnackbar('Failed to process order');
      return;
    }

    // Get order details from cart controller (has latest data)
    final cart = cartController.cart.value;
    if (cart == null) {
      showErrorSnackbar('Order not found');
      return;
    }

    // Calculate total (cart total + shipping if available)
    final cartTotal = cart.totalWithTax.toInt();
    final shippingCost = cartController.hasFreeShippingCoupon()
        ? 0
        : (orderController.selectedShippingMethod.value?.priceWithTax ?? 0);
    final amount = cartTotal + shippingCost;
    final orderId = cart.id;

    debugPrint(
        '[Checkout] Cart Total: $cartTotal, Shipping: $shippingCost, Final Amount: $amount');
    debugPrint(
        '[Checkout] Free shipping coupon applied: ${cartController.hasFreeShippingCoupon()}');

    // Generate Razorpay Order ID from backend
    showSuccessSnackbar('Generating payment order...');
    final razorpayOrder =
        await orderController.generateRazorpayOrderId(orderId);

    if (razorpayOrder == null) {
      showErrorSnackbar('Failed to generate Razorpay order');
      return;
    }

    debugPrint(
        '[Checkout] Razorpay Order ID: ${razorpayOrder.razorpayOrderId}');
    debugPrint('[Checkout] Razorpay Key ID: ${razorpayOrder.keyId}');

    // Open Razorpay payment gateway with backend-generated order ID
    _razorpayService.openPaymentGateway(
      razorpayOrderId: razorpayOrder.razorpayOrderId,
      razorpayKeyId: razorpayOrder.keyId,
      amountInPaise: amount, // Already in paise/cents
      customerName: _selectedAddress?.fullName ?? 'Customer',
      customerEmail: customerController.activeCustomer.value?.emailAddress ??
          'customer@example.com',
      customerPhone: _selectedAddress?.phoneNumber ?? '',
      description: 'Order #${cart.code}',
      onPaymentSuccess: (response) async {
        debugPrint(
            '[Checkout] Razorpay payment successful: ${response.paymentId}');

        // Add payment to order with Razorpay details in correct format
        final success = await orderController.addPayment(
          method: 'online', // Use 'online' as the method code
          metadata: {
            'method': 'online',
            'status': 'completed',
            'orderCode': cart.code,
            'payment_details': {
              'razorpay_order_id': response.orderId,
              'razorpay_payment_id': response.paymentId,
              'razorpay_signature': response.signature,
            },
            'paymentSource': 'client',
            'paymentStatus': 'authorized',
          },
        );

        if (success) {
          // Try to transition order to next state
          debugPrint('[Checkout] Payment successful, transitioning order...');
          final transitioned = await orderController.transitionToNextState();
          if (transitioned) {
            showSuccessSnackbar('Payment successful! Order placed.');
            Get.offAllNamed('/order-confirmation', arguments: cart.code);
          } else {
            showSuccessSnackbar('Payment successful! Order will be processed.');
            Get.offAllNamed('/order-confirmation', arguments: cart.code);
          }
        } else {
          showErrorSnackbar('Payment completed but order failed to update');
        }
      },
      onPaymentFailure: (response) {
        debugPrint('[Checkout] Razorpay payment failed: ${response.message}');
        showErrorSnackbar('Payment failed: ${response.message}');
      },
    );
  }

  /// Handle Cash on Delivery payment
  Future<void> _handleCODPayment() async {
    // Transition to ArrangingPayment state
    final transitioned = await orderController.transitionToArrangingPayment();
    if (!transitioned) {
      showErrorSnackbar('Failed to process order');
      return;
    }

    // Add payment
    final success = await orderController.addPayment(
      method: orderController.selectedPaymentMethod.value!.code,
      metadata: {
        'payment_type': 'cash_on_delivery',
      },
    );

    if (success) {
      showSuccessSnackbar('Order placed successfully!');
      // Navigate to order confirmation page
      final cart = cartController.cart.value;
      if (cart != null) {
        Get.offAllNamed('/order-confirmation', arguments: cart.code);
      } else {
        Get.offAllNamed('/home');
      }
    } else {
      showErrorSnackbar('Payment failed');
    }
  }

  /// Apply loyalty points
  Future<void> _applyLoyaltyPoints() async {
    final pointsText = _loyaltyPointsController.text.trim();
    if (pointsText.isEmpty) {
      showErrorSnackbar('Please enter loyalty points amount');
      return;
    }

    final points = int.tryParse(pointsText);
    if (points == null || points <= 0) {
      showErrorSnackbar('Please enter a valid loyalty points amount');
      return;
    }

    // Check if user has enough loyalty points available
    final availablePoints = customerController.loyaltyPoints;
    if (points > availablePoints) {
      showErrorSnackbar(
          'Insufficient loyalty points! You have $availablePoints points available. Earn more points to apply loyalty points.');
      return;
    }

    // Check minimum points requirement from config
    final config = bannerController.loyaltyPointsConfig.value;
    if (config != null && points < config.pointsPerRupee) {
      showErrorSnackbar(
          'Minimum loyalty points required: ${config.pointsPerRupee} points. Please enter ${config.pointsPerRupee} or more points.');
      return;
    }

    final success = await bannerController.applyLoyaltyPoints(points);
    if (success) {
      showSuccessSnackbar('Loyalty points applied successfully');
      setState(() {}); // Refresh UI
    } else {
      showErrorSnackbar('Failed to apply loyalty points');
    }
  }

  /// Remove loyalty points
  Future<void> _removeLoyaltyPoints() async {
    final success = await bannerController.removeLoyaltyPoints();
    if (success) {
      _loyaltyPointsController.clear();
      showSuccessSnackbar('Loyalty points removed successfully');
      setState(() {}); // Refresh UI
    } else {
      showErrorSnackbar('Failed to remove loyalty points');
    }
  }

  /// Show coupon codes bottom sheet
  void _showCouponCodesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.rp(20)),
            topRight: Radius.circular(ResponsiveUtils.rp(20)),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
              width: ResponsiveUtils.rp(40),
              height: ResponsiveUtils.rp(4),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Coupon Codes',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: ResponsiveUtils.rp(24),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: ResponsiveUtils.rp(1), color: AppColors.divider),

            // Coupon codes list
            Expanded(
              child: Obx(() {
                debugPrint(
                    '[CheckoutPage] Bottom sheet - Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');
                debugPrint(
                    '[CheckoutPage] Bottom sheet - Available coupons count: ${bannerController.availableCouponCodes.length}');

                if (!bannerController.couponCodesLoaded.value) {
                  debugPrint(
                      '[CheckoutPage] Bottom sheet - Showing loading indicator');
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.button),
                  );
                }

                final enabledCoupons = bannerController.availableCouponCodes
                    .where((coupon) => coupon.enabled)
                    .toList();

                debugPrint(
                    '[CheckoutPage] Bottom sheet - Enabled coupons count: ${enabledCoupons.length}');

                if (enabledCoupons.isEmpty) {
                  debugPrint(
                      '[CheckoutPage] Bottom sheet - No enabled coupons, showing empty state');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: ResponsiveUtils.rp(64),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: ResponsiveUtils.rp(16)),
                        Text(
                          'No coupon codes available',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                  itemCount: enabledCoupons.length,
                  itemBuilder: (context, index) {
                    final coupon = enabledCoupons[index];
                    final isApplied =
                        bannerController.isCouponCodeApplied(coupon.couponCode);
                    final descriptionText =
                        HtmlUtils.stripHtmlTags(coupon.description);

                    return Card(
                      color: AppColors.surface,
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                      elevation: ResponsiveUtils.rp(2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.rp(12)),
                        side: BorderSide(
                          color:
                              isApplied ? AppColors.success : AppColors.border,
                          width: isApplied
                              ? ResponsiveUtils.rp(2)
                              : ResponsiveUtils.rp(1),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Coupon header
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.rp(8),
                                    vertical: ResponsiveUtils.rp(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isApplied
                                        ? AppColors.success
                                        : AppColors.button,
                                    borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.rp(6)),
                                  ),
                                  child: Text(
                                    coupon.couponCode,
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveUtils.sp(12),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                if (isApplied)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.rp(8),
                                      vertical: ResponsiveUtils.rp(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.rp(6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: AppColors.textLight,
                                          size: ResponsiveUtils.rp(14),
                                        ),
                                        SizedBox(width: ResponsiveUtils.rp(4)),
                                        Text(
                                          'APPLIED',
                                          style: TextStyle(
                                            color: AppColors.textLight,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveUtils.sp(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: ResponsiveUtils.rp(12)),

                            // Coupon name
                            Text(
                              coupon.name,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            SizedBox(height: ResponsiveUtils.rp(8)),

                            // Description
                            if (descriptionText.isNotEmpty) ...[
                              Text(
                                descriptionText,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.sp(14),
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.rp(8)),
                            ],

                            // Expiry date
                            if (coupon.endsAt != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: ResponsiveUtils.rp(16),
                                    color: AppColors.error,
                                  ),
                                  SizedBox(width: ResponsiveUtils.rp(4)),
                                  Text(
                                    'Expires: ${DateTime.parse(coupon.endsAt!).toString().split(' ')[0]}',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: ResponsiveUtils.sp(12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveUtils.rp(8)),
                            ],

                            // Validation status
                            if (!isApplied) ...[
                              FutureBuilder<Map<String, dynamic>>(
                                future:
                                    bannerController.getCouponValidationStatus(
                                        coupon.couponCode),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final validation = snapshot.data!;
                                    if (!validation['valid']) {
                                      Color errorColor = AppColors.warning;
                                      if (validation['error'] ==
                                          'MINIMUM_ORDER_AMOUNT_NOT_MET') {
                                        errorColor = AppColors.error;
                                      } else if (validation['error'] ==
                                              'COUPON_EXPIRED' ||
                                          validation['error'] ==
                                              'COUPON_DISABLED') {
                                        errorColor = AppColors.textSecondary;
                                      } else if (validation['error'] ==
                                          'ANOTHER_COUPON_APPLIED') {
                                        errorColor = AppColors.info;
                                      }

                                      return Container(
                                        padding: EdgeInsets.all(
                                            ResponsiveUtils.rp(8)),
                                        decoration: BoxDecoration(
                                          color:
                                              errorColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveUtils.rp(6)),
                                          border: Border.all(
                                              color: errorColor.withValues(
                                                  alpha: 0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: errorColor,
                                              size: ResponsiveUtils.rp(16),
                                            ),
                                            SizedBox(
                                                width: ResponsiveUtils.rp(8)),
                                            Expanded(
                                              child: Text(
                                                validation['message'],
                                                style: TextStyle(
                                                  color: errorColor,
                                                  fontSize:
                                                      ResponsiveUtils.sp(11),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                              SizedBox(height: ResponsiveUtils.rp(12)),
                            ],

                            // Apply/Remove button
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                final anyCouponApplied =
                                    bannerController.isAnyCouponApplied();
                                final currentlyAppliedCoupon = bannerController
                                    .getCurrentlyAppliedCoupon();
                                final isAnotherCouponApplied =
                                    anyCouponApplied &&
                                        currentlyAppliedCoupon !=
                                            coupon.couponCode;

                                return ElevatedButton(
                                  onPressed: isAnotherCouponApplied
                                      ? null
                                      : () async {
                                          if (isApplied) {
                                            // Remove coupon
                                            final success =
                                                await bannerController
                                                    .removeCouponCode(
                                                        coupon.couponCode);
                                            if (success) {
                                              showSuccessSnackbar(
                                                  'Coupon code removed successfully');
                                              Navigator.pop(
                                                  context); // Close bottom sheet
                                              setState(() {}); // Refresh UI
                                            } else {
                                              showErrorSnackbar(
                                                  'Failed to remove coupon code');
                                            }
                                          } else {
                                            // Apply coupon
                                            if (bannerController
                                                .hasCouponProducts(
                                                    coupon.couponCode)) {
                                              // Coupon has products to add
                                              final result = await bannerController
                                                  .applyCouponCodeWithProducts(
                                                      coupon.couponCode);
                                              if (result['success']) {
                                                showSuccessSnackbar(result[
                                                        'message'] ??
                                                    'Coupon applied successfully with products added!');
                                                Navigator.pop(
                                                    context); // Close bottom sheet
                                                setState(() {}); // Refresh UI
                                              } else {
                                                if (result[
                                                        'rollbackPerformed'] ==
                                                    true) {
                                                  showErrorSnackbar(result[
                                                          'message'] ??
                                                      'Failed to apply coupon. Added products have been removed.');
                                                } else {
                                                  showErrorSnackbar(result[
                                                          'message'] ??
                                                      'Failed to apply coupon code');
                                                }
                                              }
                                            } else {
                                              // Regular coupon without products
                                              final result =
                                                  await bannerController
                                                      .applyCouponCode(
                                                          coupon.couponCode);
                                              if (result['success']) {
                                                showSuccessSnackbar(result[
                                                        'message'] ??
                                                    'Coupon applied successfully!');
                                                Navigator.pop(
                                                    context); // Close bottom sheet
                                                setState(() {}); // Refresh UI
                                              } else {
                                                showErrorSnackbar(result[
                                                        'message'] ??
                                                    'Failed to apply coupon code');
                                              }
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isAnotherCouponApplied
                                        ? AppColors.grey300
                                        : (isApplied
                                            ? AppColors.error
                                            : AppColors.success),
                                    foregroundColor: AppColors.textLight,
                                    padding: EdgeInsets.symmetric(
                                        vertical: ResponsiveUtils.rp(12)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.rp(8)),
                                    ),
                                  ),
                                  child: Text(
                                    isAnotherCouponApplied
                                        ? 'Another Coupon Applied'
                                        : (isApplied
                                            ? 'Remove Coupon'
                                            : 'Apply Coupon'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveUtils.sp(14),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
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
            'Checkout',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(() {
          if (utilityController.isLoadingRx.value) {
            return _buildShimmerCheckout();
          }

          return Column(
            children: [
              // Content Area - All sections in one scrollable view
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.wait([
                      _loadCustomerAddresses(),
                      _loadShippingMethods(),
                      _loadCouponCodes(),
                      _loadLoyaltyPointsConfig(),
                    ]);
                  },
                  color: AppColors.button,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address Section
                        _buildAddressStep(),
                        SizedBox(height: ResponsiveUtils.rp(20)),

                        // Shipping Method Section
                        _buildShippingStep(),
                        SizedBox(height: ResponsiveUtils.rp(20)),

                        // Other Instructions Section
                        _buildOtherInstructionsStep(),
                        SizedBox(height: ResponsiveUtils.rp(20)),

                        // Payment Section
                        _buildPaymentStep(),
                        SizedBox(
                            height: ResponsiveUtils.rp(
                                100)), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Place Order Button
              _buildPlaceOrderButton(),
            ],
          );
        }),
      );
    });
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
          child: Text(
            'Select Delivery Address',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(20),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // Add New Address Button
        Container(
          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await Get.toNamed('/addresses');
              await _loadCustomerAddresses();
            },
            icon: Icon(Icons.add_location_alt_rounded,
                size: ResponsiveUtils.rp(20)),
            label: Text('Add New Address'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.button,
              side: BorderSide(color: AppColors.button),
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              ),
            ),
          ),
        ),

        // Address List
        Obx(() {
          if (customerController.addresses.isEmpty) {
            return Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(40)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.location_off_rounded,
                    size: ResponsiveUtils.rp(48),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  Text(
                    'No addresses found',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Text(
                    'Please add a delivery address to continue',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(14),
                    ),
                  ),
                ],
              ),
            );
          }

          AddressModel? shippingAddress;
          for (final address in customerController.addresses) {
            if (address.defaultShippingAddress) {
              shippingAddress = address;
              break;
            }
          }

          if (shippingAddress != null &&
              _selectedAddress?.id != shippingAddress.id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedAddress = shippingAddress;
                });
              }
            });
          }

          if (shippingAddress == null) {
            return Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: ResponsiveUtils.rp(36),
                    color: AppColors.warning,
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  Text(
                    'No default shipping address set',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Text(
                    'Please mark an address as your shipping address to continue.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(13),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Get.toNamed('/addresses');
                      await _loadCustomerAddresses();
                    },
                    icon: Icon(Icons.manage_accounts_outlined,
                        size: ResponsiveUtils.rp(18)),
                    label: const Text('Manage Addresses'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(20),
                          vertical: ResponsiveUtils.rp(12)),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  border: Border.all(color: AppColors.button, width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                  child: AddressCardPremium(
                    fullName: shippingAddress.fullName,
                    streetLine1: shippingAddress.streetLine1,
                    streetLine2: shippingAddress.streetLine2,
                    city: shippingAddress.city,
                    postalCode: shippingAddress.postalCode,
                    phoneNumber: shippingAddress.phoneNumber,
                    isSelected: true,
                    isDefault: true,
                    onTap: () async {
                      await Get.toNamed('/addresses');
                      await _loadCustomerAddresses();
                    },
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    await Get.toNamed('/addresses');
                    await _loadCustomerAddresses();
                  },
                  icon: Icon(
                    Icons.edit_location_alt_outlined,
                    size: ResponsiveUtils.rp(16),
                  ),
                  label: const Text('Manage Addresses'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.button,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildShippingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
          child: Text(
            'Select Delivery Method',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(20),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // Shipping Methods
        ...orderController.shippingMethods.map((method) {
          final isSelected =
              orderController.selectedShippingMethod.value?.id == method.id;
          return Container(
            margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              border: Border.all(
                color: isSelected ? AppColors.button : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: InkWell(
              onTap: () async {
                if (orderController.selectedShippingMethod.value?.id ==
                    method.id) return;
                orderController.selectedShippingMethod.value = method;
                await _applyShippingMethod();
              },
              child: Padding(
                padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                child: Row(
                  children: [
                    Container(
                      width: ResponsiveUtils.rp(20),
                      height: ResponsiveUtils.rp(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected ? AppColors.button : AppColors.border,
                          width: 2,
                        ),
                        color:
                            isSelected ? AppColors.button : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(Icons.check,
                              color: Colors.white, size: ResponsiveUtils.rp(14))
                          : null,
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.name,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.rp(4)),
                          Text(
                            '${method.description}\n${cartController.formatPrice(method.priceWithTax)}',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(13),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOtherInstructionsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
          child: Text(
            'Additional Instructions (Optional)',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(20),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // Instructions Text Field
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
            border: Border.all(color: AppColors.border),
          ),
          padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add any special instructions for your order',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              TextField(
                controller: _otherInstructionsController,
                maxLines: 6,
                minLines: 4,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Leave at door, Call before delivery, Special packaging requirements...',
                  hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: ResponsiveUtils.sp(14),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    borderSide: BorderSide(color: AppColors.button, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                ),
                onChanged: (value) {
                  // Auto-save instructions as user types (debounced)
                  _saveOtherInstructions(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveOtherInstructions(String instructions) {
    // Cancel previous timer
    _instructionsDebounceTimer?.cancel();
    
    // Debounce: Only save after user stops typing for 1.5 seconds
    _instructionsDebounceTimer = Timer(Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      
      final currentText = _otherInstructionsController.text.trim();
      if (currentText.isEmpty) {
        return; // Don't save empty instructions
      }
      
      await orderController.setOtherInstruction(currentText);
    });
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Methods
        Container(
          padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
          child: Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(20),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        Obx(() {
          final eligibleMethods = orderController.paymentMethods
              .where((m) => m.isEligible)
              .toList();

          if (eligibleMethods.isEmpty) {
            return Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No payment methods available right now.',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Text(
                    'Please try again later or contact support.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(13),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: eligibleMethods.map((method) {
              final isSelected =
                  orderController.selectedPaymentMethod.value?.id == method.id;
              return Container(
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  border: Border.all(
                    color: isSelected ? AppColors.button : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    orderController.selectedPaymentMethod.value = method;
                  },
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                    child: Row(
                      children: [
                        Container(
                          width: ResponsiveUtils.rp(20),
                          height: ResponsiveUtils.rp(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.button
                                  : AppColors.border,
                              width: 2,
                            ),
                            color: isSelected
                                ? AppColors.button
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? Icon(Icons.check,
                                  color: Colors.white,
                                  size: ResponsiveUtils.rp(14))
                              : null,
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.code.toUpperCase(),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(15),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (method.eligibilityMessage != null) ...[
                                SizedBox(height: ResponsiveUtils.rp(4)),
                                Text(
                                  method.eligibilityMessage!,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(13),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),

        SizedBox(height: ResponsiveUtils.rp(16)),

        // Coupon Codes Section
        _buildCouponSection(),

        SizedBox(height: ResponsiveUtils.rp(16)),

        // Loyalty Points Section
        _buildLoyaltyPointsSection(),

        SizedBox(height: ResponsiveUtils.rp(16)),

        // Order Summary
        _buildOrderSummary(),
      ],
    );
  }

  Widget _buildCouponSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Coupon Codes',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Obx(() {
                final appliedCount = bannerController.appliedCouponCodes.length;
                if (appliedCount > 0) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(12)),
                    ),
                    child: Text(
                      '$appliedCount Applied',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.sp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Obx(() {
            if (bannerController.appliedCouponCodes.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.success,
                            size: ResponsiveUtils.rp(16)),
                        SizedBox(width: ResponsiveUtils.rp(8)),
                        Text(
                          'Applied Coupons:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                            fontSize: ResponsiveUtils.sp(14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    ...bannerController.appliedCouponCodes.map(
                      (code) => Padding(
                        padding: EdgeInsets.only(
                            left: ResponsiveUtils.rp(24),
                            bottom: ResponsiveUtils.rp(4)),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer,
                                color: AppColors.success,
                                size: ResponsiveUtils.rp(14)),
                            SizedBox(width: ResponsiveUtils.rp(8)),
                            Text(code,
                                style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveUtils.sp(13))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCouponCodesBottomSheet(),
              icon: Icon(Icons.local_offer, size: ResponsiveUtils.rp(20)),
              label: Text('Browse Coupons'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyPointsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loyalty Points',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(18),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Obx(() {
            final availablePoints = customerController.loyaltyPoints;
            final config = bannerController.loyaltyPointsConfig.value;
            final minimumPoints = config?.pointsPerRupee ?? 0;

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                  decoration: BoxDecoration(
                    color: availablePoints > 0
                        ? AppColors.info.withValues(alpha: 0.1)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    border: Border.all(
                      color: availablePoints > 0
                          ? AppColors.info.withValues(alpha: 0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.stars,
                          color: availablePoints > 0
                              ? AppColors.info
                              : AppColors.textSecondary,
                          size: ResponsiveUtils.rp(20)),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Available: $availablePoints points',
                        style: TextStyle(
                          color: availablePoints > 0
                              ? AppColors.info
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
                if (minimumPoints > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Text(
                    'Minimum: $minimumPoints points',
                    style: TextStyle(
                        color: AppColors.warning,
                        fontSize: ResponsiveUtils.sp(12)),
                  ),
                ],
              ],
            );
          }),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _loyaltyPointsController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter points',
                    hintStyle: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: ResponsiveUtils.sp(14)),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.rp(8))),
                    filled: true,
                    fillColor: AppColors.inputFill,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(8)),
              ElevatedButton(
                onPressed: _applyLoyaltyPoints,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(16),
                      vertical: ResponsiveUtils.rp(12)),
                ),
                child: Text('Apply'),
              ),
            ],
          ),
          Obx(() {
            if (bannerController.loyaltyPointsApplied.value) {
              return Padding(
                padding: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Applied: ${bannerController.loyaltyPointsUsed.value} points',
                      style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.sp(14)),
                    ),
                    TextButton(
                      onPressed: _removeLoyaltyPoints,
                      child: Text('Remove',
                          style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
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
          Divider(color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal',
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary)),
              Obx(() {
                final subtotal =
                    (cartController.cart.value?.subTotalWithTax ?? 0).toInt();
                return Text(
                  cartController.formatPrice(subtotal),
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textPrimary),
                );
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping',
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary)),
              Obx(() {
                if (cartController.hasFreeShippingCoupon()) {
                  return Text('Free',
                      style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.sp(14)));
                }
                return Text(
                  orderController.selectedShippingMethod.value != null
                      ? cartController.formatPrice(orderController
                          .selectedShippingMethod.value!.priceWithTax)
                      : 'TBD',
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textPrimary),
                );
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Obx(() {
            final payment = orderController.selectedPaymentMethod.value;
            if (payment == null) return SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment',
                    style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        color: AppColors.textSecondary)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          payment.code.toUpperCase(),
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (payment.eligibilityMessage != null)
                          Padding(
                            padding:
                                EdgeInsets.only(top: ResponsiveUtils.rp(2)),
                            child: Text(
                              payment.eligibilityMessage!,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(12),
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          Divider(color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(16),
                      color: AppColors.textPrimary)),
              Obx(() {
                final total =
                    (cartController.cart.value?.totalWithTax ?? 0).toInt();
                return Text(
                  cartController.formatPrice(total),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(16),
                      color: AppColors.button),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order Total Summary
            Obx(() {
              final total =
                  (cartController.cart.value?.totalWithTax ?? 0).toInt();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    cartController.formatPrice(total),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.button,
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Validate all selections
                  if (_selectedAddress == null) {
                    showErrorSnackbar('Please select a delivery address');
                    return;
                  }
                  if (orderController.selectedShippingMethod.value == null) {
                    showErrorSnackbar('Please select a shipping method');
                    return;
                  }
                  if (orderController.selectedPaymentMethod.value == null) {
                    showErrorSnackbar('Please select a payment method');
                    return;
                  }

                  // Submit address and shipping method first
                  await _handleAddressSubmit();
                  await _handleShippingMethodSubmit();

                  // Then proceed to payment
                  await _handlePayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                ),
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCheckout() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address section shimmer
            Container(
              height: ResponsiveUtils.rp(120),
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
            // Payment method shimmer
            Container(
              height: ResponsiveUtils.rp(20),
              width: ResponsiveUtils.rp(150),
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            ...List.generate(
                2,
                (index) => Container(
                      height: ResponsiveUtils.rp(60),
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
            SizedBox(height: ResponsiveUtils.rp(24)),
            // Order summary shimmer
            Container(
              height: ResponsiveUtils.rp(20),
              width: ResponsiveUtils.rp(150),
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            ...List.generate(
                4,
                (index) => Container(
                      height: ResponsiveUtils.rp(40),
                      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
            SizedBox(height: ResponsiveUtils.rp(24)),
            // Place order button shimmer
            Container(
              height: ResponsiveUtils.rp(48),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
