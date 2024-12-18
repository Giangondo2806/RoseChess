

// Enum for piece types
enum PieceType { rook, knight, bishop, advisor, king, cannon, pawn, none }

// Enum for piece colors
enum PieceColor { red, black }

// Piece class
class Piece {
  final PieceType type;
  final PieceColor color;
  final String assetPath;

  const Piece({required this.type, required this.color, required this.assetPath});
}