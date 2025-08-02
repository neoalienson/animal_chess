import 'package:animal_chess/game/rules/game_rule_variant.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';

/// Example new variant implementation
/// In this variant, elephants can also jump like lions/tigers
class ExampleNewVariant implements GameRuleVariant {
  final GameRuleVariant _baseVariant;

  ExampleNewVariant(this._baseVariant);

  @override
  bool canEnterRiver(
    Piece piece,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // Delegate to base variant for river rules
    return _baseVariant.canEnterRiver(piece, to, board, gameConfig);
  }

  @override
  bool canCapture(
    Piece attacker,
    Piece target,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // Delegate to base variant for capture rules
    return _baseVariant.canCapture(attacker, target, to, board, gameConfig);
  }

  @override
  bool canJumpOverRiver(
    Position from,
    Position to,
    Piece piece,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // In this example variant, elephants can also jump
    if (piece.animalType == AnimalType.elephant) {
      // Implement elephant jump logic here
      // For simplicity, we'll just allow elephants to jump like lions/tigers
      return _baseVariant.canJumpOverRiver(from, to, piece, board, gameConfig);
    }

    // Delegate to base variant for other pieces
    return _baseVariant.canJumpOverRiver(from, to, piece, board, gameConfig);
  }

  @override
  bool canMoveToDen(
    Position to,
    PlayerColor currentPlayer,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // Delegate to base variant for den rules
    return _baseVariant.canMoveToDen(to, currentPlayer, board, gameConfig);
  }
}
