import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rose_chess/utils/xiangqi.dart';

import '../constants.dart';
import '../generated/l10n.dart';
import '../models/board_position.dart';
import '../models/piece.dart';
import '../utils/board.dart';
import 'board_state.dart';

class BoardEditState extends BoardState {
  final AppLocalizations _lang;
  final String _initFen;

  List<Piece> _removedPieces = [];
  List<Piece> get removedPiecesRed {
    final List<Piece> result = [];
    for (int i = 0; i < _removedPieces.length; i++) {
      if (_removedPieces[i].color == PieceColor.red &&
          result.indexWhere((test) => test.type == _removedPieces[i].type) ==
              -1) {
        result.add(_removedPieces[i]);
      }
    }
    return result;
  }

  List<Piece> get removedPiecesBlack {
    final List<Piece> result = [];
    for (int i = 0; i < _removedPieces.length; i++) {
      if (_removedPieces[i].color == PieceColor.black &&
          result.indexWhere((test) => test.type == _removedPieces[i].type) ==
              -1) {
        result.add(_removedPieces[i]);
      }
    }
    return result;
  }

  bool showPopup = false;
  late Offset popupPosition;
  BoardPosition? selectedEmptyPosition;
  late double squareSize;

  BoardEditState(this._lang, this._initFen) {
    initializeBoard(lang: _lang, fen: _initFen);
    calculatorRemovePieces();
  }



  String _selectedColor = 'r';
  set selectedColor(String color) {
    _selectedColor = color;
    notifyListeners();
  }

  String get selectedColor => _selectedColor;

  @override
  void onPieceTapped(BoardPosition position) {
    if(showPopup){
      hidePopup();
    }
    
    if (selectedPosition == null) {
      if (board[position] != null) {
        selectedPosition = position;
      } else {
        // Show popup near the empty square
        showRemovedPiecesPopup(position);
      }
    } else {
      final piece = board[selectedPosition!];
      if (piece != null) {
        if (board[position] != null) {
          _removedPieces.add(board[position]!);
        }
        movePiece(selectedPosition!, position, piece);
      }
    }
    notifyListeners();
  }

  void showRemovedPiecesPopup(BoardPosition position) {
    if (max(removedPiecesBlack.length, removedPiecesRed.length) == 0) {
      return;
    }
    selectedEmptyPosition = position;
    showPopup = true;

    // Calculate popup position
    double x = position.col * squareSize;
    double y = position.row * squareSize;

    // Get screen width
    final screenWidth = (MAX_COLS * squareSize);
    final popupWidth = (squareSize + 4) * max(removedPiecesBlack.length, removedPiecesRed.length) + 16; // Match the width from RemovedPiecesPopup

    // Adjust x position to keep popup visible
    if (x + popupWidth > screenWidth) {
      x = screenWidth - popupWidth;
    }
    x = x.clamp(0, screenWidth - popupWidth);

    // Adjust y position if needed
    final screenHeight = (MAX_ROWS * squareSize);
    final estimatedPopupHeight = 50; // Approximate height of popup
    if (y + estimatedPopupHeight > screenHeight) {
      y = screenHeight - estimatedPopupHeight;
    }
    y = y.clamp(0, screenHeight - estimatedPopupHeight);

    popupPosition = Offset(x, y);
    notifyListeners();
  }

  void hidePopup() {
    showPopup = false;
    selectedEmptyPosition = null;
    notifyListeners();
  }

  void restorePiece(Piece piece, BoardPosition position) {
    board[position] = piece;
    piecePositions[piece.id] = position;
    _removedPieces.remove(piece);
    hidePopup();
    notifyListeners();
  }

  void calculatorRemovePieces() {
    _removedPieces = FULL_PIECES
        .map((e) => createPieceFromData(e, UniqueKey().toString()))
        .toList();
    // lặp qua toàn bộ board
    for (int i = 0; i < MAX_ROWS; i++) {
      for (int j = 0; j < MAX_COLS; j++) {
        final position = BoardPosition.fromRowCol(i, j);
        final piece = board[position];
        if (piece != null) {
          final foundPieceFromAllPiece = _removedPieces.firstWhere(
              (element) =>
                  element.type == piece.type && element.color == piece.color,
              orElse: () => Piece(
                  type: PieceType.king,
                  color: PieceColor.black,
                  assetPath: '',
                  id: '0'));
          if (foundPieceFromAllPiece.id != '0') {
            _removedPieces.remove(foundPieceFromAllPiece);
          }
        }
      }
    }
  }

  void resetBoard() {}

  void clearBoard() {}


}
