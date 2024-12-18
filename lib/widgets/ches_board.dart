import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Assets paths
const String boardAsset = 'assets/images/xiangqiboards/wikimedia.svg';
const String RR = 'assets/images/xiangqipieces/wikipedia/rr.svg';
const String RN = 'assets/images/xiangqipieces/wikipedia/rn.svg';
const String RB = 'assets/images/xiangqipieces/wikipedia/rb.svg';
const String RA = 'assets/images/xiangqipieces/wikipedia/ra.svg';
const String RK = 'assets/images/xiangqipieces/wikipedia/rk.svg';
const String RC = 'assets/images/xiangqipieces/wikipedia/rc.svg';
const String RP = 'assets/images/xiangqipieces/wikipedia/rp.svg';
const String BR = 'assets/images/xiangqipieces/wikipedia/br.svg';
const String BN = 'assets/images/xiangqipieces/wikipedia/bn.svg';
const String BB = 'assets/images/xiangqipieces/wikipedia/bb.svg';
const String BA = 'assets/images/xiangqipieces/wikipedia/ba.svg';
const String BK = 'assets/images/xiangqipieces/wikipedia/bk.svg';
const String BC = 'assets/images/xiangqipieces/wikipedia/bc.svg';
const String BP = 'assets/images/xiangqipieces/wikipedia/bp.svg';

// Enum for piece types
enum PieceType { rook, knight, bishop, advisor, king, cannon, pawn, none }

// Enum for piece colors
enum PieceColor { red, black }

// Piece class
class Piece {
  final PieceType type;
  final PieceColor color;
  final String assetPath;

  Piece({required this.type, required this.color, required this.assetPath});
}

// Board position (using notation like 'a9', 'b8', etc.)
class BoardPosition {
  final String notation;

  BoardPosition(this.notation);

  // Convert notation to row and column
  int get row {
    return 9 - int.parse(notation[1]);
  }

  int get col {
    return notation.codeUnitAt(0) - 'a'.codeUnitAt(0);
  }

  @override
  bool operator ==(Object other) {
    return other is BoardPosition && notation == other.notation;
  }

  @override
  int get hashCode => notation.hashCode;
}

class ChessBoardWidget extends StatefulWidget {
  const ChessBoardWidget({Key? key}) : super(key: key);

  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  // Board dimensions
  final int rows = 10;
  final int cols = 9;

  // Initial board setup (using a map for easier access)
  late Map<BoardPosition, Piece?> board;

  // Currently selected piece position
  BoardPosition? selectedPosition;

  // Mapping of notations to hexadecimal values (SQUARES)
  static const Map<String, int> SQUARES = {
    'a9': 0x00,
    'b9': 0x01,
    'c9': 0x02,
    'd9': 0x03,
    'e9': 0x04,
    'f9': 0x05,
    'g9': 0x06,
    'h9': 0x07,
    'i9': 0x08,
    'a8': 0x10,
    'b8': 0x11,
    'c8': 0x12,
    'd8': 0x13,
    'e8': 0x14,
    'f8': 0x15,
    'g8': 0x16,
    'h8': 0x17,
    'i8': 0x18,
    'a7': 0x20,
    'b7': 0x21,
    'c7': 0x22,
    'd7': 0x23,
    'e7': 0x24,
    'f7': 0x25,
    'g7': 0x26,
    'h7': 0x27,
    'i7': 0x28,
    'a6': 0x30,
    'b6': 0x31,
    'c6': 0x32,
    'd6': 0x33,
    'e6': 0x34,
    'f6': 0x35,
    'g6': 0x36,
    'h6': 0x37,
    'i6': 0x38,
    'a5': 0x40,
    'b5': 0x41,
    'c5': 0x42,
    'd5': 0x43,
    'e5': 0x44,
    'f5': 0x45,
    'g5': 0x46,
    'h5': 0x47,
    'i5': 0x48,
    'a4': 0x50,
    'b4': 0x51,
    'c4': 0x52,
    'd4': 0x53,
    'e4': 0x54,
    'f4': 0x55,
    'g4': 0x56,
    'h4': 0x57,
    'i4': 0x58,
    'a3': 0x60,
    'b3': 0x61,
    'c3': 0x62,
    'd3': 0x63,
    'e3': 0x64,
    'f3': 0x65,
    'g3': 0x66,
    'h3': 0x67,
    'i3': 0x68,
    'a2': 0x70,
    'b2': 0x71,
    'c2': 0x72,
    'd2': 0x73,
    'e2': 0x74,
    'f2': 0x75,
    'g2': 0x76,
    'h2': 0x77,
    'i2': 0x78,
    'a1': 0x80,
    'b1': 0x81,
    'c1': 0x82,
    'd1': 0x83,
    'e1': 0x84,
    'f1': 0x85,
    'g1': 0x86,
    'h1': 0x87,
    'i1': 0x88,
    'a0': 0x90,
    'b0': 0x91,
    'c0': 0x92,
    'd0': 0x93,
    'e0': 0x94,
    'f0': 0x95,
    'g0': 0x96,
    'h0': 0x97,
    'i0': 0x98,
  };

