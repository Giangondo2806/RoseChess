import 'package:flutter/material.dart';
import 'package:rose_chess/models/chessdb_move.dart';

class BookItem extends StatelessWidget {
  final ChessdbMove move;

  const BookItem({Key? key, required this.move}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(move.san!, textAlign: TextAlign.center),
        ),
        Expanded(
          child: Text(move.score, textAlign: TextAlign.center),
        ),
        Expanded(
          child: Text(move.winrate, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}