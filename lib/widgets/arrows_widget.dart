import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_state.dart';
import '../models/board_position.dart';

class ArrowData {
  final BoardPosition from;
  final BoardPosition to;
  final Color color;

  ArrowData({required this.from, required this.to, required this.color});
}

class ArrowsWidget extends StatelessWidget {
  final double squareSize;

  const ArrowsWidget({Key? key, required this.squareSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardState>(
      builder: (context, boardState, child) {
        return CustomPaint(
          painter: ArrowsPainter(arrows: boardState.arrows, squareSize: squareSize),
        );
      },
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}