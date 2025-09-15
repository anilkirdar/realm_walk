import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../init/notifier/theme_notifier.dart';
import '../adaptive_widgets/adaptive_circular_indicator.dart';

class SvgPictureAsset extends StatelessWidget {
  const SvgPictureAsset({
    super.key,
    required this.asset,
    this.color,
    this.height,
    this.width,
    this.shouldSetColor = true,
  });
  final String asset;
  final double? height, width;
  final Color? color;
  final bool shouldSetColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      colorFilter: shouldSetColor
          ? ColorFilter.mode(
              color ?? context.theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            )
          : null,
      height: height,
      width: width,
    );
  }
}

class SvgPictureNetwork extends StatelessWidget {
  const SvgPictureNetwork({
    super.key,
    required this.url,
    this.color,
    this.height,
    this.width,
    this.shouldSetColor = true,
  });
  final String url;
  final double? height, width;
  final Color? color;
  final bool shouldSetColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      colorFilter: shouldSetColor
          ? ColorFilter.mode(
              color ?? context.theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            )
          : null,
      height: height,
      width: width,
      placeholderBuilder: (context) {
        return Center(
          child: AdaptiveCPI(
            backgroundColor:
                Provider.of<ThemeNotifier>(context).getCustomTheme.blackToWhite,
          ),
        );
      },
    );
  }
}

class SvgPictureString extends StatelessWidget {
  const SvgPictureString({
    super.key,
    required this.asset,
    this.color,
    this.height,
    this.width,
    this.shouldSetColor = true,
  });
  final String asset;
  final double? height, width;
  final Color? color;
  final bool shouldSetColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      asset.startsWith('string://') ? asset.substring(8) : asset,
      colorFilter: shouldSetColor
          ? ColorFilter.mode(
              color ?? context.theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            )
          : null,
      height: height,
      width: width,
      placeholderBuilder: (context) {
        return Center(
          child: AdaptiveCPI(
            backgroundColor:
                Provider.of<ThemeNotifier>(context).getCustomTheme.blackToWhite,
          ),
        );
      },
    );
  }
}
