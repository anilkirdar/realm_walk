import 'package:flutter/material.dart';

import '../../../core/constants/utils/ui_constants/size_const.dart';
import '../../../core/extensions/context_extension.dart';

class OnTopTitle extends StatelessWidget {
  const OnTopTitle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConst.onBoardTitleSize,
      color: context.theme.scaffoldBackgroundColor,
      margin: context.onlyBottomPaddingNormal,
      alignment: Alignment.topCenter,
      child: Text(
        text,
        style: context.theme.textTheme.headlineSmall,
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}
