import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/piece.dart';
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
                   ..._buildBoardSquares(squareSize, boardState),
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
          squares.add(_buildSquare(squareSize,boardState,position));
      }
    }
      return squares;
  }


 Widget _buildSquare(double squareSize, BoardState boardState, BoardPosition position){
     final piece = boardState.board[position];
    if(piece != null){
      return _buildAnimatedPiece(piece, squareSize, boardState, position);
    }
    return  _buildEmptySquare(squareSize, boardState, position);
 }

   Widget _buildEmptySquare(double squareSize, BoardState boardState, BoardPosition position){
    return  Positioned(
      left: position.col * squareSize,
      top: (9 - position.row) * squareSize,
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

   Widget _buildAnimatedPiece(Piece piece, double squareSize, BoardState boardState, BoardPosition position) {
       return AnimatedPositioned(
        key: ValueKey(piece.id),
         duration: const Duration(milliseconds: 100), // Increased duration
         curve: Curves.linear, // Using Curves.easeInOut
         left: position.col * squareSize,
         top: (9 - position.row) * squareSize,
         width: squareSize,
         height: squareSize,
      child:  PieceWidget(
             piece: piece,
             squareSize: squareSize,
             isSelected: boardState.selectedPosition == position,
             onTap: () => boardState.onPieceTapped(position),
         ),
      );
   }
}