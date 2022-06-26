import 'dart:async';
import 'package:flutter/material.dart';

typedef StopWatchTime = Duration;

class StopWatchContext extends ChangeNotifier {
  final List<StopWatchTime> _laps = [];

  List<StopWatchTime> get laps => _laps;

  bool _isStopWatchRunning = false;

  bool _lapEvent = false;

  bool _watchIsInPauseMode = true;

  bool get isStopWatchRunning => _isStopWatchRunning;
  bool get isWatchTicking => !_watchIsInPauseMode;

  Duration _duration = const Duration();

  Stream<StopWatchTime>? get getStopWatch =>
      Stream.periodic(const Duration(milliseconds: 1000), (_) {
        if (_isStopWatchRunning) {
          final int seconds =
              _duration.inSeconds + (!_watchIsInPauseMode ? 1 : 0);
          _duration = StopWatchTime(seconds: seconds);

          if (_lapEvent) {
            _addlaps(_duration);
          }
          return _duration;
        }
        return const StopWatchTime();
      });

  void stopTheWatch() {
    _isStopWatchRunning = false;
    _duration = const StopWatchTime();
    notifyListeners();
  }

  void _addlaps(StopWatchTime newTime) {
    _lapEvent = false;

    _laps.add(newTime);
    notifyListeners();
  }

  void removeLap(int lapIndex) {
    _laps.removeAt(lapIndex);
    notifyListeners();
  }

  void startTheWatch() {
    _isStopWatchRunning = true;
    // _watchIsInPauseMode = true;
    notifyListeners();
  }

  void createALap() => _lapEvent = true;

  void toggleTheWatch() {
    _watchIsInPauseMode = !_watchIsInPauseMode;
    notifyListeners();
  }
}
