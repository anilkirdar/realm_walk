import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/decorations/box_decoration.dart';
import 'outlined_text_button.dart';

class RectangularTextButton extends StatelessWidget {
  const RectangularTextButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.isUndeline,
    required this.height,
    this.fontSize,
    this.fontColor,
    this.fontStyle,
    this.fontWeight,
  });
  final Function()? onPressed;
  final String text;
  final bool isUndeline;
  final double height;
  final double? fontSize;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height - 4,
      padding: EdgeInsets.zero,
      width: double.infinity,
      decoration:
          BoxDecorationConst.instance.rectangleTextButton(context.theme,context),
      child: OutlinedTextButton(
        fontColor: fontColor,
        isUnderline: false,
        text: text,
        fontSize: fontSize,
        fontWeight: fontWeight,
        onPressed: onPressed,
      ),
    );
  }
}
