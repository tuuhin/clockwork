import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class ClockMainPainter extends CustomPainter {
  ClockMainPainter({
    required this.current,
  });
  DateTime current;
  @override
  void paint(Canvas canvas, Size size) {
    /// [SECONDS]
    canvas.drawLine(
        Offset(
            size.width * .5 -
                size.width * .15 * sin(radians(current.second * 6)),
            size.height * .5 +
                size.height * .15 * cos(radians(current.second * 6))),
        Offset(
            size.width * .5 +
                size.width * .45 * sin(radians(current.second * 6)),
            size.width * .5 -
                size.width * .45 * cos(radians(current.second * 6))),
        Paint()
          ..strokeWidth = 2
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true
          ..color = Colors.pinkAccent);

    /// [MINUTES]
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
          ..strokeWidth = 3
          ..isAntiAlias = true
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.multiply
          ..style = PaintingStyle.stroke
          ..color = Colors.black87);

    /// [HOUR]

    canvas.drawLine(
        Offset(
            size.width * .5 +
                size.width * .25 * sin(radians(current.hour * 30)),
            size.height * .5 -
                size.height * .25 * cos(radians(current.hour * 30))),
        Offset(
            size.width * .5 - size.width * .1 * sin(radians(current.hour * 30)),
            size.width * .5 +
                size.width * .1 * cos(radians(current.hour * 30))),
        Paint()
          ..strokeWidth = 5
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = Colors.black);

    // The center punch

    canvas.drawCircle(Offset(size.width * .5, size.height * .5), 3,
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClockPainterDial extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (double i = 0; i <= 360; i += 5) {
      canvas.drawLine(
          Offset(size.width * .5 + size.width * 0.46 * cos(radians(i)),
              size.height * .5 - size.height * 0.46 * sin(radians(i))),
          Offset(size.width * .5 + size.width * 0.5 * cos(radians(i)),
              size.height * .5 - size.height * 0.5 * sin(radians(i))),
          Paint()
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..color = Colors.grey);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
