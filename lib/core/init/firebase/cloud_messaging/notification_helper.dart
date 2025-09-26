import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static final shownNotifications = <String>[];

  static Future<void> initialize(
    Future<void> Function(String payload) onNotificationClick,
  ) async {
    const InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    _notiPlugin.initialize(
      initialSettings,
      onDidReceiveNotificationResponse: (response) async {
        onNotificationClick(response.payload ?? '{}');
      },
    );
  }

  static void showNotification(RemoteMessage message) {
    final hashString =
        "${message.notification!.title}${message.notification!.body}${message.data.toString()}";
    if (shownNotifications.contains(hashString)) return;

    shownNotifications.add(hashString);

    final NotificationDetails notiDetails = NotificationDetails(
      android: const AndroidNotificationDetails(
        'com.realmwalk.app',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentBanner: true,
        presentAlert: true,
        presentSound: true,
        threadIdentifier: message.data['type'] ?? '',
      ),
    );

    _notiPlugin.show(
      DateTime.now().microsecond,
      message.notification!.title,
      message.notification!.body,
      notiDetails,
      payload: jsonEncode(message.data),
    );
  }
}
