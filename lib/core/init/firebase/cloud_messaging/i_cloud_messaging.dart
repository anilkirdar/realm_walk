import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../../views/_initial_views/_wrapper/store/wrapper_store.dart';
import '../crashlytics/crashlytics_manager.dart';

abstract class ICloudMessagingManager {
  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void initContext(BuildContext context);

  Future<void> initialize(OverlayState overlayState, WrapperStore wrapperStore);

  Future<void> getAndSaveFCMToken(WrapperStore wrapperStore);

  Future<String> getFCMToken();

  Future<void> onTokenRefresh(WrapperStore wrapperStore);

  Future<void> onMessageOpenedApp();

  Future<void> onMessageListener();

  Future<void> getInitialMessage(BuildContext context);

  Future<void> updateNotificationValue(bool isSubscribe);

  Future<void> deleteToken();
}
