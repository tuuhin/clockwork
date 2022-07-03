import 'dart:math';

import 'package:flutter/material.dart';

class Sprinkle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.width * .2, size.height * .28),
        size.height * .03,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.blueAccent);
    canvas.drawCircle(
        Offset(size.width * .8, size.height * .1),
        size.height * .04,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.redAccent);
    canvas.drawCircle(
        Offset(size.width * .8, size.height * .75),
        size.height * .035,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.greenAccent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
