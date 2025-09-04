import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Call this from InitialBindings
  Future<void> init() async {
    // 🔹 Ask notification permission (needed for Android 13+ & iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 Local notifications initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_list_alt');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notification clicked: ${details.payload}");

        if (details.payload != null) {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(jsonDecode(details.payload!));

          switch (data['type']) {
            case 'reminder':
              Get.toNamed(Routes.incompleteTasksScreen);
              break;
            case 'completed':
              Get.toNamed(Routes.completedTasksScreen);
              break;
            case 'warning':
              Get.toNamed(Routes.myAccountScreen);
              break;
            default:
              Get.toNamed(Routes.incompleteTasksScreen); // fallback
          }
        }
      },
    );

    // 🔹 Create notification channel (Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_channel', // id
      'Task Notifications', // name
      description: 'Channel for task related notifications',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 🔹 FCM Listeners
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 🔹 Print token (for testing: copy into Firebase console to send push)
    String? token = await _messaging.getToken();
    debugPrint("FCM Token: $token");
  }

  // Foreground message
  void _onMessage(RemoteMessage message) {
    debugPrint("Foreground message: ${message.notification?.title}");

    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }

  // When notification is tapped and app opens
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint("Notification tapped (FCM): ${message.notification?.title}");

    final type = message.data['type'] ?? 'reminder';

    switch (type) {
      case 'reminder':
        Get.toNamed(Routes.incompleteTasksScreen);
        break;
      case 'completed':
        Get.toNamed(Routes.completedTasksScreen);
        break;
      case 'warning':
        Get.toNamed(Routes.myAccountScreen);
        break;
      default:
        Get.toNamed(Routes.incompleteTasksScreen);
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Channel for task related notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_stat_list_alt', // <-- custom icon
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "No title",
      message.notification?.body ?? "No body",
      platformDetails,
      payload: message.data.toString(),
    );
  }
}

// 🔹 Top-level background handler (must be outside the class!)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message received: ${message.notification?.title}");
}
