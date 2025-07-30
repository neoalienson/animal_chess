import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/piece.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final bool isSelected;
  final VoidCallback? onTap;

  const PieceWidget({
    super.key,
    required this.piece,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        width: 40,
        height: 40,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
