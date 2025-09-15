import 'package:flutter/material.dart';

class IndicatorListView extends StatelessWidget {
  static const double _defaultSize = 8.0;

  const IndicatorListView({
    super.key,
    this.itemCount,
    this.onListItem,
    this.currentIndex,
    this.circleRadius,
    required this.dotColor,
    required this.selectedDotColor,
    this.size = _defaultSize,
    required this.selectedSize,
    required this.dotSpacing,
    this.borderWidth = 0,
    this.borderColor = Colors.grey,
    this.selectedBorderColor,
  });
  final int? itemCount, currentIndex;

  final double? circleRadius;

  final Widget Function(int index)? onListItem;

  ///The dot color
  final Color dotColor;

  ///The selected dot color
  final Color selectedDotColor;

  ///The normal dot size
  final double size;

  ///The selected dot size
  final double selectedSize;

  ///The space between dots
  final double dotSpacing;

  ///The border width of the indicator
  final double borderWidth;

  ///The borderColor is set to dotColor if not set
  final Color borderColor;

  ///The selectedBorderColor is set to selectedDotColor if not set
  final Color? selectedBorderColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      shrinkWrap: true,
      itemBuilder: buildPadding,
    );
  }

  Padding buildPadding(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: buildCircleAvatar(index, context),
    );
  }

  Widget buildCircleAvatar(int index, BuildContext context) {
    Color color = dotColor;
    if (index == currentIndex) {
      color = selectedDotColor;
    }
    return SizedBox(
      width: size + dotSpacing,
      child: Material(
        color: borderWidth > 0 ? borderColor : color,
        type: MaterialType.circle,
        child: AnimatedOpacity(
          opacity: opacityValue(index),
          duration: const Duration(seconds: 1),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Material(
                type: MaterialType.circle,
                color: color,
                child: Container(
                  width: size - borderWidth,
                  height: size - borderWidth,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double opacityValue(int index) => isCurrentIndex(index) ? 1 : 0.8;

  bool isCurrentIndex(int index) => currentIndex == index;
}
