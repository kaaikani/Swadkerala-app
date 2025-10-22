import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../controllers/banner/bannercontroller.dart';
import '../services/razorpay_service.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';

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

  final _formKey = GlobalKey<FormState>();
  late RazorpayService _razorpayService;
  
  // Address selection
  AddressModel? _selectedAddress;
  bool _useExistingAddress = true;

  // Address Form Controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetLine1Controller = TextEditingController();
  final _streetLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  String _customerEmail = 'customer@example.com'; // Get from user profile if available

  // Loyalty Points
  final _loyaltyPointsController = TextEditingController();

  int _currentStep = 0;

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
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetLine1Controller.dispose();
    _streetLine2Controller.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _loyaltyPointsController.dispose();
    _razorpayService.dispose();
    super.dispose();
  }

  Future<void> _loadCustomerAddresses() async {
    await customerController.getActiveCustomer();
    // Set default address if available
    if (customerController.addresses.isNotEmpty) {
      _selectedAddress = customerController.addresses.first;
    }
  }

  Future<void> _loadShippingMethods() async {
    await orderController.getEligibleShippingMethods();
  }

  Future<void> _loadCouponCodes() async {
    debugPrint('[CheckoutPage] ===== LOADING COUPON CODES =====');
    debugPrint('[CheckoutPage] BannerController available: true');
    debugPrint('[CheckoutPage] Current coupon codes count: ${bannerController.availableCouponCodes.length}');
    debugPrint('[CheckoutPage] Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');
    
    try {
      debugPrint('[CheckoutPage] Calling bannerController.getCouponCodeList()...');
      await bannerController.getCouponCodeList();
      debugPrint('[CheckoutPage] bannerController.getCouponCodeList() completed');
      
      debugPrint('[CheckoutPage] After loading - Coupon codes count: ${bannerController.availableCouponCodes.length}');
      debugPrint('[CheckoutPage] After loading - Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');
      
      if (bannerController.availableCouponCodes.isNotEmpty) {
        debugPrint('[CheckoutPage] ✅ Successfully loaded ${bannerController.availableCouponCodes.length} coupon codes');
        for (int i = 0; i < bannerController.availableCouponCodes.length; i++) {
          final coupon = bannerController.availableCouponCodes[i];
          debugPrint('[CheckoutPage] Coupon $i: ${coupon.name} (${coupon.couponCode}) - Enabled: ${coupon.enabled}');
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

  Future<void> _handleAddressSubmit() async {
    bool success = false;
    
    if (_useExistingAddress) {
      // Use selected existing address
      if (_selectedAddress == null) {
        showErrorSnackbar('Please select an address');
        return;
      }
      
      success = await orderController.setShippingAddress(
        fullName: _selectedAddress!.fullName,
        phoneNumber: _selectedAddress!.phoneNumber,
        streetLine1: _selectedAddress!.streetLine1,
        streetLine2: _selectedAddress!.streetLine2,
        city: _selectedAddress!.city,
        province: _selectedAddress!.province,
        postalCode: _selectedAddress!.postalCode,
        countryCode: _selectedAddress!.country.code,
      );
    } else {
      // Use new address form
      if (!_formKey.currentState!.validate()) {
        return;
      }
      
      success = await orderController.setShippingAddress(
        fullName: _fullNameController.text,
        streetLine1: _streetLine1Controller.text,
        streetLine2: _streetLine2Controller.text,
        city: _cityController.text,
        province: _provinceController.text,
        postalCode: _postalCodeController.text,
        countryCode: 'IN',
        phoneNumber: _phoneController.text,
      );
    }

    if (success) {
      showSuccessSnackbar('Address saved successfully');
      setState(() => _currentStep = 1);
      await orderController.getEligibleShippingMethods();
    } else {
      showErrorSnackbar('Failed to save address');
    }
  }

  Future<void> _handleShippingMethodSubmit() async {
    if (orderController.selectedShippingMethod.value == null) {
      showErrorSnackbar('Please select a shipping method');
      return;
    }

    final success = await orderController.setShippingMethod(
      orderController.selectedShippingMethod.value!.id,
    );

    if (success) {
      showSuccessSnackbar('Shipping method selected');
      setState(() => _currentStep = 2);
      await orderController.getEligiblePaymentMethods();
    } else {
      showErrorSnackbar('Failed to set shipping method');
    }
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
    final shippingCost = orderController.selectedShippingMethod.value?.priceWithTax ?? 0;
    final amount = cartTotal + shippingCost;
    final orderId = cart.id;
    
    debugPrint('[Checkout] Cart Total: $cartTotal, Shipping: $shippingCost, Final Amount: $amount');

    // Generate Razorpay Order ID from backend
    showSuccessSnackbar('Generating payment order...');
    final razorpayOrder = await orderController.generateRazorpayOrderId(orderId);
    
    if (razorpayOrder == null) {
      showErrorSnackbar('Failed to generate Razorpay order');
      return;
    }

    debugPrint('[Checkout] Razorpay Order ID: ${razorpayOrder.razorpayOrderId}');
    debugPrint('[Checkout] Razorpay Key ID: ${razorpayOrder.keyId}');

    // Open Razorpay payment gateway with backend-generated order ID
    _razorpayService.openPaymentGateway(
      razorpayOrderId: razorpayOrder.razorpayOrderId,
      razorpayKeyId: razorpayOrder.keyId,
      amountInPaise: amount, // Already in paise/cents
      customerName: _fullNameController.text,
      customerEmail: _customerEmail,
      customerPhone: _phoneController.text,
      description: 'Order #${cart.code}',
      onPaymentSuccess: (response) async {
        debugPrint('[Checkout] Razorpay payment successful: ${response.paymentId}');
        
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

  /// Apply loyalty points (only after coupon codes are applied)
  Future<void> _applyLoyaltyPoints() async {
    // Check if any coupon codes are applied first
    if (bannerController.appliedCouponCodes.isEmpty) {
      showErrorSnackbar('Please apply coupon codes before using loyalty points');
      return;
    }

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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Coupon Codes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Coupon codes list
            Expanded(
              child: Obx(() {
                debugPrint('[CheckoutPage] Bottom sheet - Coupon codes loaded: ${bannerController.couponCodesLoaded.value}');
                debugPrint('[CheckoutPage] Bottom sheet - Available coupons count: ${bannerController.availableCouponCodes.length}');
                
                if (!bannerController.couponCodesLoaded.value) {
                  debugPrint('[CheckoutPage] Bottom sheet - Showing loading indicator');
                  return const Center(child: CircularProgressIndicator());
                }
                
                final enabledCoupons = bannerController.availableCouponCodes
                    .where((coupon) => coupon.enabled)
                    .toList();
                
                debugPrint('[CheckoutPage] Bottom sheet - Enabled coupons count: ${enabledCoupons.length}');
                
                if (enabledCoupons.isEmpty) {
                  debugPrint('[CheckoutPage] Bottom sheet - No enabled coupons, showing empty state');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No coupon codes available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: enabledCoupons.length,
                  itemBuilder: (context, index) {
                    final coupon = enabledCoupons[index];
                    final isApplied = bannerController.isCouponCodeApplied(coupon.couponCode);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isApplied ? Colors.green : Colors.grey.shade200,
                          width: isApplied ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Coupon header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isApplied ? Colors.green : Colors.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    coupon.couponCode,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (isApplied)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check, color: Colors.white, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          'APPLIED',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Coupon name
                            Text(
                              coupon.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Description
                            if (coupon.description != null) ...[
                              Text(
                                coupon.description!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            
                            // Expiry date
                            if (coupon.endsAt != null) ...[
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 16, color: Colors.red.shade400),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Expires: ${DateTime.parse(coupon.endsAt!).toString().split(' ')[0]}',
                                    style: TextStyle(
                                      color: Colors.red.shade400,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            
                            // Products included
                            if (bannerController.hasCouponProducts(coupon.couponCode)) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.shopping_bag, size: 16, color: Colors.blue.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Products included:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ...bannerController.getCouponProducts(coupon.couponCode).map((product) => 
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20, bottom: 4),
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle, size: 12, color: Colors.blue.shade600),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${product['name']} (Qty: ${product['quantity']})',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.blue.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).toList(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            // Validation status
                            if (!isApplied) ...[
                              FutureBuilder<Map<String, dynamic>>(
                                future: bannerController.getCouponValidationStatus(coupon.couponCode),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final validation = snapshot.data!;
                                    if (!validation['valid']) {
                                      Color errorColor = Colors.orange;
                                      if (validation['error'] == 'MINIMUM_ORDER_AMOUNT_NOT_MET') {
                                        errorColor = Colors.red;
                                      } else if (validation['error'] == 'COUPON_EXPIRED' || 
                                               validation['error'] == 'COUPON_DISABLED') {
                                        errorColor = Colors.grey;
                                      } else if (validation['error'] == 'ANOTHER_COUPON_APPLIED') {
                                        errorColor = Colors.blue;
                                      }
                                      
                                      return Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: errorColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: errorColor.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.warning, color: errorColor, size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                validation['message'],
                                                style: TextStyle(
                                                  color: errorColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            // Apply/Remove button
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                final anyCouponApplied = bannerController.isAnyCouponApplied();
                                final currentlyAppliedCoupon = bannerController.getCurrentlyAppliedCoupon();
                                final isAnotherCouponApplied = anyCouponApplied && currentlyAppliedCoupon != coupon.couponCode;
                                
                                return ElevatedButton(
                                  onPressed: isAnotherCouponApplied ? null : () async {
                                    if (isApplied) {
                                      // Remove coupon
                                      final success = await bannerController.removeCouponCode(coupon.couponCode);
                                      if (success) {
                                        showSuccessSnackbar('Coupon code removed successfully');
                                        Navigator.pop(context); // Close bottom sheet
                                        setState(() {}); // Refresh UI
                                      } else {
                                        showErrorSnackbar('Failed to remove coupon code');
                                      }
                                    } else {
                                      // Apply coupon
                                      if (bannerController.hasCouponProducts(coupon.couponCode)) {
                                        // Coupon has products to add
                                        final result = await bannerController.applyCouponCodeWithProducts(coupon.couponCode);
                                        if (result['success']) {
                                          showSuccessSnackbar(result['message'] ?? 'Coupon applied successfully with products added!');
                                          Navigator.pop(context); // Close bottom sheet
                                          setState(() {}); // Refresh UI
                                        } else {
                                          if (result['rollbackPerformed'] == true) {
                                            showErrorSnackbar(result['message'] ?? 'Failed to apply coupon. Added products have been removed.');
                                          } else {
                                            showErrorSnackbar(result['message'] ?? 'Failed to apply coupon code');
                                          }
                                        }
                                      } else {
                                        // Regular coupon without products
                                        final result = await bannerController.applyCouponCode(coupon.couponCode);
                                        if (result['success']) {
                                          showSuccessSnackbar(result['message'] ?? 'Coupon applied successfully!');
                                          Navigator.pop(context); // Close bottom sheet
                                          setState(() {}); // Refresh UI
                                        } else {
                                          showErrorSnackbar(result['message'] ?? 'Failed to apply coupon code');
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isAnotherCouponApplied 
                                        ? Colors.grey 
                                        : (isApplied ? Colors.red : Colors.green),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    isAnotherCouponApplied 
                                        ? 'Another Coupon Applied' 
                                        : (isApplied ? 'Remove Coupon' : 'Apply Coupon'),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
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
      appBar: const AppBarWidget(
        title: 'Checkout',
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stepper(
          currentStep: _currentStep,
          onStepContinue: () async {
            if (_currentStep == 0) {
              await _handleAddressSubmit();
            } else if (_currentStep == 1) {
              await _handleShippingMethodSubmit();
            } else if (_currentStep == 2) {
              await _handlePayment();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            // Step 1: Shipping Address
            Step(
              title: const Text('Shipping Address'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Address Selection Toggle
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Use Existing Address'),
                            value: true,
                            groupValue: _useExistingAddress,
                            onChanged: (value) {
                              setState(() {
                                _useExistingAddress = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Add New Address'),
                            value: false,
                            groupValue: _useExistingAddress,
                            onChanged: (value) {
                              setState(() {
                                _useExistingAddress = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    
                    // Existing Address Selection
                    if (_useExistingAddress) ...[
                      Obx(() {
                        if (customerController.addresses.isEmpty) {
                          return const Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No addresses found. Please add a new address.'),
                            ),
                          );
                        }
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Address:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...customerController.addresses.map((address) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: RadioListTile<AddressModel>(
                                  title: Text(address.fullName),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(address.streetLine1),
                                      if (address.streetLine2.isNotEmpty)
                                        Text(address.streetLine2),
                                      Text('${address.city}, ${address.province} ${address.postalCode}'),
                                      if (address.defaultShippingAddress)
                                        const Text('Default Shipping', style: TextStyle(color: Colors.blue)),
                                    ],
                                  ),
                                  value: address,
                                  groupValue: _selectedAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAddress = value;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }),
                    ],
                    
                    // New Address Form
                    if (!_useExistingAddress) ...[
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _streetLine1Controller,
                      decoration: const InputDecoration(
                        hintText: 'Address Line 1',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _streetLine2Controller,
                      decoration: const InputDecoration(
                        hintText: 'Address Line 2 (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              hintText: 'City',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter city';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _provinceController,
                            decoration: const InputDecoration(
                              hintText: 'State',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter state';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _postalCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Postal Code',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter postal code';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

            // Step 2: Shipping Method
            Step(
              title: const Text('Shipping Method'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: orderController.shippingMethods.map((method) {
                  return RadioListTile(
                    title: Text(method.name),
                    subtitle: Text(
                      '${method.description}\n${cartController.formatPrice(method.priceWithTax)}',
                    ),
                    value: method,
                    groupValue: orderController.selectedShippingMethod.value,
                    onChanged: (value) {
                      orderController.selectedShippingMethod.value = value;
                    },
                  );
                }).toList(),
              ),
            ),

            // Step 3: Payment
            Step(
              title: const Text('Payment'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  ...orderController.paymentMethods
                      .where((m) => m.isEligible)
                      .map((method) {
                    return RadioListTile(
                      title: Text(method.code.toUpperCase()),
                      subtitle: method.eligibilityMessage != null
                          ? Text(method.eligibilityMessage!)
                          : null,
                      value: method,
                      groupValue: orderController.selectedPaymentMethod.value,
                      onChanged: (value) {
                        orderController.selectedPaymentMethod.value = value;
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  
                  // Coupon Codes Section - Improved UI
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Coupon Codes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Obx(() {
                                final appliedCount = bannerController.appliedCouponCodes.length;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: appliedCount > 0 ? Colors.green : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    appliedCount > 0 ? '$appliedCount Applied' : 'None Applied',
                                    style: TextStyle(
                                      color: appliedCount > 0 ? Colors.white : Colors.grey.shade600,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Applied Coupon Codes Display
                          Obx(() {
                            if (bannerController.appliedCouponCodes.isNotEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          'Applied Coupon Codes:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ...bannerController.appliedCouponCodes.map((code) => 
                                      Padding(
                                        padding: const EdgeInsets.only(left: 24, bottom: 4),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.local_offer, color: Colors.green, size: 14),
                                            const SizedBox(width: 8),
                                            Text(
                                              code,
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).toList(),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          
                          const SizedBox(height: 12),
                          
                          // Coupon Codes Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showCouponCodesBottomSheet(),
                              icon: const Icon(Icons.local_offer),
                              label: const Text('Browse Available Coupon Codes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Debug button to test coupon loading
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Loyalty Points Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Loyalty Points',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            if (bannerController.appliedCouponCodes.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  border: Border.all(color: Colors.orange.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Please apply coupon codes first before using loyalty points',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _loyaltyPointsController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter loyalty points',
                                    border: OutlineInputBorder(),
                                    labelText: 'Loyalty Points',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Obx(() => ElevatedButton(
                                onPressed: bannerController.appliedCouponCodes.isNotEmpty 
                                    ? _applyLoyaltyPoints 
                                    : null,
                                child: const Text('Apply'),
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            if (bannerController.loyaltyPointsApplied.value) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Loyalty Points Applied: ${bannerController.loyaltyPointsUsed.value}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: _removeLoyaltyPoints,
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Order Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal'),
                              Text(
                                cartController.formatPrice(
                                  (cartController.cart.value?.subTotalWithTax ?? 0).toInt(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text(
                                orderController.selectedShippingMethod.value != null
                                    ? cartController.formatPrice(
                                        orderController.selectedShippingMethod.value!.priceWithTax,
                                      )
                                    : 'TBD',
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                cartController.formatPrice(
                                  (cartController.cart.value?.totalWithTax ?? 0).toInt(),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

