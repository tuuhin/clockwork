import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/context.dart';
import '../widgets/app_widgets.dart';
import '../widgets/stopwatch/stopwatch_clock.dart';

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({Key? key}) : super(key: key);

  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late StopWatchContext _stopWatchContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stopWatchContext = Provider.of<StopWatchContext>(context);
    if (_stopWatchContext.isStopWatchRunning) {
      _animationController.forward();

      _animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
  }

  void _onStartTap() {
    if (!_stopWatchContext.isStopWatchRunning) {
      _animationController.repeat();
      _stopWatchContext.startTheWatch();
    }

    _stopWatchContext.toggleTheWatch();
    // _animationController.stop();
  }

  void _onReset() {
    if (!_stopWatchContext.isWatchTicking) {
      _animationController.stop();
      return _stopWatchContext.stopTheWatch();
    }
    _stopWatchContext.createALap();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          StopWatchClock(
            controller: _animationController,
          ),
          const StopWatchLaps(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width * .45, 50),
                  ),
                  onPressed: _onStartTap,
                  child: Text(
                    !_stopWatchContext.isWatchTicking ? 'START' : 'PAUSE',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.white),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width * .45, 50),
                ),
                onPressed:
                    _stopWatchContext.isStopWatchRunning ? _onReset : null,
                child: Text(
                  !_stopWatchContext.isWatchTicking ? 'RESET' : 'LAP',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: !_stopWatchContext.isStopWatchRunning
                            ? Colors.black
                            : Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
