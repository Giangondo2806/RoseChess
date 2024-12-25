import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rose_chess/models/engine_info.dart';

class EngineAnalysisState with ChangeNotifier {
  final List<EngineInfo> engineAnalysis = [];

  void addAnalysis(EngineInfo info) {
    engineAnalysis.insert(0, info);
    notifyListeners();
  }

  void clearAnalysis() {
    engineAnalysis.clear();
    notifyListeners();
  }
}
