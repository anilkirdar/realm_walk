import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../crashlytics/crashlytics_manager.dart';
import 'remote_config_keys.dart';

typedef ConfigUpdateCallback = void Function(
    String key, RemoteConfigValue value);

class RemoteConfigManager {
  static RemoteConfigManager? _instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Add value notifier for config changes
  final ValueNotifier<bool> configUpdated = ValueNotifier<bool>(false);

  // Add callback type for config updates
  final Map<String, ConfigUpdateCallback> _updateCallbacks = {};

  static RemoteConfigManager get instance {
    return _instance ??= RemoteConfigManager._init();
  }

  RemoteConfigManager._init() {
    // Listen to config updates
    _remoteConfig.onConfigUpdated.listen((event) async {
      try {
        await _remoteConfig.activate();

        // Notify listeners of specific key changes
        for (final key in event.updatedKeys) {
          if (_updateCallbacks.containsKey(key)) {
            _updateCallbacks[key]?.call(key, _remoteConfig.getValue(key));
          }
        }

        configUpdated.value = !configUpdated.value;
      } catch (e) {
        await CrashlyticsManager.instance.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: 'Error handling config update',
        );
      }
    });
  }

  // Add method to register callbacks for specific keys
  void addListener(RemoteConfigKeys key, ConfigUpdateCallback callback) {
    _updateCallbacks[key.name] = callback;
  }

  void removeListener(RemoteConfigKeys key) {
    _updateCallbacks.remove(key.name);
  }

  // Add method to force fetch new values
  Future<bool> fetchAndActivate() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      await CrashlyticsManager.instance.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error fetching remote config',
      );
      return false;
    }
  }

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval:
            kDebugMode ? const Duration(minutes: 0) : const Duration(hours: 1),
      ));

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      await CrashlyticsManager.instance.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error initializing remote config',
      );
    }
  }

  String getString(
    RemoteConfigKeys key,
  ) {
    return _remoteConfig.getString(key.name);
  }

  bool getBool(RemoteConfigKeys key) {
    return _remoteConfig.getBool(key.name);
  }

  int getInt(RemoteConfigKeys key) {
    return _remoteConfig.getInt(key.name);
  }

  double getDouble(RemoteConfigKeys key) {
    return _remoteConfig.getDouble(key.name);
  }
}
