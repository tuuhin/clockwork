import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class StopWatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;

    for (double i = 0; i <= 360; i += 5) {
      canvas.drawLine(
          Offset(size.width * .5 + size.width * 0.46 * cos(radians(i)),
              size.height * .5 - size.height * 0.46 * sin(radians(i))),
          Offset(size.width * .5 * (1 + cos(radians(i))),
              size.height * .5 * (1 - sin(radians(i)))),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
