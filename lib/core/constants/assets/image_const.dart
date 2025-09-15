class ImageConst {
  static ImageConst? _instance;

  static ImageConst get instance {
    return _instance ??= ImageConst._init();
  }

  ImageConst._init();

  String toPng(String name) => "assets/images/$name.png";
  
  String toIllustration(String name) => "assets/illustrations/$name.png";

  String get userPrimary => toPng('user_primary');
  
  // Onboard View
  String get onboard1 => toIllustration('onboard1');
  String get onboard2 => toIllustration('onboard2');
  String get onboard3 => toIllustration('onboard3');
  
  // User Choice View
  String get userChoice => toIllustration('create_account');
  
  // Create Account View
  String get createAccount => toIllustration('create_account');
  
  // Login View
  String get login => toIllustration('login');
}
