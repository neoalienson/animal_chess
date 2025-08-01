import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/constants/game_constants.dart';

class GameRules {
  final GameBoard board;
  final GameConfig gameConfig;

  GameRules({required this.board, required this.gameConfig});

  /// Check if a move is valid
  bool isValidMove(Position from, Position to, PlayerColor currentPlayer) {
    Piece? piece = board.getPiece(from);
    if (piece == null || piece.playerColor != currentPlayer) return false;

    // Can't move to own den
    if (board.isOwnDen(to, currentPlayer)) return false;

    Piece? targetPiece = board.getPiece(to);

    // Can't capture own pieces
    if (targetPiece != null && targetPiece.playerColor == currentPlayer) {
      return false;
    }

    // Check if it's a jump move
    if (_canJumpOverRiver(from, to, piece)) {
      // If it's a jump, the 'to' position must be empty or contain a capturable piece
      if (targetPiece == null) {
        return true;
      } else {
        return piece.canCapture(targetPiece);
      }
    }

    // If not a jump move, check if it's an adjacent move
    List<Position> adjacent = from.adjacentPositions;
    if (!adjacent.contains(to)) return false; // Not adjacent and not a jump, so invalid

    // Special rules for river entry (for adjacent moves)
    if (board.isRiver(to)) {
      if (gameConfig.dogRiverVariant) {
        if (piece.animalType != AnimalType.rat && piece.animalType != AnimalType.dog) {
          return false;
        }
      } else {
        if (piece.animalType != AnimalType.rat) {
          return false;
        }
      }
    }

    // Check capture rules for adjacent moves
    if (targetPiece != null) {
      // Pieces in traps can be captured by any opponent piece
      if (board.isTrap(to)) {
        return targetPiece.playerColor != currentPlayer;
      }

      // Rat cannot capture elephant (if variant is enabled)
      if (gameConfig.ratCannotCaptureElephant &&
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
    if (gameConfig.extendedLionTigerJumps && piece.animalType == AnimalType.leopard) {
      canJump = true;
    }

    if (!canJump) return false;

    int distance;

    // Check horizontal jump (left or right)
    if (from.row == to.row) {
      distance = (from.column - to.column).abs();
      // Standard horizontal jump for Lion/Tiger (over 2 river cells)
      if ((piece.animalType == AnimalType.lion || piece.animalType == AnimalType.tiger) && distance == GameConstants.lionTigerVerticalJumpDistance) {
        Position river1 = Position(from.column + (to.column > from.column ? 1 : -1), from.row);
        Position river2 = Position(from.column + (to.column > from.column ? 2 : -2), from.row);
        if (board.isRiver(river1) && board.isRiver(river2)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat)) {
            return false;
          }
          return true;
        }
      }
      // Extended Lion double river jump (over 2 rivers)
      if (gameConfig.extendedLionTigerJumps && piece.animalType == AnimalType.lion && distance == GameConstants.extendedLionDoubleRiverJumpHorizontal) { // 2 columns for first river + 1 column for land + 2 columns for second river
        // Check if both rivers are clear of rats
        Position river1_1 = Position(from.column + (to.column > from.column ? 1 : -1), from.row);
        Position river1_2 = Position(from.column + (to.column > from.column ? 2 : -2), from.row);
        Position river2_1 = Position(from.column + (to.column > from.column ? 4 : -4), from.row);
        Position river2_2 = Position(from.column + (to.column > from.column ? 5 : -5), from.row);

        if (board.isRiver(river1_1) && board.isRiver(river1_2) &&
            board.isRiver(river2_1) && board.isRiver(river2_2)) {
          if (board.getPiece(river1_1)?.animalType == AnimalType.rat ||
              board.getPiece(river1_2)?.animalType == AnimalType.rat ||
              board.getPiece(river2_1)?.animalType == AnimalType.rat ||
              board.getPiece(river2_2)?.animalType == AnimalType.rat) {
            return false;
          }
          return true;
        }
      }
      // Extended Leopard horizontal river crossing (same as single river jump)
      if (gameConfig.extendedLionTigerJumps && piece.animalType == AnimalType.leopard && distance == GameConstants.lionTigerHorizontalJumpDistance) {
        Position river1 = Position(from.column + (to.column > from.column ? 1 : -1), from.row);
        Position river2 = Position(from.column + (to.column > from.column ? 2 : -2), from.row);
        if (board.isRiver(river1) && board.isRiver(river2)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
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
      distance = (from.row - to.row).abs();
      // Standard vertical jump for Lion/Tiger (over 3 river cells)
      if ((piece.animalType == AnimalType.lion || piece.animalType == AnimalType.tiger) && distance == GameConstants.lionTigerVerticalJumpDistance) {
        Position river1 = Position(from.column, from.row + (to.row > from.row ? 1 : -1));
        Position river2 = Position(from.column, from.row + (to.row > from.row ? 2 : -2));
        Position river3 = Position(from.column, from.row + (to.row > from.row ? 3 : -3));
        if (board.isRiver(river1) && board.isRiver(river2) && board.isRiver(river3)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          Piece? rat3 = board.getPiece(river3);
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat) ||
              (rat3 != null && rat3.animalType == AnimalType.rat)) {
            return false;
          }
          return true;
        }
      }
      // Extended Lion double river jump (over 2 rivers)
      if (gameConfig.extendedLionTigerJumps && piece.animalType == AnimalType.lion && distance == GameConstants.extendedLionDoubleRiverJumpVertical) { // 3 rows for first river + 1 row for land + 3 rows for second river
        // Check if both rivers are clear of rats
        Position river1_1 = Position(from.column, from.row + (to.row > from.row ? 1 : -1));
        Position river1_2 = Position(from.column, from.row + (to.row > from.row ? 2 : -2));
        Position river1_3 = Position(from.column, from.row + (to.row > from.row ? 3 : -3));
        Position river2_1 = Position(from.column, from.row + (to.row > from.row ? 5 : -5));
        Position river2_2 = Position(from.column, from.row + (to.row > from.row ? 6 : -6));
        Position river2_3 = Position(from.column, from.row + (to.row > from.row ? 7 : -7));

        if (board.isRiver(river1_1) && board.isRiver(river1_2) && board.isRiver(river1_3) &&
            board.isRiver(river2_1) && board.isRiver(river2_2) && board.isRiver(river2_3)) {
          if (board.getPiece(river1_1)?.animalType == AnimalType.rat ||
              board.getPiece(river1_2)?.animalType == AnimalType.rat ||
              board.getPiece(river1_3)?.animalType == AnimalType.rat ||
              board.getPiece(river2_1)?.animalType == AnimalType.rat ||
              board.getPiece(river2_2)?.animalType == AnimalType.rat ||
              board.getPiece(river2_3)?.animalType == AnimalType.rat) {
            return false;
          }
          return true;
        }
      }
    }

    return false;
  }
}
