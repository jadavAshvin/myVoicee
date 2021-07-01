import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter {
  double currentProgress;
  Color color;
  Color progressColors;

  CircleProgress(this.currentProgress, this.color, this.progressColors);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 3
      ..color = progressColors
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    Paint completeArc = Paint()
      ..strokeWidth = 3
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    double angle = 2 * pi * (currentProgress / 100);
    double angle1 = 2 * pi * ((100 - currentProgress) / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        angle - pi / 2, angle1, false, outerCircle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
