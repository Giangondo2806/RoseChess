import 'package:flutter/material.dart';
import 'package:rose_chess/providers/board_state.dart';
import 'package:rose_chess/widgets/chess_board_widget.dart';

import '../generated/l10n.dart';
import '../providers/board_edit_state.dart';
class BoardEditScreen extends StatelessWidget {
  final String fen;
  const BoardEditScreen({Key? key, required  this.fen}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      final lang = AppLocalizations.of(context);
      final BoardState boardState = BoardEditState(lang, fen);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(lang.settingsTitle),
      ), // AppBar
      body: Container(
        child: ChessBoardWidget(boardState: boardState)
      )); // Container
      

  }
}
