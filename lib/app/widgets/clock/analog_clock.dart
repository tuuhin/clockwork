import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/clock/clock_painter.dart';
import 'package:stopwatch/context/context.dart';
import 'package:vector_math/vector_math.dart' show radians;

class AnalogClock extends StatefulWidget {
  const AnalogClock({Key? key}) : super(key: key);

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    _rotation =
        Tween<double>(begin: 0.0, end: 360).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final ClockTime _clck = Provider.of<ClockTime>(context);
    return SizedBox(
      height: _size.height * 0.35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: _size.width * .6,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2, 2),
                        blurRadius: 2,
                        spreadRadius: .1)
                  ]),
            ),
          ),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, animation) {
                return Transform.rotate(
                  angle: radians(_rotation.value),
                  child: SizedBox.square(
                    dimension: _size.width * 0.56,
                    child: CustomPaint(
                      painter: ClockPainterDial(),
                    ),
                  ),
                );
              }),
          SizedBox.square(
              dimension: _size.width * 0.45,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 0),
                        blurRadius: 1,
                        spreadRadius: .1),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: .1)
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )),
          SizedBox.square(
            dimension: _size.width * 0.4,
            child: CustomPaint(
              painter: ClockMainPainter(
                current: _clck,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
