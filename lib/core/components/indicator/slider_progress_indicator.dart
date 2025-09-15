import 'package:flutter/material.dart';

import '../../constants/utils/ui_constants/sized_box_const.dart';
import '../../init/managers/date_time_manager.dart';

class SliderProgressIndicator extends StatelessWidget {
  const SliderProgressIndicator(
      {super.key,
      required this.min,
      required this.max,
      required this.value,
      required this.thumbColor,
      required this.inactiveColor,
      required this.activeColor,
      this.isValueInMinutes = false})
      : assert(min <= max, "Min can't be higher than Max"),
        assert(min <= value, "Value can't be less than Min");
  final int min, max, value;
  final Color thumbColor, inactiveColor, activeColor;
  final bool isValueInMinutes;

  @override
  Widget build(BuildContext context) {
    final DateTimeManager dateTimeManager = DateTimeManager.instance;
    int parsedValue = value;
    int maxValue = max;
    String valueInMinutesSeconds = '00:00';
    String maxString = '$max';

    if (isValueInMinutes) {
      valueInMinutesSeconds = dateTimeManager.intToString(value);
      maxString = '${(maxValue / 60).round()}';
    }
    if (value >= max) {
      parsedValue = max;
    }
    if (maxValue <= 0) {
      maxValue = 1;
    }
    const TextStyle valueStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );
    const TextStyle rangeStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  '$min',
                  style: rangeStyle,
                ),
                Expanded(
                    child: Text(
                  isValueInMinutes ? valueInMinutesSeconds : '$value',
                  style: valueStyle,
                  textAlign: TextAlign.center,
                )),
                SizedBox(
                  width: 30,
                  child: Text(
                    maxString,
                    style: rangeStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBoxConst.width2
              ],
            ),
            SizedBox(
              height: 14,
              child: Stack(
                children: [
                  Positioned(
                    top: 3.5,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 5.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: inactiveColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4.5,
                    left: 1,
                    right: (maxValue - parsedValue) /
                        maxValue *
                        (constraints.maxWidth),
                    child: Container(
                      height: 3.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1,
                    right: (maxValue - parsedValue) /
                        maxValue *
                        (constraints.maxWidth),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: activeColor,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: CircleAvatar(
                        radius: 7,
                        backgroundColor: inactiveColor,
                        child: CircleAvatar(
                            backgroundColor: activeColor, radius: 6)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
