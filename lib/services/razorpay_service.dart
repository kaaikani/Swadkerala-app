import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;

  /// Format phone number for Razorpay
  String _formatPhoneNumber(String phone) {
    // Remove all non-digit characters except +
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If phone doesn't start with +, add country code (assuming India +91)
    if (!cleaned.startsWith('+')) {
      // Remove any leading zeros
      cleaned = cleaned.replaceAll(RegExp(r'^0+'), '');
      // Add +91 if it's an Indian number (10 digits)
      if (cleaned.length == 10) {
        cleaned = '+91$cleaned';
      }
    }
    
    // Ensure the phone number is exactly 13 characters (+91xxxxxxxxxx)
    if (cleaned.startsWith('+91') && cleaned.length == 13) {
      return cleaned;
    }
    
    // If it's still not in the right format, try to fix it
    if (cleaned.length == 10) {
      return '+91$cleaned';
    }
    
    return cleaned;
  }

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('[Razorpay] ✅ Payment Success!');
    debugPrint('[Razorpay] Payment ID: ${response.paymentId}');
    debugPrint('[Razorpay] Order ID: ${response.orderId}');
    debugPrint('[Razorpay] Signature: ${response.signature}');
    
    if (onSuccess != null) {
      onSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('[Razorpay] ❌ Payment Failed!');
    debugPrint('[Razorpay] Error Code: ${response.code}');
    debugPrint('[Razorpay] Error Message: ${response.message}');
    
    if (onFailure != null) {
      onFailure!(response);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('[Razorpay] External Wallet: ${response.walletName}');
  }

  /// Open Razorpay payment gateway
  void openPaymentGateway({
    required String razorpayOrderId,
    required String razorpayKeyId,
    required int amountInPaise,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? description,
    required Function(PaymentSuccessResponse) onPaymentSuccess,
    required Function(PaymentFailureResponse) onPaymentFailure,
  }) {
    onSuccess = onPaymentSuccess;
    onFailure = onPaymentFailure;

    // Validate Razorpay key
    if (razorpayKeyId.isEmpty) {
      debugPrint('[Razorpay] ⚠️ ERROR: No Razorpay key provided from backend!');
      return;
    }

    // Enhanced description with order ID and phone number
    final enhancedDescription = description ?? 'Order Payment | Phone: $customerPhone';

    // Format phone number for Razorpay
    final formattedPhone = _formatPhoneNumber(customerPhone);
    debugPrint('[Razorpay] 📞 Phone Number Validation:');
    debugPrint('[Razorpay] - Original Phone: $customerPhone');
    debugPrint('[Razorpay] - Formatted Phone: $formattedPhone');
    debugPrint('[Razorpay] - Phone Length: ${formattedPhone.length}');
    debugPrint('[Razorpay] - Phone Valid: ${formattedPhone.startsWith('+91') && formattedPhone.length == 13}');

    debugPrint('[Razorpay] Payment Details:');
    debugPrint('[Razorpay] - Order ID: $razorpayOrderId');
    debugPrint('[Razorpay] - Amount: Rs.${amountInPaise / 100}');
    debugPrint('[Razorpay] - Customer: $customerName');
    debugPrint('[Razorpay] - Phone: $formattedPhone');
    debugPrint('[Razorpay] - Email: $customerEmail');
    debugPrint('[Razorpay] - Description: $enhancedDescription');

    final options = {
      'key': razorpayKeyId, // Razorpay key from backend
      'amount': amountInPaise, // Amount in paise (1 INR = 100 paise)
      'name': customerName.isNotEmpty ? customerName : 'Kaaikani Store',
      'order_id': razorpayOrderId, // Razorpay order ID from backend
      'description': enhancedDescription,
      'timeout': 300, // in seconds (5 minutes)
      'prefill': {
        'contact': formattedPhone,
        'email': customerEmail,
        'name': customerName,
      },
      'required': {
        'contact': false, // Mark contact as optional but pre-filled
      },
      'method': {
        'netbanking': true,
        'card': true,
        'upi': true,
        'wallet': true,
      },
      'theme': {
        'color': '#3399cc',
      },
      'retry': {
        'enabled': true,
        'max_count': 3,
      },
      'send_sms_hash': true,
      'remember_customer': false,
      'readonly': {
        'email': false,
        'contact': true, // Make contact field readonly so phone number is locked
        'name': false,
      },
      'notes': {
        'order_id': razorpayOrderId,
        'customer_phone': formattedPhone,
        'customer_email': customerEmail,
        'contact_prefilled': formattedPhone,
      },
      'customer': {
        'contact': formattedPhone,
        'email': customerEmail,
        'name': customerName,
      },
      'modal': {
        'backdropclose': false,
        'escape': false,
        'handleback': true,
        'confirm_close': true,
        'animation': true,
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'googlepay']
      }
    };

    try {
      debugPrint('[Razorpay] 🚀 Opening payment gateway...');
      debugPrint('[Razorpay] - Amount: Rs.${amountInPaise / 100}');
      debugPrint('[Razorpay] - Phone Prefill: $formattedPhone');
      debugPrint('[Razorpay] - Contact Field Readonly: true');
      debugPrint('[Razorpay] - Full Options: $options');
      _razorpay.open(options);
    } catch (e) {
      debugPrint('[Razorpay] ❌ Error opening payment gateway: $e');
      if (onFailure != null) {
        // Create a mock failure response for gateway opening errors
        final mockResponse = PaymentFailureResponse(
          0, 
          'Failed to open payment gateway: $e', 
          {}
        );
        onFailure!(mockResponse);
      }
    }
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}

