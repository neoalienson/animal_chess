import 'package:test/test.dart';
import 'package:animal_chess/ai/board_evaluator.dart';
import 'package:animal_chess/ai/board_evaluation_result.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/game/game_rules.dart';

void main() {
  group('BoardEvaluator', () {
    late GameBoard board;
    late GameConfig config;
    late GameRules rules;
    late BoardEvaluator evaluator;

    setUp(() {
      board = GameBoard();
      config = GameConfig();
      rules = GameRules(board: board, gameConfig: config);
      evaluator = BoardEvaluator(gameRules: rules, config: config);
    });

    test('evaluateBoardState returns a score', () {
      final result = evaluator.evaluateBoardState(board, PlayerColor.red);
      expect(result, isA<BoardEvaluationResult>());
      expect(result.score, isA<double>());
    });
  });
}
