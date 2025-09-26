import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../product/enum/local_keys_enum.dart';
import '../../../../views/_initial_views/_wrapper/store/wrapper_store.dart';
import '../../../../views/_main/viewmodel/main_viewmodel.dart';
import '../../cache/local_manager.dart';
import '../../managers/analytic_manager.dart';
import '../../print_dev.dart';
import 'i_cloud_messaging.dart';
import 'model/notification_model.dart';
import 'notification_helper.dart';
import 'notification_topics.dart';

class CloudMessagingManager extends ICloudMessagingManager {
  static CloudMessagingManager? _instance;

  static CloudMessagingManager get instance {
    return _instance ??= CloudMessagingManager._init();
  }

  CloudMessagingManager._init();

  String _fcmToken = '';

  late BuildContext _context;

  StreamSubscription<RemoteMessage>? remoteMessageSubscription;

  @override
  void initContext(BuildContext context) => _context = context;

  @override
  Future<void> initialize(
    OverlayState overlayState,
    WrapperStore wrapperStore,
  ) async {
    /// While debugging in web, this function should not execute
    if (kIsWeb) return;

    /// By default it is true, if null is got from isNotificationEnabled.
    final bool isNotificationEnabled =
        LocalManager.instance.getBoolValue(
          LocalManagerKeys.isNotificationEnabled,
        ) ??
        true;
    if (_fcmToken.isNotEmpty) return;

    /// If notification is set false, no need to ask for a permission
    if (isNotificationEnabled != false) {
      final bool isNotificationGranted = await _requestPermission();
      if (isNotificationGranted == false) {
        /// if notification access is declined, try again to get.
        /// This time it asks only once.
        _requestPermission();
      }
    }

    getAndSaveFCMToken(wrapperStore);

    onTokenRefresh(wrapperStore);

    onMessageListener();

    onMessageOpenedApp();

    LocalNotification.initialize((String payload) async {
      try {
        // Validate payload is proper JSON before parsing
        if (payload.trim().isEmpty) {
          PrintDev.instance.debug('Empty notification payload received');
          return;
        }

        final Map<String, dynamic> jsonData = jsonDecode(payload);
        final notification = NotificationModel.fromJson(jsonData);

        if (notification != null) {
          handleNotification(notification, _context);
        }
      } catch (e) {
        PrintDev.instance.debug('Failed to parse notification payload: $e');
        await crashlyticsManager.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: 'Error parsing notification payload',
        );
      }
    });

    await setSubscribeToMainTopicValue(isNotificationEnabled);
  }

  Future<void> setSubscribeToMainTopicValue(bool value) async {
    if (value) {
      await firebaseMessaging.subscribeToTopic(NotificationTopics.main);
    } else {
      await firebaseMessaging.unsubscribeFromTopic(NotificationTopics.main);
    }
  }

  @override
  Future<void> getAndSaveFCMToken(WrapperStore wrapperStore) async {
    try {
      if (_fcmToken != '') {
        return;
      }

      _fcmToken = await firebaseMessaging.getToken() ?? '';
      await wrapperStore.saveFCM(_fcmToken);
      return;
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'error  getAndSaveFCMToken at cloud_messaging',
      );
      return;
    }
  }

  @override
  Future<String> getFCMToken() async {
    try {
      return await firebaseMessaging.getToken() ?? '';
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'error  getFCMToken at cloud_messaging',
      );
      return '';
    }
  }

  @override
  Future<void> onTokenRefresh(WrapperStore wrapperStore) async {
    firebaseMessaging.onTokenRefresh
        .listen((fcmToken) async {
          await wrapperStore.saveFCM(_fcmToken);
        })
        .onError((err) async {
          await crashlyticsManager.sendACrash(
            error: err.toString(),
            stackTrace: StackTrace.current,
            reason: 'Error onTokenRefresh at cloud_messaging',
          );
        });
  }

  Future<bool> _requestPermission() async {
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'error at request permission cloud_messaging',
      );
      return false;
    }
  }

  /// Attempts to navigate with periodic checks for valid context
  void _safeNavigate(BuildContext context, String route, {bool root = false}) {
    if (!context.mounted) {
      PrintDev.instance.debug('Context is not mounted, skipping navigation');
      return;
    }

    try {
      context.go(route);
    } catch (e) {
      PrintDev.instance.debug('Navigation failed: $e');
      // Fallback navigation to main screen if needed
      context.go('/home');
    }
  }

  bool handleNotification(
    NotificationModel notification,
    BuildContext context,
  ) {
    Map<String, dynamic> notificationVariables = {};
    if (notification.variables != null) {
      try {
        notificationVariables = jsonDecode(notification.variables!);
      } catch (e) {
        PrintDev.instance.debug("Failed to parse notification variables: $e");
      }
    }

    try {
      MainViewModel mainViewModel = Provider.of<MainViewModel>(
        _context,
        listen: false,
      );

      switch (notification.id) {
        default:
          _safeNavigate(context, '/home');
          AnalyticManager.instance.trackScreen("Home");
          return true;
      }
    } catch (e) {
      PrintDev.instance.debug('Failed to access MainViewModel: $e');
      return false;
    }
  }

  @override
  Future<void> onMessageOpenedApp() async {
    try {
      FirebaseMessaging.onMessageOpenedApp.listen((
        RemoteMessage message,
      ) async {
        /// Decoding notification data into NotificationModel
        NotificationModel notification = NotificationModel.fromJson(
          message.data,
        );

        /// If notification type is null, throw an exception
        if (notification.type == null) {
          /// TODO: temporarily disabled checking of notification type
          // throw Exception('notification type is null');
        }

        PrintDev.instance.debug(
          '_onMessageOpenedApp TRIGGERED:${notification.toJson()}',
        );
        handleNotification(notification, _context);
      });
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error onMessageOpenedApp at cloud_messaging',
      );
      return;
    }
  }

  @override
  Future<void> onMessageListener() async {
    try {
      remoteMessageSubscription?.cancel();
      remoteMessageSubscription = FirebaseMessaging.onMessage.listen((
        RemoteMessage message,
      ) async {
        PrintDev.instance.debug('_onMessageListener TRIGGERED:${message.data}');

        LocalNotification.showNotification(message);
      });
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error onMessageListener at cloud_messaging',
      );
      return;
    }
  }

  void onForegroundMessageReceived() {}

  @override
  Future<void> getInitialMessage(BuildContext context) async {
    try {
      /// when app is closed and it will be called only once
      FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage? message,
      ) {
        if (message != null) {
          PrintDev.instance.debug(
            '_getInitialMessage TRIGGERED:${message.notification}',
          );
          NotificationModel notification = NotificationModel.fromJson(
            message.data,
          );
          handleNotification(notification, context);
        }
      });
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error getInitialMessage',
      );
      return;
    }
  }

  @override
  Future<void> updateNotificationValue(bool isSubscribe) async {
    try {
      if (isSubscribe == true) {
        firebaseMessaging.subscribeToTopic(NotificationTopics.main);
      } else {
        firebaseMessaging.unsubscribeFromTopic(NotificationTopics.main);
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error updateNotificationValue',
      );
      return;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      _fcmToken = '';
      await firebaseMessaging.deleteToken();
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error deleteToken at cloud_messaging',
      );
      return;
    }
  }
}
