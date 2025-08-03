import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';

class BoardEvaluator {
  final GameRules gameRules;
  final GameConfig config;

  // Configurable weights (with defaults)
  final double safetyWeight;
  final double denProximityWeight;
  final double pieceValueWeight;
  final double threatWeight;
  final double areaControlWeight;

  BoardEvaluator({
    required this.gameRules,
    required this.config,
    this.safetyWeight = 0.7,
    this.denProximityWeight = 1.2,
    this.pieceValueWeight = 0.9,
    this.threatWeight = 1.0,
    this.areaControlWeight = 0.0,
  });

  /// Main evaluation function that scores the board state for a player
  BoardEvaluationResult evaluateBoardState(GameBoard board, PlayerColor player) {
    double safety = 0.0;
    double pieceValue = 0.0;
    double threats = 0.0;
    double denProximity = 0.0;
    double areaControl = 0.0;

    // Evaluate each piece on the board
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);

        if (piece != null) {
          // Add or subtract based on piece value
          final pieceValueComponent = evaluatePieceValue(piece, pos, player);
          pieceValue += pieceValueComponent;

          // Evaluate safety of the piece
          final safetyComponent = evaluateSafety(board, pos, player);
          safety += safetyComponent * safetyWeight;

          // Evaluate threats this piece can make
          final threatsComponent = evaluateThreats(board, pos, piece, player);
          threats += threatsComponent * threatWeight;
        }
      }
    }

    // Evaluate proximity to opponent's den
    final denProximityComponent = evaluateDenProximity(board, player);
    denProximity += denProximityComponent * denProximityWeight;

    // Evaluate area control 
    final areaControlComponent = _calculateAreaControlScore(board, player);
    areaControl += areaControlComponent * areaControlWeight;

    // Calculate final score
    final score = safety + pieceValue + threats + denProximity + areaControl;

    return BoardEvaluationResult(
      safety: safety,
      pieceValue: pieceValue,
      threats: threats,
      denProximity: denProximity,
      areaControl: areaControl,
      score: score,
    );
  }

  /// Evaluate the value of a piece based on its rank and position
  double evaluatePieceValue(
    Piece piece,
    Position position,
    PlayerColor player,
  ) {
    final isOwnPiece = piece.playerColor == player;
    final rankValue = piece.animalType.rank;

    // Base value is the rank of the piece
    double value = rankValue.toDouble();

    // Adjust for player perspective
    if (!isOwnPiece) {
      value = -value;
    }

    return value * pieceValueWeight;
  }

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

    return threatScore;
  }

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

    return threatScore;
  }

  /// Evaluate proximity to opponent's den
  double evaluateDenProximity(GameBoard board, PlayerColor player) {
    final opponentDenPosition = player == PlayerColor.red
        ? Position(3, 8) // Green player's den
        : Position(3, 0); // Red player's den

    double closestDistance = double.infinity;
    double totalProximity = 0.0;

    // Find the closest piece to opponent's den
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        if (piece?.playerColor == player) {
          final distance =
              (pos.column - opponentDenPosition.column).abs() +
              (pos.row - opponentDenPosition.row).abs();

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

    // Convert distance to score (smaller distance = higher score)
    return closestDistance == double.infinity
        ? 0.0
        : (10.0 - closestDistance) * totalProximity;
  }

  /// Calculate area control score for a player (pieces with clear paths to den)
  double _calculateAreaControlScore(GameBoard board, PlayerColor player) {
    final denPos = player == PlayerColor.red ? Position(3, 8) : Position(3, 0);
    double score = 0.0;
    
    // Only evaluate pieces in the den column (column 3)
    for (int row = 0; row < 9; row++) {
      final pos = Position(3, row);
      final piece = board.getPiece(pos);
      
      if (piece?.playerColor == player) {
        // Check if the path to the den is clear of opponent pieces
        final pathClear = _isPathClear(board, pos, denPos, player);
        if (pathClear) {
          // Higher score for pieces closer to the den
          final distance = (pos.row - denPos.row).abs();
          score += 1.0 / (distance + 1);
        }
      }
    }
    
    return score;
  }

  /// Check if the path between a piece and the den is clear of opponent pieces
  bool _isPathClear(GameBoard board, Position piecePos, Position denPos, PlayerColor player) {
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
