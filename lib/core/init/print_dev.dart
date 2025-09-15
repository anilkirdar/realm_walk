import 'package:flutter/foundation.dart';

class PrintDev {
  static PrintDev? _instance;

  static PrintDev get instance {
    return _instance ??= PrintDev._init();
  }

  PrintDev._init();

  void debug(dynamic string) {
    if (kDebugMode) {
      print('_________________________');
      print(string);
      print('***_________________________***');
    }
  }

  void justPrint(dynamic string) {
    if (kDebugMode) {
      print(string);
    }
  }

  void viewInit(String string) {
    if (kDebugMode) {
      print("View: $string");
    }
  }

  void buildWidget(String string) {
    if (kDebugMode) {
      print("Widget: $string");
    }
  }

  void initState(String string) {
    if (kDebugMode) {
      // flutterDebugToast("INIT STATE: $string");
      print("INIT STATE: $string");
    }
  }

  void dispose(String string) {
    if (kDebugMode) {
      // flutterInfoToast("DISPOSE: $string");
      print("DISPOSE: $string");
    }
  }

  void exception(Object string) {
    if (kDebugMode) {
      print('_________________________EXCEPTION_________________________');
      print(string);
      print(
          '***_________________________EXCEPTION_________________________***');
    }
  }
}
