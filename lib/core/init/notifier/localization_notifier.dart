import 'package:flutter/material.dart';

import '../../../product/enum/local_keys_enum.dart';
import '../cache/local_manager.dart';

class LocalizationNotifier extends ChangeNotifier {
  LocalizationNotifier() {
    readLocale();
  }

  String locale = 'en';

  readLocale() {
    final localeData = LocalManager.instance.getNullableStringValue(
      LocalManagerKeys.locale,
    );

    if (localeData != null) {
      locale = localeData.toLowerCase();
    } else {
      final systemLocale =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      locale = systemLocale.toLowerCase();

      LocalManager.instance.setStringValue(LocalManagerKeys.locale, locale);
    }

    notifyListeners();
  }

  changeLocale(String newLocale, {bool notify = true}) {
    LocalManager.instance.setStringValue(LocalManagerKeys.locale, newLocale);
    locale = newLocale;

    if (notify) {
      notifyListeners();
    }
  }
}
