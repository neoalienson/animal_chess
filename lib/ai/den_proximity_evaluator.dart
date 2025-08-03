import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';

class DenProximityEvaluator {
  final GameRules gameRules;
  final GameConfig config;
  final double denProximityWeight;

  DenProximityEvaluator({
    required this.gameRules,
    required this.config,
    this.denProximityWeight = 1.2,
  });

  /// Evaluate proximity to opponent's den
  /// 
  /// This method calculates how close a player's pieces are to the opponent's den.
  /// The closer pieces are to the opponent's den, the more threatening they become,
  /// as they can potentially attack the opponent's pieces or even reach the den itself.
  /// 
  /// Algorithm:
  /// 1. Identify the opponent's den position (red player's den is at (3,0), green player's at (3,8))
  /// 2. For each of the player's pieces:
  ///    - Calculate row distance to opponent's den (only vertical distance)
  ///    - Track the closest piece to the den
  ///    - Accumulate proximity score based on inverse distance
  /// 3. Normalize the score to a maximum value of 1.0 based on:
  ///    - The number of pieces a player has (more pieces = higher max score)
  ///    - Maximum possible score (when all pieces are at row 0 or 8)
  /// 
  /// Parameters:
  ///   board - The current game board state
  ///   player - The player whose pieces we're evaluating
  /// 
  /// Returns:
  ///   A double representing the proximity score normalized to [0, 1]
  double evaluateDenProximity(GameBoard board, PlayerColor player) {
    final opponentDenPosition = player == PlayerColor.red
        ? Position(3, 0) // Green player's den
        : Position(3, 8); // Red player's den

    double closestDistance = double.infinity;
    double totalProximity = 0.0;
    int pieceCount = 0;

    // Find the closest piece to opponent's den and count pieces
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        if (piece?.playerColor == player) {
          pieceCount++;
          // Use only row distance to encourage AI to use the width of the board
          final distance = (pos.row - opponentDenPosition.row).abs();

          if (distance < closestDistance) {
            closestDistance = distance.toDouble();
          }

          // Add inverse of distance as a measure of proximity
          if (distance > 0) {
            totalProximity += 1.0 / distance;
          }
        }
      }
    }

    // Calculate maximum possible score based on piece count
    // Max score is achieved when all pieces are at the closest possible distance (row 0 or 8)
    // For a player with n pieces, maximum score = n * (1.0 / 1) = n (assuming distance 1)
    // But we cap it at a reasonable maximum to prevent over-inflation
    final maxPossibleScore = pieceCount > 0 ? pieceCount : 1.0;
    
    // Convert distance to score (smaller distance = higher score)
    double rawScore = closestDistance == double.infinity
        ? 0.0
        : (10.0 - closestDistance) * totalProximity;
    double score = maxPossibleScore > 0 ? (rawScore / maxPossibleScore/ pieceCount) : 0.0;
    // print('$rawScore, $maxPossibleScore, $totalProximity, $pieceCount, $score');

    // Normalize to [0, 1] range
    return score * denProximityWeight;
  }
}
