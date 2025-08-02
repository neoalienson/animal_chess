import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/constants/game_constants.dart';
import 'package:logging/logging.dart';

class GameRules {
  final GameBoard board;
  final GameConfig gameConfig;
  final Logger _logger = Logger('GameRules');

  GameRules({required this.board, required this.gameConfig});

  /// Check if a move is valid
  bool isValidMove(Position from, Position to, PlayerColor currentPlayer) {
    _logger.fine(
      "isValidMove: from=$from, to=$to, currentPlayer=$currentPlayer",
    );
    Piece? piece = board.getPiece(from);
    _logger.fine("Piece at from: $piece");
    if (piece == null || piece.playerColor != currentPlayer) {
      _logger.fine("Invalid: piece is null or not current player's");
      return false;
    }

    // Can't move to own den
    if (board.isOwnDen(to, currentPlayer)) {
      _logger.fine("Invalid: moving to own den");
      return false;
    }

    Piece? targetPiece = board.getPiece(to);
    _logger.fine("Target piece at to: $targetPiece");

    // Can't capture own pieces
    if (targetPiece != null && targetPiece.playerColor == currentPlayer) {
      _logger.fine("Invalid: capturing own piece");
      return false;
    }

    // Check if it's a jump move
    if (_canJumpOverRiver(from, to, piece)) {
      _logger.fine("Is a jump move");
      // If it's a jump, the 'to' position must be empty or contain a capturable piece
      if (targetPiece == null) {
        _logger.fine("Valid jump: target empty");
        return true;
      } else {
        _logger.fine("Valid jump: target capturable");
        return piece.canCapture(targetPiece);
      }
    }

    // If not a jump move, check if it's an adjacent move
    List<Position> adjacent = from.adjacentPositions;
    _logger.fine("Adjacent positions: $adjacent");
    if (!adjacent.contains(to)) {
      _logger.fine("Invalid: not adjacent and not a jump");
      return false; // Not adjacent and not a jump, so invalid
    }

    // Special rules for river entry (for adjacent moves)
    if (board.isRiver(to)) {
      _logger.fine("Moving to river");
      if (gameConfig.dogRiverVariant) {
        if (piece.animalType != AnimalType.rat &&
            piece.animalType != AnimalType.dog) {
          _logger.fine("Invalid: only rat or dog can enter river with variant");
          return false;
        }
      } else {
        if (piece.animalType != AnimalType.rat) {
          _logger.fine("Invalid: only rat can enter river without variant");
          return false;
        }
      }
    }

    // Check capture rules for adjacent moves
    if (targetPiece != null) {
      _logger.fine("Target piece exists, checking capture rules");
      // Pieces in traps can be captured by any opponent piece
      if (board.isTrap(to)) {
        _logger.fine("Target in trap, checking opponent piece");
        return targetPiece.playerColor != currentPlayer;
      }

      // Rat cannot capture elephant (if variant is enabled)
      if (gameConfig.ratCannotCaptureElephant &&
          piece.animalType == AnimalType.rat &&
          targetPiece.animalType == AnimalType.elephant) {
        _logger.fine("Invalid: rat cannot capture elephant variant");
        return false;
      }

      // Normal capture rules
      _logger.fine("Normal capture rules");
      return piece.canCapture(targetPiece);
    }

    _logger.fine("Valid adjacent move");
    return true;
  }

