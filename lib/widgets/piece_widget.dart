import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/piece.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final double squareSize;
  final bool isSelected;
  final VoidCallback onTap;

  const PieceWidget({
    Key? key,
    required this.piece,
    required this.squareSize,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pieceSize = squareSize-3; // Điều chỉnh kích thước quân cờ
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        alignment: Alignment.center, // Căn giữa quân cờ
        child: SvgPicture.asset(
          piece.assetPath,
          width: pieceSize,
          height: pieceSize,
        ),
      ),
    );
  }
}