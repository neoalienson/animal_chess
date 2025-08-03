import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';

class BoardEvaluator {
  final GameRules gameRules;
  final GameConfig config;

  // Configurable weights (with defaults)
  final double safetyWeight;
  final double denProximityWeight;
  final double pieceValueWeight;
  final double threatWeight;

  BoardEvaluator({
    required this.gameRules,
    required this.config,
    this.safetyWeight = 0.7,
    this.denProximityWeight = 1.2,
    this.pieceValueWeight = 0.9,
    this.threatWeight = 1.0,
  });

  /// Main evaluation function that scores the board state for a player
  double evaluateBoardState(GameBoard board, PlayerColor player) {
    double score = 0.0;

    // Evaluate each piece on the board
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);

        if (piece != null) {
          // Add or subtract based on piece value
          final pieceValue = evaluatePieceValue(piece, pos, player);
          score += pieceValue;

          // Evaluate safety of the piece
          final safety = evaluateSafety(board, pos, player);
          score += safety * safetyWeight;

          // Evaluate threats this piece can make
          final threats = evaluateThreats(board, pos, piece, player);
          score += threats * threatWeight;
        }
      }
    }

    // Evaluate proximity to opponent's den
    final denProximity = evaluateDenProximity(board, player);
    score += denProximity * denProximityWeight;

    return score;
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
}
