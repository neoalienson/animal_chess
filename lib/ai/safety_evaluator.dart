import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';

class SafetyEvaluator {
  final GameRules gameRules;
  final GameConfig config;
  final double safetyWeight;

  SafetyEvaluator({
    required this.gameRules,
    required this.config,
    this.safetyWeight = 0.7,
  });

  /// Evaluate safety of a position by checking valid opponent capture moves
  double evaluateSafety(
    GameBoard board,
    Position position,
    PlayerColor player,
  ) {
    final piece = board.getPiece(position);
    if (piece == null) return 0.0;

    final opponent = player == PlayerColor.red
        ? PlayerColor.green
        : PlayerColor.red;
    double threatScore = 0.0;

    // Check if any opponent piece can capture this piece
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final opponentPiece = board.getPiece(pos);
        if (opponentPiece?.playerColor == opponent) {
          if (gameRules.isValidMove(pos, position, opponent)) {
            // Threat is more significant for higher rank pieces
            threatScore -= (9 - opponentPiece!.animalType.rank) * 0.7;
          }
        }
      }
    }

    return threatScore * safetyWeight;
  }
}
