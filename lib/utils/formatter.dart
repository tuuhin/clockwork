String _twoDigits(int n) => n.toString().padLeft(2, '0');

String clockFormat(Duration time) {
  String _timeHour = _twoDigits(time.inHours.remainder(60));
  String _timeMinutes = _twoDigits(time.inMinutes.remainder(60));
  String _timeSeconds = _twoDigits(time.inSeconds.remainder(60));
  return '$_timeHour:$_timeMinutes:$_timeSeconds';
}
