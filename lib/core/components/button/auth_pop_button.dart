import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/managers/button_feedback_manager.dart';
import 'pop_button_card.dart';

class AuthPopButton extends StatelessWidget {
  const AuthPopButton({super.key, this.onPop});
  final Function()? onPop;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: SizeConst.authPopButtonHeight,
        width: SizeConst.authPopButtonWidth,
        margin: PaddingConst.vertical12 + PaddingConst.left4,
        child: PopButtonCard(
            onPressed: onPop ??
                () {
                  FeedbackManager.instance.provideHapticFeedback();
                  context.pop();
                }),
      ),
    );
  }
}
