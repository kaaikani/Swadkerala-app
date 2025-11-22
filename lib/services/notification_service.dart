import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      icon: '@mipmap/ic_launcher',
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
    final title = message.notification?.title ?? 'Kaaikani';
    final body = message.notification?.body ?? '';
    if (body.isEmpty) return;

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }
}

