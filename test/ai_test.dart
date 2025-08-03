import 'package:animal_chess/game/ai_strategy.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:logging/logging.dart';

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
  final Logger logger = Logger('AI');

  // Create AI strategy
  final ai = AIStrategy(config, actions);

  // Test AI move calculation
  final bestMove = ai.calculateBestMove(board, PlayerColor.red, actions);

  if (bestMove != null) {
    logger.fine('AI found a move: ${bestMove.from} -> ${bestMove.to}');
  } else {
    logger.fine('AI could not find a move');
  }
}
