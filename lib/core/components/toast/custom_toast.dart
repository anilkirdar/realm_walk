import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/font_size_const.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/radius_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/theme/app_color_scheme.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    super.key,
    required this.context,
    required this.toastLocation,
    required this.text,
    required this.isVisible,
  });

  final BuildContext context;
  final Alignment toastLocation;
  final String text;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConst.horizontal16 + PaddingConst.bottom12,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: isVisible ? 1 : 0,
        child: Align(
          alignment: toastLocation,
          child: Container(
            padding: PaddingConst.horizontal8 + PaddingConst.vertical2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColorScheme.instance.white,
              borderRadius: RadiusConst.circular25,
            ),
            width: 220,
            height: SizeConst.toastHeight,
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: FontSizeConst.smallest,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF413E69)),
            ),
          ),
        ),
      ),
    );
  }
}
