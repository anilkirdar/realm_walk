import 'package:flutter/material.dart';

import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/theme/app_color_scheme.dart';
import '../icons/svg_icon.dart';

class CircularAnimatedWidget extends StatefulWidget {
  const CircularAnimatedWidget({
    super.key,
    required this.assetPath,
    this.endHeight = 160,
    this.marginValue = 85,
    this.beginHeight = 130,
    this.containerHeight = 104,
    this.iconSize = 57,
    this.backgroundColor,
    this.shadowColor,
  });

  final String assetPath;
  final double endHeight, beginHeight, marginValue, containerHeight, iconSize;
  final Color? backgroundColor;
  final Color? shadowColor;

  @override
  State<CircularAnimatedWidget> createState() => _CircularAnimatedWidgetState();
}

class _CircularAnimatedWidgetState extends State<CircularAnimatedWidget>
    with SingleTickerProviderStateMixin {
  final double heightFactor = SizeConst.heightFactor;
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(
            begin: widget.beginHeight * heightFactor,
            end: widget.endHeight * heightFactor)
        .animate(controller)
      ..addStatusListener((status) {
        if (mounted) {
          if (status == AnimationStatus.completed) {
            controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            controller.forward();
          }
        }
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Container(
            height: animation.value,
            width: animation.value,
            decoration: BoxDecoration(
              color: widget.shadowColor ??
                  AppColorScheme.instance.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(animation.value),
            ),
            child: Center(
              child: Container(
                height: widget.containerHeight * heightFactor,
                width: widget.containerHeight * heightFactor,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      widget.backgroundColor ?? AppColorScheme.instance.primary,
                ),
                child: Center(
                  child: SvgPictureAsset(
                    asset: widget.assetPath,
                    height: widget.iconSize * heightFactor,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
