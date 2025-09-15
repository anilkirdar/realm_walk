import 'package:flutter/material.dart';

import '../../constants/utils/ui_constants/radius_const.dart';
import '../../init/theme/app_color_scheme.dart';

class CustomCheckbox2 extends StatelessWidget {
  const CustomCheckbox2(
      {super.key,
      required this.isChecked,
      required this.onChanged,
      this.size = 40,
      this.sizeIcon = 28,
      this.radius,
      this.borderColor,
      this.checkedColor,
      this.checkPosition,
      this.boxPosition = 10});
  final bool isChecked;
  final Function() onChanged;
  final Color? borderColor, checkedColor;
  final double? size, checkPosition, boxPosition, sizeIcon;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: size,
        width: size,
        child: Container(
          decoration: BoxDecoration(
            color: isChecked
                ? AppColorScheme.instance.white
                : AppColorScheme.instance.white,
            borderRadius: RadiusConst.small3Rectangular,
          ),
          child: isChecked
              ? Icon(
                  Icons.check,
                  size: size,
                  color: checkedColor ?? AppColorScheme.instance.success,
                )
              : null,
        ),
      ),
    );
  }
}
