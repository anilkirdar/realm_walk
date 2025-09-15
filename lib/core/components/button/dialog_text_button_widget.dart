import 'package:flutter/material.dart';

import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/theme/app_color_scheme.dart';
import 'animated_button.dart';

class AlertButton extends StatelessWidget {
  const AlertButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.text,
    this.height,
  });
  final Function() onPressed;
  final Color color;
  final String text;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? SizeConst.elevatedButtonSmallHeight,
      width: SizeConst.smallButtonWidth,
      child: BaseAnimatedButton(
        size: ButtonSize.small,
        shadowColor: color.withOpacity(0.5),
        backgroundColor: color,
        onTap: onPressed,
        child: AnimatedButtonText(
          text: text,
          color: AppColorScheme.instance.white,
          size: ButtonSize.small,
        ),
      ),
    );
  }
}
