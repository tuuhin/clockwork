import 'package:flutter/cupertino.dart';

String _twoDigits(int n) => n.toString().padLeft(2, '0');

String stopWatchFormat(Duration time) {
  String _timeHour = _twoDigits(time.inHours.remainder(60));
  String _timeMinutes = _twoDigits(time.inMinutes.remainder(60));
  String _timeSeconds = _twoDigits(time.inSeconds.remainder(60));
  return '$_timeHour:$_timeMinutes:$_timeSeconds';
}

String clockFormat(DateTime dateTime) {
  String _timeHour = _twoDigits(dateTime.hour);
  String _timeMinutes = _twoDigits(dateTime.minute);
  String _timeSeconds = _twoDigits(dateTime.second);
  return '$_timeHour:$_timeMinutes:$_timeSeconds';
}

String getTimeFromOffset(int offset) {
  DateTime time = DateTime.now()
      .subtract(const Duration(seconds: 19800))
      .add(Duration(seconds: offset));
  return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
}

DateTime getime(offset) => DateTime.now()
    .subtract(const Duration(seconds: 19800))
    .add(Duration(seconds: offset));
