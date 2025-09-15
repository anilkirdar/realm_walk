extension DateExtension on DateTime {
  String? toFormattedString() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year;

    return '$day/$month/$year';
  }
}
