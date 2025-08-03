import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'board_evaluation_result.dart';
import 'piece_value_evaluator.dart';
import 'safety_evaluator.dart';
import 'threats_evaluator.dart';
import 'den_proximity_evaluator.dart';
import 'area_control_evaluator.dart';

class BoardEvaluator {
  final GameRules gameRules;
  final GameConfig config;

  // Configurable weights (with defaults)
  final double safetyWeight;
  final double denProximityWeight;
  final double pieceValueWeight;
  final double threatWeight;
  final double areaControlWeight;

  final PieceValueEvaluator pieceValueEvaluator;
  final SafetyEvaluator safetyEvaluator;
  final ThreatsEvaluator threatsEvaluator;
  final DenProximityEvaluator denProximityEvaluator;
  final AreaControlEvaluator areaControlEvaluator;

  BoardEvaluator({
    required this.gameRules,
    required this.config,
    this.safetyWeight = 0.7,
    this.denProximityWeight = 1.2,
    this.pieceValueWeight = 0.9,
    this.threatWeight = 1.0,
    this.areaControlWeight = 0.0,
  })  : pieceValueEvaluator = PieceValueEvaluator(
          gameRules: gameRules,
          config: config,
          pieceValueWeight: pieceValueWeight,
        ),
        safetyEvaluator = SafetyEvaluator(
          gameRules: gameRules,
          config: config,
          safetyWeight: safetyWeight,
        ),
        threatsEvaluator = ThreatsEvaluator(
          gameRules: gameRules,
          config: config,
          threatWeight: threatWeight,
        ),
        denProximityEvaluator = DenProximityEvaluator(
          gameRules: gameRules,
          config: config,
          denProximityWeight: denProximityWeight,
        ),
        areaControlEvaluator = AreaControlEvaluator(
          gameRules: gameRules,
          config: config,
          areaControlWeight: areaControlWeight,
        );

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
          final pieceValueComponent = pieceValueEvaluator.evaluatePieceValue(piece, pos, player);
          pieceValue += pieceValueComponent;

          // Evaluate safety of the piece
          final safetyComponent = safetyEvaluator.evaluateSafety(board, pos, player);
          safety += safetyComponent;

          // Evaluate threats this piece can make
          final threatsComponent = threatsEvaluator.evaluateThreats(board, pos, piece, player);
          threats += threatsComponent;
        }
      }
    }

    // Evaluate proximity to opponent's den
    final denProximityComponent = denProximityEvaluator.evaluateDenProximity(board, player);
    denProximity += denProximityComponent;

    // Evaluate area control 
    final areaControlComponent = areaControlEvaluator.calculateAreaControlScore(board, player);
    areaControl += areaControlComponent;

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
}
