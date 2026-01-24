import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/theme_controller.dart';
import '../services/razorpay_service.dart';
import '../services/analytics_service.dart';
import '../widgets/snackbar.dart';
import 'package:firebase_analytics/firebase_analytics.dart' as analytics;
import '../graphql/Customer.graphql.dart';
import '../graphql/order.graphql.dart';
import '../services/graphql_client.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../utils/app_config.dart';
import '../utils/app_strings.dart';
import '../widgets/checkout/checkout_payment_section.dart';
import '../widgets/checkout/checkout_app_bar.dart';
import '../widgets/checkout/checkout_order_summary_section.dart';
import '../widgets/checkout/checkout_delivery_address_section.dart';
import '../widgets/checkout/checkout_place_order_button.dart';
import '../widgets/checkout/checkout_shimmer_loading.dart';
import '../widgets/checkout/slide_to_pay_button.dart';
import '../widgets/error_dialog.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with WidgetsBindingObserver {
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
  Query$GetActiveCustomer$activeCustomer$addresses? _selectedAddress;
  
  // Blink animation for address card
  final RxBool _shouldBlinkAddress = false.obs;

  // Expandable sections for slide-down animations
  // ignore: unused_field
  bool _isPaymentExpanded = false;
  // ignore: unused_field
  bool _isOrderSummaryExpanded = false;
  
  // SlideAction key for resetting
  final GlobalKey<SlideToPayButtonState> _slideActionKey = GlobalKey<SlideToPayButtonState>();
  
  // Track order placement state to prevent slider reset on success
  bool _orderPlacedSuccessfully = false;

  // Loyalty Points
  final _loyaltyPointsController = TextEditingController();
  // ignore: unused_field
  final RxBool _applyAllPoints = false.obs; // Toggle for apply all vs manual

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
  
  // Local loading flag to prevent flicker on initial load
  bool _isInitialLoading = true;
  
  // Track last route to detect navigation changes
  String? _lastRoute;
  bool _hasRefreshedFromAddresses = false; // Flag to prevent duplicate refreshes

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _razorpayService = RazorpayService();
    _lastRoute = Get.currentRoute;
    // Load data without showing loading state to prevent flicker
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Reset loyalty points state after the current frame to avoid build-time state updates
      // This ensures clean state for new orders. The actual order state will be loaded and synced later.
      bannerController.resetLoyaltyPoints();
      if (_loyaltyPointsController.text.isNotEmpty) {
        _loyaltyPointsController.clear();
      }
      // Load shipping address first (at the top)
      await _loadCustomerAddresses();
      // Then load other data in parallel
      await Future.wait([
        _loadShippingMethods(),
        _refreshPaymentMethods(), // Always fetch payment methods when entering checkout page
        _loadCouponCodes(),
        // Removed _loadLoyaltyPointsConfig() - loyalty points config should be loaded from cart page
      ], eagerError: false);
      
      // Mark initial loading as complete
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
      
      // Load existing state (non-critical, can happen after initial render)
      // Use already-loaded data from cart page instead of making new API calls
      // Note: _loadExistingShippingMethod() must be called after _loadShippingMethods() completes
      _loadExistingInstructions();
      _loadExistingCouponCodes();
      _loadExistingLoyaltyPoints();
      _loadExistingShippingMethod(); // Load existing shipping method from order (after shipping methods are loaded)
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loyaltyPointsController.dispose();
    _otherInstructionsController.dispose();
    _instructionsDebounceTimer?.cancel();
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're returning from addresses page
    final currentRoute = Get.currentRoute;
    if (_lastRoute != null && 
        _lastRoute == '/addresses' && 
        currentRoute == '/checkout' &&
        !_isInitialLoading &&
        !_hasRefreshedFromAddresses) {
      // User returned from addresses page - refresh data
      _hasRefreshedFromAddresses = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Get.currentRoute == '/checkout') {
          _refreshCheckoutData().then((_) {
            // Reset flag after refresh completes
            _hasRefreshedFromAddresses = false;
          });
        }
      });
    }
    // Reset flag if route changes away from checkout
    if (currentRoute != '/checkout') {
      _hasRefreshedFromAddresses = false;
    }
    _lastRoute = currentRoute;
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
    // First, check if active order has a shipping address
    await orderController.getActiveOrder(skipLoading: true);
    
    // Try to get shipping address from active order response
    // Note: This will work after GraphQL files are regenerated with shippingAddress in ActiveOrder query
    try {
      final response = await GraphqlService.client.value.query$ActiveOrder(
        Options$Query$ActiveOrder(),
      );
      
      final activeOrder = response.parsedData?.activeOrder;
      if (activeOrder != null) {
        // Check if activeOrder has shippingAddress (Query$ActiveOrder$activeOrder type)
        // Using reflection/dynamic access since types may not be regenerated yet
        final orderJson = activeOrder.toJson();
        if (orderJson['shippingAddress'] != null) {
          final shippingAddressData = orderJson['shippingAddress'] as Map<String, dynamic>?;
          if (shippingAddressData != null && shippingAddressData.isNotEmpty) {
            // If order has a shipping address, we should match it to customer addresses
            // This will be handled below in customer address matching
          }
        }
      }
    } catch (e) {
    }
    
    await customerController.getActiveCustomer();
    Query$GetActiveCustomer$activeCustomer$addresses? defaultShipping;
    
    // Find default shipping address
    for (final address in customerController.addresses) {
      if (address.defaultShippingAddress ?? false) {
        defaultShipping = address;
        break;
      }
    }
    
    // If no default shipping address, use the first available address
    if (defaultShipping == null && customerController.addresses.isNotEmpty) {
      defaultShipping = customerController.addresses.first;
    }
    
    if (!mounted) return;
    
    final previousAddress = _selectedAddress;
    setState(() {
      _selectedAddress = defaultShipping;
    });
    
    // If address was set (either default or first available), automatically set it as shipping address
    if (_selectedAddress != null) {
      // Check if this is a new address (was null before) or if address changed
      final isNewAddress = previousAddress == null || previousAddress.id != _selectedAddress!.id;
      
      if (isNewAddress) {
        // Automatically set shipping address when address is loaded or changed
        await _setShippingAddressFromSelected();
      }
    }
    
    // Shipping methods will be loaded in initState Future.wait, no need to call here
  }
  
  /// Set shipping address from currently selected address
  Future<void> _setShippingAddressFromSelected() async {
    if (_selectedAddress == null) return;
    
    try {
      final addressSet = await orderController.setShippingAddress(
        fullName: _selectedAddress!.fullName ?? '',
        phoneNumber: _selectedAddress!.phoneNumber ?? '',
        streetLine1: _selectedAddress!.streetLine1,
        streetLine2: _selectedAddress!.streetLine2 ?? '',
        city: _selectedAddress!.city ?? '',
        province: null, // Province not available in GraphQL query
        postalCode: _selectedAddress!.postalCode ?? '',
        countryCode: _selectedAddress!.country.code,
        skipLoading: true,
      );
      
      if (addressSet) {
        // Shipping methods will be loaded in initState Future.wait, no need to call again
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> _loadShippingMethods() async {
    await orderController.getEligibleShippingMethods();

    if (orderController.shippingMethods.isEmpty) {
      orderController.selectedShippingMethod.value = null;
      _lastAppliedShippingMethodId = null;
      return;
    }
    // Removed auto-select and auto-apply logic - user should select shipping method manually
    // Just load the methods, don't auto-select or auto-apply
  }

  /// Load existing shipping method from already-loaded order data
  Future<void> _loadExistingShippingMethod() async {
    try {
      // Use already-loaded order data instead of fetching again
      final order = orderController.currentOrder.value;
      
      if (order != null && order.shippingLines.isNotEmpty) {
        final shippingLine = order.shippingLines.first;
        final shippingMethodId = shippingLine.shippingMethod.id;
        
        // Find matching shipping method from available methods
        final matchingMethod = orderController.shippingMethods.firstWhereOrNull(
          (method) => method.id == shippingMethodId,
        );
        
        if (matchingMethod != null) {
          orderController.selectedShippingMethod.value = matchingMethod;
          _lastAppliedShippingMethodId = matchingMethod.id;
        } else {
        }
      } else {
    }
    } catch (e) {
    }
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
        showSuccessSnackbar(AppStrings.shippingMethodSelected);
      }
      // Only refresh cart if method was actually changed
      // Note: getActiveOrder() in cart controller doesn't show loading, so it's fine to call it
      if (!skipIfAlreadySet) {
        await cartController.getActiveOrder();
      }
      await _refreshPaymentMethods();
    } else {
      showErrorSnackbar(AppStrings.failedToSetShippingMethod);
    }
  }

  Future<void> _loadCouponCodes() async {
    try {
      await bannerController.getCouponCodeList();
      if (bannerController.availableCouponCodes.isNotEmpty) {
        for (int i = 0; i < bannerController.availableCouponCodes.length; i++) {
          // final coupon = bannerController.availableCouponCodes[i]; // Unused variable
        }
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> _loadLoyaltyPointsConfig() async {
    try {
      await bannerController.fetchLoyaltyPointsConfig();

      final config = bannerController.loyaltyPointsConfig.value;
      if (config != null) {
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> _loadExistingInstructions() async {
    try {
      // Use already-loaded order data instead of fetching again
      final order = orderController.currentOrder.value;
      
      if (order != null) {
        try {
          String? instructions;
          
          // Access customFields from Fragment$Cart type (now supports customFields)
          if (order.customFields != null) {
            final customFields = order.customFields!;
            instructions = customFields.otherInstructions;
          }
          
        if (instructions != null && instructions.isNotEmpty && mounted) {
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
          } else {
          }
        } catch (e) {
        }
      }
    } catch (e) {
    }
  }

  /// Load existing coupon codes from the order
  Future<void> _loadExistingCouponCodes() async {
    try {
      // Use already-loaded cart data instead of fetching again
      final cart = cartController.cart.value;
      if (cart != null && cart.couponCodes.isNotEmpty) {
        // Sync applied coupon codes with the order
        for (final couponCode in cart.couponCodes) {
          if (!bannerController.appliedCouponCodes.contains(couponCode)) {
            bannerController.appliedCouponCodes.add(couponCode);
          }
        }
        
        // Remove any coupon codes that are not in the order
        final codesToRemove = bannerController.appliedCouponCodes
            .where((code) => !cart.couponCodes.contains(code))
            .toList();
        for (final code in codesToRemove) {
          bannerController.appliedCouponCodes.remove(code);
        }
      } else {
      }
    } catch (e) {
    }
  }

  /// Load existing loyalty points from the order
  Future<void> _loadExistingLoyaltyPoints() async {
    try {
      // Use already-loaded order data instead of fetching again
      final order = orderController.currentOrder.value;
      
      if (order != null) {
        try {
          int? loyaltyPointsUsed;
          
          // Access customFields from Fragment$Cart type (now supports customFields)
          if (order.customFields != null) {
            final customFields = order.customFields!;
            loyaltyPointsUsed = customFields.loyaltyPointsUsed;
          }
        
        if (loyaltyPointsUsed != null && loyaltyPointsUsed > 0) {
          // Sync loyalty points state
          bannerController.loyaltyPointsUsed.value = loyaltyPointsUsed;
          bannerController.loyaltyPointsApplied.value = true;
          
          // Update the text field to show applied points
          if (mounted) {
            _loyaltyPointsController.text = loyaltyPointsUsed.toString();
          }
        } else {
          // Reset if no points are applied (important for new orders)
            bannerController.resetLoyaltyPoints();
            if (mounted) {
              _loyaltyPointsController.clear();
            }
          }
        } catch (e) {
          bannerController.resetLoyaltyPoints();
          if (mounted) {
            _loyaltyPointsController.clear();
          }
        }
      } else {
        bannerController.resetLoyaltyPoints();
        if (mounted) {
          _loyaltyPointsController.clear();
        }
      }
    } catch (e) {
      // On error, reset to be safe
      bannerController.resetLoyaltyPoints();
      if (mounted) {
        _loyaltyPointsController.clear();
      }
    }
  }


  // ignore: unused_element
  Future<void> _handleShippingMethodSubmit() async {
    if (orderController.selectedShippingMethod.value == null) {
      showErrorSnackbar(AppStrings.pleaseSelectShippingMethod);
      return;
    }

    await _applyShippingMethod(showFeedback: true, force: true);
  }

  Future<void> _handlePayment() async {
    if (orderController.selectedPaymentMethod.value == null) {
      showErrorSnackbar(AppStrings.pleaseSelectPaymentMethod);
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
    // Check if address is missing and trigger blink
    if (_selectedAddress == null) {
      _triggerAddressBlink();
      showErrorSnackbar('Please select a delivery address');
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }
    
    // Validate checkout before proceeding
    if (!_validateCheckout()) {
      // Reset slider on validation error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }
    
    // Validate payment method
    if (orderController.selectedPaymentMethod.value == null) {
      showErrorSnackbar(AppStrings.pleaseSelectPaymentMethod);
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }

    // Set shipping address when placing order
    if (_selectedAddress != null) {
      final addressSet = await orderController.setShippingAddress(
        fullName: _selectedAddress!.fullName ?? '',
        phoneNumber: _selectedAddress!.phoneNumber ?? '',
        streetLine1: _selectedAddress!.streetLine1,
        streetLine2: _selectedAddress!.streetLine2 ?? '',
        city: _selectedAddress!.city ?? '',
        province: null, // Province not available in GraphQL query
        postalCode: _selectedAddress!.postalCode ?? '',
        countryCode: _selectedAddress!.country.code,
        skipLoading: true,
      );
      
      // If shipping address failed to set, don't proceed to payment
      if (!addressSet) {
        showErrorSnackbar(AppStrings.failedToSetShippingAddress);
        // Reset slider on error
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _slideActionKey.currentState?.reset(),
        );
        return;
      }
    }

    // Then proceed to payment (shipping method should already be set)
    await _handlePayment();
  }
  
  /// Track payment analytics (helper method to reduce callback complexity)
  Future<void> _trackPaymentAnalytics(
    dynamic response,
    dynamic orderModel,
    dynamic cartOrder,
  ) async {
    try {
      if (orderModel != null) {
        // Track purchase event using OrderModel
        final items = orderModel.lines.map((line) {
          return analytics.AnalyticsEventItem(
            itemId: line.productVariant.id,
            itemName: line.productVariant.name,
            itemCategory: 'Product',
            price: line.unitPriceWithTax / 100.0,
            quantity: line.quantity,
          );
        }).toList();
        
        await AnalyticsService().logPurchase(
          transactionId: orderModel.code.isNotEmpty ? orderModel.code : orderModel.id,
          value: orderModel.totalWithTax / 100.0,
          currency: 'INR',
          items: items,
          parameters: {
            'payment_method': 'razorpay',
            'payment_id': response.paymentId ?? '',
          },
        );
      } else if (cartOrder != null) {
        // Track purchase event using Order (from cart)
        final items = cartOrder.lines.map((line) {
          return analytics.AnalyticsEventItem(
            itemId: line.productVariant.id,
            itemName: line.productVariant.name,
            itemCategory: 'Product',
            price: line.unitPriceWithTax / 100.0,
            quantity: line.quantity,
          );
        }).toList();
        
        await AnalyticsService().logPurchase(
          transactionId: cartOrder.code.isNotEmpty ? cartOrder.code : cartOrder.id,
          value: cartOrder.totalWithTax / 100.0,
          currency: 'INR',
          items: items,
          parameters: {
            'payment_method': 'razorpay',
            'payment_id': response.paymentId ?? '',
          },
        );
      }
    } catch (e) {
      // Silently fail analytics - don't block payment success flow
    }
  }
  
  /// Trigger blink animation on address card
  void _triggerAddressBlink() {
    // Create a repeating blink effect (3 blinks)
    int blinkCount = 0;
    const totalBlinks = 3;
    const blinkDuration = Duration(milliseconds: 200);
    
    Timer.periodic(blinkDuration, (timer) {
      blinkCount++;
      if (blinkCount % 2 == 1) {
        _shouldBlinkAddress.value = true;
      } else {
        _shouldBlinkAddress.value = false;
      }
      
      if (blinkCount >= totalBlinks * 2) {
        timer.cancel();
        _shouldBlinkAddress.value = false;
      }
    });
  }

  /// Handle Razorpay online payment
  Future<void> _handleRazorpayPayment() async {
    // final currentOrderBeforeTransition = orderController.currentOrder.value; // Unused variable
    // Transition to ArrangingPayment state
    final transitioned = await orderController.transitionToArrangingPayment();
    if (!transitioned) {
      showErrorSnackbar('Failed to process order');
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }
    // Refresh order to get latest state from server
    await orderController.getActiveOrder(skipLoading: true);
    // Also refresh cart to get latest data
    await cartController.getActiveOrder();
    
    // Add a small delay to ensure server has processed the transition
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Verify order is in ArrangingPayment state before generating Razorpay order
    final currentOrder = orderController.currentOrder.value;
    if (currentOrder != null && currentOrder.state != 'ArrangingPayment') {
      // Try refreshing one more time
      await orderController.getActiveOrder(skipLoading: true);
      await cartController.getActiveOrder();
      final refreshedOrder = orderController.currentOrder.value;
      if (refreshedOrder?.state != 'ArrangingPayment') {
        showErrorSnackbar('Order state error. Please try again.');
        return;
      } else {
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
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }

    // Calculate total (order total + shipping if available)
    final shippingCost = cartController.hasFreeShippingCoupon()
        ? 0
        : orderController.getShippingPrice(orderController.selectedShippingMethod.value);
    final amount = orderTotal + shippingCost;

    // Generate Razorpay Order ID from backend
    final razorpayOrder =
        await orderController.generateRazorpayOrderId(orderId);

    if (razorpayOrder == null || 
        razorpayOrder.razorpayOrderId == null || 
        razorpayOrder.keyId == null) {
      // Error message is already shown by the controller's error handling
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }
    // Ensure customer data is loaded before getting phone number
    if (customerController.activeCustomer.value == null) {
      await customerController.getActiveCustomer();
    }
    
    // Get customer phone number - prioritize address phone, fallback to customer phone
    // Ensure we always have a phone number for Razorpay
    final customer = customerController.activeCustomer.value;
    String customerPhone = '';
    
    // Priority 1: Selected address phone number
    if (_selectedAddress?.phoneNumber != null && 
        (_selectedAddress!.phoneNumber?.isNotEmpty ?? false)) {
      customerPhone = _selectedAddress!.phoneNumber!.trim();
    } 
    // Priority 2: Customer profile phone number
    else if (customer?.phoneNumber != null && 
             (customer!.phoneNumber?.isNotEmpty ?? false)) {
      customerPhone = customer.phoneNumber!.trim();
    }
    // Priority 3: Try to get from customer addresses
    else if (customer != null && (customer.addresses?.isNotEmpty ?? false)) {
      // Try to find phone number from any address
      for (var address in customer.addresses!) {
        if ((address.phoneNumber?.isNotEmpty ?? false)) {
          customerPhone = address.phoneNumber!.trim();
          break;
        }
      }
    }

    // Validate phone number before proceeding
    if (customerPhone.isEmpty) {
      showErrorSnackbar('Phone number is required for payment. Please add a phone number to your address or profile.');
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }
    
    // Ensure phone number is properly formatted (remove spaces, ensure it starts with country code if needed)
    customerPhone = customerPhone.replaceAll(' ', '').replaceAll('-', '');

    // Use amount from response if available, otherwise use calculated amount
    final paymentAmount = razorpayOrder.amount ?? amount.toInt();

    // Open Razorpay payment gateway with backend-generated order ID
    _razorpayService.openPaymentGateway(
      razorpayOrderId: razorpayOrder.razorpayOrderId!,
      razorpayKeyId: razorpayOrder.keyId!,
      amountInPaise: paymentAmount, // Use amount from response or calculated amount
      customerName: _selectedAddress?.fullName ?? 
          (customer != null ? '${customer.firstName} ${customer.lastName}'.trim() : 'Customer'),
      customerEmail: customer?.emailAddress ?? (AppConfig.emailId.isNotEmpty ? AppConfig.emailId : 'customer@example.com'),
      customerPhone: customerPhone,
      description: 'Order #${orderCode ?? orderId}',
      onPaymentSuccess: (response) async {
        // Mark order as placed immediately to prevent UI flickering
        _orderPlacedSuccessfully = true;
        
        // Batch all async operations to minimize state updates
        // Get latest order for payment - refresh to get current state
        await Future.wait([
          orderController.getActiveOrder(skipLoading: true),
          cartController.getActiveOrder(),
        ]);
        
        final latestOrderModel = orderController.currentOrder.value;
        final latestCartOrder = cartController.cart.value;
        final latestOrderCode = latestOrderModel?.code ?? latestCartOrder?.code ?? orderCode;
        final systemOrderId = latestOrderModel?.id ?? latestCartOrder?.id ?? orderId;

        // Calculate total with tax for metadata
        int orderTotalWithTax = 0;
        if (latestOrderModel != null) {
          orderTotalWithTax = latestOrderModel.totalWithTax.toInt();
        } else if (latestCartOrder != null) {
          orderTotalWithTax = latestCartOrder.totalWithTax.toInt();
        }
        
        // Add shipping cost to total
        final shippingCost = cartController.hasFreeShippingCoupon()
            ? 0
            : orderController.getShippingPrice(orderController.selectedShippingMethod.value);
        final finalTotalWithTax = orderTotalWithTax + shippingCost;
        
        // Get payment method
        final paymentMethod = orderController.selectedPaymentMethod.value?.code ?? 'razorpay';

        // Prepare Razorpay payment metadata for online payment
        // IMPORTANT: Use the Razorpay order ID we generated from backend (not response.orderId)
        // The signature verification on backend uses the order ID we generated
        // Metadata includes:
        // - razorpayPaymentId: Payment ID from Razorpay success response
        // - razorpayOrderId: Razorpay order ID (MUST be the one we generated from backend)
        // - razorpaySignature: Payment signature from Razorpay (for verification)
        // - orderId: Our system's order ID (needed for backend to look up the Razorpay secret)
        // - payment_method: Payment method code
        // - total_with_tax: Total amount with tax including shipping
        // Note: The signature is generated by Razorpay using: razorpay_order_id + razorpay_payment_id + secret
        // So we MUST use the same razorpay_order_id that was used to generate the signature
        final razorpayOrderIdToUse = razorpayOrder.razorpayOrderId ?? '';
        // Verify that the order IDs match (they should be the same)
        if (razorpayOrderIdToUse.isNotEmpty && 
            response.orderId != null && 
            response.orderId!.isNotEmpty &&
            razorpayOrderIdToUse != response.orderId) {
        }
        
        final metadata = {
          "razorpayPaymentId": response.paymentId ?? '',
          "razorpayOrderId": razorpayOrderIdToUse, // Use the one we generated from backend
          "razorpaySignature": response.signature ?? '',
          "orderId": systemOrderId, // Add system order ID for backend verification
          "payment_method": paymentMethod,
          "total_with_tax": finalTotalWithTax.toString(),
        };
        
        // Batch payment addition and analytics tracking
        
        // Execute payment addition and analytics in parallel to reduce time
        final results = await Future.wait([
          // Add payment to order with Razorpay metadata
          orderController.addPayment(
            method: paymentMethod,
            metadata: metadata,
          ),
          // Analytics tracking (non-blocking)
          _trackPaymentAnalytics(response, latestOrderModel, latestCartOrder),
        ]);
        
        // Check payment result
        final paymentResult = results[0] as Map<String, dynamic>;
        if (paymentResult['success'] != true) {
          // Payment failed - show error dialog and stay on checkout page
          final errorMessage = paymentResult['errorMessage'] as String? ?? 'Payment failed';
          ErrorDialog.show(
            title: 'Payment Failed',
            message: errorMessage,
            onClose: () {
              // Reset slider on error so user can try again
              Future.delayed(
                const Duration(milliseconds: 500),
                () => _slideActionKey.currentState?.reset(),
              );
            },
          );
          return;
        }
        
        // Try to transition order to next state
        await orderController.transitionToNextState();
        final finalOrderCode = latestOrderCode ?? orderId;
        
        // Reset loyalty points state after order placement (for next order)
        bannerController.resetLoyaltyPoints();
        
        // Clear cart and navigate in a single operation
        cartController.clearCart();
        
        // Navigate immediately without showing snackbar to prevent flickering
        // The order confirmation page will show success message
        Get.offAllNamed('/order-confirmation', arguments: finalOrderCode);
      },
      onPaymentFailure: (response) {
        showErrorSnackbar('Payment failed: ${response.message}');
        // Reset slider on error so user can try again
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _slideActionKey.currentState?.reset(),
        );
      },
    );
  }

  /// Handle Cash on Delivery payment
  Future<void> _handleCODPayment() async {
    // final currentOrderBeforeTransition = orderController.currentOrder.value; // Unused variable
    // Transition to ArrangingPayment state
    final transitioned = await orderController.transitionToArrangingPayment();
    if (!transitioned) {
      showErrorSnackbar('Failed to process order');
      // Reset slider on error
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
      return;
    }
    // Refresh order to get latest state from server
    await orderController.getActiveOrder(skipLoading: true);
    
    // Add a small delay to ensure server has processed the transition
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Verify order is in ArrangingPayment state before adding payment
    final currentOrder = orderController.currentOrder.value;
    if (currentOrder != null && currentOrder.state != 'ArrangingPayment') {
      // Try refreshing one more time
      await orderController.getActiveOrder(skipLoading: true);
      await cartController.getActiveOrder();
      final refreshedOrder = orderController.currentOrder.value;
      if (refreshedOrder?.state != 'ArrangingPayment') {
        showErrorSnackbar('Order state error. Please try again.');
        return;
      } else {
      }
    }

    // Add payment - offline payment: pass metadata with total, payment method, and transaction id
    final orderModel = orderController.currentOrder.value;
    final cartOrder = cartController.cart.value;
    
    // Calculate total from order model or cart
    int orderTotal = 0;
    String? transactionId;
    
    if (orderModel != null) {
      orderTotal = orderModel.totalWithTax.toInt();
      transactionId = orderModel.code.isNotEmpty ? orderModel.code : orderModel.id;
    } else if (cartOrder != null) {
      orderTotal = cartOrder.totalWithTax.toInt();
      transactionId = cartOrder.code.isNotEmpty ? cartOrder.code : cartOrder.id;
    }
    
    final shippingCost = cartController.hasFreeShippingCoupon()
        ? 0
        : orderController.getShippingPrice(orderController.selectedShippingMethod.value);
    final finalTotal = orderTotal + shippingCost;
    final paymentMethod = orderController.selectedPaymentMethod.value!;
    
    final paymentResult = await orderController.addPayment(
      method: paymentMethod.code,
      metadata: {
        'total': finalTotal.toString(),
        'payment_method': paymentMethod.code,
        'transaction_id': transactionId ?? 'N/A',
      },
    );

    if (paymentResult['success'] != true) {
      // Payment failed - show error dialog and stay on checkout page
      final errorMessage = paymentResult['errorMessage'] as String? ?? 'Payment failed';
      ErrorDialog.show(
        title: 'Payment Failed',
        message: errorMessage,
        onClose: () {
          // Reset slider on error so user can try again
          Future.delayed(
            const Duration(milliseconds: 500),
            () => _slideActionKey.currentState?.reset(),
          );
        },
      );
      return;
    }

    if (paymentResult['success'] == true) {
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
      
      // Mark order as placed successfully - don't reset slider
      _orderPlacedSuccessfully = true;
      
      // Reset loyalty points state after order placement (for next order)
      bannerController.resetLoyaltyPoints();
      
      // Clear cart after successful order placement
      cartController.clearCart();
      // Navigate to order confirmation page
      if (cart != null) {
        Get.offAllNamed('/order-confirmation', arguments: cart.code);
      } else {
        Get.offAllNamed('/home');
      }
    } else {
      showErrorSnackbar('Payment failed');
      // Reset slider on error so user can try again
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _slideActionKey.currentState?.reset(),
      );
    }
  }

  /// Apply loyalty points

  /// Refresh checkout data when returning from addresses page
  Future<void> _refreshCheckoutData() async {
    await Future.wait([
      _loadCustomerAddresses(),
      _loadShippingMethods(),
      _refreshPaymentMethods(),
    ], eagerError: false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          // Reset route tracking when leaving checkout page
          if (didPop) {
            _lastRoute = null;
          }
        },
        child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              CheckoutAppBar(),
              
              // Content Area
              Expanded(
                child: GetBuilder<UtilityController>(
                  builder: (utilityCtrl) {
                    // Only show shimmer on initial load, not on subsequent loading states
                    if (_isInitialLoading && utilityCtrl.isLoading) {
                      return CheckoutShimmerLoading();
                    }

                    return RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        _loadCustomerAddresses(),
                        _loadShippingMethods(),
                        _refreshPaymentMethods(), // Always refresh payment methods on pull-to-refresh
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Order Summary Section
                                  CheckoutOrderSummarySection(
                                    cartController: cartController,
                                    orderController: orderController,
                                    utilityController: utilityController,
                                    bannerController: bannerController,
                                  ),
                                  
                                  Divider(height: ResponsiveUtils.rp(32), thickness: 8, color: AppColors.divider),
                                  
                                  // Delivery Address Section
                                  CheckoutDeliveryAddressSection(
                                    selectedAddress: _selectedAddress,
                                    shouldBlinkAddress: _shouldBlinkAddress,
                                    onLoadAddresses: _loadCustomerAddresses,
                                  ),
                                  
                                  Divider(height: ResponsiveUtils.rp(32), thickness: 8, color: AppColors.divider),
                                  
                                  // Payment Method Section
                                  _buildPaymentMethodSection(),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: ResponsiveUtils.rp(100)), // Space for bottom bar
                        ],
                      ),
                    ),
                  );
                  },
                ),
              ),

              // Place Order Button
              CheckoutPlaceOrderButton(
                cartController: cartController,
                orderController: orderController,
                utilityController: utilityController,
                bannerController: bannerController,
                selectedAddress: _selectedAddress,
                slideActionKey: _slideActionKey,
                orderPlacedSuccessfully: _orderPlacedSuccessfully,
                onPlaceOrder: _onPlaceOrder,
              ),
            ],
          ),
          ),
        ),
      ),
      );
    });
  }

  // Old methods removed - now using components
  // _buildCustomAppBar, _buildOrderSummarySection, _buildDeliveryAddressSection, 
  // _buildPlaceOrderButton, _buildShimmerCheckout have been moved to separate component files.

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ResponsiveUtils.rp(16)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: CheckoutPaymentSection(
            orderController: orderController,
          ),
        ),
      ],
    );
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
      return Obx(() {
        final shouldBlink = _shouldBlinkAddress.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _buildSectionCard(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                  decoration: BoxDecoration(
                    color: shouldBlink
                        ? AppColors.error.withValues(alpha: 0.15)
                        : AppColors.buttonLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    border: Border.all(
                      color: shouldBlink
                          ? AppColors.error.withValues(alpha: 0.8)
                          : AppColors.button.withValues(alpha: 0.2),
                      width: shouldBlink ? 2.5 : 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: ResponsiveUtils.rp(48),
                        color: shouldBlink ? AppColors.error : AppColors.textSecondary,
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Text(
                        'No delivery address selected',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(15),
                          color: shouldBlink ? AppColors.error : AppColors.textSecondary,
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
                        label: Text(AppStrings.addAddress),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: shouldBlink ? AppColors.error : AppColors.button,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(24),
                            vertical: ResponsiveUtils.rp(14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                          elevation: shouldBlink ? 4 : 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
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
            _selectedAddress!.fullName ?? '',
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
                  '${_selectedAddress!.streetLine1}${(_selectedAddress!.streetLine2?.isNotEmpty ?? false) ? ', ${_selectedAddress!.streetLine2}' : ''}, ${_selectedAddress!.city ?? ''}',
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
                _selectedAddress!.phoneNumber ?? '',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              if (_selectedAddress!.defaultShippingAddress ?? false) ...[
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
                        color: AppColors.buttonText,
                        size: ResponsiveUtils.rp(14),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(4)),
                      Text(
                        'Default',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          color: AppColors.buttonText,
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

  // Old method removed - now using CheckoutPlaceOrderButton component


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
                              selectedMethod.name.isNotEmpty 
                                  ? selectedMethod.name 
                                  : _formatPaymentMethodName(selectedMethod.code),
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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
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
      showErrorSnackbar(AppStrings.pleaseSelectPaymentMethod);
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




  // Old method removed - now using CheckoutShimmerLoading component
}

