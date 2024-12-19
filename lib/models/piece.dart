// Enum for piece types
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
