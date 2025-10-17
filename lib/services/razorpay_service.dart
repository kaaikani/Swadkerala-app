import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('[Razorpay] Payment Success: ${response.paymentId}');
    debugPrint('[Razorpay] Order ID: ${response.orderId}');
    debugPrint('[Razorpay] Signature: ${response.signature}');
    
    if (onSuccess != null) {
      onSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('[Razorpay] Payment Error: ${response.code} - ${response.message}');
    
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

    final options = {
      'key': razorpayKeyId, // Razorpay key from backend
      'amount': amountInPaise, // Amount in paise (1 INR = 100 paise)
      'name': 'Your Store',
      'order_id': razorpayOrderId, // Razorpay order ID from backend
      'description': description ?? 'Purchase from Store',
      'timeout': 300, // in seconds (5 minutes)
      'prefill': {
        'contact': customerPhone,
        'email': customerEmail,
        'name': customerName,
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
        'contact': false,
        'name': false,
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
      debugPrint('[Razorpay] Opening payment gateway with amount: Rs.${amountInPaise / 100}');
      _razorpay.open(options);
    } catch (e) {
      debugPrint('[Razorpay] Error opening payment gateway: $e');
    }
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}

