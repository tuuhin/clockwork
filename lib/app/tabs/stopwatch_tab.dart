import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/utils.dart' show clockFormat;
import 'package:vector_math/vector_math.dart' show radians;

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({Key? key}) : super(key: key);

  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> _rotate;

  late AnimationController _animationController;
  late StopWatchContext _stopWatchContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stopWatchContext = Provider.of<StopWatchContext>(context);
    if (_stopWatchContext.isStopWatchRunning) {
      _animationController.repeat();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _rotate = Tween<double>(
      begin: 0.0,
      end: 360,
    ).animate(_animationController);
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
    final Size _size = MediaQuery.of(context).size;
    final StopWatchTime _time = Provider.of<StopWatchTime>(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: _size.height * .45,
            // color: Colors.red,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.square(
                  dimension: _size.width * .67,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).cardColor,
                              offset: const Offset(-20, -20),
                              blurRadius: 20,
                              spreadRadius: 2),
                          BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color.fromARGB(255, 205, 205, 205)
                                  : Colors.grey,
                              offset: const Offset(20, 20),
                              blurRadius: 50,
                              spreadRadius: 2)
                        ]),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: radians(_rotate.value),
                      child: child,
                    );
                  },
                  child: SizedBox.square(
                    dimension: _size.width * 0.65,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).cardColor,
                              offset: const Offset(-10, -10),
                              blurRadius: 20,
                              spreadRadius: 2),
                          BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color.fromARGB(255, 221, 220, 220)
                                  : Theme.of(context).scaffoldBackgroundColor,
                              offset: const Offset(20, 20),
                              blurRadius: 50,
                              spreadRadius: 2)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: CustomPaint(
                          foregroundPainter: ClockPainer(
                            dialColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black87
                                    : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * .6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).cardColor,
                              offset: const Offset(-4, -4),
                              blurRadius: 20,
                              spreadRadius: 1),
                          BoxShadow(
                              color: Theme.of(context).cardColor,
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 1)
                        ]),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * .48,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(255, 226, 225, 225),
                              offset: Offset(-1, -1),
                              blurRadius: 20,
                              spreadRadius: 3),
                        ]),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * .35,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color.fromARGB(255, 234, 232, 232)
                                  : Colors.grey,
                              offset: Offset(0, 0),
                              blurRadius: 20,
                              spreadRadius: 1),
                        ]),
                  ),
                ),
                Text(
                  clockFormat(_time),
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Technology',
                      color: Colors.black),
                ),
                // for animating balls
                SizedBox.square(
                  dimension: _size.width * 0.65,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                  ),
                )
              ],
            ),
          ),
          const StopWatchLaps(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      elevation: 10,
                      fixedSize: const Size(150, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _onStartTap,
                    child: Text(
                      !_stopWatchContext.isWatchTicking ? 'START' : 'PAUSE',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.white, letterSpacing: 1.2),
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    elevation: 10,
                    fixedSize: const Size(150, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed:
                      _stopWatchContext.isStopWatchRunning ? _onReset : null,
                  child: Text(
                    !_stopWatchContext.isWatchTicking ? 'RESET' : 'LAP',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: !_stopWatchContext.isStopWatchRunning
                            ? Colors.black
                            : Colors.white,
                        letterSpacing: 1.2),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
