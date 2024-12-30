import 'dart:math';

import 'package:rose_chess/utils/xiangqi.dart';

import '../generated/l10n.dart';

class EngineInfo {
  final String title;
  final String moves;
  final String bestmove;

  EngineInfo({required this.title, required this.moves, required this.bestmove});

  @override
  String toString() {
    return '{title: "$title", moves: "$moves"}';
  }
}

double calcEval(num x) {
  double output = 0.08837 * pow(x, 1.6745);
  if (output > 4 * x) {
    return x * 4;
  } else {
    return output;
  }
}

EngineInfo? parseEngineInfo(
    {required String input, required String fen, AppLocalizations? lang}) {
  // Tách chuỗi thành các phần dựa trên các từ khóa
  final depthMatch = RegExp(r'depth (\d+)').firstMatch(input);
  final scoreMatch = RegExp(r'score cp ([-]?\d+)').firstMatch(input);
  final npsMatch = RegExp(r'nps (\d+)').firstMatch(input);
  final pvMatch = RegExp(r'(?<!multi)pv (.*?)(?=\snodes|\stime|\shashfull|$)')
      .firstMatch(input);

  // Trích xuất thông tin từ các phần đã tách
  final depth = int.tryParse(depthMatch?.group(1) ?? '') ?? 0;
  final score = double.tryParse(scoreMatch?.group(1) ?? '') ?? 0;
  final nps = int.tryParse(npsMatch?.group(1) ?? '') ?? 0;
  final String moves = pvMatch?.group(1) ?? '';

  String sans = '';
  try {
    sans = getSanMovesFromfenAndNotations(
        fen: fen, chainNotation: moves, lang: lang);
  } catch (e) {
     return null;
  }

  // Nhân nps với 2 và lấy đơn vị là k
  final npsK = (nps * 2 / 1000).round();

  // Tính toán điểm số
  final calculatedScore =
      score > 0 ? calcEval(score).round() : (-calcEval(score.abs()).round());

  // Tạo title
  final title = '${lang!.depth} ${depth+2}, ${lang.score} $calculatedScore, ${lang.nps} ${npsK}k';

  // bestmove
  final bestmove = moves.split(' ')[0];

  return EngineInfo(title: title, moves: sans, bestmove: bestmove);
}
