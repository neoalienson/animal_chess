import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';

class BoardEvaluationResult {
  final double safety;
  final double pieceValue;
  final double threats;
  final double denProximity;
  final double areaControl;
  final double score;

  BoardEvaluationResult({
    this.safety = 0,
    this.pieceValue = 0,
    this.threats = 0,
    this.denProximity = 0,
    this.areaControl = 0,
    this.score = -double.infinity,
  });

  @override
  String toString() {
    return 'BoardEvaluationResult(safety: $safety, pieceValue: $pieceValue, threats: $threats, denProximity: $denProximity, areaControl: $areaControl, score: $score)';
  }

  /// Compare two BoardEvaluationResult objects based on their score
  bool operator >(BoardEvaluationResult other) {
    return this.score > other.score;
  }

  bool operator <(BoardEvaluationResult other) {
    return this.score < other.score;
  }

  bool operator >=(BoardEvaluationResult other) {
    return this.score >= other.score;
  }

  bool operator <=(BoardEvaluationResult other) {
    return this.score <= other.score;
  }
}
