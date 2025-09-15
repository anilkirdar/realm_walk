import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.size = 40,
    this.radius,
    this.borderColor,
    this.checkedColor,
    this.checkPosition,
    this.boxPosition = 10,
    this.iconSize,
  });
  final bool isChecked;
  final Function() onChanged;
  final Color? borderColor, checkedColor;
  final double? size, checkPosition, boxPosition, iconSize;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          children: [
            Positioned(
              top: boxPosition,
              bottom: boxPosition,
              right: boxPosition,
              left: boxPosition,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius ?? BorderRadius.circular(3),
                  border: Border.all(color: borderColor ?? Colors.grey),
                ),
              ),
            ),
            if (isChecked)
              Positioned(
                top: 1,
                bottom: 3,
                right: -1,
                left: 3,
                child: Icon(
                  Icons.check_rounded,
                  size: iconSize ?? 28,
                  color: checkedColor ??
                      context.theme.colorScheme.secondaryContainer,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
