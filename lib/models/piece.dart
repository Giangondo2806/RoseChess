// Enum for piece types
import '../constants.dart';
import '../utils/xiangqi.dart';

enum PieceType { rook, knight, bishop, advisor, king, cannon, pawn, none }

// Enum for piece colors
enum PieceColor {
  red('r'),
  black('b');

  final String name;
  const PieceColor(this.name);

  @override
  String toString() => name;
}

class Piece {
  final String id; // Thêm ID cho Piece
  final PieceType type;
  final PieceColor color;
  final String assetPath;

  Piece(
      {required this.id,
      required this.type,
      required this.color,
      required this.assetPath});
}


  Piece createPieceFromData(XiangqiPiece pieceData, String uniqueKey) {
    final type = _getPieceType(pieceData.type);
    final color = _getPieceColor(pieceData.color);
    final assetPath = _getAssetPath(type, color);
    final piece = Piece(
      id: uniqueKey,
      type: type,
      color: color,
      assetPath: assetPath,
    );
    return piece;
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