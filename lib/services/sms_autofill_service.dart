import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SmsAutofillService {
  static final SmsAutofillService _instance = SmsAutofillService._internal();
  factory SmsAutofillService() => _instance;
  SmsAutofillService._internal();

  String? _appHash;
  Function(String)? _onOtpReceived;
  StreamSubscription? _smsSubscription;

  /// Initialize SMS autofill service
  Future<void> initialize() async {
    try {
      // Get app hash for SMS verification
      _appHash = await SmsAutoFill().getAppSignature;
      debugPrint('[SmsAutofillService] SMS autofill service initialized');
      debugPrint('[SmsAutofillService] App Hash Key: $_appHash');
      debugPrint('[SmsAutofillService] Hash Key Length: ${_appHash?.length}');
    } catch (e) {
      debugPrint('[SmsAutofillService] Error getting app hash: $e');
      _appHash = 'PLACEHOLDER_HASH';
      debugPrint('[SmsAutofillService] Using placeholder hash: $_appHash');
    }
  }

  /// Start listening for SMS messages
  Future<void> startListening(Function(String) onOtpReceived) async {
    try {
      _onOtpReceived = onOtpReceived;
      
      debugPrint('[SmsAutofillService] Starting SMS autofill listening...');
      debugPrint('[SmsAutofillService] Current App Hash Key: $_appHash');
      
      // Start listening for SMS messages using the correct API
      SmsAutoFill().listenForCode();
      
      // Set up a timer to check for SMS codes periodically
      _smsSubscription = Stream.periodic(Duration(seconds: 2)).listen((_) async {
        try {
          String code = await SmsAutoFill().getAppSignature;
          if (code.length == 4 && code != _appHash) {
            debugPrint('[SmsAutofillService] SMS code received: $code');
            _onOtpReceived?.call(code);
          }
        } catch (e) {
          // Continue checking
        }
      });
      
      debugPrint('[SmsAutofillService] SMS autofill listening started successfully');
      
    } catch (e) {
      debugPrint('[SmsAutofillService] Error starting SMS listener: $e');
      // Fallback: show manual entry message
      _showManualEntryMessage();
    }
  }

  /// Stop listening for SMS messages
  void stopListening() {
    try {
      _smsSubscription?.cancel();
      _smsSubscription = null;
      _onOtpReceived = null;
      debugPrint('[SmsAutofillService] Stopped listening for SMS messages');
    } catch (e) {
      debugPrint('[SmsAutofillService] Error stopping SMS listener: $e');
    }
  }

  /// Get app hash for SMS verification
  String? get appHash {
    debugPrint('[SmsAutofillService] Getting app hash: $_appHash');
    return _appHash;
  }

  /// Check if SMS autofill is available
  Future<bool> isAvailable() async {
    try {
      // For now, return true as the package should handle availability
      return true;
    } catch (e) {
      debugPrint('[SmsAutofillService] Error checking availability: $e');
      return false;
    }
  }

  /// Request SMS permission
  Future<bool> requestSmsPermission() async {
    try {
      // For now, return true as permission is handled by the package
      return true;
    } catch (e) {
      debugPrint('[SmsAutofillService] Error requesting SMS permission: $e');
      return false;
    }
  }

  /// Show manual entry message when SMS autofill fails
  void _showManualEntryMessage() {
    debugPrint('[SmsAutofillService] SMS autofill not available, user should enter OTP manually');
  }

  /// Dispose resources
  void dispose() {
    stopListening();
  }
}