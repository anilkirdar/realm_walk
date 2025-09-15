import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../views/_main/viewmodel/main_viewmodel.dart';
import '../../../views/onboard/viewmodel/onboard_viewmodel.dart';
import 'localization_notifier.dart';
import 'theme_notifier.dart';

class ApplicationProvider {
  static ApplicationProvider? _instance;

  static ApplicationProvider get instance {
    _instance ??= ApplicationProvider._init();
    return _instance!;
  }

  ApplicationProvider._init();

  List<SingleChildWidget> dependedItems = [
    /// Theme Notifier to handle theme changes
    ChangeNotifierProvider(create: (ctx) => ThemeNotifier()),

    ChangeNotifierProvider(create: (ctx) => LocalizationNotifier()),

    Provider<MainViewModel>(create: (_) => MainViewModel()),

    Provider<OnboardViewModel>(create: (_) => OnboardViewModel()),
  ];
  List<SingleChildWidget> uiChangeItems = [];
}
