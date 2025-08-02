import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';

class GameConstants {
  static final Map<PlayerColor, Map<AnimalType, int>> pieceCounts = {
    PlayerColor.green: {
      AnimalType.elephant: 1,
      AnimalType.lion: 1,
      AnimalType.tiger: 1,
      AnimalType.leopard: 1,
      AnimalType.wolf: 1,
      AnimalType.dog: 1,
      AnimalType.cat: 1,
      AnimalType.rat: 1,
    },
    PlayerColor.red: {
      AnimalType.elephant: 1,
      AnimalType.lion: 1,
      AnimalType.tiger: 1,
      AnimalType.leopard: 1,
      AnimalType.wolf: 1,
      AnimalType.dog: 1,
      AnimalType.cat: 1,
      AnimalType.rat: 1,
    },
  };

  static final Map<AnimalType, int> pieceStrengths = {
    AnimalType.elephant: 8,
    AnimalType.lion: 7,
    AnimalType.tiger: 6,
    AnimalType.leopard: 5,
    AnimalType.wolf: 4,
    AnimalType.dog: 3,
    AnimalType.cat: 2,
    AnimalType.rat: 1,
  };

  // Jump distances for lion/tiger movement
  static const int lionTigerHorizontalJumpDistance = 3;
  static const int lionTigerVerticalJumpDistance = 2;
  static const int extendedLionDoubleRiverJumpHorizontal = 4;
  static const int extendedLionDoubleRiverJumpVertical = 3;

  // Piece starting positions
  static final Map<PlayerColor, Map<AnimalType, Position>> pieceStartPositions =
      {
        PlayerColor.green: {
          AnimalType.elephant: Position(6, 2),
          AnimalType.lion: Position(0, 0),
          AnimalType.tiger: Position(6, 0),
          AnimalType.leopard: Position(2, 2),
          AnimalType.wolf: Position(4, 2),
          AnimalType.dog: Position(1, 1),
          AnimalType.cat: Position(5, 1),
          AnimalType.rat: Position(0, 2),
        },
        PlayerColor.red: {
          AnimalType.elephant: Position(0, 6),
          AnimalType.lion: Position(6, 8),
          AnimalType.tiger: Position(0, 8),
          AnimalType.leopard: Position(4, 6),
          AnimalType.wolf: Position(2, 6),
          AnimalType.dog: Position(5, 7),
          AnimalType.cat: Position(1, 7),
          AnimalType.rat: Position(6, 6),
        },
      };
}
