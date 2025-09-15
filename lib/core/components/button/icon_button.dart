import 'package:flutter/cupertino.dart';

import '../../constants/utils/ui_constants/padding_const.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
    this.padding,
  });

  final Widget child;
  final Function() onTap;
  final Color? color;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: onTap,
        color: color,
        padding: padding ?? (PaddingConst.bottom4 / 2 + PaddingConst.all2),
        child: child);
  }
}
