import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';

class GameActions {
  final GameBoard board;
  final GameConfig gameConfig;
  PlayerColor currentPlayer;
  Position? selectedPosition;
  bool gameEnded;
  PlayerColor? winner;
  List<Piece> capturedPieces;
  final GameRules gameRules;

  GameActions({
    required this.board,
    required this.gameConfig,
    required this.currentPlayer,
    required this.selectedPosition,
    required this.gameEnded,
    required this.winner,
    required this.capturedPieces,
    required this.gameRules,
  });

  /// Move a piece
  bool movePiece(Position from, Position to) {
    if (gameEnded) return false;

    if (!gameRules.isValidMove(from, to, currentPlayer)) {
      return false;
    }

    Piece? piece = board.getPiece(from);
    if (piece == null) {
      return false;
    }

    Piece? targetPiece = board.getPiece(to);

    // Check win condition: entering opponent's den
    if (board.isOpponentDen(to, currentPlayer)) {
      // With rat-only variant, only rat can win by entering den
      if (gameConfig.ratOnlyDenEntry && piece.animalType != AnimalType.rat) {
        return false; // Not a valid win under this variant
      } else {
        // Valid win
        board.movePiece(from, to);
        winner = currentPlayer;
        gameEnded = true;
        return true;
      }
    }

    // Capture opponent piece
    if (targetPiece != null) {
      board.removePiece(to);
      capturedPieces.add(targetPiece);
    }

    // Move the piece
    board.movePiece(from, to);

    // Check if game has ended (capture all pieces)
    winner = board.getWinner();
    if (winner != null) {
      gameEnded = true;
    }

    switchPlayer();
    return true;
  }

  /// Switch to the next player
  void switchPlayer() {
    currentPlayer = currentPlayer == PlayerColor.green
        ? PlayerColor.red
        : PlayerColor.green;
  }

  /// Get valid moves for a selected piece
  List<Position> getValidMoves(Position from) {
    if (board.getPiece(from)?.playerColor != currentPlayer) return [];

    List<Position> validMoves = [];
    for (int col = 0; col < GameBoard.columns; col++) {
      for (int row = 0; row < GameBoard.rows; row++) {
        Position to = Position(col, row);
        if (gameRules.isValidMove(from, to, currentPlayer)) {
          validMoves.add(to);
        }
      }
    }

    return validMoves;
  }

  /// Reset the game
  void resetGame() {
    board.initializeDefaultBoard();
    currentPlayer = PlayerColor.red;
    selectedPosition = null;
    gameEnded = false;
    winner = null;
  }
}