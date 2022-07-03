import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwatch/app/widgets/stopwatch/lap_cards.dart';

typedef StopWatchTime = Duration;

class StopWatchContext extends ChangeNotifier {
  final GlobalKey<AnimatedListState> _globalKey =
      GlobalKey<AnimatedListState>();
  final List<StopWatchTime> _laps = [];

  GlobalKey<AnimatedListState> get key => _globalKey;

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
    for (Duration lap in _laps) {
      if (_globalKey.currentState != null) {
        _globalKey.currentState!.removeItem(0, (context, animation) {
          final Tween<Offset> _offset = Tween<Offset>(
              begin: const Offset(0, -1), end: const Offset(0, 0));
          final Tween<double> _opacity = Tween<double>(begin: 0, end: 1);
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
        });
      }
    }
    _laps.clear();
    notifyListeners();
  }

  void _addlaps(StopWatchTime newTime) {
    _lapEvent = false;
    _laps.add(newTime);
    if (_globalKey.currentState != null) {
      _globalKey.currentState!.insertItem(_laps.indexOf(newTime));
    }
    notifyListeners();
  }

  void removeLap(int index) {
    if (_globalKey.currentState != null) {
      _globalKey.currentState!.removeItem(index, (context, animation) {
        final Tween<Offset> _offset =
            Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0));
        final Tween<double> _opacity = Tween<double>(begin: 0, end: 1);
        return SlideTransition(
          position: animation.drive(_offset),
          child: FadeTransition(
              opacity: animation.drive(_opacity),
              child: StopWatchLapsCard(
                lapNumber: index,
                time: const Duration(),
              )),
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
    _watchIsInPauseMode = !_watchIsInPauseMode;
    notifyListeners();
  }
}
