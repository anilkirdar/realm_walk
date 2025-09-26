import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../../core/constants/utils/ui_constants/size_const.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/notifier/theme_notifier.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.title,
    required this.subTitle,
    this.mainAxisAlignment,
  });
  final String title, subTitle;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
          textScaleFactor: SizeConst.heightFactor > 1
              ? 1
              : SizeConst.heightFactor,
        ),
        Padding(
          padding: PaddingConst.top4,
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: Provider.of<ThemeNotifier>(
                context,
              ).getCustomTheme.purpleToLightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
