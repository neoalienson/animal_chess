import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';

class AreaControlEvaluator {
  final GameRules gameRules;
  final GameConfig config;
  final double areaControlWeight;

  AreaControlEvaluator({
    required this.gameRules,
    required this.config,
    this.areaControlWeight = 0.0,
  });

  /// Calculate area control score for a player (pieces with clear paths to den)
  double calculateAreaControlScore(GameBoard board, PlayerColor player) {
    final denPos = player == PlayerColor.red ? Position(3, 8) : Position(3, 0);
    double score = 0.0;
    
    // Only evaluate pieces in the den column (column 3)
    for (int row = 0; row < 9; row++) {
      final pos = Position(3, row);
      final piece = board.getPiece(pos);
      
      if (piece?.playerColor == player) {
        // Check if the path to the den is clear of opponent pieces
        final pathClear = isPathClear(board, pos, denPos, player);
        if (pathClear) {
          // Higher score for pieces closer to the den
          final distance = (pos.row - denPos.row).abs();
          score += 1.0 / (distance + 1);
        }
      }
    }
    
    return score * areaControlWeight;
  }

  /// Check if the path between a piece and the den is clear of opponent pieces
  bool isPathClear(GameBoard board, Position piecePos, Position denPos, PlayerColor player) {
    final step = (denPos.row - piecePos.row).sign;
    int currentRow = piecePos.row + step;
    
    // Check each position in the path towards the den
    while (currentRow != denPos.row) {
      final checkPos = Position(denPos.column, currentRow);
      final piece = board.getPiece(checkPos);
      if (piece != null && piece.playerColor != player) {
        return false; // Opponent piece blocking the path
      }
      currentRow += step;
    }
    return true;
  }
}
