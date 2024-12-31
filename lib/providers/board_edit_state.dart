import 'dart:ui';

import '../generated/l10n.dart';
import '../models/board_position.dart';
import '../models/piece.dart';
import 'board_state.dart';

class BoardEditState extends BoardState {
  final AppLocalizations _lang;
  final String _fen;
  List<Piece> removedPieces = [];
  bool showPopup = false;
  late Offset popupPosition;
  BoardPosition? selectedEmptyPosition;

  BoardEditState(this._lang, this._fen) {
    initializeBoard(lang: _lang, fen: _fen);
  }

  @override
  void onPieceTapped(BoardPosition position) {
    if (selectedPosition == null) {
      if (board[position] != null) {
        selectedPosition = position;
      } else {
        // Show popup near the empty square
        showRemovedPiecesPopup(position);
      }
    } else {
      final piece = board[selectedPosition!];
      if (piece != null) {
        if (board[position] != null) {
          removedPieces.add(board[position]!);
        }
        movePiece(selectedPosition!, position, piece);
      }
    }
    notifyListeners();
  }

  void showRemovedPiecesPopup(BoardPosition position) {
    final squareSize = 40.0; // Adjust based on your board size
    selectedEmptyPosition = position;
    showPopup = true;
    
    // Calculate popup position
    double x = position.col * squareSize;
    double y = position.row * squareSize;
    
    // Adjust position to avoid screen edges
    if (x > 200) x -= 200; // popup width
    if (y > 300) y -= 100; // approximate popup height
    
    popupPosition = Offset(x, y);
    notifyListeners();
  }

  void hidePopup() {
    showPopup = false;
    selectedEmptyPosition = null;
    notifyListeners();
  }

  void restorePiece(Piece piece, BoardPosition position) {
    board[position] = piece;
    piecePositions[piece.id] = position;
    removedPieces.remove(piece);
    hidePopup();
    notifyListeners();
  }
}