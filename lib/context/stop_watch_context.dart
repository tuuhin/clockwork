import 'dart:async';
import 'package:flutter/material.dart';

typedef StopWatchTime = Duration;

class StopWatchContext extends ChangeNotifier {
  bool _isStopWatchRunning = false;

  bool _pauseTheWatch = false;

  Stream<StopWatchTime>? _stream;

  bool get isStopWatchRunning => _isStopWatchRunning;

  Duration _duration = const Duration();

  Stream<StopWatchTime>? getStopWatch() {
    _stream =
        Stream.periodic(const Duration(milliseconds: 100), (computationCount) {
      if (_isStopWatchRunning) {
        final int seconds = _duration.inSeconds + (!_pauseTheWatch ? 1 : 0);
        _duration = StopWatchTime(seconds: seconds);
        return _duration;
      }
      return const StopWatchTime();
    });
    return _stream;
  }

  void startTheWatch() => _isStopWatchRunning = true;

  void stopTheWatch() {
    _isStopWatchRunning = false;
    _duration = const StopWatchTime();
  }

  void pauseTheWatch() => _pauseTheWatch = true;
}
