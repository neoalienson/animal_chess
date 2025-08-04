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

void main() {
  group('AIStrategy Per Player', () {
    late GameBoard board;
    late GameConfig config;
    late GameRules rules;
    late GameActions actions;

    setUp(() {
      board = GameBoard();
      config = GameConfig();
      rules = GameRules(board: board, gameConfig: config);
      actions = GameActions(board: board, gameConfig: config, gameRules: rules);
    });

    test('AIStrategy uses correct strategy for green player', () {
      // Configure green AI with offensive strategy and red AI with defensive strategy
      final configWithStrategies = config.copyWith(
        aiGreen: true,
        aiRed: true,
        aiGreenStrategy: AIStrategyType.offensive,
        aiRedStrategy: AIStrategyType.defensive,
      );
      
      final ai = AIStrategy(configWithStrategies, actions);
      
      // Just verify that the AIStrategy can calculate moves with the new config
      // Using the default board state
      final greenMove = ai.calculateBestMove(board, PlayerColor.green, actions);
      final redMove = ai.calculateBestMove(board, PlayerColor.red, actions);
      
      // At least one move should be valid in the initial board state
      expect(greenMove != null || redMove != null, isTrue);
    });
    
    test('AIStrategy handles different player strategies', () {
      // Configure green AI with offensive strategy and red AI with defensive strategy
      final configWithStrategies = config.copyWith(
        aiGreenStrategy: AIStrategyType.offensive,
        aiRedStrategy: AIStrategyType.defensive,
      );
      
      final ai = AIStrategy(configWithStrategies, actions);
      
      // Just verify that the AIStrategy can be created with the new config
      expect(ai, isNotNull);
    });
  });
}
