import 'package:flutter/cupertino.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/size_const.dart';

class OutlinedTextButton extends StatelessWidget {
  const OutlinedTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isUnderline = true,
    this.fontSize,
    this.fontColor,
    this.fontStyle,
    this.fontWeight,
    this.boxHeight,
    this.underlineColor,
  });
  final Function()? onPressed;
  final String text;
  final bool isUnderline;
  final double? fontSize, boxHeight;
  final Color? fontColor, underlineColor;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (boxHeight ?? SizeConst.textButtonHeight) +
          (fontSize == null ? 0 : fontSize! / 2),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Text(
          text,
          style: context.theme.textTheme.labelLarge!.copyWith(
              
              color: fontColor,
              fontSize: fontSize,
              fontStyle: fontStyle,
              fontWeight: fontWeight,
              decoration:
                  isUnderline ? TextDecoration.underline : TextDecoration.none,
              decorationColor: underlineColor ?? context.theme.primaryColor),
        ),
      ),
    );
  }
}
