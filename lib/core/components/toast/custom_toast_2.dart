import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/radius_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/theme/app_color_scheme.dart';

class CustomToast2 extends StatelessWidget {
  const CustomToast2({
    required this.text,
    required this.isShown,
    this.color,
    super.key,
  });

  final String text;
  final Color? color;
  final bool isShown;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isShown ? 1 : 0,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 220,
          maxWidth: context.width * .8,
          minHeight: SizeConst.toastHeight,
          maxHeight: SizeConst.toastHeight,
        ),
        alignment: Alignment.center,
        padding: PaddingConst.horizontal8,
        decoration: BoxDecoration(
          color: color ?? AppColorScheme.instance.white,
          borderRadius: RadiusConst.circular25,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: context.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColorScheme.instance.error,
          ),
        ),
      ),
    );
  }
}
