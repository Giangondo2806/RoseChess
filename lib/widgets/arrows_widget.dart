import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../providers/arrow_state.dart'; // Import ArrowState

class ArrowsWidget extends StatelessWidget {
  final bool isFlipped;
  final double squareSize;
  final List<ArrowData> arrows;

  const ArrowsWidget({Key? key, required this.squareSize, required this.arrows, required this.isFlipped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArrowsPainter(arrows: arrows, squareSize: squareSize, isFlipped: isFlipped),
    );
  }
}

class ArrowsPainter extends CustomPainter {
  final List<ArrowData> arrows;
  final double squareSize;
  final bool isFlipped;

  ArrowsPainter({required this.arrows, required this.squareSize, required this.isFlipped});

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

    int fromRow = isFlipped ? 9 - arrowData.from.row : arrowData.from.row;
    int fromCol = isFlipped ? 8 - arrowData.from.col : arrowData.from.col;
    int toRow = isFlipped ? 9 - arrowData.to.row : arrowData.to.row;
    int toCol = isFlipped ? 8 - arrowData.to.col : arrowData.to.col;

     double fromCenterX = fromCol * squareSize + squareSize / 2;
    double fromCenterY = fromRow * squareSize + squareSize / 2;
    double toCenterX = toCol * squareSize + squareSize / 2;
    double toCenterY = toRow * squareSize + squareSize / 2;

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
    return !listEquals(arrows, oldDelegate.arrows);
  }
}
