import 'package:animal_chess/game/ai_strategy.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/game/game_rules.dart';

void main() {
  // Create a game board
  final board = GameBoard();
  final config = GameConfig();
  final rules = GameRules(board: board, gameConfig: config);
  final actions = GameActions(
    board: board,
    gameConfig: config,
    gameRules: rules,
  );

  // Create AI strategy
  final ai = AIStrategy(config, actions);

  // Test AI move calculation for green player
  final bestMove = ai.calculateBestMove(board, PlayerColor.green, actions);

  if (bestMove != null) {
    print('Green AI found a move: ${bestMove.from} -> ${bestMove.to}');
  } else {
    print('Green AI could not find a move');
  }
}
