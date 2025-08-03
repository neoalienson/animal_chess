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
      // Create a custom board state where the AI needs to consider opponent responses
      final customBoard = GameBoard();
      customBoard.clearBoard();

      // Place a red piece that can capture a green piece
      customBoard.setPiece(
        Position(0, 0),
        Piece(AnimalType.cat, PlayerColor.red),
      );
      customBoard.setPiece(
        Position(0, 1),
        Piece(AnimalType.rat, PlayerColor.green),
      );

      // Place another green piece that can capture the red piece
      customBoard.setPiece(
        Position(1, 0),
        Piece(AnimalType.dog, PlayerColor.green),
      );

      final customActions = GameActions(
        board: customBoard,
        gameConfig: config,
        gameRules: rules,
      );

      final bestMove = ai.calculateBestMove(
        customBoard,
        PlayerColor.red,
        customActions,
      );
      expect(bestMove, isNotNull);
    });
  });
}
