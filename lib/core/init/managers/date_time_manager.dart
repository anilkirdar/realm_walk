import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';

class DateTimeManager {
  static DateTimeManager? _instance;

  static DateTimeManager get instance {
    return _instance ??= DateTimeManager._init();
  }

  DateTimeManager._init();

  /// TODO: remove after version 1.9.0
  static String secondsToMinutesRanking(String seconds) {
    final int second = int.parse(seconds);

    if (second > 20 && second < 60) return '1';
    if (second >= 60) return (second / 60).floor().toString();
    return '0';
  }

  static String secondsToMinutesRankingInt(int seconds) {
    if (seconds > 20 && seconds < 60) return '1';
    if (seconds >= 60) return (seconds / 60).floor().toString();
    return '0';
  }

  String intToString(int seconds) {
    int hours = seconds ~/ 60;
    int minutes = seconds % 60;
    String minutesResult = minutes <= 9 ? '0$minutes' : '$minutes';
    String hoursResult = hours <= 9 ? '0$hours' : '$hours';
    return '$hoursResult:$minutesResult';
  }

  String intToMinuteWithoutSeconds(int seconds) {
    int hours = seconds ~/ 60;
    int minutes = seconds % 60;
    String minutesResult = '$minutes';
    String hoursResult = '$hours';
    return minutesResult == '0' ? hoursResult : '$hoursResult:$minutesResult';
  }

  int getTodayDateFromZeroHour(DateTime dateTimeNow) {
    final int dateTimeAtZeroHour =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 0, 0, 0)
            .millisecondsSinceEpoch;
    return dateTimeAtZeroHour;
  }

  int getDateFromZeroHour(int date) {
    final DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(date);
    final int dateTimeAtZeroHour =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 0, 0, 0)
            .millisecondsSinceEpoch;
    return dateTimeAtZeroHour;
  }

  int getYesterdayDateFromZeroHour() {
    final DateTime dateTimeNow = DateTime.now();
    final int dateTimeAtZeroHour = DateTime(
            dateTimeNow.year, dateTimeNow.month, dateTimeNow.day - 1, 0, 0, 0)
        .millisecondsSinceEpoch;
    return dateTimeAtZeroHour;
  }

  Future<String> getTimeZone() async {
    return await FlutterTimezone.getLocalTimezone();
  }

  String getFormattedDateFromFormattedString(
      {required String? value,
      String desiredFormat = 'yMMMd',
      String? locale}) {
    ///one of the possible formats: yyyy MMMM dd, kk:mm
    DateTime? dateTime = DateTime.now();

    String formattedDate = '';
    if (value == null || value.isEmpty) {
      return formattedDate;
    }
    try {
      dateTime = DateTime.parse(value).toLocal();
      formattedDate =
          DateFormat(desiredFormat, locale ?? 'en_US').format(dateTime);
      // final newFormattedDate = DateTime.fromMillisecondsSinceEpoch(dateTimeInt).toUtc().toString();
      //     formattedDate = newFormattedDate;
      //  print('dateTimeInt: $dateTimeInt');
      //  print('newFormattedDate: $newFormattedDate');
    } catch (e) {
      print(e);
      return '';
    }
    return formattedDate;
  }

  int? getSinceEpochFromFormattedString(String? value) {
    if (value == null) return null;

    final DateTime parsedTime = DateTime.parse(value);
    return parsedTime.millisecondsSinceEpoch;
  }

  DateTime? getDateTimeFromFormattedString(String? value) {
    if (value == null) return null;

    return DateTime.parse(value);
  }

  int? getDateFromZeroHourFromFormattedString(String? value) {
    if (value == null) return null;

    final DateTime dateTimeNow = DateTime.parse(value);

    final int dateTimeAtZeroHour =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 0, 0, 0)
            .millisecondsSinceEpoch;
    return dateTimeAtZeroHour;
  }

  Duration getDurationForCron(TimeOfDay timeOfRequiredShedule) {
    /// create a duration until the next specified time of day
    final now = DateTime.now();

    DateTime scheduledTime = DateTime(now.year, now.month, now.day,
        timeOfRequiredShedule.hour, timeOfRequiredShedule.minute);

    /// Get difference between now and scheduledTime
    Duration duration = scheduledTime.difference(now);

    /// If duration is negative, it means that the time has passed scheduledTime
    /// In this situation it will add one day and set a new scheduledTime and
    /// set the difference between a new scheduledTime and now
    if (duration.isNegative) {
      int scheduledTimeInt = scheduledTime.millisecondsSinceEpoch;

      const int oneDayInt = 24 * 60 * 60 * 1000;

      scheduledTimeInt = scheduledTimeInt + oneDayInt;

      scheduledTime = DateTime.fromMillisecondsSinceEpoch(scheduledTimeInt);

      duration = scheduledTime.difference(now);
    }

    return duration;
  }

  DateTime? _parseDateTime(String? dateTimeString) {
    try {
      if (dateTimeString == null || dateTimeString.isEmpty) return null;

      DateTime parsedDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateTimeString);

      Duration timeZoneOffset = parsedDateTime.toLocal().timeZoneOffset;

      // parsedDateTime.add(Duration(hours: timeZoneOffset.inHours));
      DateTime utcDateTime = DateTime.fromMillisecondsSinceEpoch(
          parsedDateTime.millisecondsSinceEpoch +
              timeZoneOffset.inMilliseconds);
      return utcDateTime;
    } catch (e) {
      return null;
    }
  }

  String notificationTime(String? dateTimeString) {
    final DateTime? dateTime = _parseDateTime(dateTimeString);

    if (dateTime == null) return 'a while ago';

    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      final formatter = DateFormat('MMM d, yyyy');
      return formatter.format(dateTime);
    } else if (difference.inDays >= 1) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours >= 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes >= 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inSeconds >= 1) {
      final seconds = difference.inSeconds;
      return '$seconds ${seconds == 1 ? 'second' : 'seconds'} ago';
    } else {
      return 'Just now';
    }
  }

  void testTime() async {
    // DateTime now = DateTime.now();
    // print(now.timeZoneName);
    // print(now.timeZoneOffset);
    // print(
    //     'now.timeZoneOffset:${now.timeZoneOffset.inHours}, ${now.timeZoneOffset.inMinutes}');
    // print(now.timeZoneOffset.isNegative);
    // print(now.isUtc);
    // print(now.toLocal());
    // List<String> _availableTimezones =
    //     await FlutterNativeTimezone.getAvailableTimezones();
    // print('response: ${now.toIso8601String()}${now.timeZoneName}');
    // print(_availableTimezones);
  }
}
