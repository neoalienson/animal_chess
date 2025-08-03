import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';

class ThreatsEvaluator {
  final GameRules gameRules;
  final GameConfig config;
  final double threatWeight;

  ThreatsEvaluator({
    required this.gameRules,
    required this.config,
    this.threatWeight = 1.0,
  });

  /// Evaluate threats this piece can make to opponent pieces
  double evaluateThreats(
    GameBoard board,
    Position position,
    Piece piece,
    PlayerColor player,
  ) {
    if (piece.playerColor != player) return 0.0;

    double threatScore = 0.0;
    final opponent = player == PlayerColor.red
        ? PlayerColor.green
        : PlayerColor.red;

    // Check if this piece can capture any opponent piece
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final targetPiece = board.getPiece(pos);
        if (targetPiece?.playerColor == opponent) {
          if (gameRules.isValidMove(position, pos, player)) {
            // Can capture - positive value
            // Value based on the rank of the piece being captured
            threatScore += targetPiece!.animalType.rank * 0.5;
          }
        }
      }
    }

    return threatScore * threatWeight;
  }
}