  // Initial board setup as a 2D array
  final List<List<Map<String, dynamic>?>> initialBoard = [
    [
      {'type': 'r', 'color': 'b', 'notion': 'a9'},
      {'type': 'n', 'color': 'b', 'notion': 'b9'},
      {'type': 'b', 'color': 'b', 'notion': 'c9'},
      {'type': 'a', 'color': 'b', 'notion': 'd9'},
      {'type': 'k', 'color': 'b', 'notion': 'e9'},
      {'type': 'a', 'color': 'b', 'notion': 'f9'},
      {'type': 'b', 'color': 'b', 'notion': 'g9'},
      {'type': 'n', 'color': 'b', 'notion': 'h9'},
      {'type': 'r', 'color': 'b', 'notion': 'i9'}
    ],
    [null, null, null, null, null, null, null, null, null],
    [
      null,
      {'type': 'c', 'color': 'b', 'notion': 'b7'},
      null,
      null,
      null,
      null,
      null,
      {'type': 'c', 'color': 'b', 'notion': 'h7'},
      null
    ],
    [
      {'type': 'p', 'color': 'b', 'notion': 'a6'},
      null,
      {'type': 'p', 'color': 'b', 'notion': 'c6'},
      null,
      {'type': 'p', 'color': 'b', 'notion': 'e6'},
      null,
      {'type': 'p', 'color': 'b', 'notion': 'g6'},
      null,
      {'type': 'p', 'color': 'b', 'notion': 'i6'}
    ],
    [null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null],
    [
      {'type': 'p', 'color': 'r', 'notion': 'a3'},
      null,
      {'type': 'p', 'color': 'r', 'notion': 'c3'},
      null,
      {'type': 'p', 'color': 'r', 'notion': 'e3'},
      null,
      {'type': 'p', 'color': 'r', 'notion': 'g3'},
      null,
      {'type': 'p', 'color': 'r', 'notion': 'i3'}
    ],
    [
      null,
      {'type': 'c', 'color': 'r', 'notion': 'b2'},
      null,
      null,
      null,
      null,
      null,
      {'type': 'c', 'color': 'r', 'notion': 'h2'},
      null
    ],
    [null, null, null, null, null, null, null, null, null],
    [
      {'type': 'r', 'color': 'r', 'notion': 'a0'},
      {'type': 'n', 'color': 'r', 'notion': 'b0'},
      {'type': 'b', 'color': 'r', 'notion': 'c0'},
      {'type': 'a', 'color': 'r', 'notion': 'd0'},
      {'type': 'k', 'color': 'r', 'notion': 'e0'},
      {'type': 'a', 'color': 'r', 'notion': 'f0'},
      {'type': 'b', 'color': 'r', 'notion': 'g0'},
      {'type': 'n', 'color': 'r', 'notion': 'h0'},
      {'type': 'r', 'color': 'r', 'notion': 'i0'}
    ]
  ];

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    board = {};
    for (int i = 0; i < initialBoard.length; i++) {
      for (int j = 0; j < initialBoard[i].length; j++) {
        final pieceData = initialBoard[i][j];
        if (pieceData != null) {
          final notation = pieceData['notion'];
          final type = _getPieceType(pieceData['type']);
          final color = _getPieceColor(pieceData['color']);
          final assetPath = _getAssetPath(type, color);
          board[BoardPosition(notation)] =
              Piece(type: type, color: color, assetPath: assetPath);
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
        return PieceColor.red; // You can change the default color if needed
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

      void _onPieceTapped(BoardPosition position) {
    setState(() {
      if (selectedPosition == null) {
        // Select the piece only if it's not empty and it's the player's turn
        if (board[position] != null) {
          selectedPosition = position;
          print('Selected: ${selectedPosition?.notation}');
        }
      } else {
        // Handle move only if the tapped position is different from the selected position
        if (position != selectedPosition) {
          // Move the piece if the destination is empty or has an opponent's piece
          if (board[position] == null || board[position]!.color != board[selectedPosition!]!.color) {
            print('Moving from ${selectedPosition?.notation} to ${position.notation}');
            // Update the board map
            board[position] = board[selectedPosition];
            board[selectedPosition!] = null; // Set the old position to empty
            print('Board updated');

            // Deselect the piece after moving
            selectedPosition = null;

            // TODO: Switch player turn after moving (you'll need to implement this)
          } else {
            // If the destination has the same color, select the new piece
            selectedPosition = position;
            print('Selected: ${selectedPosition?.notation}');
          }
        } else {
          // If tapping the same piece, deselect it
          selectedPosition = null;
          print('Deselected');
        }
      }
    });
  }

 @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardWidth = constraints.maxWidth;
        final squareSize = boardWidth / cols;

        return Center(
          child: AspectRatio(
            aspectRatio: cols / rows,
            child: Stack(
              children: [
                // Board image
                SvgPicture.asset(
                  boardAsset,
                  width: boardWidth,
                  height: boardWidth * (rows / cols),
                ),
                // Pieces and Empty Squares
                ..._buildSquares(squareSize),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build all squares (both with and without pieces)
  List<Widget> _buildSquares(double squareSize) {
    List<Widget> squares = [];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final position = BoardPosition(String.fromCharCode('a'.codeUnitAt(0) + j) + (9 - i).toString());
        final piece = board[position];

        squares.add(
          Positioned(
            left: j * squareSize,
            top: i * squareSize,
            width: squareSize,
            height: squareSize,
            child: GestureDetector(
              onTap: () => _onPieceTapped(position),
              child: Container(
                decoration: BoxDecoration(
                  border: selectedPosition == position
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: piece != null
                    ? SvgPicture.asset(
                        piece.assetPath,
                        width: squareSize,
                        height: squareSize,
                      )
                    : null, // No child if the square is empty
              ),
            ),
          ),
        );
      }
    }
    return squares;
  }
}
