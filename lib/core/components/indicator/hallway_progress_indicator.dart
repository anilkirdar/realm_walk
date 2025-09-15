import 'package:flutter/material.dart';

import '../../constants/app/app_const.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/string_extension.dart';
import '../../init/managers/date_time_manager.dart';
import '../progress_bar/hallway_progress_bar.dart';

class HallwaySliderProgressIndicator extends StatelessWidget {
  const HallwaySliderProgressIndicator({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.thumbColor,
    required this.inactiveColor,
    required this.activeColor,
    this.isValueInMinutes = false,
    this.overrideValue,
  }) : assert(min <= max, "Min can't be higher than Max"),
       assert(min <= value, "Value can't be less than Min");
  final int min, max, value;
  final Color thumbColor, inactiveColor, activeColor;
  final bool isValueInMinutes;
  final Widget? overrideValue;

  @override
  Widget build(BuildContext context) {
    final DateTimeManager dateTimeManager = DateTimeManager.instance;
    int parsedValue = value;
    int maxValue = max;
    String valueInMinutesSeconds = '00:00';

    if (isValueInMinutes) {
      valueInMinutesSeconds = dateTimeManager.intToString(max - value);
    }
    if (value >= max) {
      parsedValue = max;
    }
    if (maxValue <= 0) {
      maxValue = 1;
    }
    const TextStyle valueStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      fontFamily: AppConst.poppins,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 14,
            width: double.maxFinite,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: HallwayProgressBar(
                    maxValue: maxValue.toDouble(),
                    minValue: min.toDouble(),
                    value: parsedValue.toDouble(),
                    activeColor: activeColor,
                    inactiveColor: activeColor,
                  ),
                ),
                Positioned(
                  left: -0.1,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: inactiveColor,
                    child: CircleAvatar(
                      backgroundColor: activeColor,
                      radius: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 2.0,
            left: context.sLanguageCode.isRTL ? 0 : 4,
            right: context.sLanguageCode.isRTL ? 4 : 0,
          ),
          child: Center(
            child:
                overrideValue != null
                    ? overrideValue!
                    : Text(
                      (isValueInMinutes ? valueInMinutesSeconds : '$value '),
                      style: valueStyle,
                      textAlign: TextAlign.center,
                    ),
          ),
        ),
      ],
    );
  }
}
