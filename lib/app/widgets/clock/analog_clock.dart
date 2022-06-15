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
    return Container(
      height: _size.height * 0.35,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: _size.width * .62,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    color: Theme.of(context).cardColor,
                    offset: const Offset(-20, -20),
                    blurRadius: 40,
                    spreadRadius: 2),
                const BoxShadow(
                    color: Color.fromARGB(255, 205, 205, 205),
                    offset: Offset(20, 20),
                    blurRadius: 40,
                    spreadRadius: 2)
              ]),
            ),
          ),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, animation) {
                return Transform.rotate(
                  angle: radians(_rotation.value),
                  child: SizedBox.square(
                    dimension: _size.width * 0.55,
                    child: CustomPaint(
                      painter: ClockPainterDial(color: Colors.grey),
                    ),
                  ),
                );
              }),
          SizedBox.square(
              dimension: _size.width * 0.5,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                ),
              )),
          SizedBox.square(
            dimension: _size.width * 0.43,
            child: CustomPaint(
              painter: ClockMainPainter(
                  current: _clck,
                  isSeconds: true,
                  hourDialColor: Colors.black,
                  secondsDialColor: Colors.grey,
                  minuteDialColor: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
