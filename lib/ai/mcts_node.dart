import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/ai/animal_chess_network.dart';
import 'package:animal_chess/ai/ai_move.dart';
import 'dart:math';

class MctsNode {
  final GameBoard board;
  final PlayerColor player;
  final GameRules rules;
  final Position? fromPosition;
  final Position? toPosition;
  final MctsNode? parent;
  final List<MctsNode> children;
  int visits;
  double wins;
  final double explorationConstant;

  MctsNode({
    required this.board,
    required this.player,
    required this.rules,
    this.fromPosition,
    this.toPosition,
    this.parent,
    List<MctsNode>? children, // Make it optional and nullable for default
    this.visits = 0,
    this.wins = 0.0,
    this.explorationConstant = 1.41, // sqrt(2)
  }) : children = children ?? []; // Initialize with an empty growable list if not provided

  /// Check if this node represents a terminal state (game over)
  bool get isTerminal {
    return board.getWinner() != null;
  }

  /// Check if this node is fully expanded (all possible moves considered)
  bool get isFullyExpanded {
    return children.isNotEmpty;
  }

  /// Get untried moves from this node
  List<Move> getUntriedMoves() {
    final moves = <Move>[];
    
    // Get all pieces for current player
    final playerPieces = board.getPlayerPieces(player);
    
    // For each piece, find valid moves
    for (final entry in playerPieces.entries) {
      final from = entry.key;
      final piece = entry.value;
      
      // Check all possible destinations
      for (int col = 0; col < 7; col++) {
        for (int row = 0; row < 9; row++) {
          final to = Position(col, row);
          
          // Skip if move is invalid
          if (!rules.isValidMove(from, to, player)) {
            continue;
          }
          
          // Create move
          final move = Move(from: from, to: to);
          moves.add(move);
        }
      }
    }
    
    return moves;
  }

  /// Select child node using UCB1 formula
  MctsNode select() {
    if (children.isEmpty) {
      return this;
    }
    
    // Find the child with maximum UCB1 value
    MctsNode bestChild = children.first;
    double bestValue = -1.0; // Initialize with a very small value

    // If this is the root node, we don't use parent.visits for its children's UCB1 calculation directly.
    // Instead, we just pick the child with the highest UCB1 value.
    // The UCB1 formula for children already accounts for their parent's visits.
    if (parent == null) {
      bestValue = ucb1(bestChild);
    } else {
      bestValue = ucb1(bestChild);
    }
    
    for (int i = 1; i < children.length; i++) {
      final child = children[i];
      final value = ucb1(child);
      if (value > bestValue) {
        bestValue = value;
        bestChild = child;
      }
    }
    
    return bestChild.select();
  }

  /// Calculate UCB1 value for a node
  double ucb1(MctsNode node) {
    if (node.visits == 0) {
      return double.infinity;
    }
    
    // UCB1 formula: exploitation + exploration
    final exploitation = node.wins / node.visits;
    // Ensure node.parent is not null before accessing its visits
    final exploration = explorationConstant * 
        sqrt(log(node.parent!.visits) / node.visits);
    
    return exploitation + exploration;
  }

  /// Expand the node by adding all possible child nodes
  void expand(AnimalChessNetwork network, GameRules rules) {
    if (isTerminal) return;
    
    // Get all untried moves
    final untriedMoves = getUntriedMoves();
    
    // Create a child node for each move
    for (final move in untriedMoves) {
      // Create a new board state for this move
      final newBoard = board.copy();
      newBoard.movePiece(move.from, move.to);
      
      // Create child node
      final child = MctsNode(
        board: newBoard,
        player: player == PlayerColor.red ? PlayerColor.green : PlayerColor.red,
        rules: rules,
        fromPosition: move.from,
        toPosition: move.to,
        parent: this,
      );
      
      children.add(child);
    }
  }

  /// Simulate a random playout from this node
  double simulate(GameRules rules) {
    if (isTerminal) {
      // Return 1.0 if current player won, 0.0 if opponent won
      final winner = board.getWinner();
      return winner == player ? 1.0 : 0.0;
    }
    
    // Create a copy of the board for simulation
    final simBoard = board.copy();
    var currentPlayer = player;
    
    // Simulate until game ends
    while (simBoard.getWinner() == null) {
      // Get all pieces for current player
      final playerPieces = simBoard.getPlayerPieces(currentPlayer);
      
      if (playerPieces.isEmpty) {
        // No pieces left for this player - opponent wins
        return currentPlayer == player ? 0.0 : 1.0;
      }
      
      // Get a random valid move
      final moves = <Move>[];
      for (final entry in playerPieces.entries) {
        final from = entry.key;
        final piece = entry.value;
        
        // Check all possible destinations
        for (int col = 0; col < 7; col++) {
          for (int row = 0; row < 9; row++) {
            final to = Position(col, row);
            
            // Skip if move is invalid
            if (!rules.isValidMove(from, to, currentPlayer)) {
              continue;
            }
            
            // Create move
            final move = Move(from: from, to: to);
            moves.add(move);
          }
        }
      }
      
      if (moves.isEmpty) {
        // No valid moves - opponent wins
        return currentPlayer == player ? 0.0 : 1.0;
      }
      
      // Choose a random move
      final randomMove = moves[DateTime.now().millisecondsSinceEpoch % moves.length];
      
      // Apply move to simulation board
      simBoard.movePiece(randomMove.from, randomMove.to);
      
      // Switch player
      currentPlayer = currentPlayer == PlayerColor.red ? PlayerColor.green : PlayerColor.red;
    }
    
    // Return result based on who won
    final winner = simBoard.getWinner();
    return winner == player ? 1.0 : 0.0;
  }

  /// Backpropagate the simulation result up the tree
  void backpropagate(double result) {
    visits++;
    wins += result;
    
    if (parent != null) {
      parent!.backpropagate(result);
    }
  }

  /// Get the best move based on visit count
  Move get bestMove {
    if (children.isEmpty) {
      return Move(from: Position(0, 0), to: Position(0, 0)); // Fallback
    }
    
    // Find child with maximum visits
    MctsNode bestChild = children.first;
    int maxVisits = children.first.visits;
    
    for (int i = 1; i < children.length; i++) {
      final child = children[i];
      if (child.visits > maxVisits) {
        maxVisits = child.visits;
        bestChild = child;
      }
    }
    
    return Move(
      from: bestChild.fromPosition ?? Position(0, 0),
      to: bestChild.toPosition ?? Position(0, 0),
    );
  }
}
