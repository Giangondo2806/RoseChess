import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rose_flutter/utils/xiangqi.dart';
import '../models/piece.dart';
import '../providers/board_state.dart';
import '../constants.dart';
import 'piece_widget.dart';
import '../models/board_position.dart';

class ArrowData {
  final BoardPosition from;
  final BoardPosition to;
  final Color color;

  ArrowData({required this.from, required this.to, required this.color});
}

class ChessBoardWidget extends StatefulWidget {
  const ChessBoardWidget({Key? key, required BoardState boardState})
      : super(key: key);

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  List<String> _previousMoves = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final boardState = Provider.of<BoardState>(context);

    // boardState.xiangqi.turn   === Xiangqi.RED
    boardState.roseEngine?.stdout.listen((line) {
      if (line.startsWith('info depth') && line.contains(' pv ')) {
        _extractMoves(line);
      }
    });
  }

  void _extractMoves(String line) {
    final pvIndex = line.indexOf(' pv ');
    if (pvIndex != -1) {
      final pvString = line.substring(pvIndex + 4);
      final moves = pvString.split(' ');
      if (moves.length >= 2) {
        if (moves[0] !=
                (_previousMoves.isNotEmpty ? _previousMoves[0] : null) ||
            moves[1] !=
                (_previousMoves.length > 1 ? _previousMoves[1] : null)) {
          _previousMoves = List.from(moves);

          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              final boardState =
                  Provider.of<BoardState>(context, listen: false);
              boardState.clearArrows();
              boardState.arrows.add(ArrowData(
                from: BoardPosition(moves[0].substring(0, 2)),
                to: BoardPosition(moves[0].substring(2, 4)),
                color: Colors.blue.withOpacity(0.7),
              ));
              boardState.arrows.add(ArrowData(
                from: BoardPosition(moves[1].substring(0, 2)),
                to: BoardPosition(moves[1].substring(2, 4)),
                color: Colors.green.withOpacity(0.7),
              ));
              boardState.notifyListeners();
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardWidth = constraints.maxWidth; // Sử dụng chiều rộng tối đa
        final boardState = Provider.of<BoardState>(context, listen: false);
        final squareSize = boardWidth / boardState.cols;
        final boardHeight = boardWidth *
            (boardState.rows / boardState.cols); // Tính toán chiều cao

        return Center(
          child: SizedBox(
            width: boardWidth,
            height: boardHeight,
            child: Consumer<BoardState>(
              builder: (context, boardState, child) {
                return Stack(
                  children: [
                    RepaintBoundary(
                      child: SvgPicture.asset(
                        boardAsset,
                        width: boardWidth,
                        height: boardHeight,
                      ),
                    ),
                    ..._buildBoardSquares(squareSize, boardState),
                    if (boardState.arrows.isNotEmpty)
                      _buildMoveIndicator(squareSize, boardState),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBoardSquares(double squareSize, BoardState boardState) {
    List<Widget> squares = [];

    for (int i = 0; i < boardState.rows; i++) {
      for (int j = 0; j < boardState.cols; j++) {
        final position = BoardPosition(
            String.fromCharCode('a'.codeUnitAt(0) + j) + (9 - i).toString());
        squares.add(_buildSquare(squareSize, boardState, position));
      }
    }
    return squares;
  }

  Widget _buildSquare(
      double squareSize, BoardState boardState, BoardPosition position) {
    final piece = boardState.board[position];
    if (piece != null) {
      return _buildAnimatedPiece(piece, squareSize, boardState, position);
    }
    return _buildEmptySquare(squareSize, boardState, position);
  }

  Widget _buildEmptySquare(
      double squareSize, BoardState boardState, BoardPosition position) {
    // bool isSameColor = boardState.board[position]?.color ==
    //     (boardState.xiangqi.turn == Xiangqi.RED
    //         ? PieceColor.red
    //         : PieceColor.black);
    return Positioned(
      left: position.col * squareSize,
      top: position.row * squareSize,
      width: squareSize,
      height: squareSize,
      child: GestureDetector(
        onTap: () => boardState.onPieceTapped(position),
        child: Container(
          decoration: BoxDecoration(
            border: boardState.selectedPosition == position
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedPiece(Piece piece, double squareSize,
      BoardState boardState, BoardPosition position) {
    return AnimatedPositioned(
      key: ValueKey(piece.id),
      duration: const Duration(milliseconds: 200),
      // Increased duration
      curve: Curves.ease,
      // Using Curves.easeInOut
      left: position.col * squareSize,
      top: position.row * squareSize,
      width: squareSize,
      height: squareSize,
      child: PieceWidget(
        piece: piece,
        squareSize: squareSize,
        isSelected: boardState.selectedPosition == position,
        onTap: () => boardState.onPieceTapped(position),
      ),
    );
  }

  Widget _buildMoveIndicator(double squareSize, BoardState boardState) {
    // Sử dụng boardState.arrows trực tiếp
    return CustomPaint(
      painter: ArrowsPainter(arrows: boardState.arrows, squareSize: squareSize),
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
