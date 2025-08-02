import 'package:animal_chess/game/rules/game_rule_variant.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';

/// Dog river variant implementation
/// In this variant, dogs can also enter rivers (in addition to rats)
class DogRiverVariant implements GameRuleVariant {
  final GameRuleVariant _baseVariant;

  DogRiverVariant(this._baseVariant);

  @override
  bool canEnterRiver(
    Piece piece,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // If dog river variant is enabled, dogs can also enter rivers
    if (gameConfig.dogRiverVariant) {
      return piece.animalType == AnimalType.rat ||
          piece.animalType == AnimalType.dog;
    }

    // Otherwise, delegate to base variant
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
