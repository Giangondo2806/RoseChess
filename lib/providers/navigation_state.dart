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

  void clearNavigation() {
    _moves.clear();
    notifyListeners();
  }

  void setNavigation(List<dynamic> data) {
    _moves =  data;
    notifyListeners();
  }

  void setBoardState({required boardState}){
    _boardState = boardState;
  }

  void previousMove() {
    
  }
}
