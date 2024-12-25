import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rose_chess/models/board_position.dart';

class ArrowData {
  final BoardPosition from;
  final BoardPosition to;
  final Color color;

  ArrowData({required this.from, required this.to, required this.color});
}

class ArrowState with ChangeNotifier {
  final List<ArrowData> _arrows = [];
  List<ArrowData> get arrows => _arrows;
  final List<String> _notations = [];

  void clearArrows() {
    _arrows.clear();
    _notations.clear();
    notifyListeners();
  }

  void addArrows(String line) {
    final pvIndex = line.indexOf(' pv ');
    if (pvIndex != -1) {
      final pvString = line.substring(pvIndex + 4);
      final moves = pvString.split(' ');
      if (moves.length >= 2) {
        List<ArrowData> newArrows = [];
        for (int i = 0; i < 2; i++) {
          newArrows.add(ArrowData(
            from: BoardPosition(moves[i].substring(0, 2)),
            to: BoardPosition(moves[i].substring(2, 4)),
            color: i == 0
                ? Colors.blue.withOpacity(0.7)
                : Colors.green.withOpacity(0.7),
          ));
        }

        if (!listEquals(_notations, [moves[0], moves[1]])) {
          clearArrows();
          _notations.addAll([moves[0], moves[1]]);
          _arrows.addAll(newArrows);
          notifyListeners();
        }
      }
    }
  }
}
