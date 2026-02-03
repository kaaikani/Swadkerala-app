import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

/// Meta (Facebook) App Events service for ad attribution and analytics.
/// Configure APP_ID and CLIENT_TOKEN in Android (strings.xml) and iOS (Info.plist).
class MetaEventsService {
  static final MetaEventsService _instance = MetaEventsService._internal();
  factory MetaEventsService() => _instance;
  MetaEventsService._internal();

  static final FacebookAppEvents _fb = FacebookAppEvents();
  bool _enabled = false;

  bool get isEnabled => _enabled;

  /// Initialize and activate app. Call once after app start.
  Future<void> initialize() async {
    try {
      await _fb.activateApp();
      _enabled = true;
      if (kDebugMode) {
        debugPrint('MetaEventsService: initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('MetaEventsService: init failed (check APP_ID/CLIENT_TOKEN): $e');
      }
    }
  }

  Future<void> _guard(Future<void> Function() fn) async {
    if (!_enabled) return;
    try {
      await fn();
    } catch (_) {}
  }

  /// Log Add to Cart (standard event).
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
    int quantity = 1,
  }) async {
    await _guard(() => _fb.logAddToCart(
          id: itemId,
          type: 'product',
          price: price,
          currency: currency.isNotEmpty ? currency : 'INR',
          content: {
            'content_name': itemName,
            'content_category': itemCategory,
            'content_ids': itemId,
            'num_items': quantity,
          },
        ));
  }

  /// Log Purchase (standard event).
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    await _guard(() {
      final params = <String, dynamic>{
        if (parameters != null) ...parameters,
        'order_id': transactionId,
      };
      return _fb.logPurchase(
        amount: value,
        currency: currency.isNotEmpty ? currency : 'INR',
        parameters: params,
      );
    });
  }

  /// Log Initiated Checkout (standard event).
  Future<void> logInitiatedCheckout({
    required double value,
    required String currency,
    num numItems = 0,
  }) async {
    await _guard(() => _fb.logInitiatedCheckout(
          totalPrice: value,
          currency: currency.isNotEmpty ? currency : 'INR',
          numItems: numItems.toInt(),
        ));
  }

  /// Log View Content (product view).
  Future<void> logViewContent({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
  }) async {
    await _guard(() => _fb.logViewContent(
          id: itemId,
          type: 'product',
          price: price,
          currency: currency.isNotEmpty ? currency : 'INR',
          content: {
            'content_name': itemName,
            'content_category': itemCategory,
          },
        ));
  }

  /// Log Add to Wishlist.
  Future<void> logAddToWishlist({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
  }) async {
    await _guard(() => _fb.logAddToWishlist(
          id: itemId,
          type: 'product',
          price: price,
          currency: currency.isNotEmpty ? currency : 'INR',
          content: {
            'content_name': itemName,
            'content_category': itemCategory,
          },
        ));
  }

  /// Log search (custom event).
  Future<void> logSearch({required String searchTerm}) async {
    await _guard(() => _fb.logEvent(
          name: 'Search',
          parameters: {'search_string': searchTerm},
        ));
  }

  /// Log completed registration (e.g. sign up).
  Future<void> logCompletedRegistration({String? method}) async {
    await _guard(() => _fb.logCompletedRegistration(
          registrationMethod: method ?? 'unknown',
        ));
  }

  /// Log custom event (e.g. apply_coupon, button_click).
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
    double? valueToSum,
  }) async {
    await _guard(() {
      final params = parameters != null
          ? Map<String, dynamic>.from(parameters)
          : <String, dynamic>{};
      return _fb.logEvent(
        name: name,
        parameters: params.isNotEmpty ? params : null,
        valueToSum: valueToSum,
      );
    });
  }

  /// Set user ID (e.g. after login).
  Future<void> setUserId(String? userId) async {
    if (!_enabled) return;
    try {
      if (userId != null && userId.isNotEmpty) {
        await _fb.setUserID(userId);
      } else {
        await _fb.clearUserID();
      }
    } catch (_) {}
  }

  /// Clear user data (on logout).
  Future<void> clearUserData() async {
    if (!_enabled) return;
    try {
      await _fb.clearUserID();
      await _fb.clearUserData();
    } catch (_) {}
  }
}
