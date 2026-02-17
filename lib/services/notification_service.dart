import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      // You can navigate using payload data if needed
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
}

