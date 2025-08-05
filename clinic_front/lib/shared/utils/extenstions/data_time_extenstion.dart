import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  String defaultString() {
    return DateFormat.yMMMd().format(this);
  }

  static DateTime? _customTime;

  static DateTime get current {
    return _customTime ?? DateTime.now();
  }

  String to12HourFormat() {
    return DateFormat('h:mm a').format(this);
  }

  String to24HourFormat() {
    return DateFormat('HH:mm').format(this);
  }

  @visibleForTesting
  static set customTime(DateTime? customTime) {
    _customTime = customTime;
  }
}
