import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../init/managers/button_feedback_manager.dart';
import 'icon_button.dart';

class PopButton extends StatelessWidget {
  const PopButton({
    super.key,
    this.canBePopped = true,
    this.onPop,
    this.padding,
    this.iconColor, this.size,
  });
  final bool canBePopped;
  final Function()? onPop;
  final EdgeInsets? padding;
  final Color? iconColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return CustomIconButton(
      padding: padding,
      onTap: onPop ??
          () {
            FeedbackManager.instance.provideHapticFeedback();
            if (canBePopped) context.pop();
          },
      child: Icon(
        Icons.arrow_back_ios,
        size: size,
        color: iconColor ?? theme.appBarTheme.iconTheme!.color,
      ),
    );
  }
}
