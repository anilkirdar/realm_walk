import 'package:flutter/material.dart';

import '../../init/cache/local_manager.dart';
import '../../init/firebase/analytics/analytics_manager.dart';
import '../../init/firebase/crashlytics/crashlytics_manager.dart';
import '../../init/network/vexana_manager.dart';
import '../../init/print_dev.dart';

abstract mixin class BaseViewModel {
  late BuildContext viewModelContext;

  final VexanaManager vexanaManager = VexanaManager.instance;

  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;

  final CrashlyticsMessages crashlyticsMessages = CrashlyticsMessages.instance;

  final AnalyticsManager analyticsManager = AnalyticsManager.instance;

  final LocalManager localManager = LocalManager.instance;

  final PrintDev printDev = PrintDev.instance;

  void setContext(BuildContext context);

  void init();

  Future<bool> onBackPressed() async {
    // await navigationManager.onBackPressed();
    return false;
  }
}
