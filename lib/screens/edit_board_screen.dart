// BoardEditScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/widgets/chess_board_widget.dart';
import 'package:rose_chess/widgets/piece_widget.dart';
import '../generated/l10n.dart';
import '../models/piece.dart';
import '../providers/board_edit_state.dart';

class BoardEditScreen extends StatelessWidget {
  final String fen;
  const BoardEditScreen({Key? key, required this.fen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lang.settingsTitle),
      ),
      body: ChangeNotifierProvider<BoardEditState>(
        create: (context) => BoardEditState(lang, fen),
        child: Consumer<BoardEditState>(
          builder: (context, boardState, child) => Stack(
            children: [
              ChessBoardWidget(boardState: boardState),
              // Popup for removed pieces
              if (boardState.showPopup)
                Positioned(
                  left: boardState.popupPosition.dx,
                  top: boardState.popupPosition.dy,
                  child: RemovedPiecesPopup(
                    pieces: boardState.removedPieces,
                    onPieceSelected: (piece) => 
                    boardState.restorePiece(piece, boardState.selectedEmptyPosition!),
                    onDismiss: () => boardState.hidePopup(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemovedPiecesPopup extends StatelessWidget {
  final List<Piece> pieces;
  final Function(Piece) onPieceSelected;
  final VoidCallback onDismiss;

  const RemovedPiecesPopup({
    Key? key,
    required this.pieces,
    required this.onPieceSelected,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(maxWidth: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onDismiss,
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pieces.map((piece) => PieceWidget(
                piece: piece,
                squareSize: 40,
                isSelected: false,
                onTap: () => onPieceSelected(piece),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}