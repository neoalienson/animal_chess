import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';

class BoardConstants {
  static const int columns = 7;
  static const int rows = 9;

  // Dens positions
  static const Map<PlayerColor, Position> dens = {
    PlayerColor.green: Position(3, 0),
    PlayerColor.red: Position(3, 8),
  };

  // Traps positions
  static const Map<PlayerColor, List<Position>> traps = {
    PlayerColor.green: [Position(2, 0), Position(4, 0), Position(3, 1)],
    PlayerColor.red: [Position(2, 8), Position(4, 8), Position(3, 7)],
  };

  // Rivers positions
  static const List<Position> rivers = [
    // Left river (2x3 area)
    Position(1, 3), Position(1, 4), Position(1, 5),
    Position(2, 3), Position(2, 4), Position(2, 5),
    // Right river (2x3 area)
    Position(4, 3), Position(4, 4), Position(4, 5),
    Position(5, 3), Position(5, 4), Position(5, 5),
  ];
}
