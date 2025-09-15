import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/decorations/box_decoration.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/notifier/theme_notifier.dart';
import '../../init/theme/app_color_scheme.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    required this.child,
    this.highlightColor,
    this.baseColor,
  });
  final Widget child;
  final Color? highlightColor, baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          baseColor ??
          Provider.of<ThemeNotifier>(
            context,
          ).getCustomTheme.lightGreyToDarkerGrey,
      highlightColor:
          highlightColor ?? AppColorScheme.instance.lightGrey.withOpacity(0.5),
      child: child,
    );
  }
}

class Shimmers {
  static SliverChildBuilderDelegate buildSliverShimmerList1({
    double height = SizeConst.listTileSizeHallway,
  }) {
    return SliverChildBuilderDelegate(
      childCount: 10,
      (context, index) => Shimmer.fromColors(
        baseColor:
            Provider.of<ThemeNotifier>(
              context,
            ).getCustomTheme.lightGreyToDarkerGrey,
        highlightColor: AppColorScheme.instance.lightGrey.withOpacity(0.5),
        child: Container(
          height: height,
          margin:
              PaddingConst.horizontal2 +
              PaddingConst.listTIlePadding +
              context.paddingMainHorizontal,
          decoration: BoxDecorationConst.instance.rankingListTileShimmer(
            context.theme,
          ),
        ),
      ),
    );
  }

  static Widget buildPaywallShimmer(
    BuildContext context, [
    bool isSelected = false,
  ]) {
    return CustomShimmer(
      baseColor:
          Provider.of<ThemeNotifier>(
            context,
          ).getCustomTheme.lightGreyToDarkerGrey,
      highlightColor: AppColorScheme.instance.lightGrey.withOpacity(0.5),
      child: Container(
        height:
            isSelected
                ? SizeConst.paywallPlanHeightSelected - 4
                : SizeConst.paywallPlanHeightUnselected - 4,
        margin:
            PaddingConst.all2 +
            (isSelected ? EdgeInsets.zero : PaddingConst.horizontal14),
        decoration: BoxDecorationConst.instance.paywallListTileShimmer(
          context.theme,
          isSelected,
        ),
      ),
    );
  }
}
