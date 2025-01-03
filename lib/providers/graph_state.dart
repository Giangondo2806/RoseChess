import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class GraphState with ChangeNotifier {
  late List<dynamic> _moves = [];
  List<dynamic> get chartData => _moves;
  int _currentMove =0;


  void setMoves(List<dynamic> data) {
    _moves = data;
    _currentMove = _moves.length-1;
    notifyListeners();
  }

  void addMoves(dynamic data) {
    _moves.add(data);
    _currentMove = _moves.length-1;
    notifyListeners();


  }

  void clearGraph() {
    _moves.clear();
    notifyListeners();
  }
}
