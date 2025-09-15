import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/sized_box_const.dart';
import '../../constants/utils/ui_constants/text_style_const.dart';
import '../../extensions/context_extension.dart';
import '../../init/managers/button_feedback_manager.dart';
import '../../init/notifier/theme_notifier.dart';
import '../../init/theme/app_color_scheme.dart';
import '../dynamic_text_size/dynamic_text_size.dart';
import 'models/tabbar_item.dart';

class SliverTabbarDelegate extends SliverPersistentHeaderDelegate {
  final List<TabbarItem> pages;
  final ValueNotifier<int> currentPageNotifier;
  final Function(int)? onPageChanged;
  final bool showIndicator;
  final double? indicatorThickness;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? fontSize;
  final double? minHeight;
  final double? maxHeight;

  SliverTabbarDelegate({
    required this.pages,
    required this.currentPageNotifier,
    this.onPageChanged,
    this.showIndicator = true,
    this.indicatorThickness,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize,
    this.minHeight,
    this.maxHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color:
          Provider.of<ThemeNotifier>(context).isDark
              ? AppColorScheme.instance.backgroundDark
              : AppColorScheme.instance.background,
      child: ValueListenableBuilder<int>(
        valueListenable: currentPageNotifier,
        builder: (context, currentPage, _) {
          return Container(
            width: context.width,
            padding: PaddingConst.vertical8 + PaddingConst.horizontal8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  pages
                      .map(
                        (item) => _buildTabButton(context, item, currentPage),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    TabbarItem item,
    int currentPage,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FeedbackManager.instance.provideHapticFeedback();
          if (item.onPres != null) {
            item.onPres!();
          }
          currentPageNotifier.value = item.index;
          onPageChanged?.call(item.index);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DynamicTextSize(
                item.text,
                textStyle: TextStyleConst.instance.tabbarStyle().copyWith(
                  color:
                      currentPage == item.index
                          ? selectedColor ??
                              Provider.of<ThemeNotifier>(
                                context,
                              ).getCustomTheme.purpleToWhite
                          : unselectedColor ??
                              Provider.of<ThemeNotifier>(
                                context,
                              ).getCustomTheme.greyToLightBlue,
                  fontSize: fontSize,
                ),
                maxLines: 1,
                maxFontSize: fontSize ?? 14,
                minFontSize: 8,
                sizeStep: 2,
              ),
              if (showIndicator) ...[
                currentPage == item.index
                    ? const SizedBox(height: 1)
                    : const SizedBox.shrink(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBoxConst.height6,
                    Divider(
                      height: 0,
                      thickness:
                          currentPage == item.index
                              ? indicatorThickness ?? 2
                              : 1,
                      color:
                          currentPage == item.index
                              ? selectedColor ??
                                  Provider.of<ThemeNotifier>(
                                    context,
                                  ).getCustomTheme.purpleToWhite
                              : unselectedColor ??
                                  Provider.of<ThemeNotifier>(
                                    context,
                                  ).getCustomTheme.greyToLightBlue,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight ?? 56.0;

  @override
  double get minExtent => minHeight ?? 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
