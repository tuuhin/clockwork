import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/utils.dart';
import 'package:vector_math/vector_math.dart' show radians;

class StopWatchClock extends StatefulWidget {
  final AnimationController controller;
  const StopWatchClock({Key? key, required this.controller}) : super(key: key);

  @override
  State<StopWatchClock> createState() => _StopWatchClockState();
}

class _StopWatchClockState extends State<StopWatchClock>
    with SingleTickerProviderStateMixin {
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();

    _rotate = Tween<double>(
      begin: 0.0,
      end: 360,
    ).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final StopWatchTime _time = Provider.of<StopWatchTime>(context);
    Color _shadowColor = const Color.fromARGB(255, 231, 231, 231);
    return Container(
      height: _size.height * 0.4,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: _size.width * .6,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: _shadowColor,
                        offset: const Offset(0, 0),
                        blurRadius: 40,
                        spreadRadius: 2)
                  ]),
            ),
          ),
          AnimatedBuilder(
              animation: widget.controller,
              builder: (context, animation) {
                return Transform.rotate(
                  angle: radians(_rotate.value),
                  child: SizedBox.square(
                    dimension: _size.width * 0.58,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: CustomPaint(
                        painter: StopWatchPainter(),
                      ),
                    ),
                  ),
                );
              }),
          SizedBox.square(
            dimension: _size.width * .48,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                  BoxShadow(
                    color: _shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ])),
          ),
          SizedBox.square(
            dimension: _size.width * .4,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                  BoxShadow(
                    color: _shadowColor,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ])),
          ),
          SizedBox.square(
            dimension: _size.width * .35,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                  BoxShadow(
                    color: _shadowColor,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ])),
          ),
          Text(
            stopWatchFormat(_time),
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'Technology',
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
