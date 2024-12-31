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
  bool isFlipped = false;
  BoardPosition? selectedPosition;
  void onPieceTapped(BoardPosition position);
  void initializeBoard({AppLocalizations? lang, String? fen}) {
    piecePositions = {};
    board = {};
    xiangqi = Xiangqi(lang: lang, fen: fen);
    initFen = xiangqi.generateFen();
    var initialBoard = xiangqi.getBoard();
    int idCounter = 0;
    for (int i = 0; i < initialBoard.length; i++) {
      for (int j = 0; j < initialBoard[i].length; j++) {
        final pieceData = initialBoard[i][j];
        if (pieceData != null) {
          // Đảm bảo BoardPosition luôn có notation
          if (pieceData.notion == null) {
            throw Exception("Piece data notion is null at i=$i, j=$j");
          }
          final piece = createPieceFromData(pieceData, idCounter);
          board[BoardPosition(pieceData.notion!)] = piece;
          piecePositions[piece.id] = BoardPosition(pieceData.notion!);
          idCounter++;
        }
      }
    }
  }
}
