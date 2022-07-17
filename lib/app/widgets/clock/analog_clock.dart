import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' show radians;

import '../../../context/context.dart';
import 'clock_painter.dart';

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

    _animationController.addStatusListener((AnimationStatus status) {
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
    final Size size = MediaQuery.of(context).size;
    final ClockTime clck = Provider.of<ClockTime>(context);
    return SizedBox(
      height: size.height * 0.35,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.square(
            dimension: size.width * .6,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
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
              builder: (BuildContext context, Widget? animation) {
                return Transform.rotate(
                  angle: radians(_rotation.value),
                  child: SizedBox.square(
                    dimension: size.width * 0.56,
                    child: CustomPaint(
                      painter: ClockPainterDial(),
                    ),
                  ),
                );
              }),
          SizedBox.square(
              dimension: size.width * 0.45,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey, blurRadius: 1, spreadRadius: .1),
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
            dimension: size.width * 0.4,
            child: CustomPaint(
              painter: ClockMainPainter(
                current: clck,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
