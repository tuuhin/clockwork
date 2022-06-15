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
              animation: widget.controller,
              builder: (context, animation) {
                return Transform.rotate(
                  angle: radians(_rotate.value),
                  child: SizedBox.square(
                    dimension: _size.width * 0.55,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: CustomPaint(
                        foregroundPainter: StopWatchPainter(
                          dialColor: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }),
          SizedBox.square(
            dimension: _size.width * .48,
            child: Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  shape: BoxShape.circle,
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
          Text(
            stopWatchFormat(_time),
            style: Theme.of(context).textTheme.headline4!.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontFamily: 'Technology',
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
