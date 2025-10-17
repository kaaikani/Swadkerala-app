import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
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

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomerAddresses();
      _loadShippingMethods();
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

