import 'package:flutter/material.dart';

import '../../../../core/constants/utils/ui_constants/font_size_const.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/theme/app_color_scheme.dart';

class InformationTile extends StatelessWidget {
  const InformationTile({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: context.width * 0.24),
      child: Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleMedium!.copyWith(
                fontSize: FontSizeConst.smallest,
                // TODO: this color can cause problem in Dark mode
                color: AppColorScheme.instance.grey1,
              )),
          Text(
            subTitle,
            style: context.theme.primaryTextTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
