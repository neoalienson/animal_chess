import 'package:animal_chess/game/rules/game_rule_variant.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/constants/game_constants.dart';

/// Standard implementation of game rules (core rules without any variants)
class StandardGameRuleVariant implements GameRuleVariant {
  @override
  bool canEnterRiver(
    Piece piece,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // In standard rules, only rats can enter rivers
    return piece.animalType == AnimalType.rat;
  }

  @override
  bool canCapture(
    Piece attacker,
    Piece target,
    Position to,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // Pieces in traps can be captured by any opponent piece
    if (board.isTrap(to)) {
      return target.playerColor != attacker.playerColor;
    }

    // Normal capture rules
    return attacker.canCapture(target);
  }

  @override
  bool canJumpOverRiver(
    Position from,
    Position to,
    Piece piece,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // Only lion and tiger can jump in standard rules
    if (piece.animalType != AnimalType.lion &&
        piece.animalType != AnimalType.tiger) {
      return false;
    }

    int distance;

    // Check horizontal jump (left or right)
    if (from.row == to.row) {
      distance = (from.column - to.column).abs();
      // Standard horizontal jump for Lion/Tiger (over 2 river cells)
      if (distance == GameConstants.lionTigerHorizontalJumpDistance) {
        Position river1 = Position(
          from.column + (to.column > from.column ? 1 : -1),
          from.row,
        );
        Position river2 = Position(
          from.column + (to.column > from.column ? 2 : -2),
          from.row,
        );
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
      if (distance == 4) {
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
        if (board.isRiver(river1) &&
            board.isRiver(river2) &&
            board.isRiver(river3)) {
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
    }

    return false;
  }

  @override
  bool canMoveToDen(
    Position to,
    PlayerColor currentPlayer,
    GameBoard board,
    GameConfig gameConfig,
  ) {
    // Can't move to own den
    return !board.isOwnDen(to, currentPlayer);
  }
}
