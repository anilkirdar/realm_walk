extension NumberExtention on int {
  String calculateMinAndHour(
      String shortHour,
      String shortMinute
      ) {
    int value = this;
    int minute = value ~/ 60;
    if (minute < 60) {
      return "$minute$shortMinute";
    } else {
      int hour = minute ~/ 60;
      int percent = minute % 60;
      minute = value - (hour * minute);
      return "$hour$shortHour $percent$shortMinute";
    }
  }
}
