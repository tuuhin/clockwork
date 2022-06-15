import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class SmallClockPainter extends CustomPainter {
  DateTime current;
  SmallClockPainter({required this.current});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(
            size.width * .5 -
                size.width * .15 * sin(radians(current.minute * 6)),
            size.height * .5 +
                size.height * .15 * cos(radians(current.minute * 6))),
        Offset(
            size.width * .5 +
                size.width * .48 * sin(radians(current.minute * 6)),
            size.width * .5 -
                size.width * .48 * cos(radians(current.minute * 6))),
        Paint()
          ..strokeWidth = 2
          ..isAntiAlias = true
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.multiply
          ..style = PaintingStyle.stroke
          ..color = Colors.black);

    /// [HOUR]

    canvas.drawLine(
        Offset(
            size.width * .5 +
                size.width * .25 * sin(radians(current.hour * 15)),
            size.height * .5 -
                size.height * .25 * cos(radians(current.hour * 15))),
        Offset(
            size.width * .5 - size.width * .1 * sin(radians(current.hour * 15)),
            size.width * .5 +
                size.width * .1 * cos(radians(current.hour * 15))),
        Paint()
          ..strokeWidth = 3
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = Colors.black);

    // The center punch

    canvas.drawCircle(Offset(size.width * .5, size.height * .5),
        size.height * .04, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
