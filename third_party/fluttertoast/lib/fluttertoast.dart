library fluttertoast;

import 'package:flutter/material.dart';

/// Minimal stub implementation of fluttertoast
/// This package exists only to satisfy razorpay_flutter's dependency
/// All methods are no-ops (do nothing)

enum Toast {
  LENGTH_SHORT,
  LENGTH_LONG,
}

enum ToastGravity {
  TOP,
  CENTER,
  BOTTOM,
}

class Fluttertoast {
  /// No-op: Shows nothing
  static Future<bool> showToast({
    required String msg,
    Toast? toastLength,
    ToastGravity? gravity,
    int? timeInSecForIosWeb,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    bool? webShowClose,
    bool? webBgColor,
    String? webPosition,
    String? position,
  }) async {
    // Do nothing - this is a stub
    return true;
  }

  /// No-op: Cancels nothing
  static Future<bool> cancel() async {
    // Do nothing - this is a stub
    return true;
  }
}

