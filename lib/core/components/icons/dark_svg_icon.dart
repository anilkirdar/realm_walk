import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../init/notifier/theme_notifier.dart';

class DarkSvgPictureAsset extends StatelessWidget {
  const DarkSvgPictureAsset({
    super.key,
    required this.asset,
    this.color,
    this.height,
    this.width,
    this.shouldSetColor = true,
  });
  final Future<String> asset;
  final double? height, width;
  final Color? color;
  final bool shouldSetColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: asset,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            Provider.of<ThemeNotifier>(context).isDark
                ? snapshot.data!
                    .replaceAll("#6862c7", "#c6cedd")
                    .replaceAll("#6862C7", "#C6CEDD")
                    .replaceAll("#6962cf", "#C6CEDD")
                    .replaceAll("#6962CF", "#C6CEDD")
                    .replaceAll("#413E69", "#FFFFFF")
                    .replaceAll("#FFFFFF", "#413E69")
                : snapshot.data!,
            width: width,
            height: height,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
