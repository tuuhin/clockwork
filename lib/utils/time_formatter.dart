String _twoDigits(int n) => n.toString().padLeft(2, '0');

String stopWatchFormat(Duration time) {
  final String timeMinutes = _twoDigits(time.inMinutes.remainder(60));
  final String timeSeconds = _twoDigits(time.inSeconds.remainder(60));
  if (time.inHours > 0) {
    final String timeHour = _twoDigits(time.inHours.remainder(60));

    return '$timeHour:$timeMinutes:$timeSeconds';
  }

  return '$timeMinutes:$timeSeconds';
}

String alarmFormat(DateTime dateTime) {
  final String timeHour = _twoDigits(dateTime.hour);
  final String timeMinutes = _twoDigits(dateTime.minute);
  return '$timeHour : $timeMinutes';
}

String clockFormat(DateTime dateTime) {
  final String timeHour = _twoDigits(dateTime.hour);
  final String timeMinutes = _twoDigits(dateTime.minute);
  final String timeSeconds = _twoDigits(dateTime.second);
  return '$timeHour:$timeMinutes:$timeSeconds';
}

String getTimeFromOffset(int offset) {
  final DateTime time = DateTime.now()
      .subtract(const Duration(seconds: 19800))
      .add(Duration(seconds: offset));
  return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
}

DateTime getime(int offset) => DateTime.now()
    .subtract(const Duration(seconds: 19800))
    .add(Duration(seconds: offset));
