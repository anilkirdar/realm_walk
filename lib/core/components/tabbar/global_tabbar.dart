import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/sized_box_const.dart';
import '../../constants/utils/ui_constants/text_style_const.dart';
import '../../extensions/context_extension.dart';
import '../../init/managers/button_feedback_manager.dart';
import '../../init/notifier/theme_notifier.dart';
import '../dynamic_text_size/dynamic_text_size.dart';
import 'models/tabbar_item.dart';

class GlobalTabbar extends StatefulWidget {
  static final GlobalKey<_GlobalTabbarState> globalKey =
      GlobalKey<_GlobalTabbarState>();

  static _GlobalTabbarState? of(BuildContext context) {
    return globalKey.currentState;
  }

  final List<TabbarItem> pages;
  final EdgeInsets? verticalPadding;
  final int? initialPage;
  final Function(int)? onPageChanged;
  final bool showIndicator;
  final double? indicatorThickness;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? fontSize;
  const GlobalTabbar({
    super.key,
    required this.pages,
    this.verticalPadding,
    this.initialPage,
    this.onPageChanged,
    this.showIndicator = true,
    this.indicatorThickness,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize,
  });

  @override
  State<GlobalTabbar> createState() => _GlobalTabbarState();
}

class _GlobalTabbarState extends State<GlobalTabbar>
    with TickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage ?? 0;
    tabController = TabController(
      length: widget.pages.length,
      vsync: this,
      initialIndex: widget.initialPage ?? currentPage,
    )..addListener(() {
        if (tabController.indexIsChanging) {
          setState(() {
            currentPage = tabController.index;
          });
          widget.onPageChanged?.call(tabController.index);
        }
      });
  }

  @override
  void didUpdateWidget(GlobalTabbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPage != widget.initialPage &&
        widget.initialPage != null) {
      setState(() {
        currentPage = widget.initialPage!;
      });
      tabController.animateTo(
        widget.initialPage!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void switchToTab(int index) {
    setState(() {
      currentPage = index;
    });
    tabController.animateTo(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    widget.onPageChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            width: context.width,
            margin: (widget.verticalPadding ?? PaddingConst.bottom24),
            padding: PaddingConst.horizontal8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.pages.map((e) => _buildTabButton(e)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.pages.map((e) => e.child).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(TabbarItem item) => Expanded(
        child: GestureDetector(
          onTap: () {
            FeedbackManager.instance.provideHapticFeedback();
            if (item.onPres != null) {
              item.onPres!();
            }
            tabController.animateTo(
              item.index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DynamicTextSize(
                  item.text,
                  textStyle: TextStyleConst.instance.tabbarStyle().copyWith(
                        color: currentPage == item.index
                            ? widget.selectedColor ??
                                Provider.of<ThemeNotifier>(context)
                                    .getCustomTheme
                                    .purpleToWhite
                            : widget.unselectedColor ??
                                Provider.of<ThemeNotifier>(context)
                                    .getCustomTheme
                                    .greyToLightBlue,
                        fontSize: widget.fontSize,
                      ),
                  maxLines: 1,
                  maxFontSize: widget.fontSize ?? 14,
                  minFontSize: 8,
                  sizeStep: 2,
                ),
                if (widget.showIndicator) ...[
                  currentPage == item.index
                      ? const SizedBox(height: 1)
                      : const SizedBox.shrink(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBoxConst.height6,
                      Divider(
                        height: 0,
                        thickness: currentPage == item.index
                            ? widget.indicatorThickness ?? 2
                            : 1,
                        color: currentPage == item.index
                            ? widget.selectedColor ??
                                Provider.of<ThemeNotifier>(context)
                                    .getCustomTheme
                                    .purpleToWhite
                            : widget.unselectedColor ??
                                Provider.of<ThemeNotifier>(context)
                                    .getCustomTheme
                                    .greyToLightBlue,
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
