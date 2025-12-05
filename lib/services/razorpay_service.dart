import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart';
class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;

  /// Format phone number for Razorpay
  /// Returns phone number in format: +91xxxxxxxxxx (13 characters)
  String _formatPhoneNumber(String phone) {
    if (phone.isEmpty) return '';
    
    // Remove all non-digit characters except +
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If phone doesn't start with +, add country code (assuming India +91)
    if (!cleaned.startsWith('+')) {
      // Remove any leading zeros
      cleaned = cleaned.replaceAll(RegExp(r'^0+'), '');
      // Add +91 if it's an Indian number (10 digits)
      if (cleaned.length == 10) {
        cleaned = '+91$cleaned';
      } else if (cleaned.length == 12 && cleaned.startsWith('91')) {
        // If it starts with 91 but no +, add +
        cleaned = '+$cleaned';
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
    
    // If it's 12 digits starting with 91, add +
    if (cleaned.length == 12 && cleaned.startsWith('91')) {
      return '+$cleaned';
    }
    
    return cleaned;
  }
  
  /// Get phone number without country code for Razorpay prefill (just the 10 digits)
  String _getPhoneWithoutCountryCode(String phone) {
    final formatted = _formatPhoneNumber(phone);
    if (formatted.startsWith('+91') && formatted.length == 13) {
      return formatted.substring(3); // Return just the 10 digits
    }
    // If already 10 digits, return as is
    if (formatted.length == 10) {
      return formatted;
    }
    // Extract last 10 digits
    final digits = formatted.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length >= 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
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

    // Validate and format phone number for Razorpay
    if (customerPhone.isEmpty) {
      debugPrint('[Razorpay] ⚠️ ERROR: Customer phone number is empty!');
      if (onFailure != null) {
        final mockResponse = PaymentFailureResponse(
          0, 
          'Phone number is required for payment', 
          {}
        );
        onFailure!(mockResponse);
      }
      return;
    }
    
    final formattedPhone = _formatPhoneNumber(customerPhone);
    final phoneWithoutCountryCode = _getPhoneWithoutCountryCode(customerPhone);
    
    // Validate phone number format
    if (formattedPhone.isEmpty || !formattedPhone.startsWith('+91') || formattedPhone.length != 13) {
      debugPrint('[Razorpay] ⚠️ WARNING: Phone number format may be invalid!');
      debugPrint('[Razorpay] - Original: $customerPhone');
      debugPrint('[Razorpay] - Formatted: $formattedPhone');
      debugPrint('[Razorpay] - Will attempt to use anyway, but Razorpay may not pre-fill correctly');
    }
    
debugPrint('[Razorpay] 📞 Phone Number Validation:');
debugPrint('[Razorpay] - Original Phone: $customerPhone');
debugPrint('[Razorpay] - Formatted Phone (with +91): $formattedPhone');
debugPrint('[Razorpay] - Phone Without Country Code: $phoneWithoutCountryCode');
debugPrint('[Razorpay] - Phone Length: ${formattedPhone.length}');
debugPrint('[Razorpay] - Phone Valid: ${formattedPhone.startsWith('+91') && formattedPhone.length == 13}');

debugPrint('[Razorpay] Payment Details:');
debugPrint('[Razorpay] - Order ID: $razorpayOrderId');
debugPrint('[Razorpay] - Amount: Rs.${amountInPaise / 100}');
debugPrint('[Razorpay] - Customer: $customerName');
debugPrint('[Razorpay] - Phone: $formattedPhone');
debugPrint('[Razorpay] - Email: $customerEmail');
debugPrint('[Razorpay] - Description: $enhancedDescription');

    // Ensure we have a valid phone number for prefill
    final prefillContact = formattedPhone.isNotEmpty && formattedPhone.startsWith('+91') && formattedPhone.length == 13
        ? formattedPhone
        : (phoneWithoutCountryCode.length == 10 ? '+91$phoneWithoutCountryCode' : formattedPhone);
    
    final options = {
      'key': razorpayKeyId, // Razorpay key from backend
      'amount': amountInPaise, // Amount in paise (1 INR = 100 paise)
      'name': customerName.isNotEmpty ? customerName : 'Kaaikani Store',
      'order_id': razorpayOrderId, // Razorpay order ID from backend
      'description': enhancedDescription,
      'timeout': 300, // in seconds (5 minutes)
      'prefill': {
        'contact': prefillContact, // Full format with country code: +91xxxxxxxxxx (phone number)
        'email': customerEmail, // Original email address
        'name': customerName,
      },
      'required': {
        'contact': false, // Contact is pre-filled, so not required to be entered manually
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
        'contact': true, // Make contact field readonly so phone number is locked and pre-filled
        'name': false,
      },
      'notes': {
        'order_id': razorpayOrderId,
        'customer_phone': prefillContact, // Phone number
        'customer_email': customerEmail, // Original email
        'contact_prefilled': prefillContact,
      },
      'customer': {
        'contact': prefillContact, // Phone number in format: +91xxxxxxxxxx
        'email': customerEmail, // Original email address
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
debugPrint('[Razorpay] - Phone Prefill Contact: $prefillContact');
debugPrint('[Razorpay] - Formatted Phone: $formattedPhone');
debugPrint('[Razorpay] - Phone Without Country Code: $phoneWithoutCountryCode');
debugPrint('[Razorpay] - Contact Field Readonly: true');
debugPrint('[Razorpay] - Contact Required: true');
debugPrint('[Razorpay] - Prefill Object: ${options['prefill']}');
debugPrint('[Razorpay] - Customer Object: ${options['customer']}');
debugPrint('[Razorpay] - Readonly Object: ${options['readonly']}');
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

