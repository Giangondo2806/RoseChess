import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/constants.dart';
import 'package:rose_chess/providers/board_engine_state.dart';
import 'package:rose_chess/providers/board_state.dart';
import 'package:rose_chess/utils/board.dart';
import 'package:rose_chess/widgets/arrows_widget.dart';
import '../models/piece.dart';
import '../providers/arrow_state.dart'; // Import ArrowState
import '../providers/user_settings_provider.dart';
import 'piece_widget.dart';
import '../models/board_position.dart';

class ChessBoardWidget extends StatefulWidget {
  final BoardState boardState;

  const ChessBoardWidget({Key? key, required this.boardState})
      : super(key: key);

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double paddingValue = 10.0;
        final boardWidth = constraints.maxWidth - (2 * paddingValue);
        final boardState = widget.boardState;
        final squareSize = boardWidth / MAX_COLS;
        final boardHeight = boardWidth * (MAX_ROWS / MAX_COLS);

        final userSettingsProvider = Provider.of<UserSettingsProvider>(context);
        final isDarkMode =
            userSettingsProvider.currentTheme.brightness == Brightness.dark;

        final bool isShowArrows = boardState is BoardEngineState;

        return Center(
          child: Container(
            padding: const EdgeInsets.all(paddingValue),
            color: isDarkMode ? Colors.black : Colors.white,
            child: Container(
              color: const Color.fromARGB(255, 27, 106, 95),
              child: SizedBox(
                width: boardWidth,
                height: boardHeight,
                child: Stack(
                  children: [
                    RepaintBoundary(
                      child: SvgPicture.string(
                        getboard(linecolor: '#FFFFFF'),
                        width: boardWidth,
                        height: boardHeight,
                      ),
                    ),
                    ..._buildBoardSquares(squareSize, boardState),
                    if(isShowArrows)
                    Consumer<ArrowState>(
                      builder: (context, arrowState, child) {
                        return ArrowsWidget(
                            squareSize: squareSize, arrows: arrowState.arrows, isFlipped:  boardState.isFlipped);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBoardSquares(double squareSize, BoardState boardState) {
    List<Widget> squares = [];

    for (int i = 0; i < MAX_ROWS; i++) {
      for (int j = 0; j < MAX_COLS; j++) {
        int row = boardState.isFlipped ? (MAX_ROWS - 1 - i) : i;
        int col = boardState.isFlipped ? (MAX_COLS - 1 - j) : j;

        final position = BoardPosition.fromRowCol(row, col);
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
    final row =
        boardState.isFlipped ? MAX_ROWS - 1 - position.row : position.row;
    final col =
        boardState.isFlipped ? MAX_COLS - 1 - position.col : position.col;
    return Positioned(
      left: col * squareSize,
      top: row * squareSize,
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

  Widget _buildAnimatedPiece(
      Piece piece,
      double squareSize,
      BoardState boardState,
      BoardPosition position) {
    final row =
        boardState.isFlipped ? MAX_ROWS - 1 - position.row : position.row;
    final col =
        boardState.isFlipped ? MAX_COLS - 1 - position.col : position.col;
    return AnimatedPositioned(
      key: ValueKey(piece.id),
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
      left: col * squareSize,
      top: row * squareSize,
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
}