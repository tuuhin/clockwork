import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class ClockMainPainter extends CustomPainter {
  DateTime current;

  ClockMainPainter({required this.current});
  @override
  void paint(Canvas canvas, Size size) {
    // The dial
    canvas.drawLine(
        Offset(size.width * .5, size.height * .5),
        Offset(size.width * .5 * (1 + sin(radians(current.second * 6))),
            size.height * .5 * (1 - cos(radians(current.second * 6)))),
        Paint()
          ..strokeWidth = 3
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true
          ..color = Colors.black);
    canvas.drawLine(
        Offset(size.width * .5, size.height * .5),
        Offset(size.width * .5 * (1 + sin(radians(current.minute * 6))),
            size.height * .5 * (1 - cos(radians(current.minute * 6)))),
        Paint()
          ..strokeWidth = 5
          ..isAntiAlias = true
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.multiply
          ..style = PaintingStyle.stroke
          ..color = Colors.pinkAccent);
    canvas.drawLine(
        Offset(size.width * .5, size.height * .5),
        Offset(size.width * .5 * (1 + sin(radians(current.hour * 6))),
            size.height * .5 * (1 - cos(radians(current.hour * 6)))),
        Paint()
          ..strokeWidth = 8
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = Colors.blue);

    // The center punch
    canvas.drawCircle(Offset(size.width * .5, size.height * .5), 10,
        Paint()..color = Colors.white);
    canvas.drawCircle(Offset(size.width * .5, size.height * .5), 7,
        Paint()..color = Colors.grey);
    canvas.drawCircle(Offset(size.width * .5, size.height * .5), 5,
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ClockPainterDial extends CustomPainter {
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
            ..color = Colors.grey);
    }
    canvas.drawCircle(Offset(size.width * .5, size.height * .5),
        size.width * .45, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
