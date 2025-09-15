import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({super.key, required this.svg, required this.onTap, this.color});
  final String svg;
  final void Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: const Alignment(0.02, 0.04),
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.grey, width: 0.3),
        ),
        child: SvgPicture.asset(
          color: color,
          // Vector
          svg,
          width: 18.62,
          height: 22.92,
        ),
      ),
    );
  }
}
