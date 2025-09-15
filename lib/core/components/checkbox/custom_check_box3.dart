import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/decorations/box_decoration.dart';
import '../../init/notifier/theme_notifier.dart';

class CustomCheckbox3 extends StatelessWidget {
  const CustomCheckbox3({
    super.key,
    required this.isChecked,
    this.size = 40,
    this.radius,
    this.borderColor,
    this.checkedColor,
    this.checkPosition,
    this.boxPosition = 10,
    this.iconSize = 28,
    this.backgroundColor,
    this.uncheckedBackgroundColor,
    this.onTap,
    this.decoration,
  });
  final bool isChecked;
  final Color? borderColor,
      checkedColor,
      backgroundColor,
      uncheckedBackgroundColor;
  final double? size, checkPosition, boxPosition, iconSize;
  final BorderRadius? radius;
  final Function()? onTap;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: decoration ??
            BoxDecorationConst.instance.checkBox3Decoration(context.theme),
        child: Stack(
          children: [
            Positioned(
              top: boxPosition,
              bottom: boxPosition,
              right: boxPosition,
              left: boxPosition,
              child: Container(
                decoration: BoxDecoration(
                  color: isChecked ? backgroundColor : uncheckedBackgroundColor,
                  borderRadius: radius ?? BorderRadius.circular(3),
                  border: Border.all(
                      color: borderColor ??
                          (isChecked
                              ? Color(0xFF6962CF)
                              : Provider.of<ThemeNotifier>(context)
                                  .getCustomTheme
                                  .purpleToWhite)),
                ),
              ),
            ),
            if (isChecked)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Icon(
                  Icons.check_rounded,
                  size: iconSize,
                  color: checkedColor ?? context.theme.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
