import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/decorations/box_decoration.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/managers/button_feedback_manager.dart';
import '../../init/notifier/theme_notifier.dart';
import 'icon_button.dart';

//TODO: test this button if there any issues
class PopButtonCard extends StatelessWidget {
  const PopButtonCard({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.iOSIconSize,
    this.iOSPadding,
  });
  final Function()? onPressed;
  final double? height, width, iOSIconSize;
  final EdgeInsets? iOSPadding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: height ?? SizeConst.smallIconSizeBoxHeight,
      width: width ?? SizeConst.smallIconSizeBoxWidth,
      alignment: Alignment.center,
      decoration: BoxDecorationConst.instance
          .smallIconButton(theme, context)
          .copyWith(
              color: Provider.of<ThemeNotifier>(context)
                  .getCustomTheme
                  .whiteToDarkerGrey),
      child: CustomIconButton(
        onTap: onPressed ??
            () {
              FeedbackManager.instance.provideHapticFeedback();
              context.pop();
            },
        child: Padding(
          padding: iOSPadding ?? PaddingConst.left6,
          child: Icon(
            Icons.arrow_back_ios,
            color: Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .darkPurpleToWhite,
            size: iOSIconSize ?? 16,
          ),
        ),
      ),
    );
  }
}
