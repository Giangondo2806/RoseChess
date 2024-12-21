import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rose_flutter/models/board_position.dart';

class ArrowData {
  final BoardPosition from;
  final BoardPosition to;
  final Color color;

  ArrowData({required this.from, required this.to, required this.color});
}

class ArrowState with ChangeNotifier {
  final List<ArrowData> _arrows = [];
  List<ArrowData> get arrows => _arrows;

  void clearArrows() {
    _arrows.clear();
    notifyListeners();
  }

  void addArrow(ArrowData arrow) {
    _arrows.add(arrow);
    notifyListeners();
  }

  void addArrows(List<ArrowData> arrows) {
    _arrows.addAll(arrows);
    notifyListeners();
  }
}