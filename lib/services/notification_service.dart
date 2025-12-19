import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/snackbar.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

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

  Future<void> showRemoteNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null || android == null) {
      return;
    }

    // High importance + High priority = Heads-up notification (Snapchat-style)
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

