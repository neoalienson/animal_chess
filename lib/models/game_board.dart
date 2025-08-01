import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/constants/board_constants.dart';
import 'package:animal_chess/constants/game_constants.dart';
import 'package:logging/logging.dart';

class GameBoard {
  final Logger _logger = Logger('GameBoard');

  // Board state
  final Map<Position, Piece?> _board = {};

  // Special positions
  final Map<PlayerColor, Position> dens = BoardConstants.dens;

  final Map<PlayerColor, List<Position>> traps = BoardConstants.traps;

  final List<Position> rivers = BoardConstants.rivers;

  GameBoard() {
    initializeDefaultBoard();
  }

  // Named constructor for an empty board
  GameBoard.empty();

  /// Initialize the board with pieces in their starting positions
  void initializeDefaultBoard() {
    // Clear the board
    clearBoard();

    // Place pieces based on GameConstants
    GameConstants.pieceStartPositions.forEach((playerColor, pieces) {
      for (var pieceData in pieces) {
        _board[pieceData['position']] = Piece(pieceData['type'], playerColor);
      }
    });
  }

  /// Get the piece at a specific position
  Piece? getPiece(Position position) {
    return _board[position];
  }

  /// Set a piece at a specific position
  void setPiece(Position position, Piece? piece) {
    if (position.isValid) {
      _board[position] = piece;
    }
  }

  /// Move a piece from one position to another
  bool movePiece(Position from, Position to) {
    if (!from.isValid || !to.isValid) return false;

    Piece? piece = _board[from];
    if (piece == null) return false;

    _board[to] = piece;
    _board[from] = null;
    return true;
  }

  /// Remove a piece from the board
  void removePiece(Position position) {
    _board[position] = null;
  }

  /// Clear all pieces from the board
  void clearBoard() {
    for (int col = 0; col < BoardConstants.columns; col++) {
      for (int row = 0; row < BoardConstants.rows; row++) {
        _board[Position(col, row)] = null;
      }
    }
  }

  void dumpBoardAndChessPieces() {
    _logger.fine("""Board State (R=Red, G=Green, 0=River):""");
    for (int row = 0; row < BoardConstants.rows; row++) {
      String rowString = "";
      for (int col = 0; col < BoardConstants.columns; col++) {
        Position currentPosition = Position(col, row);
        Piece? piece = getPiece(currentPosition);
        if (piece != null) {
          String pieceChar;
          switch (piece.animalType) {
            case AnimalType.elephant:
              pieceChar = "E";
              break;
            case AnimalType.lion:
              pieceChar = "L";
              break;
            case AnimalType.tiger:
              pieceChar = "T";
              break;
            case AnimalType.leopard:
              pieceChar =
                  "P"; // Using P for Leopard to avoid conflict with Lion
              break;
            case AnimalType.wolf:
              pieceChar = "W";
              break;
            case AnimalType.dog:
              pieceChar = "D";
              break;
            case AnimalType.cat:
              pieceChar = "C";
              break;
            case AnimalType.rat:
              pieceChar = "R";
              break;
          }
          if (piece.playerColor == PlayerColor.red) {
            rowString += "${pieceChar.toUpperCase()} ";
          } else {
            rowString += "${pieceChar.toLowerCase()} ";
          }
        } else if (isRiver(currentPosition)) {
          rowString += "0 ";
        } else if (isTrap(currentPosition)) {
          rowString += "X "; // 'X' for trap
        } else if (isDen(currentPosition)) {
          rowString += "H "; // 'H' for den (home)
        } else {
          rowString += "- ";
        }
      }
      _logger.fine(rowString);
    }
  }

  /// Check if a position is a den
  bool isDen(Position position) {
    return dens.values.contains(position);
  }

  /// Check if a position is a trap
  bool isTrap(Position position) {
    return traps[PlayerColor.green]!.contains(position) ||
        traps[PlayerColor.red]!.contains(position);
  }

  /// Check if a position is in the river
  bool isRiver(Position position) {
    return rivers.contains(position);
  }

  /// Get the owner of a den or trap (null if not a den or trap)
  PlayerColor? getZoneOwner(Position position) {
    if (dens[PlayerColor.green] == position) return PlayerColor.green;
    if (dens[PlayerColor.red] == position) return PlayerColor.red;

    if (traps[PlayerColor.green]!.contains(position)) return PlayerColor.green;
    if (traps[PlayerColor.red]!.contains(position)) return PlayerColor.red;

    return null;
  }

  /// Check if a position is the player's own den
  bool isOwnDen(Position position, PlayerColor player) {
    return dens[player] == position;
  }

  /// Check if a position is the opponent's den
  bool isOpponentDen(Position position, PlayerColor player) {
    PlayerColor opponent = player == PlayerColor.green
        ? PlayerColor.red
        : PlayerColor.green;
    return dens[opponent] == position;
  }

  /// Get all pieces of a specific player
  Map<Position, Piece> getPlayerPieces(PlayerColor player) {
    Map<Position, Piece> playerPieces = {};
    _board.forEach((position, piece) {
      if (piece != null && piece.playerColor == player) {
        playerPieces[position] = piece;
      }
    });
    return playerPieces;
  }

  /// Check if the game has a winner
  PlayerColor? getWinner() {
    // Check if any piece is in the opponent's den
    Piece? greenPieceInRedDen = _board[dens[PlayerColor.red]!];
    if (greenPieceInRedDen != null &&
        greenPieceInRedDen.playerColor == PlayerColor.green) {
      return PlayerColor.green;
    }

    Piece? redPieceInGreenDen = _board[dens[PlayerColor.green]!];
    if (redPieceInGreenDen != null &&
        redPieceInGreenDen.playerColor == PlayerColor.red) {
      return PlayerColor.red;
    }

    // Check if a player has no pieces left
    bool greenHasPieces = getPlayerPieces(PlayerColor.green).isNotEmpty;
    bool redHasPieces = getPlayerPieces(PlayerColor.red).isNotEmpty;

    if (!greenHasPieces) return PlayerColor.red;
    if (!redHasPieces) return PlayerColor.green;

    return null;
  }

  /// Create a copy of the board (for game state management)
  GameBoard copy() {
    GameBoard newBoard = GameBoard();
    newBoard._board.clear();
    _board.forEach((position, piece) {
      newBoard._board[position] = piece != null
          ? Piece(piece.animalType, piece.playerColor)
          : null;
    });
    return newBoard;
  }
}
