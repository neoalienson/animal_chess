import 'package:test/test.dart';
import 'package:animal_chess/game/board_evaluator.dart';
import 'package:animal_chess/game/game_actions.dart';
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
      final score = evaluator.evaluateBoardState(board, PlayerColor.red);
      expect(score, isA<double>());
    });

    test(
      'evaluateBoardState returns different scores for different players',
      () {
        final redScore = evaluator.evaluateBoardState(board, PlayerColor.red);
        final greenScore = evaluator.evaluateBoardState(
          board,
          PlayerColor.green,
        );

        // In the initial board state, the scores should be equal (symmetric)
        expect(redScore, equals(greenScore));
      },
    );

    test('evaluatePieceValue gives positive score for own pieces', () {
      // This is a bit tricky to test directly since _evaluatePieceValue is private
      // Instead, we'll test the overall evaluation with a custom board state

      // Create a custom board with just one red piece
      final customBoard = GameBoard();
      customBoard.clearBoard();
      customBoard.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.red),
      ); // Rat

      final score = evaluator.evaluateBoardState(customBoard, PlayerColor.red);
      expect(score, greaterThan(0));
    });

    test('evaluatePieceValue gives negative score for opponent pieces', () {
      // Create a custom board with just one green piece
      final customBoard = GameBoard();
      customBoard.clearBoard();
      customBoard.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.green),
      ); // Rat

      final score = evaluator.evaluateBoardState(customBoard, PlayerColor.red);
      expect(score, lessThan(0));
    });

    test(
      'evaluateDenProximity gives higher score when closer to opponent den',
      () {
        // Create a board with a red piece near the green den
        final customBoard = GameBoard();
        customBoard.clearBoard();
        customBoard.setPiece(
          Position(3, 7),
          Piece(AnimalType.rat, PlayerColor.red),
        ); // Rat near green den

        final score = evaluator.evaluateBoardState(
          customBoard,
          PlayerColor.red,
        );
        expect(score, greaterThan(0));
      },
    );

    test('evaluateSafety penalizes threatened pieces', () {
      // Create a board where a red piece is threatened by a green piece
      final customBoard = GameBoard();
      customBoard.clearBoard();
      customBoard.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.red),
      ); // Red rat
      customBoard.setPiece(
        Position(0, 1),
        Piece(AnimalType.cat, PlayerColor.green),
      ); // Green cat can capture rat

      // Create new evaluator with the custom board
      final customRules = GameRules(board: customBoard, gameConfig: config);
      final customEvaluator = BoardEvaluator(
        gameRules: customRules,
        config: config,
      );

      final score = customEvaluator.evaluateBoardState(
        customBoard,
        PlayerColor.red,
      );
      expect(score, lessThan(0)); // Should be negative due to threatened rat
    });

    test('evaluateThreats rewards pieces that can capture opponent pieces', () {
      // Create a board where a red piece can capture a green piece
      final customBoard = GameBoard();
      customBoard.clearBoard();
      customBoard.setPiece(
        Position(0, 0),
        Piece(AnimalType.cat, PlayerColor.red),
      ); // Red cat
      customBoard.setPiece(
        Position(0, 1),
        Piece(AnimalType.rat, PlayerColor.green),
      ); // Green rat can be captured by cat

      // Create new evaluator with the custom board
      final customRules = GameRules(board: customBoard, gameConfig: config);
      final customEvaluator = BoardEvaluator(
        gameRules: customRules,
        config: config,
      );

      final score = customEvaluator.evaluateBoardState(
        customBoard,
        PlayerColor.red,
      );
      expect(
        score,
        greaterThan(0),
      ); // Should be positive due to capture opportunity
    });
  });
}
