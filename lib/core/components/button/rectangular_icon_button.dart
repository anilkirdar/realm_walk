import 'package:flutter/cupertino.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/decorations/box_decoration.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../icons/svg_icon.dart';

class RectangularIconButton extends StatelessWidget {
  const RectangularIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.color,
      this.size});
  final Color? color;
  final String icon;
  final Function() onPressed;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? SizeConst.smallIconSizeBoxWidth,
      width: size ?? SizeConst.smallIconSizeBoxWidth,
      alignment: Alignment.center,
      decoration:
          BoxDecorationConst.instance.smallIconButton(context.theme, context),
      child: CupertinoButton(
          onPressed: onPressed,
          padding: (PaddingConst.bottom4 / 2 + PaddingConst.all2),
          child: SvgPictureAsset(
            asset: icon,
            color: color ?? context.theme.primaryIconTheme.color,
            height: SizeConst.smallIconSizeBoxWidth - 4,
            width: SizeConst.smallIconSizeBoxWidth - 4,
          )),
    );
  }
}
