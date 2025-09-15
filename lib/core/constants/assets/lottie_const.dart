class LottieConst {
  static LottieConst? _instance;

  static LottieConst get instance {
    return _instance ??= LottieConst._init();
  }

  LottieConst._init();

  String toLottie(String name) => "assets/lottie/$name.json";

  String get search => toLottie('search');

  String get sparkle => toLottie('sparkle');

  String get enchance => toLottie('enchance');
}
