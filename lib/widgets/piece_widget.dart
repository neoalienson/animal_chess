import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/piece.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size; // New parameter for piece size

  const PieceWidget({
    super.key,
    required this.piece,
    this.isSelected = false,
    this.onTap,
    this.size = 40.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the piece size as 90% of the block size
    final pieceSize = size * 0.9;

    // Define colors for each player
    Color backgroundColor = piece.playerColor == PlayerColor.green
        ? Colors.green[300]!
        : Colors.red[300]!;

    // Add selection indicator
    if (isSelected) {
      backgroundColor = piece.playerColor == PlayerColor.green
          ? Colors.green[700]!
          : Colors.red[700]!;
    }

    // Define text color for better contrast
    Color textColor = Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: pieceSize,
        height: pieceSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.black,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            piece.animalType.chineseName,
            style: TextStyle(
              color: textColor,
              fontSize: pieceSize * 0.5, // Adjust font size proportionally
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
