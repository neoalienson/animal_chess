import 'package:animal_chess/game/rules/game_rule_variant.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';

/// Rat capture variant implementation
/// In this variant, rats cannot capture elephants
class RatCaptureVariant implements GameRuleVariant {
  final GameRuleVariant _baseVariant;

  RatCaptureVariant(this._baseVariant);

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
    // If rat cannot capture elephant variant is enabled
    if (gameConfig.ratCannotCaptureElephant) {
      // Rat cannot capture elephant
      if (attacker.animalType == AnimalType.rat &&
          target.animalType == AnimalType.elephant) {
        return false;
      }
    }

    // Delegate to base variant for other capture rules
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
    // Delegate to base variant for jump rules
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
