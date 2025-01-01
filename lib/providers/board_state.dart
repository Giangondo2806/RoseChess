import 'package:flutter/foundation.dart';

import '../generated/l10n.dart';
import '../models/board_position.dart';
import '../models/piece.dart';
import '../utils/xiangqi.dart';

abstract class BoardState with ChangeNotifier {
  late Xiangqi xiangqi;
  late Map<BoardPosition, Piece?> board;
  late Map<String, BoardPosition> piecePositions;
  late String initFen;
  bool _isFlipped = false;
  bool get isFlipped => _isFlipped;
  set isFlipped(bool value) {
    _isFlipped = value;
    notifyListeners();
  }
  BoardPosition? selectedPosition;
  void onPieceTapped(BoardPosition position);
  void initializeBoard({AppLocalizations? lang, String? fen, bool editmode = false}) {
    piecePositions = {};
    board = {};
    xiangqi = Xiangqi(lang: lang, fen: fen, editmode: editmode);
    initFen = xiangqi.generateFen();
    var initialBoard = xiangqi.getBoard();
    for (int i = 0; i < initialBoard.length; i++) {
      for (int j = 0; j < initialBoard[i].length; j++) {
        final pieceData = initialBoard[i][j];
        if (pieceData != null) {
          // Đảm bảo BoardPosition luôn có notation
          if (pieceData.notion == null) {
            throw Exception("Piece data notion is null at i=$i, j=$j");
          }
          final piece = createPieceFromData(pieceData, UniqueKey().toString());
          board[BoardPosition(pieceData.notion!)] = piece;
          piecePositions[piece.id] = BoardPosition(pieceData.notion!);
        }
      }
    }
  }
   void movePiece(BoardPosition from, BoardPosition to, Piece piece) {
    board[to] = piece;
    board[from] = null;
    piecePositions[piece.id] = to;
    selectedPosition = null;
  }

}
