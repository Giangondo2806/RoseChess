import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rose_chess/models/chessdb_move.dart';

import '../services/chess_db_service.dart';

class BookState with ChangeNotifier {
  List<ChessdbMove> _moves = [];
  List<ChessdbMove> get moves => _moves;

  void clearBooks() {
    _moves.clear();
    notifyListeners();
  }

  Future<void> getbook(String fen) async {
    await getChessdbMoves(fen).then((data) => {_moves = data});
    notifyListeners();
  }
}
