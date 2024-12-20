import 'package:flutter_test/flutter_test.dart';
import 'package:rose_flutter/services/chess_db_service.dart';

void main() {
  group('Xiangqi', () {
    test('algebraic and algebraicToEnum sdafdfdsf', () async {
      final respone = await getChessdbMoves(
          'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR w moves c3c4');
      print(respone);
    });
  });
}
