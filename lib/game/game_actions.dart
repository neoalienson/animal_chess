import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/constants/board_constants.dart';
import 'package:logging/logging.dart';

class GameActions {
  final Logger _logger = Logger('GameActions');
  final GameBoard board;
  final GameConfig gameConfig;
  PlayerColor currentPlayer = PlayerColor.red;
  Position? selectedPosition;
  bool gameEnded = false;
  PlayerColor? winner;
  List<Piece> capturedPieces = []; // List to track captured pieces
  final GameRules gameRules;

  GameActions({
    required this.board,
    required this.gameConfig,
    required this.gameRules,
  });

  /// Move a piece
  bool movePiece(Position from, Position to) {
    if (gameEnded) {
      _logger.fine("Game ended, cannot move piece.");
      return false;
    }

    if (!gameRules.isValidMove(from, to, currentPlayer)) {
      _logger.fine("Invalid move from $from to $to for $currentPlayer.");
      return false;
    }

    Piece? piece = board.getPiece(from);
    if (piece == null) {
      _logger.fine("No piece at $from.");
      return false;
    }

    Piece? targetPiece = board.getPiece(to);

    // Check win condition: entering opponent's den
    if (board.isOpponentDen(to, currentPlayer)) {
      // With rat-only variant, only rat can win by entering den
      if (gameConfig.ratOnlyDenEntry && piece.animalType != AnimalType.rat) {
        _logger.fine(
          "Rat-only den entry variant enabled, non-rat piece cannot win.",
        );
        return false; // Not a valid win under this variant
      } else {
        // Valid win
        board.movePiece(from, to);
        winner = currentPlayer;
        gameEnded = true;
        _logger.info("$currentPlayer wins by entering opponent's den!");
        return true;
      }
    }

    // Capture opponent piece
    if (targetPiece != null) {
      board.removePiece(to);
      capturedPieces.add(targetPiece);
      _logger.info(
        "$currentPlayer's ${piece.animalType} captured $targetPiece.",
      );
    }

    // Move the piece
    board.movePiece(from, to);
    _logger.fine("$currentPlayer moved ${piece.animalType} from $from to $to.");

    // Check if game has ended (capture all pieces)
    winner = board.getWinner();
    if (winner != null) {
      gameEnded = true;
      _logger.info("$winner wins by capturing all opponent pieces!");
    }

    switchPlayer();
    _logger.fine("Switched player to $currentPlayer.");
    return true;
  }

  /// Switch to the next player
  void switchPlayer() {
    currentPlayer = currentPlayer == PlayerColor.green
        ? PlayerColor.red
        : PlayerColor.green;
  }

  /// Get valid moves for a selected piece
  List<Position> getValidMoves(Position from, [PlayerColor? player]) {
    final effectivePlayer = player ?? currentPlayer;
    if (board.getPiece(from)?.playerColor != effectivePlayer) {
      _logger.fine("No piece or not current player's piece at $from.");
      return [];
    }

    List<Position> validMoves = [];
    for (int col = 0; col < BoardConstants.columns; col++) {
      for (int row = 0; row < BoardConstants.rows; row++) {
        Position to = Position(col, row);
        if (gameRules.isValidMove(from, to, effectivePlayer)) {
          validMoves.add(to);
        }
      }
    }
    _logger.fine("Found ${validMoves.length} valid moves for piece at $from.");
    return validMoves;
  }

  /// Reset the game
  void resetGame() {
    board.initializeDefaultBoard();
    currentPlayer = PlayerColor.red;
    selectedPosition = null;
    gameEnded = false;
    winner = null;
    capturedPieces.clear();
    _logger.info("Game reset.");
  }
}
