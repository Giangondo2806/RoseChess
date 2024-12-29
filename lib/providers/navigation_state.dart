import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rose_chess/providers/board_state.dart';
import 'package:rose_chess/utils/xiangqi.dart';

// class MoveData {
//   Move? move1;
//   Move? move2;

//   MoveData({this.move1, this.move2});
// }

class NavigationState with ChangeNotifier {
  List<dynamic> _moves = [];
  List<Map<String, Move?>> get moves => groupMoves(_moves);
  late BoardState _boardState;
  int _currentMove =0;

  void clearNavigation() {
    _moves.clear();
    notifyListeners();
  }

  void setNavigation(List<dynamic> data) {
    _moves =  data;
    _currentMove = _moves.length;
    notifyListeners();
  }

  void setBoardState({required boardState}){
    _boardState = boardState;
  }

  void previousMove() {
    if (_currentMove > 0) {
      _currentMove--;
      _boardState.gotoBoard(index: _currentMove);
    }
  }

  void nextMove() {
    if (_currentMove < _moves.length) {
      _currentMove++;
      _boardState.gotoBoard(index: _currentMove);
    }
  }

  void gotoMove(Move move) {
    final index = _moves.indexOf(move)+1;
      _currentMove = index;
      print('[rose] index: $index');
      _boardState.gotoBoard(index: _currentMove);
  }

  void gotoFistMove() {
    _currentMove = 0;
    _boardState.gotoBoard(index: _currentMove);
  }

  void gotoLastMove() {
    _currentMove = _moves.length;
    _boardState.gotoBoard(index: _currentMove);
  }
}
