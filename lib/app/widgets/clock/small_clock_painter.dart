import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class SmallClockPainter extends CustomPainter {
  DateTime current;
  Color? dialColor;
  SmallClockPainter({required this.current, this.dialColor});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(
          size.width * .5 - size.width * .15 * sin(radians(current.minute * 6)),
          size.height * .5 +
              size.height * .15 * cos(radians(current.minute * 6))),
      Offset(
          size.width * .5 + size.width * .4 * sin(radians(current.minute * 6)),
          size.width * .5 - size.width * .4 * cos(radians(current.minute * 6))),
      Paint()
        ..strokeWidth = 0.5
        ..isAntiAlias = true
        ..isAntiAlias = true
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.multiply
        ..style = PaintingStyle.stroke
        ..color = dialColor ?? Colors.black,
    );

    /// [HOUR]
    int hour = current.hour >= 12 ? current.hour - 11 : current.hour;
    canvas.drawLine(
        Offset(size.width * .5 + size.width * .25 * sin(radians(hour * 30)),
            size.height * .5 - size.height * .25 * cos(radians(hour * 30))),
        Offset(size.width * .5 - size.width * .1 * sin(radians(hour * 30)),
            size.width * .5 + size.width * .1 * cos(radians(hour * 30))),
        Paint()
          ..strokeWidth = 1
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = dialColor ?? Colors.black);

    // The center punch

    canvas.drawCircle(Offset(size.width * .5, size.height * .5),
        size.height * .04, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
