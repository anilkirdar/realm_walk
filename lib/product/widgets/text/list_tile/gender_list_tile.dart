import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/utils/decorations/box_decoration.dart';
import '../../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/notifier/theme_notifier.dart';
import '../../../../core/init/theme/app_color_scheme.dart';

class GenderWidget extends StatelessWidget {
  const GenderWidget({
    super.key,
    required this.value,
    required this.onTap,
    required this.icon,
    this.isSelected = false,
  });

  final bool isSelected;
  final String value;
  final Function() onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: PaddingConst.bottom20,
      child: ListTile(
        tileColor: Provider.of<ThemeNotifier>(context)
            .getCustomTheme
            .lightGreyToDarkerGrey,
        selected: isSelected,
        onTap: onTap,
        title: Text(value,
            style: context.textTheme.bodyLarge!.copyWith(
              color: isSelected
                  ? AppColorScheme.instance.white
                  : Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .darkPurpleToWhite,
            )),
        leading: Container(
          padding: PaddingConst.all2,
          decoration: BoxDecorationConst.instance
              .onBoardGender(context.theme,context)
              .copyWith(
                  color: isSelected
                      ? AppColorScheme.instance.white
                      : Provider.of<ThemeNotifier>(context)
                          .getCustomTheme
                          .whiteToDarkerGrey),
          child: Icon(icon,
              size: 28,
              color: isSelected
                  ? context.theme.primaryColor
                  : Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .purpleToWhite),
        ),
      ),
    );
  }
}
