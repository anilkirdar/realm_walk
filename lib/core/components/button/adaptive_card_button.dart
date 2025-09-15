import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/context_extension.dart';
import '../../init/notifier/theme_notifier.dart';
import 'adaptive_elevated_button.dart';

class AdaptiveCardButton extends StatelessWidget {
  const AdaptiveCardButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius,
    this.boxShadow,
    this.height,
  });
  final Widget child;
  final void Function() onPressed;
  final double? borderRadius, height;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          color:
              Provider.of<ThemeNotifier>(context).getCustomTheme.whiteToBeige,
          boxShadow: boxShadow ??
              [
                BoxShadow(
                    color: context.theme.shadowColor,
                    offset: const Offset(0.0, 3.0),
                    blurRadius: 6.0)
              ]),
      child: AdaptiveButton(
        height: height,
        backgroundColor: Colors.white,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
