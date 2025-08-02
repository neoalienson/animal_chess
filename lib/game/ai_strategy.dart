import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/ai_move.dart';
import 'package:animal_chess/game/game_actions.dart';

class AIStrategy {
  final GameConfig config;

  AIStrategy(this.config);

  /// Calculate the best move for the given player using a greedy algorithm
  Move? calculateBestMove(
    GameBoard board,
    PlayerColor player,
    GameActions gameActions,
  ) {
    // Get all valid moves for current player
    final validMoves = _getAllValidMoves(board, player, gameActions);
    if (validMoves.isEmpty) return null;

    // Score each move and select highest
    Move bestMove = validMoves[0];
    double bestScore = _scoreMove(board, validMoves[0], player, gameActions);

    for (int i = 1; i < validMoves.length; i++) {
      final score = _scoreMove(board, validMoves[i], player, gameActions);
      if (score > bestScore) {
        bestScore = score;
        bestMove = validMoves[i];
      }
    }

    return bestMove;
  }

  /// Get all valid moves for the current player
  List<Move> _getAllValidMoves(
    GameBoard board,
    PlayerColor player,
    GameActions gameActions,
  ) {
    final moves = <Move>[];
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        if (piece?.playerColor == player) {
          final validTargets = gameActions.getValidMoves(pos, player);
          for (final target in validTargets) {
            moves.add(Move(from: pos, to: target));
          }
        }
      }
    }
    return moves;
  }

  /// Score a move based on multiple factors
  double _scoreMove(
    GameBoard board,
    Move move,
    PlayerColor player,
    GameActions gameActions,
  ) {
    double score = 0.0;

    // 1. Capture evaluation (MOST IMPORTANT)
    final targetPiece = board.getPiece(move.to);
    if (targetPiece != null) {
      score += _evaluateCapture(board.getPiece(move.from)!, targetPiece);
    }

    // 2. Den approach evaluation
    score += _evaluateDenProximity(move.to, player);

    // 3. Safety evaluation
    score += _evaluateSafety(board, move.to, player);

    // 4. Special rule considerations
    score += _evaluateSpecialRules(board, move, player);

    return score;
  }

  /// Evaluate capture value
  double _evaluateCapture(Piece attacker, Piece defender) {
    // Special case: Rat capturing Elephant (highest value play)
    if (attacker.animalType == AnimalType.rat &&
        defender.animalType == AnimalType.elephant) {
      return 10.0; // Highest priority capture
    }

    // Standard captures - positive for advantageous captures
    final rankDiff = attacker.animalType.rank - defender.animalType.rank;
    return rankDiff < 0 ? (-rankDiff) * 0.8 : 0;
  }

  /// Evaluate proximity to opponent's den
  double _evaluateDenProximity(Position position, PlayerColor player) {
    // Den positions (opponent's den)
    final denPos = player == PlayerColor.red ? Position(3, 0) : Position(3, 8);

    // Calculate Manhattan distance
    final distance =
        (position.column - denPos.column).abs() +
        (position.row - denPos.row).abs();

    // Non-linear scoring: more valuable as we get closer
    return distance <= 1 ? 3.0 : (distance <= 3 ? 2.0 : 1.0);
  }

  /// Evaluate safety of a position
  double _evaluateSafety(
    GameBoard board,
    Position position,
    PlayerColor player,
  ) {
    double safetyScore = 0.0;
    final opponent = player == PlayerColor.red
        ? PlayerColor.green
        : PlayerColor.red;

    // Check if any opponent pieces can capture this position next turn
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        if (piece?.playerColor == opponent) {
          // Create a temporary GameActions to check if opponent can capture
          // This is a simplified check - in reality, we'd need to check all valid moves
          if (_canCapture(piece!, board.getPiece(position))) {
            // Higher penalty for being captured by higher rank
            safetyScore -= (9 - piece.animalType.rank) * 0.5;
          }
        }
      }
    }

    return safetyScore;
  }

  /// Check if a piece can capture a target piece
  bool _canCapture(Piece attacker, Piece? target) {
    if (target == null) return false;

    // Can't capture own pieces
    if (target.playerColor == attacker.playerColor) return false;

    // Use the Piece's canCapture method
    return attacker.canCapture(target);
  }

  /// Evaluate special rules considerations
  double _evaluateSpecialRules(GameBoard board, Move move, PlayerColor player) {
    double score = 0.0;

    // River crossing evaluation
    if (board.isRiver(move.to) && !board.isRiver(move.from)) {
      // Penalize river entry unless strategic
      final piece = board.getPiece(move.from)!;
      if (piece.animalType.rank < AnimalType.wolf.rank) {
        score -= 0.5; // Small penalty for weaker animals in river
      }
    }

    // Den entry validation
    if (move.to ==
        (player == PlayerColor.red ? Position(3, 0) : Position(3, 8))) {
      if (!config.ratOnlyDenEntry ||
          board.getPiece(move.from)!.animalType == AnimalType.rat) {
        score += 2.0; // Valid den entry
      }
    }

    return score;
  }
}
