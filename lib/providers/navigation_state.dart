import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rose_chess/utils/xiangqi.dart';

// class MoveData {
//   Move? move1;
//   Move? move2;

//   MoveData({this.move1, this.move2});
// }

class NavigationState with ChangeNotifier {
  List<Map<String, Move?>> _moves = [];
  List<Map<String, Move?>> get moves => _moves;

  void clearBooks() {
    _moves.clear();
    notifyListeners();
  }

  void setMove(List<dynamic> data) {
    _moves = groupMoves(data);
  }
}
