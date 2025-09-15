enum RemoteConfigKeys {
  androidForceUpdateVersion('androidForceUpdateVersion'),
  androidForceUpdateEndsAt('androidForceUpdateEndsAt'),
  calleeModalShowCallCountThreshold('calleeModalShowCallCountThreshold'),
  iosForceUpdateVersion('iosForceUpdateVersion'),
  iosForceUpdateEndsAt('iosForceUpdateEndsAt'),
  isAndroidMaintenance('isAndroidMaintence'),
  isIosMaintenance('isIosMaintence');

  final String key;
  const RemoteConfigKeys(this.key);

  @override
  String toString() => key;
}
