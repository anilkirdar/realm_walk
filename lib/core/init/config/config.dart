import 'package:universal_io/io.dart';

import '../../constants/enums/app/platform_os_enum.dart';

class Config {
  /// It is created to make tests easier to execute
  /// Use it instead of Platform.isAndroid to be able to
  /// where this getter is used
  bool isAndroid = Platform.isAndroid;

  Config._();

  static Config? _instance;

  static Config get instance => _instance ??= Config._();

  set setIsAndroid(bool value) => isAndroid = value;

  /// This getter gives real platform OS, not depending on faked [isAndroid] on tests
  PlatformOSEnum get platformOS {
    /// Since app is only for mobile platforms, web is commented
    // if (kIsWeb) return PlatformOSEnum.web;
    return Platform.isAndroid ? PlatformOSEnum.android : PlatformOSEnum.ios;
  }

  String get platformOSName {
    return platformOS.platformName;
  }
}
