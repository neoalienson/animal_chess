import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/player_color.dart';

class Piece {
  final AnimalType animalType;
  final PlayerColor playerColor;

  Piece(this.animalType, this.playerColor);

  // Getter to access playerColor as player for compatibility
  PlayerColor get player => playerColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Piece &&
        other.animalType == animalType &&
        other.playerColor == playerColor;
  }

  @override
  int get hashCode => Object.hash(animalType, playerColor);

  @override
  String toString() => '${playerColor.name} ${animalType.name}';

  /// Check if this piece can capture the opponent piece
  bool canCapture(Piece opponent) {
    // Pieces in traps can be captured by any opponent piece
    // This logic should be handled in the game controller, not here

    // Same player pieces cannot capture each other
    if (playerColor == opponent.playerColor) return false;

    // Rat can capture Elephant and vice versa (special rule)
    if (animalType == AnimalType.rat &&
        opponent.animalType == AnimalType.elephant) {
      return true;
    }

    if (animalType == AnimalType.elephant &&
        opponent.animalType == AnimalType.rat) {
      return true;
    }

    // Normal capture: can capture equal or lower rank pieces
    return animalType.rank <= opponent.animalType.rank;
  }
}
