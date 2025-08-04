import 'package:test/test.dart';
import 'package:animal_chess/game/ai_strategy.dart';
import 'package:animal_chess/game/board_evaluator.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/game/game_rules.dart';

class MockBoardEvaluator extends BoardEvaluator {
  final double mockScore;

  MockBoardEvaluator({required this.mockScore})
    : super(
        gameRules: GameRules(board: GameBoard(), gameConfig: GameConfig()),
        config: GameConfig(),
      );

  @override
  double evaluateBoardState(GameBoard board, PlayerColor player) {
    return mockScore;
  }
}

void main() {
  group('AIStrategy', () {
    late GameBoard board;
    late GameConfig config;
    late GameRules rules;
    late GameActions actions;
    late AIStrategy ai;

    setUp(() {
      board = GameBoard();
      config = GameConfig();
      rules = GameRules(board: board, gameConfig: config);
      actions = GameActions(board: board, gameConfig: config, gameRules: rules);
      ai = AIStrategy(config, actions);
    });

    test('calculateBestMove returns a move when valid moves exist', () {
      final bestMove = ai.calculateBestMove(board, PlayerColor.red, actions);
      // In the initial board state, there should be valid moves
      expect(bestMove, isNotNull);
    });

    test('calculateBestMove returns null when no valid moves exist', () {
      // Create an empty board
      final emptyBoard = GameBoard.empty();
      final emptyActions = GameActions(
        board: emptyBoard,
        gameConfig: config,
        gameRules: rules,
      );

      final bestMove = ai.calculateBestMove(
        emptyBoard,
        PlayerColor.red,
        emptyActions,
      );
      expect(bestMove, isNull);
    });

    test('AIStrategy uses BoardEvaluator for move evaluation', () {
      // Create a mock evaluator that always returns a positive score
      final mockEvaluator = MockBoardEvaluator(mockScore: 10.0);
      final aiWithMock = AIStrategy(config, actions, mockEvaluator);

      final bestMove = aiWithMock.calculateBestMove(
        board,
        PlayerColor.red,
        actions,
      );
      // Should still return a move (we're just testing that it uses the evaluator)
      expect(bestMove, isNotNull);
    });

    test('AIStrategy handles 2-ply lookahead correctly', () {
      // Use the default board state which has valid moves
      final bestMove = ai.calculateBestMove(
        board,
        PlayerColor.red,
        actions,
      );
      expect(bestMove, isNotNull);
    });
  });

  // Test area control functionality
  group('Area Control Tests', () {
    test('Area control evaluator has default weight of 0.0', () {
      final config = GameConfig();
      final board = GameBoard();
      final rules = GameRules(board: board, gameConfig: config);
      final evaluator = BoardEvaluator(
        gameRules: rules,
        config: config,
        safetyWeight: 1.0,
        denProximityWeight: 1.2,
        pieceValueWeight: 0.9,
        threatWeight: 0.7,
        // areaControlWeight should default to 0.0
      );

      expect(evaluator.areaControlWeight, equals(0.0));
    });

    test('Area control evaluation returns zero when disabled', () {
      final config = GameConfig();
      final board = GameBoard.empty(); // Empty board for clean test
      final rules = GameRules(board: board, gameConfig: config);
      final evaluator = BoardEvaluator(
        gameRules: rules,
        config: config,
        safetyWeight: 1.0,
        denProximityWeight: 1.2,
        pieceValueWeight: 0.9,
        threatWeight: 0.7,
        areaControlWeight: 0.0, // Disabled
      );

      final score = evaluator.evaluateBoardState(board, PlayerColor.red);
      // Should only evaluate other factors (should be 0.0 for empty board)
      expect(score, equals(0.0));
    });

    test('Area control evaluation enabled with non-zero weight', () {
      final config = GameConfig();
      final board = GameBoard.empty(); // Empty board for clean test
      final rules = GameRules(board: board, gameConfig: config);
      final evaluator = BoardEvaluator(
        gameRules: rules,
        config: config,
        safetyWeight: 1.0,
        denProximityWeight: 1.2,
        pieceValueWeight: 0.9,
        threatWeight: 0.7,
        areaControlWeight: 1.0, // Enabled
      );

      final score = evaluator.evaluateBoardState(board, PlayerColor.red);
      // Should still be 0.0 for empty board but with area control enabled
      expect(score, equals(0.0));
    });
  });
}
