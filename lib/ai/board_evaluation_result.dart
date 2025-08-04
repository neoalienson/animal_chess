import 'package:animal_chess/models/player_color.dart';

class BoardEvaluationResult {
  final double safety;
  final double pieceValue;
  final double threats;
  final double denProximity;
  final double areaControl;
  final double score;

  BoardEvaluationResult({
    this.safety = 0.0,
    this.pieceValue = 0.0,
    this.threats = 0.0,
    this.denProximity = 0.0,
    this.areaControl = 0.0,
    this.score = 0.0,
  });

  /// Compare two BoardEvaluationResult objects
  bool operator >(BoardEvaluationResult other) {
    return score > other.score;
  }

  bool operator <(BoardEvaluationResult other) {
    return score < other.score;
  }

  @override
  String toString() {
    return 'BoardEvaluationResult(safety: $safety, pieceValue: $pieceValue, threats: $threats, denProximity: $denProximity, areaControl: $areaControl, score: $score)';
  }
}
