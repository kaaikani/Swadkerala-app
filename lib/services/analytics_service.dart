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

      debugPrint('[Analytics] ✅ Google Analytics initialized successfully');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error initializing analytics: $e');
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
      debugPrint('[Analytics] 📊 Screen view: $screenName');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging screen view: $e');
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
      debugPrint('[Analytics] 📊 Event: $name');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging event: $e');
    }
  }

  /// Log login event
  Future<void> logLogin({String? loginMethod}) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logLogin(loginMethod: loginMethod ?? 'unknown');
      debugPrint('[Analytics] 📊 Login: ${loginMethod ?? 'unknown'}');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging login: $e');
    }
  }

  /// Log sign up event
  Future<void> logSignUp({String? signUpMethod}) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logSignUp(signUpMethod: signUpMethod ?? 'unknown');
      debugPrint('[Analytics] 📊 Sign up: ${signUpMethod ?? 'unknown'}');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging sign up: $e');
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
      debugPrint('[Analytics] 📊 Add to cart: $itemName');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging add to cart: $e');
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
      debugPrint('[Analytics] 📊 Remove from cart: $itemName');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging remove from cart: $e');
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
      debugPrint('[Analytics] 📊 Begin checkout: $value $currency');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging begin checkout: $e');
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
      debugPrint('[Analytics] 📊 Purchase: $transactionId');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging purchase: $e');
    }
  }

  /// Log search event
  Future<void> logSearch({
    required String searchTerm,
  }) async {
    try {
      if (_analytics == null) return;

      await _analytics!.logSearch(searchTerm: searchTerm);
      debugPrint('[Analytics] 📊 Search: $searchTerm');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging search: $e');
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
      debugPrint('[Analytics] 📊 View item: $itemName');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging view item: $e');
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
      debugPrint('[Analytics] 📊 Add to wishlist: $itemName');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging add to wishlist: $e');
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
      debugPrint('[Analytics] 📊 Apply coupon: $couponCode');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error logging apply coupon: $e');
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
      debugPrint('[Analytics] 📊 User property: $name = $value');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error setting user property: $e');
    }
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    try {
      if (_analytics == null) return;

      await _analytics!.setUserId(id: userId);
      debugPrint('[Analytics] 📊 User ID: $userId');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error setting user ID: $e');
    }
  }

  /// Reset analytics data (on logout)
  Future<void> resetAnalytics() async {
    try {
      if (_analytics == null) return;

      await _analytics!.resetAnalyticsData();
      await _analytics!.setUserId(id: null);
      debugPrint('[Analytics] 📊 Analytics data reset');
    } catch (e) {
      debugPrint('[Analytics] ❌ Error resetting analytics: $e');
    }
  }
}

