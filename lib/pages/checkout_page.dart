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
import '../services/analytics_service.dart';
import '../widgets/snackbar.dart';
import 'package:firebase_analytics/firebase_analytics.dart' as analytics;
import '../theme/colors.dart';
import '../utils/html_utils.dart';
import '../utils/responsive.dart';
// import '../widgets/checkout/checkout_address_section.dart'; // Unused import
import '../widgets/checkout/checkout_payment_section.dart';
// import '../widgets/checkout/checkout_summary_section.dart'; // Unused import
import 'package:slide_to_act/slide_to_act.dart';

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

  // Step management for checkout flow
  // ignore: unused_field
  int _currentStep = 0; // 0: Delivery, 1: Review & Offers, 2: Payment

  // Address selection
  AddressModel? _selectedAddress;

  // Expandable sections for slide-down animations
  // ignore: unused_field
  bool _isPaymentExpanded = false;
  // ignore: unused_field
  bool _isOrderSummaryExpanded = false;
  
  // SlideAction key for resetting
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey<SlideActionState>();

  // Loyalty Points
  final _loyaltyPointsController = TextEditingController();

  // Other Instructions
  final _otherInstructionsController = TextEditingController();
  Timer? _instructionsDebounceTimer;
  // ignore: unused_field
  bool _showInstructionsOptions = false;
  // ignore: unused_field
  bool _showOtherTextField = false;
  // ignore: unused_field
  String? _selectedDefaultInstruction;

  // Default instruction options
  final List<String> _defaultInstructions = [
    'Leave at door',
    'Call before delivery',
    'Special packaging required',
  ];

  String? _lastAppliedShippingMethodId;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();
// debugPrint('[CheckoutPage] initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
// debugPrint('[CheckoutPage] PostFrameCallback executing...');
      // Load shipping address first (at the top)
      _loadCustomerAddresses();
      // Then load other data
      _loadShippingMethods();
// debugPrint('[CheckoutPage] About to call _loadCouponCodes()');
      _loadCouponCodes();
// debugPrint('[CheckoutPage] _loadCouponCodes() call completed');
// debugPrint('[CheckoutPage] About to call _loadLoyaltyPointsConfig()');
      _loadLoyaltyPointsConfig();
