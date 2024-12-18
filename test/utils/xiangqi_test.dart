import 'package:flutter_test/flutter_test.dart';
import 'package:rose_flutter/utils/xiangqi.dart';

void main() {
  group('Xiangqi', () {
    late Xiangqi xiangqi;

    setUp(() {
      xiangqi = Xiangqi();
    });

    test('algebraic and algebraicToEnum sdafdfdsf', () {
      expect(xiangqi.algebraic(0), equals('a9'));
      expect(xiangqi.algebraic(24), equals('i8'));
      expect(xiangqi.algebraic(0x98), equals('i0'));

      expect(xiangqi.algebraicToEnum('a9'), equals(Square.a9));
      expect(xiangqi.algebraicToEnum('i8'), equals(Square.i8));
      expect(xiangqi.algebraicToEnum('i0'), equals(Square.i0));
    });
    test('should initialize with default position', () {
      expect(
          xiangqi.fen(),
          contains(
              'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR w'));
    });

    test('should make a valid move', () {
      xiangqi.move({'from': 'h2', 'to': 'e2'});
      xiangqi.move({'from': 'h9', 'to': 'g7'});
      xiangqi.move({'from': 'h0', 'to': 'g2'});
      expect(xiangqi, isNotNull);
      expect(
          xiangqi.fen(),
          contains(
              'rnbakab1r/9/1c4nc1/p1p1p1p1p/9/9/P1P1P1P1P/1C2C1N2/9/RNBAKAB1R b'));

      expect(xiangqi.gameOver(), false);

      //     expect(game.ascii()).toBe(`
      //    +---------------------------+
      //  9 | r  n  b  a  k  a  b  n  r |
      //  8 | .  .  .  .  .  .  .  .  . |
      //  7 | .  c  .  .  .  .  .  c  . |
      //  6 | p  .  p  .  p  .  p  .  p |
      //  5 | .  .  .  .  .  .  .  .  . |
      //  4 | .  .  .  .  .  .  .  .  . |
      //  3 | P  .  P  .  P  .  P  .  P |
      //  2 | .  C  .  .  C  .  .  .  . |
      //  1 | .  .  .  .  .  .  .  .  . |
      //  0 | R  N  B  A  K  A  B  N  R |
      //    +---------------------------+
      //      a  b  c  d  e  f  g  h  i`)
    });

    test('should not make an invalid move', () {
      final move = xiangqi.move({'from': 'a0', 'to': 'a9'});
      expect(move, isNull);
    });

    test('should be stalemate', () {
      xiangqi.load('3aca3/1Cnrk4/b3r4/2p1n4/2b6/9/9/9/4C4/ppppcK3 b - - 0 1');
      expect(xiangqi.gameOver(), true);
    });

    test('should be checkmate', () {
      xiangqi.load(
          'rnbakab1r/9/1c5c1/p1p5p/4p1p2/4P1P2/P1P3nCP/1C3A3/4NK3/RNB2AB1R r');
      expect(xiangqi.gameOver(), true);
    });

    test('should be undo', () {
      xiangqi.move('e3e4');
      expect(
          xiangqi.fen(),
          contains(
              'rnbakabnr/9/1c5c1/p1p1p1p1p/9/4P4/P1P3P1P/1C5C1/9/RNBAKABNR b'));
    });

    // test('generate move', () {
    //   expect(xiangqi.generatePrettyMoves().length, 2);
    // });

    test('parse notion', () {
      expect(Xiangqi.fromNotion('a0'), {"col": 0, "row": 9});
    });

    test('history', () {
      xiangqi.move({'from': 'h2', 'to': 'e2'});
      xiangqi.move({'from': 'h9', 'to': 'g7'});
      xiangqi.move({'from': 'h0', 'to': 'g2'});

      expect(
          xiangqi.getHistory(verbose: true),
          equals([
            {
              "move_number": 1,
              "color": 'r',
              "from": 'h2',
              "to": 'e2',
              "flags": 'n',
              "piece": 'C',
              "iccs": 'h2e2',
              "fen":
                  'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR w'
            },
            {
              "move_number": 1,
              "color": 'b',
              "from": 'h9',
              "to": 'g7',
              "flags": 'n',
              "piece": 'n',
              "iccs": 'h9g7',
              "fen":
                  'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C2C4/9/RNBAKABNR b'
            },
            {
              "move_number": 2,
              "color": 'r',
              "from": 'h0',
              "to": 'g2',
              "flags": 'n',
              "piece": 'N',
              "iccs": 'h0g2',
              "fen":
                  'rnbakab1r/9/1c4nc1/p1p1p1p1p/9/9/P1P1P1P1P/1C2C4/9/RNBAKAB1R w'
            }
          ]));
    });

    test('history fromload', () {
      xiangqi.load(
          'rnbakabnr/9/1c7/p1p1p1p1p/7c1/9/P1P1P1P1P/1C2C1N2/9/RNBAKAB1R b');
      expect(xiangqi.getHistory(verbose: true), equals([]));
      xiangqi.move({'from': 'c9', 'to': 'e7'});
      xiangqi.move({'from': 'c3', 'to': 'c4'});
      expect(
          xiangqi.getHistory(verbose: true),
          equals([
            {
              "color": 'b',
              "from": 'c9',
              "to": 'e7',
              "flags": 'n',
              "piece": 'b',
              "move_number": 1,
              "iccs": 'c9e7',
              "fen":
                  'rnbakabnr/9/1c7/p1p1p1p1p/7c1/9/P1P1P1P1P/1C2C1N2/9/RNBAKAB1R b'
            },
            {
              "color": 'r',
              "from": 'c3',
              "to": 'c4',
              "flags": 'n',
              "piece": 'P',
              "move_number": 2,
              "iccs": 'c3c4',
              "fen":
                  'rn1akabnr/9/1c2b4/p1p1p1p1p/7c1/9/P1P1P1P1P/1C2C1N2/9/RNBAKAB1R w'
            }
          ]));
    });
  });
}
