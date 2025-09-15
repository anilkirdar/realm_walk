import 'package:flutter/material.dart';

import '../../constants/utils/ui_constants/radius_const.dart';
import '../../extensions/context_extension.dart';
import '../../init/theme/app_color_scheme.dart';

class AdaptiveGradientButton extends StatelessWidget {
  const AdaptiveGradientButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius,
    this.height = 72,
    this.gradient,
    this.buttonShadow,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final BorderRadius? borderRadius;
  final double height;
  final Gradient? gradient;
  final List<BoxShadow>? buttonShadow;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? RadiusConst.circular100;

    return Container(
      width: context.width * 2 / 3,
      height: height,
      decoration: BoxDecoration(
        gradient:
            gradient ??
            LinearGradient(
              colors: [
                AppColorScheme.instance.primary,
                AppColorScheme.instance.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: radius,
        boxShadow:
            buttonShadow ??
            [
              BoxShadow(
                color: AppColorScheme.instance.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: radius),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: child,
      ),
    );
  }
}
