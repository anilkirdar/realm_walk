enum PlatformOSEnum {
  android,
  ios,
  web,
  windows,
  macos,
  linux,
  fuchsia,
  unknown,
}

extension PlatformOSEnumExtension on PlatformOSEnum {
  String get platformName {
    switch (this) {
      case PlatformOSEnum.android:
        return 'android';
      case PlatformOSEnum.ios:
        return 'ios';
      case PlatformOSEnum.web:
        return 'web';
      case PlatformOSEnum.windows:
        return 'windows';
      case PlatformOSEnum.macos:
        return 'macos';
      case PlatformOSEnum.linux:
        return 'linux';
      case PlatformOSEnum.fuchsia:
        return 'fuchsia';
      case PlatformOSEnum.unknown:
        return 'unknown';
      // ignore: unreachable_switch_default
      default:
        return 'unknown';
    }
  }
}
