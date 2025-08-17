import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/constants/ui_constants.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size; // New parameter for piece size
  final bool isRankDisplay; // New parameter for rank display
  final String? animalName; // New parameter for localized animal name
  final PieceDisplayFormat displayFormat; // New parameter for display format

  const PieceWidget({
    super.key,
    required this.piece,
    this.isSelected = false,
    this.onTap,
    this.size = 40.0, // Default size
    this.isRankDisplay = false, // Default to false
    this.animalName, // Allow passing a localized name
    this.displayFormat =
        PieceDisplayFormat.traditionalChinese, // Default to traditional Chinese
  });

  /// Returns the animal symbol based on the selected display format
  String _getAnimalSymbol(AnimalType animalType) {
    switch (displayFormat) {
      case PieceDisplayFormat.emoji:
        return _getEmojiSymbol(animalType);
      case PieceDisplayFormat.simplifiedChinese:
        return _getSimplifiedChineseSymbol(animalType);
      case PieceDisplayFormat.traditionalChinese:
        return _getTraditionalChineseSymbol(animalType);
    }
  }

  /// Returns the emoji symbol for the animal
  String _getEmojiSymbol(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.elephant:
        return '🐘';
      case AnimalType.lion:
        return '🦁';
      case AnimalType.tiger:
        return '🐯';
      case AnimalType.leopard:
        return '🐆';
      case AnimalType.wolf:
        return '🐺';
      case AnimalType.dog:
        return '🐕';
      case AnimalType.cat:
        return '🐈';
      case AnimalType.rat:
        return '🐀';
    }
  }

  /// Returns the simplified Chinese symbol for the animal
  String _getSimplifiedChineseSymbol(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.elephant:
        return '象';
      case AnimalType.lion:
        return '狮';
      case AnimalType.tiger:
        return '虎';
      case AnimalType.leopard:
        return '豹';
      case AnimalType.wolf:
        return '狼';
      case AnimalType.dog:
        return '狗';
      case AnimalType.cat:
        return '猫';
      case AnimalType.rat:
        return '鼠';
    }
  }

  /// Returns the traditional Chinese symbol for the animal
  String _getTraditionalChineseSymbol(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.elephant:
        return '象';
      case AnimalType.lion:
        return '獅';
      case AnimalType.tiger:
        return '虎';
      case AnimalType.leopard:
        return '豹';
      case AnimalType.wolf:
        return '狼';
      case AnimalType.dog:
        return '狗';
      case AnimalType.cat:
        return '貓';
      case AnimalType.rat:
        return '鼠';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the piece size as 90% of the block size
    final pieceSize = size * UIConstants.pieceSizeFactor;

    // Define colors for each player
    Color backgroundColor = piece.playerColor == PlayerColor.green
        ? UIConstants.greenPieceColor
        : UIConstants.redPieceColor;

    // Define text color for better contrast
    Color textColor = UIConstants.pieceTextColor;

    // If this is for rank display, use dark grey with white text
    if (isRankDisplay) {
      backgroundColor = UIConstants.rankDisplayBackgroundColor; // Dark grey
      textColor = UIConstants.pieceTextColor; // White text
    }

    // Add selection indicator (only for game board, not rank display)
    if (isSelected && !isRankDisplay) {
      backgroundColor = piece.playerColor == PlayerColor.green
          ? UIConstants.greenPieceColor
          : UIConstants.redPieceColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(UIConstants.pieceTapPadding),
        child: Container(
          width: pieceSize,
          height: pieceSize,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected && !isRankDisplay
                  ? UIConstants.pieceBorderColorSelected
                  : UIConstants.pieceBorderColorNormal,
              width: isSelected && !isRankDisplay
                  ? UIConstants.pieceBorderWidthSelected
                  : UIConstants.pieceBorderWidthNormal,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.alphaBlend(
                  UIConstants.pieceShadowColor.withOpacity(0.2),
                  Colors.transparent,
                ),
                blurRadius: UIConstants.pieceShadowBlurRadius,
                offset: UIConstants.pieceShadowOffset,
              ),
            ],
          ),
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, -2), // Move up by 5 pixels
              child: Text(
                _getAnimalSymbol(piece.animalType),
                style: TextStyle(
                  color: textColor,
                  fontSize:
                      pieceSize *
                      UIConstants
                          .pieceFontSizeFactor, // Adjust font size proportionally
                  fontWeight: FontWeight.bold,
                  height: 1.0, // Ensures proper vertical centering
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
