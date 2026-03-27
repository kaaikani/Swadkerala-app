import 'dart:convert';

import 'package:flutter/material.dart';
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
  bool _initialized = false;

  /// Last FCM topic we subscribed to (for channel-wise notifications). Unsubscribe when channel changes.
  String? _lastSubscribedTopic;

  /// Pending initial message from terminated state — processed after auth is ready.
  RemoteMessage? _pendingInitialMessage;

  // High importance channel for heads-up notifications (Snapchat-style)
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'kaaikani_updates',
    'Kaaikani Updates',
    description: 'Order, cart, and promotional updates from Kaaikani',
    importance: Importance.high, // HIGH IMPORTANCE = Heads-up notifications
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

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
    _initialized = true;
  }

  Future<void> showRemoteNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title ?? 'Kaaikani';
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
    final raw = (code?.isNotEmpty == true ? code : name) ?? 'kaaikani';
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
            'id': collectionId,
            'name': collectionName,
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

