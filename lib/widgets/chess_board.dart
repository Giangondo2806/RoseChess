import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/board_state.dart';
import '../constants.dart';
import 'piece_widget.dart';
import '../models/board_position.dart';

class ChessBoardWidget extends StatelessWidget {
  const ChessBoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardWidth = constraints.maxWidth;
        final squareSize = boardWidth /
            Provider.of<BoardState>(context, listen: false).cols;

        return Center(
          child: AspectRatio(
            aspectRatio: Provider.of<BoardState>(context, listen: false).cols /
                Provider.of<BoardState>(context, listen: false).rows,
            child: Consumer<BoardState>(
              builder: (context, boardState, child) {
                return Stack(
                  children: [
                    // Board image (with RepaintBoundary)
                    RepaintBoundary(
                      child: SvgPicture.asset(
                        boardAsset,
                        width: boardWidth,
                        height: boardWidth *
                            (boardState.rows / boardState.cols),
                      ),
                    ),
                    // Pieces and Empty Squares
                    ..._buildSquares(squareSize, boardState),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSquares(double squareSize, BoardState boardState) {
    List<Widget> squares = [];
    for (int i = 0; i < boardState.rows; i++) {
      for (int j = 0; j < boardState.cols; j++) {
        final position = BoardPosition(
            String.fromCharCode('a'.codeUnitAt(0) + j) + (9 - i).toString());
        final piece = boardState.board[position];

        squares.add(
          AnimatedPositioned(
             key: ValueKey('$position-${piece?.type}-${piece?.color}-$i-$j'),
            duration: Duration(milliseconds: 1000),
            curve: Curves.linear,
            left: j * squareSize,
            top: i * squareSize,
            width: squareSize,
            height: squareSize,
            child: piece != null
                ? PieceWidget(
                    piece: piece,
                    squareSize: squareSize,
                    isSelected: boardState.selectedPosition == position,
                    onTap: () => boardState.onPieceTapped(position),
                  )
                : GestureDetector(
                    onTap: () => boardState.onPieceTapped(position),
                    child: Container(
                      decoration: BoxDecoration(
                        border: boardState.selectedPosition == position
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                    ),
                  ),
          ),
        );
      }
    }
    return squares;
  }
}