import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwatch/app/widgets/stopwatch/lap_cards.dart';

typedef CurrentStopWatchTime = Duration;

class StopWatchContext extends ChangeNotifier {
  final Tween<Offset> _offset =
      Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0));
  final Tween<double> _opacity = Tween<double>(begin: 0, end: 1);
  final GlobalKey<AnimatedListState> _globalKey =
      GlobalKey<AnimatedListState>();
  final List<CurrentStopWatchTime> _laps = [];

  GlobalKey<AnimatedListState> get key => _globalKey;

  List<CurrentStopWatchTime> get laps => _laps;

  bool _isStopWatchRunning = false;

  bool _lapEvent = false;

  bool _watchIsPaused = true;

  bool get isStopWatchRunning => _isStopWatchRunning;
  bool get isWatchTicking => !_watchIsPaused;

  Duration _duration = const Duration();

  Stream<CurrentStopWatchTime>? get getStopWatch =>
      Stream.periodic(const Duration(milliseconds: 1000), (_) {
        if (_isStopWatchRunning) {
          final int seconds = _duration.inSeconds + (!_watchIsPaused ? 1 : 0);
          _duration = CurrentStopWatchTime(seconds: seconds);

          if (_lapEvent) {
            _addlaps(_duration);
          }
          return _duration;
        }
        return const Duration();
      });

  void stopTheWatch() {
    _isStopWatchRunning = false;
    _duration = const Duration();
    for (Duration lap in _laps) {
      if (_globalKey.currentState != null) {
        _globalKey.currentState!.removeItem(
          0,
          (context, animation) {
            return SlideTransition(
              position: animation.drive(_offset),
              child: FadeTransition(
                opacity: animation.drive(_opacity),
                child: StopWatchLapsCard(
                  lapNumber: _laps.indexOf(lap),
                  time: const Duration(),
                ),
              ),
            );
          },
        );
      }
    }
    _laps.clear();
    notifyListeners();
  }

  void _addlaps(CurrentStopWatchTime lap) {
    _lapEvent = false;
    _laps.add(lap);
    if (_globalKey.currentState != null) {
      _globalKey.currentState!.insertItem(_laps.indexOf(lap));
    }
    notifyListeners();
  }

  void removeLap(int index) {
    if (_globalKey.currentState != null) {
      _globalKey.currentState!.removeItem(index, (context, animation) {
        return SlideTransition(
          position: animation.drive(_offset),
          child: FadeTransition(
            opacity: animation.drive(_opacity),
            child: StopWatchLapsCard(
              lapNumber: index,
              time: const Duration(),
            ),
          ),
        );
      });
    }
    _laps.removeAt(index);
    notifyListeners();
  }

  void startTheWatch() {
    _isStopWatchRunning = true;
    // _watchIsInPauseMode = true;
    notifyListeners();
  }

  void createALap() => _lapEvent = true;

  void toggleTheWatch() {
    _watchIsPaused = !_watchIsPaused;
    notifyListeners();
  }
}
