import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';

class GameConstants {
  // Jump distances
  static const int lionTigerHorizontalJumpDistance = 3;
  static const int lionTigerVerticalJumpDistance = 4;
  static const int extendedLionDoubleRiverJumpHorizontal = 5;
  static const int extendedLionDoubleRiverJumpVertical = 7;
  
  // Piece starting positions
  static const Map<PlayerColor, List<Map<String, dynamic>>> pieceStartPositions = {
    PlayerColor.green: [
      {'type': AnimalType.lion, 'position': Position(0, 0)},
      {'type': AnimalType.tiger, 'position': Position(6, 0)},
      {'type': AnimalType.dog, 'position': Position(1, 1)},
      {'type': AnimalType.cat, 'position': Position(5, 1)},
      {'type': AnimalType.rat, 'position': Position(0, 2)},
      {'type': AnimalType.leopard, 'position': Position(2, 2)},
      {'type': AnimalType.wolf, 'position': Position(4, 2)},
      {'type': AnimalType.elephant, 'position': Position(6, 2)},
    ],
    PlayerColor.red: [
      {'type': AnimalType.lion, 'position': Position(6, 8)},
      {'type': AnimalType.tiger, 'position': Position(0, 8)},
      {'type': AnimalType.dog, 'position': Position(5, 7)},
      {'type': AnimalType.cat, 'position': Position(1, 7)},
      {'type': AnimalType.rat, 'position': Position(6, 6)},
      {'type': AnimalType.leopard, 'position': Position(4, 6)},
      {'type': AnimalType.wolf, 'position': Position(2, 6)},
      {'type': AnimalType.elephant, 'position': Position(0, 6)},
    ],
  };
}