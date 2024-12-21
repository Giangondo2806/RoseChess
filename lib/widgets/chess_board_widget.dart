import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rose_flutter/utils/board.dart'; // Thay your_app_name bằng tên app của bạn
import 'package:rose_flutter/widgets/arrows_widget.dart'; // Thay your_app_name bằng tên app của bạn
import '../models/piece.dart';
import '../providers/board_state.dart';
import '../providers/theme_provider.dart';
import 'piece_widget.dart';
import '../models/board_position.dart';

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
              for (int i = 0; i < 2; i++) {
                boardState.arrows.add(ArrowData(
                  from: BoardPosition(moves[i].substring(0, 2)),
                  to: BoardPosition(moves[i].substring(2, 4)),
                  color: i == 0 ? Colors.blue.withOpacity(0.7) : Colors.green.withOpacity(0.7),
                ));
              }
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
        const double paddingValue = 10.0;
        final boardWidth = constraints.maxWidth - (2 * paddingValue);
        final boardState = Provider.of<BoardState>(context, listen: false);
        final squareSize = boardWidth / boardState.cols;
        final boardHeight = boardWidth * (boardState.rows / boardState.cols);

        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDarkMode =
            themeProvider.currentTheme.brightness == Brightness.dark;

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
                    // Sử dụng ArrowsWidget
                    ArrowsWidget(squareSize: squareSize),
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

  Widget _buildAnimatedPiece(
      Piece piece,
      double squareSize,
      BoardState boardState,
      BoardPosition position) {
    return AnimatedPositioned(
      key: ValueKey(piece.id),
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
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
}