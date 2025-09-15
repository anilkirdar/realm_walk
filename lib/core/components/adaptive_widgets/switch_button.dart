import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../init/config/config.dart';

class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch(
      {super.key,
      this.onChanged,
      required this.value,
      this.activeColor,
      this.activeTrackColor,
      this.inactiveTrackColor,
      this.trackColor});
  final Function(bool)? onChanged;
  final bool value;
  final Color? activeColor, activeTrackColor, inactiveTrackColor, trackColor;

  @override
  Widget build(BuildContext context) {
    return Config.instance.isAndroid
        ? Switch(
            onChanged: onChanged,
            value: value,
            activeColor: activeColor,
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: inactiveTrackColor,
          )
        : CupertinoSwitch(
            onChanged: onChanged,
            value: value,
            activeColor: activeTrackColor,
            trackColor: inactiveTrackColor,
          );
  }
}
