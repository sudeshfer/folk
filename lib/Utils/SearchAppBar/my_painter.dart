import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final Color color;
  final Offset center;
  final double radius, containerHeight;
  final BuildContext context;

  double statusBarHeight, screenWidth;

  MyPainter(this.color,
      {this.context, this.containerHeight, this.center, this.radius}) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePainter = Paint();

    circlePainter.color = color;
    canvas.clipRect(
        Rect.fromLTWH(0, 0, screenWidth, containerHeight + statusBarHeight));
    canvas.drawCircle(center, radius, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
