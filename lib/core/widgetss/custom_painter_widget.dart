import 'dart:math';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  Color? lineColor;
  Color? completeColor;
  double? completePercent;
  double? width;

  MyPainter({this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width!;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent ?? 1);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, line..color = completeColor!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}