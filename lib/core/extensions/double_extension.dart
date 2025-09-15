import 'dart:math';

extension Round on double {
  double roundToPrecision(int n) {
    int fac = pow(10, n).toInt();
    return (this * fac).round() / fac;
  }

  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
}
