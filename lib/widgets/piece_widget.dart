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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: SvgPicture.asset(
          piece.assetPath,
          width: squareSize,
          height: squareSize,
        ),
      ),
    );
  }
}