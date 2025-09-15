import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/sized_box_const.dart';
import '../../extensions/string_extension.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      this.title,
      this.onTap,
      this.subtitle,
      this.trailingWidget,
      this.leading,
      this.isEnabled = true,
      this.isHeightBig = false,
      this.isLeadingCentered = true,
      this.titlePadding,
      this.titleWidget,
      this.customHeightPadding,
      this.titleStyle});
  final String? title;
  final Function()? onTap;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailingWidget, titleWidget;
  final bool isEnabled, isLeadingCentered;
  final bool isHeightBig;
  final EdgeInsets? titlePadding, customHeightPadding;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Padding(
        padding: context.paddingMainHorizontal +
            (customHeightPadding ??
                (isHeightBig
                    ? (PaddingConst.vertical16)
                    : (PaddingConst.vertical12))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: isLeadingCentered
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    leading != null
                        ? SizedBox(
                            width: 28,
                            child: Padding(
                              padding: context.sLanguageCode.isRTL
                                  ? PaddingConst.left8
                                  : PaddingConst.right8,
                              child: leading ?? Container(width: 0),
                            ))
                        : SizedBoxConst.zero,
                    Container(
                      padding: PaddingConst.vertical8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          titleWidget ??
                              Padding(
                                padding: titlePadding ?? PaddingConst.left4,
                                child: Text(
                                  title ?? '',
                                  style: titleStyle ??
                                      context.theme.textTheme.bodyMedium!
                                          .copyWith(fontSize: 16),
                                ),
                              ),
                          subtitle != null
                              ? Padding(
                                  padding: PaddingConst.left4,
                                  child: Text(
                                    subtitle!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: trailingWidget ??
                  Padding(
                    padding: PaddingConst.right20,
                    child: Icon(Icons.arrow_forward_ios,
                        color: context.theme.primaryIconTheme.color, size: 16),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
