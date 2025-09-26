import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../views/_initial_views/_wrapper/store/wrapper_store.dart';
import '../../../views/_main/provider/ar_provider.dart';
import '../../../views/_main/provider/combat_provider.dart';
import '../../../views/_main/provider/location_provider.dart';
import '../../../views/_main/viewmodel/main_viewmodel.dart';
import '../../../views/_product/stores/overlay_state_store.dart';
import '../../../views/auth/provider/auth_provider.dart';
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

    ChangeNotifierProvider(create: (ctx) => AuthProvider()),

    ChangeNotifierProvider(create: (ctx) => LocationProvider()),

    ChangeNotifierProvider(create: (ctx) => CombatProvider()),

    ChangeNotifierProvider(create: (ctx) => ARProvider()),

    Provider<MainViewModel>(create: (_) => MainViewModel()),

    Provider<OnboardViewModel>(create: (_) => OnboardViewModel()),

    Provider<OverlayStateStore>(create: (_) => OverlayStateStore()),

    Provider<WrapperStore>(create: (_) => WrapperStore()),
  ];
  List<SingleChildWidget> uiChangeItems = [];
}
