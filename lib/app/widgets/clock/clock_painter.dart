import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class ClockMainPainter extends CustomPainter {
  Color? hourDialColor;
  Color? minuteDialColor;
  Color? secondsDialColor;
  Color? knobColor;

  bool? isSeconds;
  DateTime current;

  ClockMainPainter({
    required this.current,
    this.isSeconds = true,
    this.hourDialColor,
    this.minuteDialColor,
    this.secondsDialColor,
    this.knobColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (isSeconds == true) {
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
            ..color = secondsDialColor ?? Colors.black);
    }

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
          ..strokeWidth = 5
          ..isAntiAlias = true
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.multiply
          ..style = PaintingStyle.stroke
          ..color = minuteDialColor ?? Colors.black);

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
          ..strokeWidth = 7
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = hourDialColor ?? Colors.black);

    // The center punch

    canvas.drawCircle(Offset(size.width * .5, size.height * .5), 3,
        Paint()..color = knobColor ?? Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ClockPainterDial extends CustomPainter {
  Color color;

  ClockPainterDial({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = 0; i <= 360; i += 5) {
      canvas.drawLine(
          Offset(size.width * .5, size.height * .5),
          Offset(size.width * .5 * (1 + cos(radians(i))),
              size.height * .5 * (1 - sin(radians(i)))),
          Paint()
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
