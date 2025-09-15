import 'package:flutter/material.dart';

class TabbarItem {
  final int index;
  final String text;
  final Widget child;
  final Function? onPres;
  final int? indicator;

  TabbarItem(
      {required this.index,
      required this.text,
      required this.child,
      this.onPres,
      this.indicator});
}
