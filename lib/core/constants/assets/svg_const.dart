class SVGConst {
  static SVGConst? _instance;

  static SVGConst get instance {
    return _instance ??= SVGConst._init();
  }

  SVGConst._init();

  String toSvg(String name) => "assets/icons/svg/$name.svg";

  String toIllustration(String name) => "assets/illustrations/$name.svg";

  String get exit => toSvg('exit');

  String get lock => toSvg('lock');

  String get openEye => toSvg('open_eye');

  String get closeEye => toSvg('close_eye');

  String get user => toSvg('user');

  String get logo => toSvg('logo');

  // Splash View
  String get splash => toIllustration('splash');

  // Onboard View
  String get onboard1 => toIllustration('onboard1');
  String get onboard2 => toIllustration('onboard2');
  String get onboard3 => toIllustration('onboard3');
  
  // Create Account View
  String get createAccount => toIllustration('create_account');
}
