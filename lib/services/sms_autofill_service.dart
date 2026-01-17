import 'dart:async';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/foundation.dart';
class SmsAutofillService {
  static final SmsAutofillService _instance = SmsAutofillService._internal();
  factory SmsAutofillService() => _instance;
  SmsAutofillService._internal();

  String? _appHash;
  Function(String)? _onOtpReceived;
  StreamSubscription<String>? _smsSubscription;

  /// Initialize SMS autofill service
  Future<void> initialize() async {
    try {
      _appHash = await SmsAutoFill().getAppSignature;
    } catch (e) {
      _appHash = 'PLACEHOLDER_HASH';
    }
  }

  /// Start listening for OTP SMS
  Future<void> startListening(Function(String) onOtpReceived) async {
    _onOtpReceived = onOtpReceived;

    try {
      await SmsAutoFill().unregisterListener();
      await SmsAutoFill().listenForCode();

      _smsSubscription = SmsAutoFill().code.listen((otp) {
        if (otp.isNotEmpty) {
          _onOtpReceived?.call(otp);
        }
      });

    } catch (e) {
      _showManualEntryMessage();
    }
  }

  /// Stop listening
  void stopListening() {
    _smsSubscription?.cancel();
    _smsSubscription = null;
    _onOtpReceived = null;
    SmsAutoFill().unregisterListener();
  }

  /// Get app hash
  String? get appHash => _appHash;

  /// Dispose resources
  void dispose() => stopListening();

  /// Show manual entry message when SMS autofill fails
  void _showManualEntryMessage() {
  }
}
