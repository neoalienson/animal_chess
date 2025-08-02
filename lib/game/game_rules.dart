import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/constants/game_constants.dart';
import 'package:animal_chess/game/rules/game_rule_variant.dart';
import 'package:animal_chess/game/rules/game_rule_factory.dart';
import 'package:logging/logging.dart';

class GameRules {
  final GameBoard board;
  final GameConfig gameConfig;
  final GameRuleVariant ruleVariant;
  final Logger _logger = Logger('GameRules');

  GameRules({required this.board, required this.gameConfig})
    : ruleVariant = GameRuleFactory.createRuleVariant(gameConfig);

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
    if (!ruleVariant.canMoveToDen(to, currentPlayer, board, gameConfig)) {
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
    if (ruleVariant.canJumpOverRiver(from, to, piece, board, gameConfig)) {
      _logger.fine("Is a jump move");
      // If it's a jump, the 'to' position must be empty or contain a capturable piece
      if (targetPiece == null) {
        _logger.fine("Valid jump: target empty");
        return true;
      } else {
        _logger.fine("Valid jump: target capturable");
        return ruleVariant.canCapture(
          piece,
          targetPiece,
          to,
          board,
          gameConfig,
        );
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
      if (!ruleVariant.canEnterRiver(piece, to, board, gameConfig)) {
        _logger.fine("Invalid: piece cannot enter river");
        return false;
      }
    }

    // Check capture rules for adjacent moves
    if (targetPiece != null) {
      _logger.fine("Target piece exists, checking capture rules");
      if (!ruleVariant.canCapture(piece, targetPiece, to, board, gameConfig)) {
        _logger.fine("Invalid: cannot capture target piece");
        return false;
      }
    }

    _logger.fine("Valid adjacent move");
    return true;
  }

  /// Check if a piece can jump over a river
  bool _canJumpOverRiver(Position from, Position to, Piece piece) {
    return ruleVariant.canJumpOverRiver(from, to, piece, board, gameConfig);
  }
}
