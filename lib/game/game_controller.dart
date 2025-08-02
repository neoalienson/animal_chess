import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/game/game_actions.dart';

class GameController {
  final GameBoard board;
  PlayerColor currentPlayer = PlayerColor.red; // Red goes first
  Position? selectedPosition;
  bool gameEnded = false;
  PlayerColor? winner;
  List<Piece> capturedPieces = []; // List to track captured pieces

  final GameConfig gameConfig;
  final GameRules gameRules;
  final GameActions gameActions;

  GameController({
    required this.board,
    required this.gameRules,
    required this.gameActions,
    required this.gameConfig,
  }) : currentPlayer = PlayerColor.red;

  bool movePiece(Position toPosition) {
    if (selectedPosition == null) return false;
    bool moved = gameActions.movePiece(selectedPosition!, toPosition);
    if (moved) {
      selectedPosition = null;
      currentPlayer = gameActions.currentPlayer;
      gameEnded = gameActions.gameEnded;
      winner = gameActions.winner;
    }
    return moved;
  }

  List<Position> getValidMoves(Position fromPosition) {
    return gameActions.getValidMoves(fromPosition);
  }

  void resetGame() {
    gameActions.resetGame();
    // Update GameController's state from GameActions after reset

    currentPlayer = gameActions.currentPlayer;
    selectedPosition = null;
    gameEnded = gameActions.gameEnded;
    winner = gameActions.winner;
    capturedPieces = gameActions.capturedPieces;
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
