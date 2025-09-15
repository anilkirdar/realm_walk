import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/decorations/box_decoration.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/radius_const.dart';
import '../../init/notifier/theme_notifier.dart';
import '../../init/theme/app_color_scheme.dart';
import 'expansion_tile_custom.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.value,
  });
  final String title, value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: PaddingConst.bottom12,
      decoration: BoxDecorationConst.instance.card3(theme, context),
      child: ClipRRect(
        borderRadius: RadiusConst.smallRectangular,
        child: ExpansionTileWidget(
          collapsedBackgroundColor:
              Provider.of<ThemeNotifier>(
                context,
              ).getCustomTheme.whiteToDarkerGrey,
          controlAffinity: ListTileControlAffinity.trailing,
          textColor: AppColorScheme.instance.white,
          iconColor: AppColorScheme.instance.white,
          collapsedIconColor:
              Provider.of<ThemeNotifier>(
                context,
              ).getCustomTheme.darkPurpleToWhite,
          backgroundColor: theme.primaryColor,
          initiallyExpanded: false,
          title: Text(title),
          children: [
            Container(
              padding: PaddingConst.all16,
              color: theme.scaffoldBackgroundColor,
              width: double.infinity,
              child: Text(
                value,
                style: TextStyle(
                  color:
                      Provider.of<ThemeNotifier>(
                        context,
                      ).getCustomTheme.darkPurpleToLightBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
