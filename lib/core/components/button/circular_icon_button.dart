import 'package:flutter/cupertino.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../icons/svg_icon.dart';

class CircularIconButton extends StatelessWidget {
  const CircularIconButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.color,
      this.size,
      this.backgroundColor,
      this.repositionX,
      this.padding})
      : super(key: key);
  final Color? color, backgroundColor;
  final EdgeInsetsGeometry? padding;
  final dynamic icon;
  final Function() onPressed;
  final double? size;
  final double? repositionX;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? SizeConst.smallIconSizeBoxWidth,
      width: size ?? SizeConst.smallIconSizeBoxWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: padding ?? PaddingConst.all4,
        child: icon is String
            ? SvgPictureAsset(
                asset: icon,
                color: color ?? context.theme.primaryIconTheme.color,
                height: SizeConst.smallestIconSize,
                width: SizeConst.smallestIconSize,
              )
            : icon is IconData
                ? repositionX != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: repositionX,
                            child: Icon(
                              icon,
                              color:
                                  color ?? context.theme.primaryIconTheme.color,
                              size: SizeConst.smallestIconSize - 2,
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        icon,
                        color: color ?? context.theme.primaryIconTheme.color,
                        size: SizeConst.smallestIconSize - 2,
                      )
                : icon,
      ),
    );
  }
}
