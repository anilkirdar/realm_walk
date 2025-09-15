class RegexConst {
  static RegexConst? _instance;

  static RegexConst get instance {
    if (_instance != null) {
      return _instance!;
    }

    _instance = RegexConst._init();
    return _instance!;
  }

  RegexConst._init();

  final String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final String passwordRegex = '';
}
