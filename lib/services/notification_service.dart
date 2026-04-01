import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../routes.dart';
import '../widgets/snackbar.dart';
import 'channel_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static const _timerPlatform = MethodChannel('com.Swadkerala.Swadkerala/offer_timer');
  bool _initialized = false;
  bool _timerChannelListenerSet = false;

  /// Last FCM topic we subscribed to (for channel-wise notifications). Unsubscribe when channel changes.
  String? _lastSubscribedTopic;

  /// Pending initial message from terminated state — processed after auth is ready.
  RemoteMessage? _pendingInitialMessage;

  // High importance channel for heads-up notifications (Snapchat-style)
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'swadkerala_updates',
    'SwadKerala Updates',
    description: 'Order, cart, and promotional updates from SwadKerala',
    importance: Importance.high, // HIGH IMPORTANCE = Heads-up notifications
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  // Channel for offer timer notifications
  static const AndroidNotificationChannel _offerTimerChannel =
      AndroidNotificationChannel(
    'kaaikani_offer_timer',
    'Offer Timers',
    description: 'Flash sale and offer countdown timers',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  /// Notification ID for offer timer (fixed so we can update/cancel it)
  static const int _offerTimerNotificationId = 9999;

  Future<void> initialize() async {
    if (_initialized) return;
    // Use custom notification icon with green background
    // Note: User needs to create notification_icon.png in drawable folders
    // If not found, Android will fallback to ic_launcher
    // The icon should be white/transparent logo on transparent background
    // Android will apply the system accent color (green) as background
    // Fallback to default launcher icon if custom icon doesn't exist
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Required when targeting iOS — otherwise plugin throws "iOS settings must be set when targeting iOS platform"
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) {
      // User tapped a local notification (foreground case)
      final payload = response.payload;
      if (payload != null && payload.isNotEmpty) {
        handleNotificationOpenFromPayload(payload);
      }
    });

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_defaultChannel);
    await androidPlugin?.createNotificationChannel(_offerTimerChannel);
    _initialized = true;

    // Subscribe to "all" topic so we can send to all users at once
    try {
      await FirebaseMessaging.instance.subscribeToTopic('all');
    } catch (_) {}

    // Listen for native timer notification taps (Android onNewIntent)
    if (Platform.isAndroid && !_timerChannelListenerSet) {
      _timerChannelListenerSet = true;
      _timerPlatform.setMethodCallHandler((call) async {
        if (call.method == 'onTimerTap') {
          final payload = call.arguments as String? ?? '';
          if (payload.isNotEmpty) {
            debugPrint('[OfferTimer] Native onTimerTap received: $payload');
            handleNotificationOpenFromPayload(payload);
          }
        }
      });
    }
  }

  Future<void> showRemoteNotification(RemoteMessage message) async {
    // Check if this is an offer timer notification
    final type = message.data['type']?.toString().toLowerCase() ?? '';
    if (type == 'offer_timer') {
      await handleOfferTimerFromFCM(message);
      return;
    }

    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title ?? 'SwadKerala';
    final body = notification.body ?? '';
    final id = notification.hashCode;
    final payload = jsonEncode(message.data);

    // Android
    final android = message.notification?.android;
    if (android != null) {
      final androidDetails = AndroidNotificationDetails(
      _defaultChannel.id,
      _defaultChannel.name,
      channelDescription: _defaultChannel.description,
      importance: Importance.high, // HIGH = Shows heads-up banner at top
      priority: Priority.high, // HIGH = Appears even when app is closed
      playSound: true,
      enableVibration: true,
      showWhen: true,
      icon: '@mipmap/ic_launcher', // Small icon - fallback to launcher if custom icon not found
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // Large icon - fallback to launcher if custom icon not found
      color: const Color(0xFF22A45D), // Green color for notification accent (matches AppColors.greenPrimary)
      colorized: true, // Enable colorization
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
      ),
    );

      await _localNotifications.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails),
        payload: payload,
      );
      return;
    }

    // iOS
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(iOS: iosDetails),
      payload: payload,
    );
  }

  /// Show a notification with a live countdown timer (Android chronometer).
  /// [title] - Notification title (e.g. "Flash Sale Live!")
  /// [body] - Notification body text
  /// [endTime] - When the offer ends (epoch milliseconds)
  /// [payload] - Optional JSON payload for tap navigation
  Future<void> showOfferTimerNotification({
    required String title,
    required String body,
    required int endTime,
    String? payload,
    Color? accentColor,
  }) async {
    final remaining = endTime - DateTime.now().millisecondsSinceEpoch;
    if (remaining <= 0) return; // Offer already expired

    // Calculate end time for display
    final endDateTime = DateTime.fromMillisecondsSinceEpoch(endTime);
    final remainingDuration = Duration(milliseconds: remaining);
    final hours = remainingDuration.inHours;
    final minutes = remainingDuration.inMinutes % 60;
    final seconds = remainingDuration.inSeconds % 60;
    final timeLeftText = hours > 0
        ? '${hours}h ${minutes}m left'
        : minutes > 0
            ? '${minutes}m ${seconds}s left'
            : '${seconds}s left';
    final endsAtText = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';

    final colorHex = accentColor != null
        ? accentColor.value.toRadixString(16).substring(2) // Remove alpha
        : 'FF6B00';

    // Android: use native custom layout with big Chronometer
    if (Platform.isAndroid) {
      try {
        await _timerPlatform.invokeMethod('showOfferTimer', {
          'title': title,
          'body': body,
          'endTime': endTime,
          'endsAt': endsAtText,
          'color': colorHex,
          'payload': payload ?? '',
        });
      } catch (e) {
        debugPrint('[OfferTimer] Native call failed, falling back to flutter_local_notifications: $e');
        // Fallback to standard notification
        await _showFallbackTimerNotification(title, body, endTime, endsAtText, timeLeftText, colorHex, payload);
      }
    } else {
      // iOS: use flutter_local_notifications with time info in body
      final iosBody = '$body\n\u23F0 Ends at $endsAtText ($timeLeftText)';
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _localNotifications.show(
        _offerTimerNotificationId,
        '\uD83D\uDD25 $title',
        iosBody,
        const NotificationDetails(iOS: iosDetails),
        payload: payload,
      );
    }

    // Auto-cancel the notification when the offer expires
    Future.delayed(Duration(milliseconds: remaining), () {
      cancelOfferTimerNotification();
    });
  }

  /// Fallback for Android if native method channel is not available
  Future<void> _showFallbackTimerNotification(
    String title, String body, int endTime, String endsAtText, String timeLeftText, String colorHex, String? payload,
  ) async {
    final notifColor = Color(int.parse('FF$colorHex', radix: 16));
    final androidDetails = AndroidNotificationDetails(
      _offerTimerChannel.id,
      _offerTimerChannel.name,
      channelDescription: _offerTimerChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      usesChronometer: true,
      chronometerCountDown: true,
      when: endTime,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: notifColor,
      colorized: true,
      subText: '\u23F1 $timeLeftText',
      styleInformation: BigTextStyleInformation(
        '$body\n\n\u23F0 Offer ends at $endsAtText',
        contentTitle: '\uD83D\uDD25 $title',
        summaryText: 'Tap to shop now',
      ),
    );

    await _localNotifications.show(
      _offerTimerNotificationId,
      '\uD83D\uDD25 $title',
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  /// Check if app was opened from a timer notification and navigate accordingly.
  /// Call this after app init / on resume.
  Future<void> handlePendingTimerNavigation() async {
    if (!Platform.isAndroid) return;
    try {
      final payload = await _timerPlatform.invokeMethod<String>('getTimerPayload');
      if (payload != null && payload.isNotEmpty) {
        debugPrint('[OfferTimer] Handling pending timer navigation: $payload');
        handleNotificationOpenFromPayload(payload);
      }
    } catch (e) {
      debugPrint('[OfferTimer] Error checking timer payload: $e');
    }
  }

  /// Cancel the offer timer notification
  Future<void> cancelOfferTimerNotification() async {
    if (Platform.isAndroid) {
      try {
        await _timerPlatform.invokeMethod('cancelOfferTimer');
      } catch (_) {}
    }
    await _localNotifications.cancel(_offerTimerNotificationId);
  }

  /// Handle FCM data that contains offer timer info.
  /// Expected FCM data keys:
  ///   - type: "offer_timer"
  ///   - offer_end_time: epoch milliseconds as string (e.g. "1719900000000")
  ///   - title: notification title
  ///   - body: notification body
  ///   - page: (optional) route to navigate on tap
  Future<void> handleOfferTimerFromFCM(RemoteMessage message) async {
    final data = message.data;
    final type = data['type']?.toString().toLowerCase() ?? '';

    debugPrint('[OfferTimer] Received FCM - type: $type, data: $data');

    if (type != 'offer_timer') return;

    final endTimeStr = data['offer_end_time'] ?? data['offerEndTime'] ?? '';
    final endTime = int.tryParse(endTimeStr);
    final now = DateTime.now().millisecondsSinceEpoch;

    debugPrint('[OfferTimer] endTime: $endTime, now: $now, isValid: ${endTime != null && endTime > now}');

    if (endTime == null || endTime <= now) {
      debugPrint('[OfferTimer] Skipped - offer expired or invalid endTime');
      return;
    }

    final title = data['title'] ?? message.notification?.title ?? 'Offer Live!';
    final body = data['body'] ?? message.notification?.body ?? 'Hurry, offer ends soon!';
    final payload = jsonEncode(data);

    // Parse accent color from FCM data (hex string e.g. "FF6B00" or "#FF6B00")
    Color? accentColor;
    final colorStr = data['color'] ?? data['accent_color'] ?? '';
    if (colorStr.isNotEmpty) {
      try {
        final hex = colorStr.replaceAll('#', '').trim();
        accentColor = Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }

    debugPrint('[OfferTimer] Showing timer notification - title: $title, remaining: ${(endTime - now) ~/ 1000}s');

    await showOfferTimerNotification(
      title: title,
      body: body,
      endTime: endTime,
      payload: payload,
      accentColor: accentColor,
    );
  }

  void showSnackbar(RemoteMessage message) {
    final body = message.notification?.body ?? '';
    if (body.isEmpty) return;

    SnackBarWidget.show(
      null,
      body,
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 4),
    );
  }

  /// Build a valid FCM topic from channel name/code. Topic allows only [a-zA-Z0-9-_.~%].
  static String _topicFromChannel(String? name, String? code) {
    final raw = (code?.isNotEmpty == true ? code : name) ?? 'swadkerala';
    final sanitized = raw
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\-_.~%]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return 'channel_${sanitized.isEmpty ? 'default' : sanitized}';
  }

  /// Subscribe to FCM topic for channel-wise notifications using channel name/code from local storage.
  /// Call when channel is set or changes (e.g. after login, switch store, or app load).
  /// Unsubscribes from the previous channel topic when switching.
  Future<void> subscribeToChannelTopic() async {
    try {
      final channelName = ChannelService.getChannelName()?.toString();
      final channelCode = ChannelService.getChannelCode()?.toString();
      final topic = _topicFromChannel(channelName, channelCode);

      final messaging = FirebaseMessaging.instance;

      if (_lastSubscribedTopic != null && _lastSubscribedTopic != topic) {
        await messaging.unsubscribeFromTopic(_lastSubscribedTopic!);
      }

      await messaging.subscribeToTopic(topic);
      _lastSubscribedTopic = topic;
    } catch (_) {}
  }

  /// Unsubscribe from current channel topic (e.g. on logout). Next subscribeToChannelTopic will subscribe to new channel.
  Future<void> unsubscribeFromChannelTopic() async {
    try {
      if (_lastSubscribedTopic != null) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(_lastSubscribedTopic!);
        _lastSubscribedTopic = null;
      }
    } catch (_) {}
  }

  // ─── Notification Click → Page Redirect ───

  /// Store initial message from terminated state (called in main.dart).
  void setPendingInitialMessage(RemoteMessage message) {
    _pendingInitialMessage = message;
  }

  /// Process pending initial message after auth is ready (called in AuthWrapper).
  Future<void> handlePendingInitialMessageIfAny() async {
    // Check stored pending message first
    if (_pendingInitialMessage != null) {
      final msg = _pendingInitialMessage!;
      _pendingInitialMessage = null;
      _navigateFromNotificationData(msg.data);
      return;
    }
    // Fallback: re-check getInitialMessage (may have been null when called too early)
    try {
      final msg = await FirebaseMessaging.instance.getInitialMessage();
      if (msg != null) {
        _navigateFromNotificationData(msg.data);
      }
    } catch (_) {}
  }

  /// Handle notification tap when app was in background (onMessageOpenedApp).
  void handleNotificationOpen(RemoteMessage message) {
    _navigateFromNotificationData(message.data);
  }

  /// Handle local notification tap (foreground). Payload is JSON-encoded message.data.
  void handleNotificationOpenFromPayload(String payload) {
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload));
      _navigateFromNotificationData(data);
    } catch (_) {}
  }

  /// Core navigation logic — routes to the correct page based on notification data.
  void _navigateFromNotificationData(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    // Normalize keys to lowercase for case-insensitive lookup
    final d = data.map((k, v) => MapEntry(k.toLowerCase(), v?.toString() ?? ''));

    // Determine target page
    String page = d['page'] ?? d['route'] ?? '';

    // If no page but has productId, default to product-detail
    if (page.isEmpty && (d.containsKey('productid') || d.containsKey('product_id'))) {
      page = 'product-detail';
    }

    // Normalize: strip leading slash, lowercase
    page = page.replaceAll(RegExp(r'^/+'), '').toLowerCase().trim();

    if (page.isEmpty) return;

    debugPrint('[Notification] Navigating to page: $page, data: $d');

    // Defer navigation to next frame to ensure navigator is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (page) {
        case 'home':
          Get.offAllNamed(AppRoutes.home);
          break;
        case 'cart':
          Get.toNamed(AppRoutes.cart);
          break;
        case 'orders':
          Get.toNamed(AppRoutes.orders);
          break;
        case 'order-detail':
          final orderCode = d['ordercode'] ?? d['order_code'] ?? '';
          if (orderCode.isNotEmpty) {
            Get.toNamed(AppRoutes.orderDetail, arguments: {'orderCode': orderCode});
          } else {
            Get.toNamed(AppRoutes.orders);
          }
          break;
        case 'product-detail':
          final productId = d['productid'] ?? d['product_id'] ?? '';
          final productName = d['productname'] ?? d['product_name'] ?? '';
          if (productId.isNotEmpty) {
            Get.toNamed(AppRoutes.productDetail, arguments: {
              'productId': productId,
              'productName': productName,
            });
          }
          break;
        case 'account':
        case 'profile':
          Get.toNamed(AppRoutes.account);
          break;
        case 'addresses':
          Get.toNamed(AppRoutes.addresses);
          break;
        case 'checkout':
          Get.toNamed(AppRoutes.checkout);
          break;
        case 'favourite':
        case 'favorites':
        case 'favourites':
          Get.toNamed(AppRoutes.favourite);
          break;
        case 'search':
          Get.toNamed(AppRoutes.search);
          break;
        case 'order-confirmation':
          final orderId = d['orderid'] ?? d['order_id'] ?? '';
          if (orderId.isNotEmpty) {
            Get.toNamed(AppRoutes.orderConfirmation, arguments: {'orderId': orderId});
          }
          break;
        case 'collection-products':
        case 'collection':
        case 'category':
          final collectionId = d['collectionid'] ?? d['collection_id'] ?? '';
          final collectionName = d['collectionname'] ?? d['collection_name'] ?? '';
          final slug = d['slug'] ?? '';
          Get.toNamed(AppRoutes.collectionProducts, arguments: {
            'collectionId': collectionId,
            'collectionName': collectionName,
            'slug': slug,
          });
          break;
        case 'loyalty-points':
        case 'loyalty-points-transactions':
          Get.toNamed(AppRoutes.loyaltyPointsTransactions);
          break;
        case 'scratch-cards':
          Get.toNamed(AppRoutes.scratchCards);
          break;
        case 'referrals':
        case 'my-referrals':
          Get.toNamed(AppRoutes.myReferrals);
          break;
        default:
          // Try navigating to the route directly
          final route = '/$page';
          Get.toNamed(route);
          break;
      }
    });
  }
}

