import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../init/notifier/custom_theme.dart';
import '../../init/notifier/theme_notifier.dart';
import '../../init/theme/app_color_scheme.dart';

/// Genel shimmer sarmalayıcı widget
class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget shimmer;

  const ShimmerWrapper({
    super.key,
    required this.child,
    required this.isLoading,
    required this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading ? shimmer : child;
  }
}

class Shimmers {
  static final Color _highlightColor = AppColorScheme.instance.lightGrey
      .withOpacity(0.5);

  static Color _getBaseColor(BuildContext context, Color? baseColor) {
    CustomTheme customTheme =
        Provider.of<ThemeNotifier>(context).getCustomTheme;
    return baseColor ?? customTheme.lightGreyToDarkerGrey;
  }

  static Color _getTextBaseColor(BuildContext context, Color? baseColor) {
    CustomTheme customTheme =
        Provider.of<ThemeNotifier>(context).getCustomTheme;
    return baseColor ?? customTheme.purpleToGrey;
  }

  static Widget shimmerContainer(
    BuildContext context, {
    required double height,
    required double width,
    BoxDecoration? decoration,
    Color? baseColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    BoxBorder? border,
    BoxShape shape = BoxShape.rectangle,
    Alignment alignment = Alignment.center,
  }) {
    final effectiveColor = _getBaseColor(context, baseColor);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Shimmer.fromColors(
        baseColor: effectiveColor,
        highlightColor: _highlightColor,
        child: Container(
          height: height,
          width: width,
          alignment: alignment,
          decoration:
              decoration ??
              BoxDecoration(
                color: effectiveColor,
                borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
                shape: shape,
                border: border,
              ),
        ),
      ),
    );
  }

  static Widget shimmerTextEffect(
    BuildContext context, {
    Color? baseColor,
    required String text,
    required TextStyle textStyle,
    double? width,
    double? height,
    TextAlign? textAlign,
  }) {
    return Shimmer.fromColors(
      baseColor: _getTextBaseColor(context, baseColor),
      highlightColor: _highlightColor,
      child: SizedBox(
        width: width,
        height: height,
        child: Text(text, style: textStyle, textAlign: textAlign),
      ),
    );
  }

  static Widget shimmerList(
    BuildContext context, {
    int itemCount = 5,
    required Widget Function(BuildContext, int) itemBuilder,
    required double height,
    double? width,
    EdgeInsets padding = EdgeInsets.zero,
    Axis scrollDirection = Axis.horizontal,
    bool shrinkWrap = true,
    ScrollPhysics? physics,
  }) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      child: ListView.builder(
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder(context, index),
      ),
    );
  }

  static Widget shimmerCircle(
    BuildContext context, {
    required double radius,
    Color? baseColor,
    BoxBorder? border,
    EdgeInsets? padding,
  }) {
    final effectiveColor = _getBaseColor(context, baseColor);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Shimmer.fromColors(
        baseColor: effectiveColor,
        highlightColor: _highlightColor,
        child: Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: effectiveColor,
            border: border,
          ),
        ),
      ),
    );
  }
}
