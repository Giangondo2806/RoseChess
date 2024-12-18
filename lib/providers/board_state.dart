import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../models/board_position.dart';
import '../constants.dart';

class BoardState with ChangeNotifier {
  // Board dimensions
  final int rows = 10;
  final int cols = 9;

  // Initial board setup (using a map for easier access)
  late Map<BoardPosition, Piece?> board;

  // Currently selected piece position
  BoardPosition? selectedPosition;
  // Map to track the location of the pieces by ID.
  late Map<String, BoardPosition> piecePositions;

  BoardState() {
    piecePositions = {}; // Khởi tạo ở đây
    initializeBoard();
  }

  void initializeBoard() {
    board = {};
    int idCounter = 0; // Bắt đầu từ 0
    for (int i = 0; i < initialBoard.length; i++) {
      for (int j = 0; j < initialBoard[i].length; j++) {
        final pieceData = initialBoard[i][j];
        if (pieceData != null) {
          final notation = pieceData['notion'];
          final type = _getPieceType(pieceData['type']);
          final color = _getPieceColor(pieceData['color']);
          final assetPath = _getAssetPath(type, color);
          final piece = Piece(
              id: 'piece_$idCounter',
              type: type,
              color: color,
              assetPath: assetPath); // Gán ID
          board[BoardPosition(notation)] = piece;
          piecePositions[piece.id] = BoardPosition(notation);
          idCounter++;
        }
      }
    }
  }

  PieceType _getPieceType(String type) {
    switch (type) {
      case 'r':
        return PieceType.rook;
      case 'n':
        return PieceType.knight;
      case 'b':
        return PieceType.bishop;
      case 'a':
        return PieceType.advisor;
      case 'k':
        return PieceType.king;
      case 'c':
        return PieceType.cannon;
      case 'p':
        return PieceType.pawn;
      default:
        return PieceType.none;
    }
  }

  PieceColor _getPieceColor(String color) {
    switch (color) {
      case 'r':
        return PieceColor.red;
      case 'b':
        return PieceColor.black;
      default:
        return PieceColor.red;
    }
  }

  String _getAssetPath(PieceType type, PieceColor color) {
    switch (type) {
      case PieceType.rook:
        return color == PieceColor.red ? RR : BR;
      case PieceType.knight:
        return color == PieceColor.red ? RN : BN;
      case PieceType.bishop:
        return color == PieceColor.red ? RB : BB;
      case PieceType.advisor:
        return color == PieceColor.red ? RA : BA;
      case PieceType.king:
        return color == PieceColor.red ? RK : BK;
      case PieceType.cannon:
        return color == PieceColor.red ? RC : BC;
      case PieceType.pawn:
        return color == PieceColor.red ? RP : BP;
      default:
        return '';
    }
  }

  void onPieceTapped(BoardPosition position) {
    if (selectedPosition == null) {
      if (board[position] != null) {
        selectedPosition = position;
      }
    } else {
      if (position != selectedPosition) {
        if (board[position] == null ||
            (board[selectedPosition] != null && board[position]!.color != board[selectedPosition]!.color)) {
            if(board[selectedPosition] == null){
                  selectedPosition = null;
                  notifyListeners();
                  return;
                }
            final piece = board[selectedPosition]!;

            board[position] = piece;
            board[selectedPosition!] = null;

            piecePositions[piece.id] = position;

            selectedPosition = null;
        } else {
            selectedPosition = position;
        }
      } else {
         selectedPosition = null;
      }
    }
    notifyListeners();
  }
}