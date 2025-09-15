import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class AnalyticManager {
  static final AnalyticManager _instance = AnalyticManager();

  Mixpanel? _mixpanel;

  static AnalyticManager get instance => _instance;

  static Future<void> initAnalyticManager() async {
    instance._mixpanel = await Mixpanel.init('a365a94b2eb0e924cc14a286191f9c88',
        trackAutomaticEvents: true);
    return;
  }

  ///Be careful to first call 'preferencesInit' in initialization
  ///step to make sure that _preferences is not null

  Future<void> setSuperProperty({Map<String, dynamic>? data}) async {
    //This method set base property
    _mixpanel?.registerSuperProperties(data ?? {});
  }

  void setTrack(String title, {Map<String, dynamic>? properties}) async {
    _mixpanel?.track(title, properties: properties);
  }

  // void tagScreen(String screenName, String? previousScreenName) {
  //   debugPrint('tagScreen: $screenName');
  //   FlutterUxcam.tagScreenName(screenName);
  //   _mixpanel?.track('${screenName} Viewed',
  //       properties: {'previousScreenName': previousScreenName});
  // }

  @Deprecated("DO NOT USE")
  void trackScreen(String screenName) {}

  Future<void> setUser(String uuid) async {
    _mixpanel?.identify(uuid);
  }

  Future<void> startTime() async {
    _mixpanel?.timeEvent('testTime');
  }

  Future<void> stopTime() async {
    //Give duration key on mixpanel panel
    _mixpanel?.track('testTime');
  }
}
