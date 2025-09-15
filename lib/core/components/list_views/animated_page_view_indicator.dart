import 'package:flutter/material.dart';

import '../../init/managers/button_feedback_manager.dart';

class AnimatedPageIndicator extends StatefulWidget {
  static const double _defaultSize = 8.0;
  static const double _defaultSelectedSize = 8.0;
  static const double _defaultSpacing = 8.0;
  static const Color _defaultDotColor = Color(0x509E9E9E);
  static const Color _defaultSelectedDotColor = Colors.grey;

  /// The current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int>? onPageSelected;

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

  AnimatedPageIndicator({
    super.key,
    required this.currentPageNotifier,
    required this.itemCount,
    this.borderColor = Colors.grey,
    this.onPageSelected,
    this.size = _defaultSize,
    this.dotSpacing = _defaultSpacing,
    Color? dotColor,
    Color? selectedDotColor,
    this.selectedSize = _defaultSelectedSize,
    this.borderWidth = 0,
    this.selectedBorderColor,
  })  : dotColor = dotColor ??
            ((selectedDotColor?.withAlpha(150)) ?? _defaultDotColor),
        selectedDotColor = selectedDotColor ?? _defaultSelectedDotColor,
        assert(borderWidth < size,
            'Border width cannot be bigger than dot size, duh!');

  @override
  AnimatedPageIndicatorState createState() {
    return AnimatedPageIndicatorState();
  }
}

class AnimatedPageIndicatorState extends State<AnimatedPageIndicator> {
  int _currentPageIndex = 0;
  late Color _borderColor;
  late Color _selectedBorderColor;

  @override
  void initState() {
    _readCurrentPageIndex();
    widget.currentPageNotifier.addListener(_handlePageIndex);
    _borderColor = widget.borderColor;
    _selectedBorderColor =
        widget.selectedBorderColor ?? widget.selectedDotColor;
    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_handlePageIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List<Widget>.generate(widget.itemCount, (int index) {
          double size = widget.size;
          Color color = widget.dotColor;
          Color? borderColor = _borderColor;
          if (isSelected(index)) {
            size = widget.selectedSize;
            color = widget.selectedDotColor;
            borderColor = _selectedBorderColor;
          }
          return GestureDetector(
            onTap: () {
              FeedbackManager.instance.provideHapticFeedback();
              widget.onPageSelected == null
                  ? null
                  : widget.onPageSelected!(index);
            },
            child: SizedBox(
              width: isSelected(index) ? size * 2 : size + widget.dotSpacing,
              child: Material(
                color: widget.borderWidth > 0
                    ? getColor(index, borderColor)
                    : getColor(index, color),
                type: MaterialType.circle,
                child: SizedBox(
                  width: isSelected(index) ? size * 2 : size,
                  height: size,
                  child: Center(
                    child: Material(
                      type: MaterialType.circle,
                      color: getColor(index, color),
                      child: Container(
                        margin: isSelected(index)
                            ? const EdgeInsets.symmetric(horizontal: 2)
                            : null,
                        width: (isSelected(index) ? size * 2 : size) -
                            widget.borderWidth,
                        height: size - widget.borderWidth,
                        decoration: BoxDecoration(
                            color: getColor(index, color),
                            // shape: BoxShape.circle,
                            border: Border.all(
                              color: getColor(index, borderColor),
                            ),
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  bool isSelected(int dotIndex) => _currentPageIndex == dotIndex;

  Color getColor(int dotIndex, Color color) {
    return _currentPageIndex == dotIndex ? color : color.withOpacity(0.1);
  }

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = widget.currentPageNotifier.value;
  }
}
