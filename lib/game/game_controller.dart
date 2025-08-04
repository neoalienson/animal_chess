import 'package:flutter/foundation.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/ai/ai_strategy.dart';
import 'package:animal_chess/ai/ml_strategy.dart';
import 'package:animal_chess/ai/animal_chess_network.dart';
import 'package:animal_chess/ai/ai_move.dart';
import 'package:logging/logging.dart';

class GameController {
  bool isActive = true;
  final Logger _logger = Logger('GameController');
  final GameBoard board;
  PlayerColor currentPlayer = PlayerColor.red; // Red goes first
  Position? selectedPosition;
  bool gameEnded = false;
  PlayerColor? winner;
  List<Piece> capturedPieces = []; // List to track captured pieces

  final GameConfig gameConfig;
  final GameRules gameRules;
  final GameActions gameActions;

  // Callback for when the game state changes
  VoidCallback? onGameStateChanged;

  GameController({
    required this.board,
    required this.gameRules,
    required this.gameActions,
    required this.gameConfig,
  }) : currentPlayer = PlayerColor.red;

  bool movePiece(Position toPosition) {
    bool moved = false;
    if (selectedPosition != null) {
      moved = gameActions.movePiece(selectedPosition!, toPosition);
      if (moved) {
        selectedPosition = null;
        currentPlayer = gameActions.currentPlayer;
        gameEnded = gameActions.gameEnded;
        winner = gameActions.winner;
        // Notify that game state has changed
        onGameStateChanged?.call();
      }
    }
    return moved;
  }

  /// Execute AI move if it's an AI player's turn
  void executeAIMoveIfNecessary() {
    _executeAIMoveIfNecessaryInternal(0);
  }

  /// Internal implementation of AI move execution with safety counter
  void _executeAIMoveIfNecessaryInternal(int safetyCounter) {
    if (!isActive || gameEnded) return;
    _logger.fine(
      "Checking AI move: current player=$currentPlayer, "
      "aiGreen=${gameConfig.aiGreen}, aiRed=${gameConfig.aiRed}",
    );

    const maxMoves = 50; // Maximum number of AI moves in a chain

    // Check if we should execute an AI move
    if (((currentPlayer == PlayerColor.green && gameConfig.aiGreen) ||
            (currentPlayer == PlayerColor.red && gameConfig.aiRed)) &&
        safetyCounter < maxMoves) {
      _logger.info(
        "Executing AI move for $currentPlayer (chain: ${safetyCounter + 1})",
      );
      _executeSingleAIMove();

      // Notify that game state has changed after each AI move
      onGameStateChanged?.call();

      // Check if we should continue with another AI move
      if (((currentPlayer == PlayerColor.green && gameConfig.aiGreen) ||
              (currentPlayer == PlayerColor.red && gameConfig.aiRed)) &&
          !gameEnded &&
          safetyCounter + 1 < maxMoves) {
        // Wait for 1 second before continuing with the next move
        Future.delayed(const Duration(seconds: 1), () {
          // Continue with the next move after the delay only if still active and AI enabled
          if (isActive &&
              !gameEnded &&
              ((currentPlayer == PlayerColor.green && gameConfig.aiGreen) ||
                  (currentPlayer == PlayerColor.red && gameConfig.aiRed))) {
            _logger.fine("Continuing with next AI move after delay");
            _executeAIMoveIfNecessaryInternal(safetyCounter + 1);
          } else {
            _logger.fine("Skipping delayed AI move - conditions no longer met");
          }
        });
      } else {
        // No more moves to execute
        if (safetyCounter + 1 >= maxMoves) {
          _logger.warning("AI move chain limit reached ($maxMoves moves)");
        } else {
          _logger.fine(
            "AI move execution completed. Total moves: ${safetyCounter + 1}",
          );
        }
      }
    } else {
      // No AI move to execute
      if (safetyCounter > 0) {
        _logger.fine(
          "AI move execution completed. Total moves: $safetyCounter",
        );
      }
    }
  }

  /// Execute a single AI move
  void _executeSingleAIMove() {
    if (!isActive ||
        (currentPlayer == PlayerColor.green && !gameConfig.aiGreen) ||
        (currentPlayer == PlayerColor.red && !gameConfig.aiRed)) {
      return;
    }
    
    Move? bestMove;
    
    // Check if ML strategy is selected
    if (currentPlayer == PlayerColor.green && gameConfig.aiGreenStrategy == AIStrategyType.machineLearning) {
      // Use ML strategy
      final network = AnimalChessNetwork(); // Initialize the ML network
      final mlStrategy = MlStrategy(
        network: network,
        rules: gameActions.gameRules,
      );
      bestMove = mlStrategy.selectMove(board, currentPlayer);
    } else if (currentPlayer == PlayerColor.red && gameConfig.aiRedStrategy == AIStrategyType.machineLearning) {
      // Use ML strategy
      final network = AnimalChessNetwork(); // Initialize the ML network
      final mlStrategy = MlStrategy(
        network: network,
        rules: gameActions.gameRules,
      );
      bestMove = mlStrategy.selectMove(board, currentPlayer);
    } else {
      // Use traditional AIStrategy
      final ai = AIStrategy(gameConfig, gameActions);
      bestMove = ai.calculateBestMove(board, currentPlayer, gameActions);
    }
    
    if (bestMove != null) {
      // Set the selected position first
      selectedPosition = bestMove.from;
      // Execute the move
      gameActions.movePiece(bestMove.from, bestMove.to);
      // Update controller state
      selectedPosition = null;
      currentPlayer = gameActions.currentPlayer;
      gameEnded = gameActions.gameEnded;
      winner = gameActions.winner;
    }
  }

  List<Position> getValidMoves(Position fromPosition) {
    return gameActions.getValidMoves(fromPosition, currentPlayer);
  }

  void resetGame() {
    gameActions.resetGame();
    // Update GameController's state from GameActions after reset

    currentPlayer = gameActions.currentPlayer;
    selectedPosition = null;
    gameEnded = gameActions.gameEnded;
    winner = gameActions.winner;
    capturedPieces = gameActions.capturedPieces;

    // Notify that game state has changed
    onGameStateChanged?.call();
  }

  /// Select a piece to move
  bool selectPiece(Position position) {
    if (gameEnded) return false;

    Piece? piece = board.getPiece(position);

    // Can only select own pieces
    if (piece == null || piece.playerColor != currentPlayer) {
      selectedPosition = null;
      return false;
    }

    selectedPosition = position;
    return true;
  }

  /// Check if a move is valid
  bool isValidMove(Position from, Position to) {
    return gameRules.isValidMove(from, to, currentPlayer);
  }

  /// Force a player to win (for debugging/testing)
  void forceWin(PlayerColor player) {
    gameEnded = true;
    winner = player;
    currentPlayer = player;
  }
}