// debugPrint('[CheckoutPage] _loadLoyaltyPointsConfig() call completed');
      _loadExistingInstructions();
      _loadExistingCouponCodes();
      _loadExistingLoyaltyPoints();
    });
  }

  @override
  void dispose() {
    _loyaltyPointsController.dispose();
    _otherInstructionsController.dispose();
    _instructionsDebounceTimer?.cancel();
    _razorpayService.dispose();
    super.dispose();
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
    
    // Load shipping methods after address selection
    _loadShippingMethods();
  }

  Future<void> _loadShippingMethods() async {
    await orderController.getEligibleShippingMethods();

    if (orderController.shippingMethods.isEmpty) {
      orderController.selectedShippingMethod.value = null;
      _lastAppliedShippingMethodId = null;
      await _refreshPaymentMethods();
      return;
    }

    // Don't auto-select delivery method if already selected
    if (orderController.selectedShippingMethod.value != null) {
      // If shipping method already selected, just refresh payment methods if needed
      if (orderController.paymentMethods.isEmpty) {
        await _refreshPaymentMethods();
      }
      return;
    }

    final currentId = orderController.selectedShippingMethod.value?.id;
    final existingSelection = orderController.shippingMethods
        .firstWhereOrNull((method) => method.id == currentId);
    final methodToApply =
        existingSelection ?? orderController.shippingMethods.first;

    // If method is already selected and applied, don't re-apply
    if (currentId != null && 
        currentId == methodToApply.id && 
        _lastAppliedShippingMethodId == currentId) {
      // Method already applied, just refresh payment methods if needed
      if (orderController.paymentMethods.isEmpty) {
        await _refreshPaymentMethods();
      }
      return;
    }

    if (orderController.selectedShippingMethod.value?.id != methodToApply.id) {
      orderController.selectedShippingMethod.value = methodToApply;
    }

    await _applyShippingMethod(force: true);
  }

  Future<void> _applyShippingMethod(
      {bool showFeedback = false, bool force = false}) async {
    final selected = orderController.selectedShippingMethod.value;
    if (selected == null) return;

    // If method is already applied and not forcing, skip without loading
    if (!force && _lastAppliedShippingMethodId == selected.id) {
      if (orderController.paymentMethods.isEmpty) {
        await _refreshPaymentMethods();
      }
      return;
    }

    // Check if shipping method is already set in current order
    final currentOrder = orderController.currentOrder.value;
    final isAlreadySet = currentOrder != null &&
        currentOrder.shippingLines.isNotEmpty &&
        currentOrder.shippingLines.any((line) => line.shippingMethod.id == selected.id);

    // If already set and not forcing, skip API call and loading
    if (!force && isAlreadySet && _lastAppliedShippingMethodId == selected.id) {
      if (orderController.paymentMethods.isEmpty) {
        await _refreshPaymentMethods();
      }
      return;
    }

    // Skip loading if method is already set in the order
    final skipIfAlreadySet = !force && isAlreadySet;
    final success = await orderController.setShippingMethod(
      selected.id, 
      skipIfAlreadySet: skipIfAlreadySet,
    );

    if (success) {
      _lastAppliedShippingMethodId = selected.id;
      if (showFeedback) {
        showSuccessSnackbar('Shipping method selected');
      }
      // Only refresh cart if method was actually changed
      // Note: getActiveOrder() in cart controller doesn't show loading, so it's fine to call it
      if (!skipIfAlreadySet) {
        await cartController.getActiveOrder();
      }
      await _refreshPaymentMethods();
    } else {
      showErrorSnackbar('Failed to set shipping method');
    }
  }

  Future<void> _loadCouponCodes() async {
// debugPrint('[CheckoutPage] ===== LOADING COUPON CODES =====');
// debugPrint('[CheckoutPage] BannerController available: true');
/// debugPrint(  '[CheckoutPage] Current coupon codes count: ${bannerController.availableCouponCodes.length}');
/// debugPrint(  '[CheckoutPage] Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');

    try {
/// debugPrint(  '[CheckoutPage] Calling bannerController.getCouponCodeList()...');
      await bannerController.getCouponCodeList();
/// debugPrint(  '[CheckoutPage] bannerController.getCouponCodeList() completed');

/// debugPrint(  '[CheckoutPage] After loading - Coupon codes count: ${bannerController.availableCouponCodes.length}');
/// debugPrint(  '[CheckoutPage] After loading - Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');

      if (bannerController.availableCouponCodes.isNotEmpty) {
/// debugPrint(  '[CheckoutPage] ✅ Successfully loaded ${bannerController.availableCouponCodes.length} coupon codes');
        for (int i = 0; i < bannerController.availableCouponCodes.length; i++) {
          // final coupon = bannerController.availableCouponCodes[i]; // Unused variable
// debugPrint( '[CheckoutPage] Coupon $i: ${bannerController.availableCouponCodes[i].name} (${bannerController.availableCouponCodes[i].couponCode}) - Enabled: ${bannerController.availableCouponCodes[i].enabled}');
        }
      } else {
// debugPrint('[CheckoutPage] ❌ No coupon codes loaded');
      }
    } catch (e) {
// debugPrint('[CheckoutPage] ❌ Error loading coupon codes: $e');
// debugPrint('[CheckoutPage] Error type: ${e.runtimeType}');
// debugPrint('[CheckoutPage] Stack trace: ${StackTrace.current}');
    }

// debugPrint('[CheckoutPage] ===== COUPON CODE LOADING COMPLETED =====');
  }

  Future<void> _loadLoyaltyPointsConfig() async {
// debugPrint('[CheckoutPage] ===== LOADING LOYALTY POINTS CONFIG =====');

    try {
/// debugPrint(  '[CheckoutPage] Calling bannerController.fetchLoyaltyPointsConfig()...');
      await bannerController.fetchLoyaltyPointsConfig();
/// debugPrint(  '[CheckoutPage] bannerController.fetchLoyaltyPointsConfig() completed');

      final config = bannerController.loyaltyPointsConfig.value;
      if (config != null) {
/// debugPrint(  '[CheckoutPage] ✅ Successfully loaded loyalty points config');
// debugPrint('[CheckoutPage] Rupees per point: ${config.rupeesPerPoint}');
// debugPrint('[CheckoutPage] Points per rupee: ${config.pointsPerRupee}');
      } else {
// debugPrint('[CheckoutPage] ❌ No loyalty points config loaded');
      }
    } catch (e) {
// debugPrint('[CheckoutPage] ❌ Error loading loyalty points config: $e');
// debugPrint('[CheckoutPage] Error type: ${e.runtimeType}');
// debugPrint('[CheckoutPage] Stack trace: ${StackTrace.current}');
    }

/// debugPrint(  '[CheckoutPage] ===== LOYALTY POINTS CONFIG LOADING COMPLETED =====');
  }

  Future<void> _loadExistingInstructions() async {
    try {
      // Skip loading state when loading existing instructions
      await orderController.getActiveOrder(skipLoading: true);
      if (orderController.currentOrder.value?.customFields?.otherInstructions != null) {
        final instructions = orderController.currentOrder.value!.customFields!.otherInstructions!;
        if (instructions.isNotEmpty && mounted) {
          _otherInstructionsController.text = instructions;
          
          // Check if it matches a default instruction
          if (_defaultInstructions.contains(instructions)) {
            setState(() {
              _selectedDefaultInstruction = instructions;
              _showInstructionsOptions = true;
              _showOtherTextField = false;
            });
          } else {
            // It's a custom instruction
            setState(() {
              _showInstructionsOptions = true;
              _showOtherTextField = true;
              _selectedDefaultInstruction = null;
            });
          }
          
// debugPrint('[CheckoutPage] Loaded existing instructions: $instructions');
        }
      }
    } catch (e) {
// debugPrint('[CheckoutPage] Error loading existing instructions: $e');
    }
  }

  /// Load existing coupon codes from the order
  Future<void> _loadExistingCouponCodes() async {
    try {
// debugPrint('[CheckoutPage] Loading existing coupon codes from order...');
      await cartController.getActiveOrder();
      
      final cart = cartController.cart.value;
      if (cart != null && cart.couponCodes.isNotEmpty) {
// debugPrint('[CheckoutPage] Found ${cart.couponCodes.length} coupon codes in order: ${cart.couponCodes}');
        
        // Sync applied coupon codes with the order
        for (final couponCode in cart.couponCodes) {
          if (!bannerController.appliedCouponCodes.contains(couponCode)) {
            bannerController.appliedCouponCodes.add(couponCode);
// debugPrint('[CheckoutPage] Added coupon code to applied list: $couponCode');
          }
        }
        
        // Remove any coupon codes that are not in the order
        final codesToRemove = bannerController.appliedCouponCodes
            .where((code) => !cart.couponCodes.contains(code))
            .toList();
        for (final code in codesToRemove) {
          bannerController.appliedCouponCodes.remove(code);
// debugPrint('[CheckoutPage] Removed coupon code from applied list: $code');
        }
        
// debugPrint('[CheckoutPage] Synced applied coupon codes: ${bannerController.appliedCouponCodes}');
      } else {
// debugPrint('[CheckoutPage] No coupon codes found in order');
      }
    } catch (e) {
// debugPrint('[CheckoutPage] Error loading existing coupon codes: $e');
    }
  }

  /// Load existing loyalty points from the order
  Future<void> _loadExistingLoyaltyPoints() async {
    try {
// debugPrint('[CheckoutPage] Loading existing loyalty points from order...');
      await orderController.getActiveOrder(skipLoading: true);
      
      final order = orderController.currentOrder.value;
      if (order != null && order.customFields != null) {
        final loyaltyPointsUsed = order.customFields!.loyaltyPointsUsed;
        
        if (loyaltyPointsUsed != null && loyaltyPointsUsed > 0) {
// debugPrint('[CheckoutPage] Found loyalty points used in order: $loyaltyPointsUsed');
          
          // Sync loyalty points state
          bannerController.loyaltyPointsUsed.value = loyaltyPointsUsed;
          bannerController.loyaltyPointsApplied.value = true;
          
          // Update the text field to show applied points
          if (mounted) {
            _loyaltyPointsController.text = loyaltyPointsUsed.toString();
// debugPrint('[CheckoutPage] Updated loyalty points controller with: $loyaltyPointsUsed');
          }
        } else {
// debugPrint('[CheckoutPage] No loyalty points found in order');
          // Reset if no points are applied
          bannerController.loyaltyPointsApplied.value = false;
          bannerController.loyaltyPointsUsed.value = 0;
          if (mounted) {
            _loyaltyPointsController.clear();
          }
        }
      }
    } catch (e) {
// debugPrint('[CheckoutPage] Error loading existing loyalty points: $e');
    }
  }


  // ignore: unused_element
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

  Future<void> _onPlaceOrder() async {
    // Validate checkout before proceeding
    if (!_validateCheckout()) {
      return;
    }
    
    // Validate payment method
    if (orderController.selectedPaymentMethod.value == null) {
      showErrorSnackbar('Please select a payment method');
      return;
    }

    // Set shipping address when placing order
    if (_selectedAddress != null) {
      await orderController.setShippingAddress(
        fullName: _selectedAddress!.fullName,
        phoneNumber: _selectedAddress!.phoneNumber,
        streetLine1: _selectedAddress!.streetLine1,
        streetLine2: _selectedAddress!.streetLine2,
        city: _selectedAddress!.city,
        province: _selectedAddress!.province,
        postalCode: _selectedAddress!.postalCode,
        countryCode: _selectedAddress!.country.code,
        skipLoading: true,
      );
    }

    // Then proceed to payment (shipping method should already be set)
    await _handlePayment();
  }

  /// Handle Razorpay online payment
  Future<void> _handleRazorpayPayment() async {
// debugPrint('[Checkout] [Razorpay] Starting payment flow...');
    // final currentOrderBeforeTransition = orderController.currentOrder.value; // Unused variable
// debugPrint('[Checkout] [Razorpay] Order state before transition: ${orderController.currentOrder.value?.state ?? "null"}');
// debugPrint('[Checkout] [Razorpay] Order ID before transition: ${orderController.currentOrder.value?.id ?? "null"}');
    
    // Transition to ArrangingPayment state
    final transitioned = await orderController.transitionToArrangingPayment();
    if (!transitioned) {
// debugPrint('[Checkout] ❌ [Razorpay] Failed to transition to ArrangingPayment state');
// debugPrint('[Checkout] [Razorpay] Order state after failed transition: ${orderController.currentOrder.value?.state ?? "null"}');
      showErrorSnackbar('Failed to process order');
      return;
    }
// debugPrint('[Checkout] ✅ [Razorpay] Successfully transitioned to ArrangingPayment state');

    // Refresh order to get latest state from server
    await orderController.getActiveOrder(skipLoading: true);
    // Also refresh cart to get latest data
    await cartController.getActiveOrder();
    
    // Add a small delay to ensure server has processed the transition
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Verify order is in ArrangingPayment state before generating Razorpay order
    final currentOrder = orderController.currentOrder.value;
    if (currentOrder != null && currentOrder.state != 'ArrangingPayment') {
// debugPrint('[Checkout] ⚠️ Order state mismatch - Current: ${currentOrder.state}, Expected: ArrangingPayment');
// debugPrint('[Checkout] Order ID: ${currentOrder.id}, Order Code: ${currentOrder.code}');
// debugPrint('[Checkout] Order Active: ${currentOrder.active}');
      // Try refreshing one more time
      await orderController.getActiveOrder(skipLoading: true);
      await cartController.getActiveOrder();
      final refreshedOrder = orderController.currentOrder.value;
      if (refreshedOrder?.state != 'ArrangingPayment') {
// debugPrint('[Checkout] ❌ Order state error after refresh - State: ${refreshedOrder?.state ?? "null"}, Expected: ArrangingPayment');
// debugPrint('[Checkout] Refreshed Order ID: ${refreshedOrder?.id ?? "null"}, Order Code: ${refreshedOrder?.code ?? "null"}');
// debugPrint('[Checkout] Refreshed Order Active: ${refreshedOrder?.active ?? "null"}');
// debugPrint('[Checkout] Cart Order State: ${cartController.cart.value?.state ?? "null"}');
        showErrorSnackbar('Order state error. Please try again.');
        return;
      } else {
// debugPrint('[Checkout] ✅ Order state corrected after refresh - State: ${refreshedOrder?.state ?? "null"}');
      }
    }

    // Get order details - prefer orderController's currentOrder, fallback to cart
    final currentOrderFromController = orderController.currentOrder.value;
    final cartOrder = cartController.cart.value;
    
    // Use order from controller if available, otherwise use cart
    final orderId = currentOrderFromController?.id ?? cartOrder?.id;
    final orderTotal = (currentOrderFromController?.totalWithTax ?? cartOrder?.totalWithTax ?? 0).toInt();
    final orderCode = currentOrderFromController?.code ?? cartOrder?.code;
    
    if (orderId == null) {
      showErrorSnackbar('Order not found');
      return;
    }

    // Calculate total (order total + shipping if available)
    final shippingCost = cartController.hasFreeShippingCoupon()
        ? 0
        : (orderController.selectedShippingMethod.value?.priceWithTax ?? 0);
    final amount = orderTotal + shippingCost;

/// debugPrint(  '[Checkout] Order Total: $orderTotal, Shipping: $shippingCost, Final Amount: $amount');
/// debugPrint(  '[Checkout] Free shipping coupon applied: ${cartController.hasFreeShippingCoupon()}');

    // Generate Razorpay Order ID from backend
    showSuccessSnackbar('Generating payment order...');
    final razorpayOrder =
        await orderController.generateRazorpayOrderId(orderId);

    if (razorpayOrder == null) {
      // Error message is already shown by the controller's error handling
// debugPrint('[Checkout] Razorpay order generation failed');
      return;
    }

/// debugPrint(  '[Checkout] Razorpay Order ID: ${razorpayOrder.razorpayOrderId}');
// debugPrint('[Checkout] Razorpay Key ID: ${razorpayOrder.keyId}');

    // Get customer phone number - prioritize address phone, fallback to customer phone
    final customer = customerController.activeCustomer.value;
    String customerPhone = '';
    
    if (_selectedAddress?.phoneNumber != null && 
        _selectedAddress!.phoneNumber.isNotEmpty) {
      customerPhone = _selectedAddress!.phoneNumber;
    } else if (customer?.phoneNumber != null && 
               customer!.phoneNumber!.isNotEmpty) {
      customerPhone = customer.phoneNumber!;
    }

    // Validate phone number before proceeding
    if (customerPhone.isEmpty) {
      showErrorSnackbar('Phone number is required for payment. Please add a phone number to your address or profile.');
      return;
    }

// debugPrint('[Checkout] Customer Phone: $customerPhone');

    // Open Razorpay payment gateway with backend-generated order ID
    _razorpayService.openPaymentGateway(
      razorpayOrderId: razorpayOrder.razorpayOrderId,
      razorpayKeyId: razorpayOrder.keyId,
      amountInPaise: amount, // Already in paise/cents
      customerName: _selectedAddress?.fullName ?? 
          (customer != null ? '${customer.firstName} ${customer.lastName}'.trim() : 'Customer'),
      customerEmail: customer?.emailAddress ?? 'customer@example.com',
      customerPhone: customerPhone,
      description: 'Order #${orderCode ?? orderId}',
      onPaymentSuccess: (response) async {
/// debugPrint(  '[Checkout] Razorpay payment successful: ${response.paymentId}');

        // Get latest order for payment - refresh to get current state
        await orderController.getActiveOrder(skipLoading: true);
        await cartController.getActiveOrder();
        
        final latestOrderModel = orderController.currentOrder.value;
        final latestCartOrder = cartController.cart.value;
        final latestOrderCode = latestOrderModel?.code ?? latestCartOrder?.code ?? orderCode;

        // Add payment to order - online payment: don't pass metadata
        final success = await orderController.addPayment(
          method: 'online', // Use 'online' as the method code
          metadata: null, // Don't pass metadata for online payment
        );

        if (success) {
          // Get latest order for analytics
          final orderForAnalyticsModel = orderController.currentOrder.value;
          final orderForAnalyticsCart = cartController.cart.value;
          
          // Use whichever is available
          if (orderForAnalyticsModel != null) {
            // Track purchase event using OrderModel
            final items = orderForAnalyticsModel.lines.map((line) {
              return analytics.AnalyticsEventItem(
                itemId: line.productVariant.id,
                itemName: line.productVariant.name,
                itemCategory: 'Product',
                price: line.unitPriceWithTax / 100.0,
                quantity: line.quantity,
              );
            }).toList();
            
            await AnalyticsService().logPurchase(
              transactionId: orderForAnalyticsModel.code.isNotEmpty ? orderForAnalyticsModel.code : orderForAnalyticsModel.id,
              value: orderForAnalyticsModel.totalWithTax / 100.0,
              currency: 'INR',
              items: items,
              parameters: {
                'payment_method': 'razorpay',
                'payment_id': response.paymentId ?? '',
              },
            );
          } else if (orderForAnalyticsCart != null) {
            // Track purchase event using Order (from cart)
            final items = orderForAnalyticsCart.lines.map((line) {
              return analytics.AnalyticsEventItem(
                itemId: line.productVariant.id,
                itemName: line.productVariant.name,
                itemCategory: 'Product',
                price: line.unitPriceWithTax / 100.0,
                quantity: line.quantity,
              );
            }).toList();
            
            await AnalyticsService().logPurchase(
              transactionId: orderForAnalyticsCart.code.isNotEmpty ? orderForAnalyticsCart.code : orderForAnalyticsCart.id,
              value: orderForAnalyticsCart.totalWithTax / 100.0,
              currency: 'INR',
              items: items,
              parameters: {
                'payment_method': 'razorpay',
                'payment_id': response.paymentId ?? '',
              },
            );
          }
          
          // Try to transition order to next state
// debugPrint('[Checkout] Payment successful, transitioning order...');
          final transitioned = await orderController.transitionToNextState();
          final finalOrderCode = latestOrderCode ?? orderId;
          if (transitioned) {
            // Clear cart after successful order placement
            cartController.clearCart();
            showSuccessSnackbar('Payment successful! Order placed.');
            Get.offAllNamed('/order-confirmation', arguments: finalOrderCode);
          } else {
            // Clear cart after successful order placement
            cartController.clearCart();
            showSuccessSnackbar('Payment successful! Order will be processed.');
            Get.offAllNamed('/order-confirmation', arguments: finalOrderCode);
          }
        } else {
          showErrorSnackbar('Payment completed but order failed to update');
        }
      },
      onPaymentFailure: (response) {
// debugPrint('[Checkout] Razorpay payment failed: ${response.message}');
        showErrorSnackbar('Payment failed: ${response.message}');
      },
    );
  }

  /// Handle Cash on Delivery payment
  Future<void> _handleCODPayment() async {
// debugPrint('[Checkout] [COD] Starting payment flow...');
    // final currentOrderBeforeTransition = orderController.currentOrder.value; // Unused variable
// debugPrint('[Checkout] [COD] Order state before transition: ${orderController.currentOrder.value?.state ?? "null"}');
// debugPrint('[Checkout] [COD] Order ID before transition: ${orderController.currentOrder.value?.id ?? "null"}');
    
    // Transition to ArrangingPayment state
    final transitioned = await orderController.transitionToArrangingPayment();
    if (!transitioned) {
// debugPrint('[Checkout] ❌ [COD] Failed to transition to ArrangingPayment state');
// debugPrint('[Checkout] [COD] Order state after failed transition: ${orderController.currentOrder.value?.state ?? "null"}');
      showErrorSnackbar('Failed to process order');
      return;
    }
// debugPrint('[Checkout] ✅ [COD] Successfully transitioned to ArrangingPayment state');

    // Refresh order to get latest state from server
    await orderController.getActiveOrder(skipLoading: true);
    
    // Add a small delay to ensure server has processed the transition
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Verify order is in ArrangingPayment state before adding payment
    final currentOrder = orderController.currentOrder.value;
    if (currentOrder != null && currentOrder.state != 'ArrangingPayment') {
// debugPrint('[Checkout] ⚠️ [COD] Order state mismatch - Current: ${currentOrder.state}, Expected: ArrangingPayment');
// debugPrint('[Checkout] [COD] Order ID: ${currentOrder.id}, Order Code: ${currentOrder.code}');
// debugPrint('[Checkout] [COD] Order Active: ${currentOrder.active}');
      // Try refreshing one more time
      await orderController.getActiveOrder(skipLoading: true);
      await cartController.getActiveOrder();
      final refreshedOrder = orderController.currentOrder.value;
      if (refreshedOrder?.state != 'ArrangingPayment') {
// debugPrint('[Checkout] ❌ [COD] Order state error after refresh - State: ${refreshedOrder?.state ?? "null"}, Expected: ArrangingPayment');
// debugPrint('[Checkout] [COD] Refreshed Order ID: ${refreshedOrder?.id ?? "null"}, Order Code: ${refreshedOrder?.code ?? "null"}');
// debugPrint('[Checkout] [COD] Refreshed Order Active: ${refreshedOrder?.active ?? "null"}');
// debugPrint('[Checkout] [COD] Cart Order State: ${cartController.cart.value?.state ?? "null"}');
// debugPrint('[Checkout] [COD] Transition result was: $transitioned');
        showErrorSnackbar('Order state error. Please try again.');
        return;
      } else {
// debugPrint('[Checkout] ✅ [COD] Order state corrected after refresh - State: ${refreshedOrder?.state ?? "null"}');
      }
    }

    // Add payment - offline payment: pass metadata with total, payment method, and payment id
    final orderModel = orderController.currentOrder.value;
    final cartOrder = cartController.cart.value;
    
    // Calculate total from order model or cart
    int orderTotal = 0;
    String? paymentId;
    
    if (orderModel != null) {
      orderTotal = orderModel.totalWithTax.toInt();
      paymentId = orderModel.code.isNotEmpty ? orderModel.code : orderModel.id;
    } else if (cartOrder != null) {
      orderTotal = cartOrder.totalWithTax.toInt();
      paymentId = cartOrder.code.isNotEmpty ? cartOrder.code : cartOrder.id;
    }
    
    final shippingCost = cartController.hasFreeShippingCoupon()
        ? 0
        : (orderController.selectedShippingMethod.value?.priceWithTax ?? 0);
    final finalTotal = orderTotal + shippingCost;
    final paymentMethod = orderController.selectedPaymentMethod.value!;
    
    final success = await orderController.addPayment(
      method: paymentMethod.code,
      metadata: {
        'total': finalTotal.toString(),
        'payment_method': paymentMethod.code,
        'payment_id': paymentId ?? 'N/A',
      },
    );

    if (success) {
      // Track purchase event for COD
      final cart = cartController.cart.value;
      if (cart != null) {
        final items = cart.lines.map((line) {
          return analytics.AnalyticsEventItem(
            itemId: line.productVariant.id,
            itemName: line.productVariant.name,
            itemCategory: 'Product',
            price: line.unitPriceWithTax / 100.0,
            quantity: line.quantity,
          );
        }).toList();
        
        await AnalyticsService().logPurchase(
          transactionId: cart.code,
          value: cart.totalWithTax / 100.0,
          currency: 'INR',
          items: items,
          parameters: {
            'payment_method': 'cash_on_delivery',
          },
        );
      }
      
      // Clear cart after successful order placement
      cartController.clearCart();
      showSuccessSnackbar('Order placed successfully!');
      // Navigate to order confirmation page
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
/// debugPrint(  '[CheckoutPage] Bottom sheet - Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');
/// debugPrint(  '[CheckoutPage] Bottom sheet - Available coupons count: ${bannerController.availableCouponCodes.length}');

                if (!bannerController.couponCodesLoaded.value) {
/// debugPrint(  '[CheckoutPage] Bottom sheet - Showing loading indicator');
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.button),
                  );
                }

                final enabledCoupons = bannerController.availableCouponCodes
                    .where((coupon) => coupon.enabled)
                    .toList();

