import '../constants.dart';
import '../models/board_position.dart';
import '../models/piece.dart';

String getboard({required String linecolor}) {
  return '''<svg xmlns="http://www.w3.org/2000/svg" width="635" height="706"><path style="stroke:$linecolor;stroke-width:2px;stroke-linecap:square" d=" M 033,033 l 568,000 M 033,105 l 568,000 M 033,176 l 568,000 M 033,247 l 568,000 M 033,318 l 568,000 M 033,389 l 568,000 M 033,460 l 568,000 M 033,531 l 568,000 M 033,602 l 568,000 M 033,673 l 568,000 M 033,034 l 000,284 M 104,034 l 000,284 M 175,034 l 000,284 M 246,034 l 000,284 M 317,034 l 000,284 M 388,034 l 000,284 M 459,034 l 000,284 M 530,034 l 000,284 M 601,034 l 000,284 M 033,389 l 000,284 M 104,389 l 000,284 M 175,389 l 000,284 M 246,389 l 000,284 M 317,389 l 000,284 M 388,389 l 000,284 M 459,389 l 000,284 M 530,389 l 000,284 M 601,389 l 000,284 M 246,034 L 388,176 M 388,034 L 246,176 M 246,531 L 388,673 M 388,531 L 246,673" /></svg>''';
}

String generateFen(Map<BoardPosition, Piece?> board, String turn) {
  String fen = '';
  for (int i = 0; i < MAX_ROWS; i++) {
    int emptyCount = 0;
    for (int j = 0; j < MAX_COLS; j++) {
      final position = BoardPosition.fromRowCol(i, j);
      final piece = board[position];
      if (piece == null) {
        emptyCount++;
      } else {
        if (emptyCount > 0) {
          fen += emptyCount.toString();
          emptyCount = 0;
        }

        final pieceName = piece.color == PieceColor.red
            ? piece.type.toString().toUpperCase()
            : piece.type.toString().toLowerCase();
        fen += pieceName;
      }
    }
    if (emptyCount > 0) {
      fen += emptyCount.toString();
    }
    if (i < MAX_ROWS - 1) {
      fen += '/';
    }
  }
  return turn == 'r' ? '$fen w' : '$fen b';

}
