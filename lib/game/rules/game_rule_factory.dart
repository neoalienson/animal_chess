import 'package:animal_chess/game/rules/game_rule_variant.dart';
import 'package:animal_chess/game/rules/standard_game_rule_variant.dart';
import 'package:animal_chess/game/rules/variants/dog_river_variant.dart';
import 'package:animal_chess/game/rules/variants/rat_capture_variant.dart';
import 'package:animal_chess/game/rules/variants/extended_jump_variant.dart';
import 'package:animal_chess/models/game_config.dart';

/// Factory class to create game rule variants based on game configuration
class GameRuleFactory {
  /// Create a game rule variant based on the game configuration
  static GameRuleVariant createRuleVariant(GameConfig gameConfig) {
    // Start with the standard rules
    GameRuleVariant variant = StandardGameRuleVariant();

    // Apply variants in a specific order
    // Note: The order matters as some variants may depend on others
    if (gameConfig.extendedLionTigerJumps) {
      variant = ExtendedJumpVariant(variant);
    }

    if (gameConfig.ratCannotCaptureElephant) {
      variant = RatCaptureVariant(variant);
    }

    if (gameConfig.dogRiverVariant) {
      variant = DogRiverVariant(variant);
    }

    return variant;
  }
}
