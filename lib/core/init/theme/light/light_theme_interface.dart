import '../app_color_scheme.dart';
import 'primary_text_theme_light.dart';
import 'text_theme_light.dart';

abstract mixin class ILightTheme {
  final AppColorScheme colorScheme = AppColorScheme.instance;
  final TextThemeLight textTheme = TextThemeLight.instance;
  final PrimaryTextThemeLight primaryTextTheme = PrimaryTextThemeLight.instance;
}