  /// Check if a piece can jump over a river
  bool _canJumpOverRiver(Position from, Position to, Piece piece) {
    _logger.fine("\n_canJumpOverRiver: from=$from, to=$to, piece=$piece");
    // Only lion and tiger can jump (and leopard with extended variant)
    bool canJump =
        (piece.animalType == AnimalType.lion ||
        piece.animalType == AnimalType.tiger);

    // With extended variant, leopard can also jump horizontally
    if (gameConfig.extendedLionTigerJumps &&
        piece.animalType == AnimalType.leopard) {
      canJump = true;
    }

    if (!canJump) {
      _logger.fine("Cannot jump: piece type not allowed");
      return false;
    }

    int distance;

    // Check horizontal jump (left or right)
    if (from.row == to.row) {
      distance = (from.column - to.column).abs();
      _logger.fine("Horizontal jump: distance=$distance");
      // Standard horizontal jump for Lion/Tiger (over 2 river cells)
      if ((piece.animalType == AnimalType.lion ||
              piece.animalType == AnimalType.tiger) &&
          distance == GameConstants.lionTigerHorizontalJumpDistance) {
        Position river1 = Position(
          from.column + (to.column > from.column ? 1 : -1),
          from.row,
        );
        Position river2 = Position(
          from.column + (to.column > from.column ? 2 : -2),
          from.row,
        );
        _logger.fine("River cells: $river1, $river2");
        if (board.isRiver(river1) && board.isRiver(river2)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          _logger.fine("Rats in river: $rat1, $rat2");
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat)) {
            _logger.fine("Cannot jump: rat in river");
            return false;
          }
          _logger.fine("Valid horizontal jump");
          return true;
        }
      }
      // Extended Lion double river jump (over 2 rivers)
      if (gameConfig.extendedLionTigerJumps &&
          piece.animalType == AnimalType.lion &&
          distance == GameConstants.extendedLionDoubleRiverJumpHorizontal) {
        // 2 columns for first river + 1 column for land + 2 columns for second river
        // Check if both rivers are clear of rats
        Position river1_1 = Position(
          from.column + (to.column > from.column ? 1 : -1),
          from.row,
        );
        Position river1_2 = Position(
          from.column + (to.column > from.column ? 2 : -2),
          from.row,
        );
        Position river2_1 = Position(
          from.column + (to.column > from.column ? 4 : -4),
          from.row,
        );
        Position river2_2 = Position(
          from.column + (to.column > from.column ? 5 : -5),
          from.row,
        );
        _logger.fine(
          "Double river cells: $river1_1, $river1_2, $river2_1, $river2_2",
        );
        if (board.isRiver(river1_1) &&
            board.isRiver(river1_2) &&
            board.isRiver(river2_1) &&
            board.isRiver(river2_2)) {
          if (board.getPiece(river1_1)?.animalType == AnimalType.rat ||
              board.getPiece(river1_2)?.animalType == AnimalType.rat ||
              board.getPiece(river2_1)?.animalType == AnimalType.rat ||
              board.getPiece(river2_2)?.animalType == AnimalType.rat) {
            _logger.fine("Cannot jump: rat in double river");
            return false;
          }
          _logger.fine("Valid double horizontal jump");
          return true;
        }
      }
      // Extended Leopard horizontal river crossing (same as single river jump)
      if (gameConfig.extendedLionTigerJumps &&
          piece.animalType == AnimalType.leopard &&
          distance == GameConstants.lionTigerHorizontalJumpDistance) {
        Position river1 = Position(
          from.column + (to.column > from.column ? 1 : -1),
          from.row,
        );
        Position river2 = Position(
          from.column + (to.column > from.column ? 2 : -2),
          from.row,
        );
        _logger.fine("Leopard river cells: $river1, $river2");
        if (board.isRiver(river1) && board.isRiver(river2)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          _logger.fine("Rats in leopard river: $rat1, $rat2");
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat)) {
            _logger.fine("Cannot jump: rat in leopard river");
            return false;
          }
          _logger.fine("Valid leopard horizontal jump");
          return true;
        }
      }
    }
    // Check vertical jump (up or down)
    else if (from.column == to.column) {
      distance = (from.row - to.row).abs();
      _logger.fine("Vertical jump: distance=$distance");
      // Standard vertical jump for Lion/Tiger (over 3 river cells)
      if ((piece.animalType == AnimalType.lion ||
              piece.animalType == AnimalType.tiger) &&
          distance == 4) {
        // Tiger needs to jump 4 rows (from row 2 to 6)
        Position river1 = Position(
          from.column,
          from.row + (to.row > from.row ? 1 : -1),
        );
        Position river2 = Position(
          from.column,
          from.row + (to.row > from.row ? 2 : -2),
        );
        Position river3 = Position(
          from.column,
          from.row + (to.row > from.row ? 3 : -3),
        );
        _logger.fine("River cells: $river1, $river2, $river3");
        if (board.isRiver(river1) &&
            board.isRiver(river2) &&
            board.isRiver(river3)) {
          Piece? rat1 = board.getPiece(river1);
          Piece? rat2 = board.getPiece(river2);
          Piece? rat3 = board.getPiece(river3);
          _logger.fine("Rats in river: $rat1, $rat2, $rat3");
          if ((rat1 != null && rat1.animalType == AnimalType.rat) ||
              (rat2 != null && rat2.animalType == AnimalType.rat) ||
              (rat3 != null && rat3.animalType == AnimalType.rat)) {
            _logger.fine("Cannot jump: rat in river");
            return false;
          }
          _logger.fine("Valid vertical jump");
          return true;
        }
      }
      // Extended Lion double river jump (over 2 rivers)
      if (gameConfig.extendedLionTigerJumps &&
          piece.animalType == AnimalType.lion &&
          distance == GameConstants.extendedLionDoubleRiverJumpVertical) {
        // 3 rows for first river + 1 row for land + 3 rows for second river
        // Check if both rivers are clear of rats
        Position river1_1 = Position(
          from.column,
          from.row + (to.row > from.row ? 1 : -1),
        );
        Position river1_2 = Position(
          from.column,
          from.row + (to.row > from.row ? 2 : -2),
        );
        Position river1_3 = Position(
          from.column,
          from.row + (to.row > from.row ? 3 : -3),
        );
        Position river2_1 = Position(
          from.column,
          from.row + (to.row > from.row ? 5 : -5),
        );
        Position river2_2 = Position(
          from.column,
          from.row + (to.row > from.row ? 6 : -6),
        );
        Position river2_3 = Position(
          from.column,
          from.row + (to.row > from.row ? 7 : -7),
        );
        _logger.fine(
          "Double river cells: $river1_1, $river1_2, $river1_3, $river2_1, $river2_2, $river2_3",
        );
        if (board.isRiver(river1_1) &&
            board.isRiver(river1_2) &&
            board.isRiver(river1_3) &&
            board.isRiver(river2_1) &&
            board.isRiver(river2_2) &&
            board.isRiver(river2_3)) {
          if (board.getPiece(river1_1)?.animalType == AnimalType.rat ||
              board.getPiece(river1_2)?.animalType == AnimalType.rat ||
              board.getPiece(river1_3)?.animalType == AnimalType.rat ||
              board.getPiece(river2_1)?.animalType == AnimalType.rat ||
              board.getPiece(river2_2)?.animalType == AnimalType.rat ||
              board.getPiece(river2_3)?.animalType == AnimalType.rat) {
            _logger.fine("Cannot jump: rat in double river");
            return false;
          }
          _logger.fine("Valid double vertical jump");
          return true;
        }
      }
    }

    _logger.fine("Invalid jump: no specific rule matched");
    return false;
  }
}
