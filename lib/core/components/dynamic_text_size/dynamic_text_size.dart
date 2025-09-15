import 'package:flutter/material.dart';

class DynamicTextSize extends StatelessWidget {
  final String text;
  final double maxFontSize;
  final double minFontSize;
  final int maxLines;
  final int sizeStep;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double? errorTolerance;
  final bool? softWrap;

  const DynamicTextSize(this.text,
      {super.key, required this.maxFontSize,
      required this.minFontSize,
      required this.maxLines,
      required this.sizeStep,
      this.textAlign,
      this.textStyle,
      this.errorTolerance,
      this.softWrap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double fontSize = maxFontSize;
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: textStyle?.copyWith(fontSize: fontSize) ??
                TextStyle(fontSize: fontSize),
          ),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        do {
          if (textPainter.didExceedMaxLines ||
              textPainter.width + (errorTolerance ?? 0) >
                  constraints.maxWidth) {
            fontSize -= sizeStep;
          } else {
            break;
          }
          textPainter.text = TextSpan(
            text: text,
            style: textStyle?.copyWith(
                  fontSize: fontSize,
                ) ??
                TextStyle(fontSize: fontSize),
          );
          textPainter.layout(maxWidth: constraints.maxWidth);
        } while (fontSize >= minFontSize && fontSize <= maxFontSize);

        return Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          softWrap: softWrap == true,
          style: textStyle?.copyWith(
                fontSize: fontSize,
              ) ??
              TextStyle(fontSize: fontSize),
        );
      },
    );
  }
}
