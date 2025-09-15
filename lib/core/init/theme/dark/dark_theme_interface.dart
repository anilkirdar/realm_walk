import '../app_color_scheme.dart';
import 'primary_text_theme_dark.dart';
import 'text_theme_dark.dart';

abstract mixin class IDarkTheme {
  final AppColorScheme colorScheme = AppColorScheme.instance;
  final TextThemeDark textTheme = TextThemeDark.instance;
  final PrimaryTextThemeDark primaryTextTheme = PrimaryTextThemeDark.instance;
}
