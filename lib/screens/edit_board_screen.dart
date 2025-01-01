import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/widgets/chess_board_widget.dart';
import 'package:rose_chess/widgets/piece_widget.dart';
import '../constants.dart';
import '../generated/l10n.dart';
import '../models/piece.dart';
import '../providers/board_edit_state.dart';
import '../utils/board.dart';

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
          builder: (context, boardState, child) => LayoutBuilder(
            builder: (context, constraints) {
              const double paddingValue = 10.0;
              final boardWidth = constraints.maxWidth - (2 * paddingValue);
              final squareSize = boardWidth / MAX_COLS;
              boardState.squareSize = squareSize;

              saveBoard() {
                final fen =
                    generateFen(boardState.board, boardState.selectedColor);
                    print('FEN before pop: $fen');
                    Navigator.pop(context, fen);
              }

              return Column(
                children: [
                  Stack(
                    children: [
                      ChessBoardWidget(boardState: boardState),
                      if (boardState.showPopup)
                        Positioned(
                          left: boardState.popupPosition.dx,
                          top: boardState.popupPosition.dy,
                          child: RemovedPiecesPopup(
                            redpieces: boardState.removedPiecesRed,
                            blackpieces: boardState.removedPiecesBlack,
                            onPieceSelected: (piece) => boardState.restorePiece(
                                piece, boardState.selectedEmptyPosition!),
                            onDismiss: () => boardState.hidePopup(),
                            squareSize: squareSize,
                          ),
                        ),
                    ],
                  ),
                  /**
                   * button for startboard, emptyboard,save
                   * radio button for red and black
                   */
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            boardState.resetBoard();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Khởi tạo"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            boardState.clearBoard();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Xóa"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Đổi bên"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            saveBoard();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Lưu"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Quân đỏ"),
                        Radio<String>(
                          value: PieceColor.red.name,
                          groupValue: boardState.selectedColor,
                          onChanged: (value) {
                            boardState.selectedColor = PieceColor.red.name;
                          },
                          activeColor: Colors.red,
                        ),
                        const SizedBox(width: 18),
                        const Text("Quân đen"),
                        Radio<String>(
                          value: PieceColor.black.name,
                          groupValue: boardState.selectedColor,
                          onChanged: (value) {
                            boardState.selectedColor = PieceColor.black.name;
                          },
                          activeColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow[800]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hướng dẫn:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "1.Nhấn đúp vào quân cờ để xóa.",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "2.Nhấn vào ô trống, sau đó chọn quân cờ từ bảng chọn để thêm vào.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class RemovedPiecesPopup extends StatelessWidget {
  final Function(Piece) onPieceSelected;
  final VoidCallback onDismiss;
  final double squareSize;
  final List<Piece> redpieces;
  final List<Piece> blackpieces;

  const RemovedPiecesPopup({
    Key? key,
    required this.redpieces,
    required this.blackpieces,
    required this.onPieceSelected,
    required this.onDismiss,
    required this.squareSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        (squareSize + 4) * max(blackpieces.length, redpieces.length) + 16;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(4),
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: redpieces
                    .map((piece) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: SizedBox(
                            width: squareSize,
                            height: squareSize,
                            child: PieceWidget(
                              piece: piece,
                              squareSize: squareSize,
                              isSelected: false,
                              onTap: () => onPieceSelected(piece),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: blackpieces
                    .map((piece) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: SizedBox(
                            width: squareSize,
                            height: squareSize,
                            child: PieceWidget(
                              piece: piece,
                              squareSize: squareSize,
                              isSelected: false,
                              onTap: () => onPieceSelected(piece),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
