import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class StopWatchPainter extends CustomPainter {
  final Color dialColor;

  StopWatchPainter({required this.dialColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = dialColor;

    for (double i = 0; i <= 360; i += 5) {
      canvas.drawLine(
          Offset(size.width * .5, size.height * .5),
          Offset(size.width * .5 * (1 + cos(radians(i))),
              size.height * .5 * (1 - sin(radians(i)))),
          _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
