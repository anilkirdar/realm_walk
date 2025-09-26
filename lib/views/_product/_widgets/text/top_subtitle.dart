import 'package:flutter/material.dart';

import '../../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../../core/extensions/context_extension.dart';

class OnBoardTopSubtitle extends StatelessWidget {
  const OnBoardTopSubtitle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: PaddingConst.bottom8,
      color: context.theme.scaffoldBackgroundColor,
      child: Text(text, style: context.theme.textTheme.titleSmall),
    );
  }
}
