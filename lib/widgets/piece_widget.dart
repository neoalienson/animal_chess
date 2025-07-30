import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/piece.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size; // New parameter for piece size
  final bool isRankDisplay; // New parameter for rank display

  const PieceWidget({
    super.key,
    required this.piece,
    this.isSelected = false,
    this.onTap,
    this.size = 40.0, // Default size
    this.isRankDisplay = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the piece size as 90% of the block size
    final pieceSize = size * 0.9;

    // Define colors for each player
    Color backgroundColor = piece.playerColor == PlayerColor.green
        ? Colors.green[300]!
        : Colors.red[300]!;

    // Define text color for better contrast
    Color textColor = Colors.white;

    // If this is for rank display, use dark grey with white text
    if (isRankDisplay) {
      backgroundColor = Colors.grey[800]!; // Dark grey
      textColor = Colors.white; // White text
    }

    // Add selection indicator (only for game board, not rank display)
    if (isSelected && !isRankDisplay) {
      backgroundColor = piece.playerColor == PlayerColor.green
          ? Colors.green[700]!
          : Colors.red[700]!;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: pieceSize,
        height: pieceSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected && !isRankDisplay ? Colors.yellow : Colors.black,
            width: isSelected && !isRankDisplay ? 3 : 1,
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
