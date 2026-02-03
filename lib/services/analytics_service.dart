import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'meta_events_service.dart';

/// Service for analytics (Firebase + Meta/Facebook App Events).
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;

  /// Initialize analytics service (Firebase + Meta).
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);

      await _analytics!.setDefaultEventParameters({
        'app_version': '2.0.78',
        'platform': defaultTargetPlatform.toString(),
      });

      await MetaEventsService().initialize();
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
      if (_analytics != null) {
        await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
        parameters: parameters,
      );
      }
      MetaEventsService().logEvent(name: 'screen_view', parameters: {'screen_name': screenName, if (screenClass != null) 'screen_class': screenClass});
    } catch (e) {
    }
  }

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      if (_analytics != null) {
        await _analytics!.logEvent(
        name: name,
        parameters: parameters,
      );
      }
      MetaEventsService().logEvent(name: name, parameters: parameters);
    } catch (e) {
    }
  }

  /// Log login event
  Future<void> logLogin({String? loginMethod}) async {
    try {
      if (_analytics != null) {
        await _analytics!.logLogin(loginMethod: loginMethod ?? 'unknown');
      }
      MetaEventsService().logEvent(name: 'Login', parameters: {'method': loginMethod ?? 'unknown'});
    } catch (e) {
    }
  }

  /// Log sign up event
  Future<void> logSignUp({String? signUpMethod}) async {
    try {
      if (_analytics != null) {
        await _analytics!.logSignUp(signUpMethod: signUpMethod ?? 'unknown');
      }
      MetaEventsService().logCompletedRegistration(method: signUpMethod ?? 'unknown');
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
      if (_analytics != null) {
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
      }
      MetaEventsService().logAddToCart(
        itemId: itemId,
        itemName: itemName,
        itemCategory: itemCategory,
        price: price,
        currency: currency,
        quantity: quantity,
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
      if (_analytics != null) {
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
      }
      MetaEventsService().logEvent(
        name: 'RemoveFromCart',
        parameters: {'content_id': itemId, 'content_type': 'product', 'currency': currency, 'value': price},
        valueToSum: price,
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
      if (_analytics != null) {
        await _analytics!.logBeginCheckout(
          value: value,
          currency: currency,
          items: items,
        );
      }
      MetaEventsService().logInitiatedCheckout(value: value, currency: currency);
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
      if (_analytics != null) {
        await _analytics!.logPurchase(
          transactionId: transactionId,
          value: value,
          currency: currency,
          items: items,
          parameters: parameters,
        );
      }
      MetaEventsService().logPurchase(
        transactionId: transactionId,
        value: value,
        currency: currency,
        parameters: parameters != null ? Map<String, dynamic>.from(parameters) : null,
      );
    } catch (e) {
    }
  }

  /// Log search event
  Future<void> logSearch({
    required String searchTerm,
  }) async {
    try {
      if (_analytics != null) {
        await _analytics!.logSearch(searchTerm: searchTerm);
      }
      MetaEventsService().logSearch(searchTerm: searchTerm);
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
      if (_analytics != null) {
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
      }
      MetaEventsService().logViewContent(
        itemId: itemId,
        itemName: itemName,
        itemCategory: itemCategory,
        price: price,
        currency: currency,
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
      if (_analytics != null) {
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
      }
      MetaEventsService().logAddToWishlist(
        itemId: itemId,
        itemName: itemName,
        itemCategory: itemCategory,
        price: price,
        currency: currency,
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
      if (_analytics != null) {
        await _analytics!.logEvent(
          name: 'apply_coupon',
          parameters: {
            'coupon_name': couponName,
            'coupon_code': couponCode,
            'value': value,
            'currency': currency,
          },
        );
      }
      MetaEventsService().logEvent(
        name: 'apply_coupon',
        parameters: {
          'coupon_name': couponName,
          'coupon_code': couponCode,
          'value': value,
          'currency': currency,
        },
        valueToSum: value,
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
      if (_analytics != null) {
        await _analytics!.setUserProperty(name: name, value: value);
      }
    } catch (e) {
    }
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    try {
      if (_analytics != null) {
        await _analytics!.setUserId(id: userId);
      }
      MetaEventsService().setUserId(userId);
    } catch (e) {
    }
  }

  /// Reset analytics data (on logout)
  Future<void> resetAnalytics() async {
    try {
      if (_analytics != null) {
        await _analytics!.resetAnalyticsData();
        await _analytics!.setUserId(id: null);
      }
      MetaEventsService().clearUserData();
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
      final parameters = <String, Object>{
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
        if (additionalParameters != null) ...additionalParameters,
      };
      if (_analytics != null) {
        await _analytics!.logEvent(name: 'button_click', parameters: parameters);
      }
      MetaEventsService().logEvent(name: 'button_click', parameters: parameters);
    } catch (e) {
    }
  }
}
