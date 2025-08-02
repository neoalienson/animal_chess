import 'package:flutter/foundation.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/game/ai_strategy.dart';
import 'package:animal_chess/game/ai_move.dart';
import 'package:logging/logging.dart';

class GameController {
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
    _logger.fine(
      "Checking AI move: current player=$currentPlayer, "
      "aiGreen=${gameConfig.aiGreen}, aiRed=${gameConfig.aiRed}",
    );

    // Check if current player is AI
    if ((currentPlayer == PlayerColor.green && gameConfig.aiGreen) ||
        (currentPlayer == PlayerColor.red && gameConfig.aiRed)) {
      _logger.info("Executing AI move for $currentPlayer");
      _executeAIMove();
    } else {
      _logger.fine("No AI move needed");
    }
  }

  /// Execute the best move for the AI player
  void _executeAIMove() {
    final ai = AIStrategy(gameConfig);
    final bestMove = ai.calculateBestMove(board, currentPlayer, gameActions);
    if (bestMove != null) {
      // Set the selected position first
      selectedPosition = bestMove.from;
      movePiece(bestMove.to);
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
