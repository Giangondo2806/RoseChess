import 'package:http/http.dart' as http;
import 'package:rose_flutter/models/chessdb_move.dart';
import 'package:rose_flutter/utils/xiangqi.dart';

Future<List<ChessdbMove>> getChessdbMoves(String fen) async {
  final Xiangqi xiangqi = Xiangqi(fen: fen);
  final response = await http.get(
    Uri.parse(
        'http://www.chessdb.cn/chessdb.php?action=queryall&learn=1&showall=1&board=$fen'),
    headers: {
      'Accept-Encoding': 'gzip, deflate',
      'Content-Type': 'application/x-www-form-urlencoded'
    },
  );
  if (response.statusCode == 200) {
    final data = response.body;
    try {
      return data
          .split('|')
          .sublist(0, 15)
          .map((el) => ChessdbMove.fromString(el))
          .map((el) {
            el.san = el.notation != ''
                ? xiangqi.getSanfromNotation(el.notation!)
                : '';
            return el;
          })
          .where((el) => el.score != '??')
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  } else {
    print('error: ${response.statusCode}');
    return [];
  }
}
