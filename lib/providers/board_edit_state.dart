import 'package:rose_chess/generated/l10n.dart';

import '../models/board_position.dart';
import 'board_state.dart';

class BoardEditState  extends BoardState {
  final AppLocalizations _lang;
  final String _fen;


  BoardEditState(this._lang,  this._fen) {
    initializeBoard(lang: _lang, fen: _fen);
  }

  @override
  void onPieceTapped(BoardPosition position) {
    // if (selectedPosition == null) {
    //   selectedPosition = position;
    // } else {
    //   final selectedPiece = board[selectedPosition];
    //   board[position] = selectedPiece;
    //   board[selectedPosition] = null;
    //   selectedPosition = null;
    // }
    notifyListeners();
  }
}