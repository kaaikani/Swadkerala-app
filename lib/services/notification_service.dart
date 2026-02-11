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

  // Fallback when no Vendure channel is set
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'kaaikani_updates',
    'Kaaikani Updates',
    description: 'Order, cart, and promotional updates from Kaaikani',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  /// Android channel ID from stored Vendure channel code so this device uses a channel-specific notification channel.
  static String get _currentChannelId {
    final code = ChannelService.getChannelCode();
    if (code != null && code.toString().trim().isNotEmpty) {
      return 'kaaikani_${code.toString().trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]'), '_')}';
    }
    return _defaultChannel.id;
  }

  /// Display name for the Android channel (uses stored channel name when available).
  static String get _currentChannelName {
    final name = ChannelService.getChannelName();
    final code = ChannelService.getChannelCode();
    if (name != null && name.toString().trim().isNotEmpty) {
      return name.toString().trim();
    }
    if (code != null && code.toString().trim().isNotEmpty) {
      return 'Kaaikani $code';
    }
    return _defaultChannel.name;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

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

  /// Ensure the channel-specific Android notification channel exists (call before showing).
  Future<void> _ensureChannelForCurrentStore() async {
    if (_currentChannelId == _defaultChannel.id) return;
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(AndroidNotificationChannel(
      _currentChannelId,
      _currentChannelName,
      description: 'Notifications for $_currentChannelName',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    ));
  }

  /// Only show notification if message is for current channel (payload channel/channelCode matches stored channel).
  /// If payload has no channel info, show to all (backward compatible).
  static bool _isNotificationForCurrentChannel(RemoteMessage message) {
    final data = message.data;
    if (data.isEmpty) return true;
    final payloadChannel = data['channel'] ?? data['channelCode'] ?? data['channel_token'];
    if (payloadChannel == null || payloadChannel.toString().trim().isEmpty) return true;
    final storedCode = ChannelService.getChannelCode();
    final storedToken = ChannelService.getChannelToken()?.toString();
    if (storedCode != null && storedCode.toString().toLowerCase() == payloadChannel.toString().toLowerCase()) return true;
    if (storedToken != null && storedToken == payloadChannel) return true;
    return false;
  }

  Future<void> showRemoteNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null || android == null) {
      return;
    }

    // Only show if this notification is for the channel saved locally (specific channel alone get notification).
    if (!_isNotificationForCurrentChannel(message)) {
      return;
    }

    await _ensureChannelForCurrentStore();

    final androidDetails = AndroidNotificationDetails(
      _currentChannelId,
      _currentChannelName,
      channelDescription: 'Notifications for $_currentChannelName',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      color: const Color(0xFF22A45D),
      colorized: true,
      styleInformation: BigTextStyleInformation(
        notification.body ?? '',
        contentTitle: notification.title ?? 'Kaaikani',
      ),
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'Kaaikani',
      notification.body ?? '',
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
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
}

