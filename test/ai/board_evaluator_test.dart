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

    test('lion river jump score higher than horizontal moves', () {
      // Set up a board with a lion that can make a river jump (closer to opponent's den)
      final riverJumpBoard = GameBoard.empty()
        ..setPiece(Position(3, 2), Piece(AnimalType.lion, PlayerColor.red));
      
      // Set up a board with a lion that makes a horizontal move (further from opponent's den)
      final horizontalMoveBoard = GameBoard.empty()
        ..setPiece(Position(3, 5), Piece(AnimalType.lion, PlayerColor.red));

      final riverJumpResult = evaluator.evaluateBoardState(riverJumpBoard, PlayerColor.red);
      final horizontalMoveResult = evaluator.evaluateBoardState(horizontalMoveBoard, PlayerColor.red);

      print(riverJumpResult);
      print(horizontalMoveResult);
      // River jump should give higher score than horizontal move (closer to den)
      expect(riverJumpResult.score, greaterThan(horizontalMoveResult.score));
    });
  });
}
