import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() async {
  FlutterForegroundTask.setTaskHandler(ForegroundServiceManager.instance);
}

class ForegroundServiceManager extends TaskHandler {
  ForegroundServiceManager._init();
  static ForegroundServiceManager? _instance;
  static ForegroundServiceManager get instance {
    _instance ??= ForegroundServiceManager._init();
    return _instance!;
  }

  BuildContext? context;

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    log('Foreground task destroyed');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    log('Foreground task running...');
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    log('Foreground task started');
  }

  Future<ServiceRequestResult> startForegroundService(
    BuildContext context,
  ) async {
    this.context = context;

    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'RealmWalk',
      notificationText: 'Tap to return to the app',
      notificationIcon: null,
      callback: startCallback,
    );
  }

  void stopForegroundService() async {
    await FlutterForegroundTask.stopService();
  }

  void initForegroundService() {
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service_notification',
        channelName: 'Notifications',
        channelDescription: '',
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.once(),
        allowWakeLock: true,
      ),
    );
  }
}
