import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';

class PieceValueEvaluator {
  final GameRules gameRules;
  final GameConfig config;
  final double pieceValueWeight;

  PieceValueEvaluator({
    required this.gameRules,
    required this.config,
    this.pieceValueWeight = 0.9,
  });

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
}
