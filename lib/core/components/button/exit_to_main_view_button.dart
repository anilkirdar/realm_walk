import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/assets/svg_const.dart';
import '../../extensions/context_extension.dart';
import '../../init/managers/button_feedback_manager.dart';
import '../icons/svg_icon.dart';
import 'icon_button.dart';

class ExitToMainViewButton extends StatelessWidget {
  const ExitToMainViewButton({
    super.key,
    this.padding,
    this.isPop = false,
    this.onTap,
  });

  final EdgeInsets? padding;
  final bool isPop;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      padding: padding,
      onTap: onTap ??
          () {
            FeedbackManager.instance.provideHapticFeedback();
            isPop ? context.pop() : context.pop((route) => route.isFirst);
          },
      child: SvgPictureAsset(
        asset: SVGConst.instance.exit,
        color: context.theme.appBarTheme.iconTheme!.color,
        width: 14.8,
      ),
    );
  }
}
