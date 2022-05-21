import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class ClockPainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.multiply
      ..color = Colors.black87;

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
