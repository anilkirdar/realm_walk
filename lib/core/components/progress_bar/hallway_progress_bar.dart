import 'dart:math';

import 'package:flutter/material.dart';

class HallwayProgressBar extends StatelessWidget {
  final double minValue, maxValue, value;
  final Color inactiveColor, activeColor;

  const HallwayProgressBar(
      {super.key,
      required this.minValue,
      required this.maxValue,
      required this.value,
      required this.activeColor,
      required this.inactiveColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 14,
      child: CustomPaint(
        painter: ProgressBarPainter(
            minValue: minValue,
            maxValue: maxValue,
            value: value,
            activeColor: activeColor,
            inactiveColor: inactiveColor),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double minValue, maxValue, value;
  final Color inactiveColor, activeColor;

  ProgressBarPainter(
      {required this.minValue,
      required this.maxValue,
      required this.value,
      required this.activeColor,
      required this.inactiveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Background Line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint..color = Colors.white,
    );

    // Progress Line
    final progressWidth =
        (value - minValue) / (maxValue - minValue) * size.width;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(min(progressWidth, size.width), size.height / 2),
      paint..color = activeColor,
    );

    // Circular Indicator
    const circularRadius = 6.0;
    final circularX = min(progressWidth, size.width);
    canvas.drawCircle(Offset(circularX, size.height / 2), circularRadius,
        paint..color = inactiveColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
