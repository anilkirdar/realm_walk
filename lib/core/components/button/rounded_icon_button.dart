import 'package:flutter/material.dart';

import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/radius_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../extensions/context_extension.dart';
import '../../init/theme/app_color_scheme.dart';
import '../icons/svg_icon.dart';
import 'icon_button.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.isBorder = false,
      this.iconColor,
      this.size,
      this.iconSize});
  final Function() onPressed;
  final String icon;
  final Color? iconColor;
  final double? size, iconSize;
  final bool? isBorder;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: size ?? SizeConst.smallIconSizeBoxWidth,
      width: size ?? SizeConst.smallIconSizeBoxWidth,
      margin: PaddingConst.top12,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: RadiusConst.circular75,
          color: AppColorScheme.instance.white,
      border: isBorder! ?
       Border.all(
          color: context
              .theme.colorScheme.secondary,
          width: 2)
      : null),
      child: CustomIconButton(
          padding: EdgeInsets.zero,
          onTap: onPressed,
          child: SvgPictureAsset(
            asset: icon,
            color: iconColor ?? theme.primaryColor,
            width: iconSize,
          )),
    );
  }
}
