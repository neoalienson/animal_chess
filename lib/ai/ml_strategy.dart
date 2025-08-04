import 'package:animal_chess/ai/animal_chess_network.dart';
import 'package:animal_chess/ai/mcts_node.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/ai/ai_move.dart';

class MlStrategy {
  final AnimalChessNetwork network;
  final GameRules rules;
  final int maxSearchDepth;
  final int maxTimeMs;

  MlStrategy({
    required this.network,
    required this.rules,
    this.maxSearchDepth = 1000,
    this.maxTimeMs = 3000, // 3 seconds max
  });

  Move selectMove(GameBoard board, PlayerColor player) {
    // Create root node for MCTS
    final rootNode = MctsNode(
      board: board,
      player: player,
      rules: rules,
    );

    // Run MCTS with the specified search depth
    final startTime = DateTime.now().millisecondsSinceEpoch;
    int iterations = 0;
    
    while (iterations < maxSearchDepth && 
           DateTime.now().millisecondsSinceEpoch - startTime < maxTimeMs) {
      // Selection phase
      final selectedNode = rootNode.select();
      
      // Expansion phase
      if (!selectedNode.isTerminal) {
        selectedNode.expand(network, rules);
      }
      
      // Simulation phase
      final simulationResult = selectedNode.simulate(rules);
      
      // Backpropagation phase
      selectedNode.backpropagate(simulationResult);
      
      iterations++;
    }
    
    // Return the best move based on visit count
    return rootNode.bestMove;
  }
}
