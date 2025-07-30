import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';

class GameController {
  late GameBoard board;
  PlayerColor currentPlayer;
  Position? selectedPosition;
  bool gameEnded = false;
  PlayerColor? winner;

  // Game variants
  bool ratOnlyDenEntry = false;
  bool extendedLionTigerJumps = false;
  bool dogRiverVariant = false;
  bool ratCannotCaptureElephant = false;

  GameController() : currentPlayer = PlayerColor.red {
    board = GameBoard();
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
    Piece? piece = board.getPiece(from);
    if (piece == null || piece.playerColor != currentPlayer) return false;

    // Can't move to own den
    if (board.isOwnDen(to, currentPlayer)) return false;

    // Check if destination is adjacent
    List<Position> adjacent = from.adjacentPositions;
    if (!adjacent.contains(to)) return false;

    Piece? targetPiece = board.getPiece(to);

    // Can't capture own pieces
    if (targetPiece != null && targetPiece.playerColor == currentPlayer) {
      return false;
    }

    // Special rules for river
    if (board.isRiver(to)) {
      // Only rat can enter river (unless dog variant is enabled)
      if (piece.animalType != AnimalType.rat && !dogRiverVariant) {
        return false;
      }

      // In dog variant, only dog can enter river
      if (dogRiverVariant && piece.animalType != AnimalType.dog) {
        return false;
      }
    }

    // Special rules for jumping over rivers
    if (_canJumpOverRiver(from, to, piece)) {
      return true;
    }

    // Check capture rules
    if (targetPiece != null) {
      // Pieces in traps can be captured by any opponent piece
      if (board.isTrap(to)) {
        return targetPiece.playerColor != currentPlayer;
      }

      // Rat cannot capture elephant (if variant is enabled)
      if (ratCannotCaptureElephant &&
          piece.animalType == AnimalType.rat &&
          targetPiece.animalType == AnimalType.elephant) {
        return false;
      }

      // Normal capture rules
      return piece.canCapture(targetPiece);
    }

    return true;
  }

  /// Check if a piece can jump over a river
  bool _canJumpOverRiver(Position from, Position to, Piece piece) {
    // Only lion and tiger can jump (and leopard with extended variant)
    bool canJump =
        (piece.animalType == AnimalType.lion ||
        piece.animalType == AnimalType.tiger);

    // With extended variant, leopard can also jump horizontally
    if (extendedLionTigerJumps && piece.animalType == AnimalType.leopard) {
      canJump = true;
    }

    if (!canJump) return false;

    // Check horizontal jump (left or right)
    if (from.row == to.row) {
      // Jumping left
      if (to.column == from.column - 3) {
        // Check if there's a rat in the river
        Position river1 = Position(from.column - 1, from.row);
        Position river2 = Position(from.column - 2, from.row);
        if (board.isRiver(river1) && board.isRiver(river2)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          // Can't jump if there's a rat in the river
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat)) {
            return false;
          }
          return true;
        }
      }
      // Jumping right
      else if (to.column == from.column + 3) {
        // Check if there's a rat in the river
        Position river1 = Position(from.column + 1, from.row);
        Position river2 = Position(from.column + 2, from.row);
        if (board.isRiver(river1) && board.isRiver(river2)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          // Can't jump if there's a rat in the river
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat)) {
            return false;
          }
          return true;
        }
      }
    }
    // Check vertical jump (up or down)
    else if (from.column == to.column) {
      // Jumping up
      if (to.row == from.row - 4) {
        // Check if there's a rat in the river
        Position river1 = Position(from.column, from.row - 1);
        Position river2 = Position(from.column, from.row - 2);
        Position river3 = Position(from.column, from.row - 3);
        if (board.isRiver(river1) &&
            board.isRiver(river2) &&
            board.isRiver(river3)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          Piece? rat3 = board.getPiece(river3);
          // Can't jump if there's a rat in the river
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat) ||
              (rat3 != null && rat3.animalType == AnimalType.rat)) {
            return false;
          }
          return true;
        }
      }
      // Jumping down
      else if (to.row == from.row + 4) {
        // Check if there's a rat in the river
        Position river1 = Position(from.column, from.row + 1);
        Position river2 = Position(from.column, from.row + 2);
        Position river3 = Position(from.column, from.row + 3);
        if (board.isRiver(river1) &&
            board.isRiver(river2) &&
            board.isRiver(river3)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          Piece? rat3 = board.getPiece(river3);
          // Can't jump if there's a rat in the river
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat) ||
              (rat3 != null && rat3.animalType == AnimalType.rat)) {
            return false;
          }
          return true;
        }
      }
    }

    return false;
  }

  /// Move a piece
  bool movePiece(Position to) {
    if (gameEnded || selectedPosition == null) return false;

    Position from = selectedPosition!;
    if (!isValidMove(from, to)) {
      selectedPosition = null;
      return false;
    }

    Piece? piece = board.getPiece(from);
    if (piece == null) {
      selectedPosition = null;
      return false;
    }

    Piece? targetPiece = board.getPiece(to);

    // Check win condition: entering opponent's den
    if (board.isOpponentDen(to, currentPlayer)) {
      // With rat-only variant, only rat can win by entering den
      if (ratOnlyDenEntry && piece.animalType != AnimalType.rat) {
        // Not a valid win
      } else {
        // Valid win
        board.movePiece(from, to);
        winner = currentPlayer;
        gameEnded = true;
        selectedPosition = null;
        return true;
      }
    }

    // Capture opponent piece
    if (targetPiece != null) {
      board.removePiece(to);
    }

    // Move the piece
    board.movePiece(from, to);

    // Check if game has ended (capture all pieces)
    winner = board.getWinner();
    if (winner != null) {
      gameEnded = true;
    }

    selectedPosition = null;
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
    for (Position to in from.adjacentPositions) {
      if (isValidMove(from, to)) {
        validMoves.add(to);
      }
    }

    // Add jump moves for lion/tiger (and leopard with extended variant)
    Piece? piece = board.getPiece(from);
    if (piece != null) {
      // Check all possible jump destinations
      for (int col = 0; col < GameBoard.columns; col++) {
        for (int row = 0; row < GameBoard.rows; row++) {
          Position to = Position(col, row);
          if (_canJumpOverRiver(from, to, piece) && isValidMove(from, to)) {
            validMoves.add(to);
          }
        }
      }
    }

    return validMoves;
  }

  /// Reset the game
  void resetGame() {
    board = GameBoard();
    currentPlayer = PlayerColor.red;
    selectedPosition = null;
    gameEnded = false;
    winner = null;
  }

  /// Set game variant options
  void setGameVariant({
    bool? ratOnlyDenEntry,
    bool? extendedLionTigerJumps,
    bool? dogRiverVariant,
    bool? ratCannotCaptureElephant,
  }) {
    if (ratOnlyDenEntry != null) this.ratOnlyDenEntry = ratOnlyDenEntry;
    if (extendedLionTigerJumps != null)
      this.extendedLionTigerJumps = extendedLionTigerJumps;
    if (dogRiverVariant != null) this.dogRiverVariant = dogRiverVariant;
    if (ratCannotCaptureElephant != null)
      this.ratCannotCaptureElephant = ratCannotCaptureElephant;
  }
}
