import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../providers/arrow_state.dart'; // Import ArrowState

class ArrowsWidget extends StatelessWidget {
  final double squareSize;
  final List<ArrowData> arrows;

  const ArrowsWidget({Key? key, required this.squareSize, required this.arrows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build');
    return CustomPaint(
      painter: ArrowsPainter(arrows: arrows, squareSize: squareSize),
    );
  }
}

class ArrowsPainter extends CustomPainter {
  final List<ArrowData> arrows;
  final double squareSize;

  ArrowsPainter({required this.arrows, required this.squareSize});

  @override
  void paint(Canvas canvas, Size size) {
    for (final arrow in arrows) {
      _drawArrow(canvas, arrow, squareSize);
    }
  }

  void _drawArrow(Canvas canvas, ArrowData arrowData, double squareSize) {
    final paint = Paint()
      ..color = arrowData.color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double fromCenterX = arrowData.from.col * squareSize + squareSize / 2;
    double fromCenterY = arrowData.from.row * squareSize + squareSize / 2;
    double toCenterX = arrowData.to.col * squareSize + squareSize / 2;
    double toCenterY = arrowData.to.row * squareSize + squareSize / 2;

    final path = Path();
    path.moveTo(fromCenterX, fromCenterY);
    path.lineTo(toCenterX, toCenterY);

    double angle = atan2(toCenterY - fromCenterY, toCenterX - fromCenterX);
    double arrowSize = 20;

    double arrowPointX = toCenterX - arrowSize * cos(angle);
    double arrowPointY = toCenterY - arrowSize * sin(angle);

    canvas.drawLine(
      Offset(toCenterX, toCenterY),
      Offset(arrowPointX - arrowSize / 2 * sin(angle),
          arrowPointY + arrowSize / 2 * cos(angle)),
      paint,
    );
    canvas.drawLine(
      Offset(toCenterX, toCenterY),
      Offset(arrowPointX + arrowSize / 2 * sin(angle),
          arrowPointY - arrowSize / 2 * cos(angle)),
      paint,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowsPainter oldDelegate) {
    print('current: ${arrows}');
    print(listEquals(arrows, oldDelegate.arrows));
    return !listEquals(arrows, oldDelegate.arrows);
  }
}