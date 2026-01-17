import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Service for Google Analytics tracking
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;

  /// Initialize analytics service
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
      
      // Set default event parameters
      await _analytics!.setDefaultEventParameters({
        'app_version': '2.0.78',
        'platform': defaultTargetPlatform.toString(),
      });

    } catch (e) {
    }
  }

  /// Get analytics observer for route tracking
  FirebaseAnalyticsObserver? get observer => _observer;

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
        parameters: parameters,
      );
    } catch (e) {
    }
  }

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
    }
  }

  /// Log login event
  Future<void> logLogin({String? loginMethod}) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logLogin(loginMethod: loginMethod ?? 'unknown');
    } catch (e) {
    }
  }

  /// Log sign up event
  Future<void> logSignUp({String? signUpMethod}) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logSignUp(signUpMethod: signUpMethod ?? 'unknown');
    } catch (e) {
    }
  }

  /// Log add to cart event
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
    int quantity = 1,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logAddToCart(
        currency: currency,
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
            quantity: quantity,
          ),
        ],
      );
    } catch (e) {
    }
  }

  /// Log remove from cart event
  Future<void> logRemoveFromCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
    int quantity = 1,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logRemoveFromCart(
        currency: currency,
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
            quantity: quantity,
          ),
        ],
      );
    } catch (e) {
    }
  }

  /// Log begin checkout event
  Future<void> logBeginCheckout({
    required double value,
    required String currency,
    List<AnalyticsEventItem>? items,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logBeginCheckout(
        value: value,
        currency: currency,
        items: items,
      );
    } catch (e) {
    }
  }

  /// Log purchase event
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logPurchase(
        transactionId: transactionId,
        value: value,
        currency: currency,
        items: items,
        parameters: parameters,
      );
    } catch (e) {
    }
  }

  /// Log search event
  Future<void> logSearch({
    required String searchTerm,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logSearch(searchTerm: searchTerm);
    } catch (e) {
    }
  }

  /// Log view item event
  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logViewItem(
        currency: currency,
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
          ),
        ],
      );
    } catch (e) {
    }
  }

  /// Log add to wishlist event
  Future<void> logAddToWishlist({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logAddToWishlist(
        currency: currency,
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
          ),
        ],
      );
    } catch (e) {
    }
  }

  /// Log apply coupon event
  Future<void> logApplyCoupon({
    required String couponName,
    required String couponCode,
    required double value,
    required String currency,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logEvent(
        name: 'apply_coupon',
        parameters: {
          'coupon_name': couponName,
          'coupon_code': couponCode,
          'value': value,
          'currency': currency,
        },
      );
    } catch (e) {
    }
  }

  /// Set user property
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
    }
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    try {
      if (_analytics == null) return;

      await _analytics!.setUserId(id: userId);
    } catch (e) {
    }
  }

  /// Reset analytics data (on logout)
  Future<void> resetAnalytics() async {
    try {
      if (_analytics == null) return;

      await _analytics!.resetAnalyticsData();
      await _analytics!.setUserId(id: null);
    } catch (e) {
    }
  }

  /// Log button click event
  /// This should be called for every button interaction in the app
  Future<void> logButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, Object>? additionalParameters,
  }) async {
    try {
      if (_analytics == null) return;

      final parameters = <String, Object>{
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
        if (additionalParameters != null) ...additionalParameters,
      };

      await _analytics!.logEvent(
        name: 'button_click',
        parameters: parameters,
      );
    } catch (e) {
    }
  }
}
