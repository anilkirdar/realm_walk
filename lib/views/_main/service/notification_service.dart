import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../enum/ar_notification_type_enum.dart';

class NotificationService {
  static NotificationService? _instance;
  NotificationService._internal();

  factory NotificationService() {
    _instance ??= NotificationService._internal();
    return _instance!;
  }

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  bool _isInitialized = false;
  bool _notificationsEnabled = true;

  // Notification channels
  static const String _spawnChannelId = 'ar_spawns';
  static const String _combatChannelId = 'ar_combat';
  static const String _harvestChannelId = 'ar_harvest';
  static const String _socialChannelId = 'ar_social';

  // In-app notification system
  final StreamController<ARNotification> _notificationController =
      StreamController<ARNotification>.broadcast();

  Stream<ARNotification> get notificationStream =>
      _notificationController.stream;

  // Initialize notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _flutterLocalNotificationsPlugin!.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      // Create notification channels for Android
      await _createNotificationChannels();

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;
      print('✅ Notification service initialized');
      return true;
    } catch (e) {
      print('❌ Notification service initialization failed: $e');
      return false;
    }
  }

  // Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _spawnChannelId,
              'AR Spawns',
              description:
                  'Notifications about new monster and resource spawns',
              importance: Importance.high,
              enableVibration: true,
            ),
          );

      await _flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _combatChannelId,
              'AR Combat',
              description: 'Notifications about combat events and rewards',
              importance: Importance.max,
              enableVibration: true,
              enableLights: true,
            ),
          );

      await _flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _harvestChannelId,
              'AR Harvest',
              description: 'Notifications about resource harvesting',
              importance: Importance.defaultImportance,
            ),
          );

      await _flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _socialChannelId,
              'AR Social',
              description: 'Notifications about nearby players and friends',
              importance: Importance.defaultImportance,
            ),
          );
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  // Handle notification responses
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _handleNotificationTap(response.payload);
  }

  // Handle notification tap actions
  void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    try {
      final data = json.decode(payload);
      final type = data['type'] as String?;

      switch (type) {
        case 'spawn':
          _handleSpawnNotificationTap(data);
          break;
        case 'combat':
          _handleCombatNotificationTap(data);
          break;
        case 'harvest':
          _handleHarvestNotificationTap(data);
          break;
        case 'social':
          _handleSocialNotificationTap(data);
          break;
      }
    } catch (e) {
      print('❌ Error handling notification tap: $e');
    }
  }

  // Spawn notifications
  Future<void> showSpawnNotification(
    String message, {
    String? monsterId,
    String? resourceId,
    bool isPersonal = false,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final notification = ARNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      type: ARNotificationType.spawn,
      title: isPersonal ? 'Personal Spawn' : 'New Spawns Nearby',
      message: message,
      timestamp: DateTime.now(),
      data: {
        'monsterId': monsterId,
        'resourceId': resourceId,
        'isPersonal': isPersonal,
      },
    );

    // Show in-app notification
    _notificationController.add(notification);

    // Show system notification
    await _showSystemNotification(
      notification.id,
      notification.title,
      notification.message,
      _spawnChannelId,
      payload: json.encode({
        'type': 'spawn',
        'monsterId': monsterId,
        'resourceId': resourceId,
        'isPersonal': isPersonal,
      }),
    );
  }

  // Combat notifications
  Future<void> showCombatNotification(
    String message, {
    String? monsterId,
    String? sessionId,
    bool isVictory = false,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final notification = ARNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      type: ARNotificationType.combat,
      title: isVictory ? 'Victory!' : 'Combat',
      message: message,
      timestamp: DateTime.now(),
      data: {
        'monsterId': monsterId,
        'sessionId': sessionId,
        'isVictory': isVictory,
      },
    );

    _notificationController.add(notification);

    await _showSystemNotification(
      notification.id,
      notification.title,
      notification.message,
      _combatChannelId,
      payload: json.encode({
        'type': 'combat',
        'monsterId': monsterId,
        'sessionId': sessionId,
        'isVictory': isVictory,
      }),
    );
  }

  // Harvest notifications
  Future<void> showHarvestNotification(
    String message, {
    String? resourceId,
    int? itemCount,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final notification = ARNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      type: ARNotificationType.harvest,
      title: 'Resource Harvested',
      message: message,
      timestamp: DateTime.now(),
      data: {'resourceId': resourceId, 'itemCount': itemCount},
    );

    _notificationController.add(notification);

    await _showSystemNotification(
      notification.id,
      notification.title,
      notification.message,
      _harvestChannelId,
      payload: json.encode({
        'type': 'harvest',
        'resourceId': resourceId,
        'itemCount': itemCount,
      }),
    );
  }

  // Reward notifications
  Future<void> showRewardNotification(
    String message, {
    int? experience,
    int? gold,
    List<String>? items,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final notification = ARNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      type: ARNotificationType.reward,
      title: 'Rewards Earned',
      message: message,
      timestamp: DateTime.now(),
      data: {'experience': experience, 'gold': gold, 'items': items},
    );

    _notificationController.add(notification);

    await _showSystemNotification(
      notification.id,
      notification.title,
      notification.message,
      _combatChannelId,
    );
  }

  // Social notifications
  Future<void> showSocialNotification(
    String message, {
    String? playerId,
    String? playerName,
    bool isFriend = false,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final notification = ARNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      type: ARNotificationType.social,
      title: 'Player Nearby',
      message: message,
      timestamp: DateTime.now(),
      data: {
        'playerId': playerId,
        'playerName': playerName,
        'isFriend': isFriend,
      },
    );

    _notificationController.add(notification);

    await _showSystemNotification(
      notification.id,
      notification.title,
      notification.message,
      _socialChannelId,
      payload: json.encode({
        'type': 'social',
        'playerId': playerId,
        'playerName': playerName,
        'isFriend': isFriend,
      }),
    );
  }

  // Show system notification
  Future<void> _showSystemNotification(
    int id,
    String title,
    String body,
    String channelId, {
    String? payload,
  }) async {
    if (!_isInitialized) return;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'ar_channel',
          'AR Notifications',
          channelDescription: 'Augmented Reality game notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin!.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Handle notification tap actions
  void _handleSpawnNotificationTap(Map<String, dynamic> data) {
    // Navigate to AR camera or minimap
    print('📍 Spawn notification tapped: $data');
  }

  void _handleCombatNotificationTap(Map<String, dynamic> data) {
    // Navigate to combat screen or show rewards
    print('⚔️ Combat notification tapped: $data');
  }

  void _handleHarvestNotificationTap(Map<String, dynamic> data) {
    // Show inventory or resource details
    print('🌿 Harvest notification tapped: $data');
  }

  void _handleSocialNotificationTap(Map<String, dynamic> data) {
    // Navigate to player profile or friends list
    print('👥 Social notification tapped: $data');
  }

  // Notification settings
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
  }

  bool get notificationsEnabled => _notificationsEnabled;

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    if (!_isInitialized) return;
    await _flutterLocalNotificationsPlugin!.cancelAll();
  }

  // Clear specific notification
  Future<void> clearNotification(int id) async {
    if (!_isInitialized) return;
    await _flutterLocalNotificationsPlugin!.cancel(id);
  }

  // Dispose
  void dispose() {
    _notificationController.close();
  }
}

// AR Notification model
class ARNotification {
  final int id;
  final ARNotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  ARNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.data = const {},
  });

  // Get notification icon based on type
  IconData get icon {
    switch (type) {
      case ARNotificationType.spawn:
        return Icons.location_on;
      case ARNotificationType.combat:
        return Icons.flash_on;
      case ARNotificationType.harvest:
        return Icons.eco;
      case ARNotificationType.reward:
        return Icons.card_giftcard;
      case ARNotificationType.social:
        return Icons.people;
    }
  }

  // Get notification color based on type
  Color get color {
    switch (type) {
      case ARNotificationType.spawn:
        return Colors.blue;
      case ARNotificationType.combat:
        return Colors.red;
      case ARNotificationType.harvest:
        return Colors.green;
      case ARNotificationType.reward:
        return Colors.amber;
      case ARNotificationType.social:
        return Colors.purple;
    }
  }

  // Check if notification is recent
  bool get isRecent {
    return DateTime.now().difference(timestamp).inMinutes < 30;
  }
}