/// debugPrint(  '[CheckoutPage] Bottom sheet - Enabled coupons count: ${enabledCoupons.length}');

                if (enabledCoupons.isEmpty) {
/// debugPrint(  '[CheckoutPage] Bottom sheet - No enabled coupons, showing empty state');
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
                                final appliedCouponCount = bannerController.appliedCouponCodes.length;
                                // Disable remove if 2 or more coupons are applied
                                final canRemoveCoupon = appliedCouponCount < 2;

                                return ElevatedButton(
                                  onPressed: (isAnotherCouponApplied || (isApplied && !canRemoveCoupon))
                                      ? null
                                      : () async {
                                          if (isApplied) {
                                            // Remove coupon - only if less than 2 coupons applied
                                            if (!canRemoveCoupon) {
                                              showErrorSnackbar(
                                                  'Cannot remove coupon when 2 or more coupons are applied');
                                              return;
                                            }
                                            // Remove coupon code (this will also remove associated products)
                                            final couponCodeToRemove = coupon.couponCode;
                                            // Check if this coupon had products before removal
                                            final hadProducts = bannerController.couponAddedProducts.containsKey(couponCodeToRemove);
                                            
                                            final success =
                                                await bannerController
                                                    .removeCouponCode(
                                                        couponCodeToRemove);
                                            if (success) {
                                              // Wait a bit for backend to process product removal
                                              await Future.delayed(Duration(milliseconds: 500));
                                              
                                              // Refresh cart to show removed products and updated prices
                                              await Future.wait([
                                                cartController.getActiveOrder(),
                                                orderController.getActiveOrder(skipLoading: true),
                                              ]);
                                              
                                              // Show appropriate message
                                              final message = hadProducts
                                                  ? 'Coupon code and associated products removed successfully'
                                                  : 'Coupon code removed successfully';
                                              
                                              showSuccessSnackbar(message);
                                              Navigator.pop(
                                                  context); // Close bottom sheet
                                              setState(() {}); // Refresh UI
                                            } else {
                                              showErrorSnackbar(
                                                  'Failed to remove coupon code');
                                            }
                                          } else {
                                            // Apply coupon
                                            final hasProducts = bannerController
                                                .hasCouponProducts(
                                                    coupon.couponCode);
// debugPrint('[CheckoutPage] Coupon ${coupon.couponCode} has products: $hasProducts');
                                            
                                            if (hasProducts) {
                                              // Coupon has products to add
// debugPrint('[CheckoutPage] Applying coupon with products: ${coupon.couponCode}');
                                              final result = await bannerController
                                                  .applyCouponCodeWithProducts(
                                                      coupon.couponCode);
                                              if (result['success']) {
                                                // Cart is already updated by applyCouponCodeWithProducts
                                                // No need for additional refresh - just update UI
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
                                                // Cart is already updated by applyCouponCode
                                                // No need for additional refresh - just update UI
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
                                    backgroundColor: (isAnotherCouponApplied || (isApplied && !canRemoveCoupon))
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
                                        : (isApplied && !canRemoveCoupon)
                                            ? 'Cannot Remove'
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(),
              
              // Content Area
              Expanded(
                child: Obx(() {
                  if (utilityController.isLoadingRx.value) {
                    return _buildShimmerCheckout();
                  }

                  return RefreshIndicator(
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
                      child: Column(
                        children: [
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          
                          // Step Content
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.rp(16),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildStepContent(),
                            ),
                          ),
                          
                          SizedBox(height: ResponsiveUtils.rp(100)), // Space for bottom bar
                        ],
                      ),
                    ),
                  );
                }),
              ),

              // Place Order Button
              _buildPlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(16),
        vertical: ResponsiveUtils.rp(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.rp(10),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: ResponsiveUtils.rp(8),
                  offset: Offset(0, ResponsiveUtils.rp(2)),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.textPrimary,
                size: ResponsiveUtils.rp(20),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          SizedBox(width: ResponsiveUtils.rp(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Checkout',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.sp(20),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  'Complete your order details',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.sp(13),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Order Summary Section
        _buildOrderSummarySection(),
        
        Divider(height: ResponsiveUtils.rp(32), thickness: 8, color: AppColors.background),
        
        // Delivery Address Section
        _buildDeliveryAddressSection(),
        
        Divider(height: ResponsiveUtils.rp(32), thickness: 8, color: AppColors.background),
        
        // Payment Method Section
        _buildPaymentMethodSection(),
      ],
    );
  }


  Widget _buildOrderSummarySection() {
    return Obx(() {
      final cart = cartController.cart.value;
      final isLoading = utilityController.isLoadingRx.value;
      
      // If cart is null but we're loading, show previous state or loading
      // This prevents showing empty cart during coupon application
      if (cart == null && isLoading) {
        // Return a minimal loading state or previous cart data
        // The cart should be restored soon, so we'll show a loading indicator
        return _buildOrderSummaryLoading();
      }
      
      final itemCount = cart?.lines.length ?? 0;
      final subtotal = cart?.subTotalWithTax ?? 0;
      final shipping = orderController.selectedShippingMethod.value?.priceWithTax ?? 0;
      final total = cart?.totalWithTax ?? 0;
      final hasFreeShipping = cartController.hasFreeShippingCoupon();
      
      // Loyalty Points
      final loyaltyPointsUsed = bannerController.loyaltyPointsUsed.value;
      final loyaltyPointsApplied = bannerController.loyaltyPointsApplied.value;
      final config = bannerController.loyaltyPointsConfig.value;
      final rupeesPerPoint = config?.rupeesPerPoint ?? 0;
      
      // Calculate loyalty discount: points used * rupees per point (in paise, so divide by 100)
      final loyaltyDiscountAmount = loyaltyPointsApplied && loyaltyPointsUsed > 0 && rupeesPerPoint > 0
          ? (loyaltyPointsUsed * rupeesPerPoint)
          : 0;
      
      // Total discount from order
      final totalDiscount = (subtotal + (hasFreeShipping ? 0 : shipping) - total);
      
      // Coupon Discount (total discount minus loyalty discount)
      final couponDiscount = bannerController.appliedCouponCodes.isNotEmpty
          ? (totalDiscount - loyaltyDiscountAmount)
          : 0;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Text(
              'Order Summary',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          
          // Summary Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Items ($itemCount)',
                  '₹${(subtotal / 100).toStringAsFixed(2)}',
                ),
                SizedBox(height: ResponsiveUtils.rp(12)),
                _buildSummaryRow(
                  'Delivery Charge',
                  hasFreeShipping 
                      ? 'FREE' 
                      : '₹${(shipping / 100).toStringAsFixed(2)}',
                  valueColor: hasFreeShipping ? AppColors.success : null,
                ),
                
                // Loyalty Points Discount
                if (loyaltyPointsApplied && loyaltyPointsUsed > 0 && loyaltyDiscountAmount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildSummaryRow(
                    'Loyalty Points Discount',
                    '-₹${(loyaltyDiscountAmount / 100).toStringAsFixed(2)}',
                    valueColor: AppColors.success,
                  ),
                ],
                
                // Coupon Discount
                if (bannerController.appliedCouponCodes.isNotEmpty && couponDiscount > 0) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildSummaryRow(
                    'Coupon Discount',
                    '-₹${(couponDiscount / 100).toStringAsFixed(2)}',
                    valueColor: AppColors.success,
                  ),
                ],
                
                SizedBox(height: ResponsiveUtils.rp(16)),
                Divider(height: 1),
                SizedBox(height: ResponsiveUtils.rp(16)),
                
                // Total
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
                      '₹${(total / 100).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.button,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOrderSummaryLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(18),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        
        // Loading indicator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(20)),
              child: CircularProgressIndicator(
                color: AppColors.button,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (_selectedAddress != null)
                TextButton(
                  onPressed: () async {
                    await Get.toNamed('/addresses');
                    await _loadCustomerAddresses();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: AppColors.button,
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        if (_selectedAddress == null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                Text(
                  'No delivery address selected',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(12)),
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed('/addresses');
                    await _loadCustomerAddresses();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(24),
                      vertical: ResponsiveUtils.rp(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  child: Text('Add Address'),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedAddress!.fullName,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Text(
                  '${_selectedAddress!.streetLine1}${_selectedAddress!.streetLine2.isNotEmpty ? ', ${_selectedAddress!.streetLine2}' : ''}, ${_selectedAddress!.city}${_selectedAddress!.province.isNotEmpty ? ', ${_selectedAddress!.province}' : ''}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Row(
                  children: [
                    Text(
                      _selectedAddress!.phoneNumber,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_selectedAddress!.defaultShippingAddress) ...[
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(8),
                          vertical: ResponsiveUtils.rp(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
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
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: CheckoutPaymentSection(
              orderController: orderController,
            ),
          ),
        ],
      );
    });
  }

  // ignore: unused_element
  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: ResponsiveUtils.rp(20),
          ),
        ),
        SizedBox(width: ResponsiveUtils.rp(12)),
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildAddressCard() {
    if (_selectedAddress == null) {
      return _buildSectionCard(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              decoration: BoxDecoration(
                color: AppColors.buttonLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(
                  color: AppColors.button.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: ResponsiveUtils.rp(48),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  Text(
                    'No delivery address selected',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Get.toNamed('/addresses');
                      await _loadCustomerAddresses();
                    },
                    icon: Icon(Icons.add_location_alt_rounded, size: ResponsiveUtils.rp(20)),
                    label: Text('Add Address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(24),
                        vertical: ResponsiveUtils.rp(14),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(18),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Text(
                    'Delivery Address',
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
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(16),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(4)),
                  TextButton(
                    onPressed: () async {
                      await Get.toNamed('/addresses');
                      await _loadCustomerAddresses();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Change',
                      style: TextStyle(
                        color: AppColors.button,
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Text(
            _selectedAddress!.fullName,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(15),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Row(
            children: [
              Icon(
                Icons.home_rounded,
                size: ResponsiveUtils.rp(16),
                color: AppColors.textSecondary,
              ),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Expanded(
                child: Text(
                  '${_selectedAddress!.streetLine1}${_selectedAddress!.streetLine2.isNotEmpty ? ', ${_selectedAddress!.streetLine2}' : ''}, ${_selectedAddress!.city}${_selectedAddress!.province.isNotEmpty ? ', ${_selectedAddress!.province}' : ''}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Row(
            children: [
              Icon(
                Icons.phone_rounded,
                size: ResponsiveUtils.rp(16),
                color: AppColors.textSecondary,
              ),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                _selectedAddress!.phoneNumber,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              if (_selectedAddress!.defaultShippingAddress) ...[
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.rp(12),
                    vertical: ResponsiveUtils.rp(6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.button,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: ResponsiveUtils.rp(14),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(4)),
                      Text(
                        'Default',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final isEnabled = _selectedAddress != null &&
          orderController.selectedPaymentMethod.value != null;
      final cart = cartController.cart.value;
      final total = cart?.totalWithTax ?? 0;

      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: ResponsiveUtils.rp(20),
              offset: Offset(0, -ResponsiveUtils.rp(4)),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: isLoading
              ? Container(
                  height: ResponsiveUtils.rp(60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                    color: AppColors.inputBorder,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: ResponsiveUtils.rp(24),
                      height: ResponsiveUtils.rp(24),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : SlideAction(
                  key: _slideActionKey,
                  height: ResponsiveUtils.rp(60),
                  borderRadius: ResponsiveUtils.rp(16),
                  innerColor: Colors.white,
                  outerColor: isEnabled
                      ? AppColors.button
                      : AppColors.inputBorder,
                  text: isEnabled && total > 0
                      ? 'Place Order - ₹${(total / 100).toStringAsFixed(2)}'
                      : 'Place Order',
                  textStyle: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.bold,
                    color: isEnabled ? Colors.white : AppColors.textSecondary,
                  ),
                  sliderButtonIcon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isEnabled ? AppColors.button : AppColors.textSecondary,
                    size: ResponsiveUtils.rp(20),
                  ),
                  sliderButtonIconPadding: ResponsiveUtils.rp(12),
                  submittedIcon: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: ResponsiveUtils.rp(20),
                  ),
                  onSubmit: () {
                    if (!isLoading && isEnabled) {
                      _onPlaceOrder();
                      // Reset the slider after a delay
                      Future.delayed(
                        const Duration(milliseconds: 1000),
                        () => _slideActionKey.currentState?.reset(),
                      );
                    }
                    return null;
                  },
                ),
        ),
      );
    });
  }


  // ignore: unused_element
  Widget _buildExpandablePaymentSection() {
    return Obx(() {
      final selectedMethod = orderController.selectedPaymentMethod.value;
      
      return _buildSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with expand/collapse
            InkWell(
              onTap: () {
                setState(() {
                  _isPaymentExpanded = !_isPaymentExpanded;
                });
              },
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(4)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                      ),
                      child: Icon(
                        Icons.payment_rounded,
                        color: AppColors.warning,
                        size: ResponsiveUtils.rp(20),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (!_isPaymentExpanded && selectedMethod != null) ...[
                            SizedBox(height: ResponsiveUtils.rp(4)),
                            Text(
                              _formatPaymentMethodName(selectedMethod.code),
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(13),
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isPaymentExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                        size: ResponsiveUtils.rp(24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Expandable content
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              secondChild: Column(
                children: [
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  Divider(height: 1, color: AppColors.divider),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  CheckoutPaymentSection(
                    orderController: orderController,
                  ),
                ],
              ),
              crossFadeState: _isPaymentExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      );
    });
  }

  // ignore: unused_element
  Widget _buildPaymentSection() {
    return _buildSectionCard(
      child: CheckoutPaymentSection(
        orderController: orderController,
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.rp(6),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: child,
      ),
    );
  }

  bool _validateCheckout() {
    if (_selectedAddress == null) {
      showErrorSnackbar('Please select a delivery address');
      return false;
    }
    if (orderController.selectedShippingMethod.value == null) {
      showErrorSnackbar('Please select a delivery method');
      return false;
    }
    if (orderController.selectedPaymentMethod.value == null) {
      showErrorSnackbar('Please select a payment method');
      return false;
    }
    return true;
  }

  String _formatPaymentMethodName(String code) {
    // Convert payment method code to user-friendly name
    final lowerCode = code.toLowerCase();
    if (lowerCode.contains('razorpay') || lowerCode.contains('online')) {
      return 'Online Payment';
    } else if (lowerCode.contains('cod') || lowerCode.contains('cash')) {
      return 'Cash on Delivery';
    } else {
      // Capitalize first letter of each word
      return code.split('_')
          .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }
  }


  // ignore: unused_element
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

  // ignore: unused_element
  Widget _buildCouponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coupon Codes',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Obx(() {
              final appliedCount = bannerController.appliedCouponCodes.length;
              if (appliedCount > 0) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.rp(10),
                    vertical: ResponsiveUtils.rp(6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.3),
                        blurRadius: ResponsiveUtils.rp(8),
                        offset: Offset(0, ResponsiveUtils.rp(2)),
                      ),
                    ],
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
      );
  }

  // ignore: unused_element
  Widget _buildLoyaltyPointsSection() {
    return Obx(() {
      final availablePoints = customerController.loyaltyPoints;
      final config = bannerController.loyaltyPointsConfig.value;
      final minimumPoints = config?.pointsPerRupee ?? 0;
      
      // Only show loyalty points section if user has minimum required points
      if (minimumPoints > 0 && availablePoints < minimumPoints) {
        return SizedBox.shrink(); // Don't show if user doesn't have minimum points
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loyalty Points',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
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
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
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
          Obx(() {
            final isApplied = bannerController.loyaltyPointsApplied.value;
            final appliedPoints = bannerController.loyaltyPointsUsed.value;
            
            // Update controller text when points are applied
            if (isApplied && _loyaltyPointsController.text != appliedPoints.toString()) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loyaltyPointsController.text = appliedPoints.toString();
              });
            }
            
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _loyaltyPointsController,
                        keyboardType: TextInputType.number,
                        enabled: !isApplied, // Disable when applied
                        style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            color: isApplied 
                                ? AppColors.success 
                                : AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: isApplied 
                              ? 'Applied: $appliedPoints points' 
                              : 'Enter points',
                          hintStyle: TextStyle(
                              color: isApplied 
                                  ? AppColors.success 
                                  : AppColors.textTertiary,
                              fontSize: ResponsiveUtils.sp(14)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(ResponsiveUtils.rp(8)),
                              borderSide: BorderSide(
                                color: isApplied 
                                    ? AppColors.success 
                                    : AppColors.border,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(ResponsiveUtils.rp(8)),
                              borderSide: BorderSide(
                                color: isApplied 
                                    ? AppColors.success 
                                    : AppColors.border,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(ResponsiveUtils.rp(8)),
                              borderSide: BorderSide(
                                color: isApplied 
                                    ? AppColors.success 
                                    : AppColors.button,
                                width: 2,
                              )),
                          filled: true,
                          fillColor: isApplied 
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.inputFill,
                          suffixIcon: isApplied
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: ResponsiveUtils.rp(20),
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(8)),
                    ElevatedButton(
                      onPressed: isApplied ? _removeLoyaltyPoints : _applyLoyaltyPoints,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApplied 
                            ? AppColors.error 
                            : AppColors.button,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(12)),
                      ),
                      child: Text(isApplied ? 'Remove' : 'Apply'),
                    ),
                  ],
                ),
                if (isApplied) ...[
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: ResponsiveUtils.rp(18),
                            ),
                            SizedBox(width: ResponsiveUtils.rp(8)),
                            Text(
                              'Applied: $appliedPoints points',
                              style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveUtils.sp(14)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }),
        ],
      );
    });
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

