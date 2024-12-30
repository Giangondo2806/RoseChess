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
  get currentMove => _currentMove;
  Move? get hightLightMove => _currentMove-1>=0? _moves[_currentMove-1]:null;

  void clearNavigation() {
    _moves.clear();
    _currentMove = 0;
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
       notifyListeners();
    }
  }

  void nextMove() {
    if (_currentMove < _moves.length) {
      _currentMove++;
      _boardState.gotoBoard(index: _currentMove);
       notifyListeners();
    }
  }

  void gotoMove(Move move) {
    final index = _moves.indexOf(move)+1;
      _currentMove = index;
      _boardState.gotoBoard(index: _currentMove);
      notifyListeners();

  }

  void gotoFistMove() {
    _currentMove = 0;
    _boardState.gotoBoard(index: _currentMove);
     notifyListeners();
  }

  void gotoLastMove() {
    _currentMove = _moves.length;
    _boardState.gotoBoard(index: _currentMove);
     notifyListeners();
  }
}
