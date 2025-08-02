import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';

/// Base interface for game rule variants
abstract class GameRuleVariant {
  /// Check if a piece can enter a river position
  bool canEnterRiver(
    Piece piece,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  );

  /// Check if a piece can capture another piece
  bool canCapture(
    Piece attacker,
    Piece target,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  );

  /// Check if a piece can jump over a river
  bool canJumpOverRiver(
    Position from,
    Position to,
    Piece piece,
    GameBoard board,
    GameConfig gameConfig,
  );

  /// Check if a move to a den is valid
  bool canMoveToDen(
    Position to,
    PlayerColor currentPlayer,
    GameBoard board,
    GameConfig gameConfig,
  );
}
