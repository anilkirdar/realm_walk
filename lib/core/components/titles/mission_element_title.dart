import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/context_extension.dart';
import '../../init/notifier/theme_notifier.dart';

class MissionElementTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const MissionElementTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const SizedBox(height: 15),
        Center(child: Text(title, style: context.textTheme.headlineSmall)),
        Center(
          child: Text(
            subtitle,
            style: context.textTheme.labelLarge!.copyWith(
              color:
                  Provider.of<ThemeNotifier>(
                    context,
                  ).getCustomTheme.purpleToLightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
