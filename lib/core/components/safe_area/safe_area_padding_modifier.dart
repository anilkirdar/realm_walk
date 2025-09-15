import 'package:flutter/material.dart';

class SafeAreaPaddingModifier extends StatelessWidget {
  const SafeAreaPaddingModifier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final EdgeInsets padding = mediaQuery.padding;

    // Add 12 pixels to the top padding
    final EdgeInsets newPadding = padding.copyWith(
      top: padding.top + 12,
    );

    return MediaQuery(
      data: mediaQuery.copyWith(padding: newPadding),
      child: child,
    );
  }
}
