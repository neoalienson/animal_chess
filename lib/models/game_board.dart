import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';

class GameBoard {
  static const int columns = 7;
  static const int rows = 9;

  // Board state
  final Map<Position, Piece?> _board = {};

  // Special positions
  final Map<PlayerColor, Position> dens = {
    PlayerColor.green: Position(3, 0),
    PlayerColor.red: Position(3, 8),
  };

  final Map<PlayerColor, List<Position>> traps = {
    PlayerColor.green: [Position(2, 0), Position(4, 0), Position(3, 1)],
    PlayerColor.red: [Position(2, 8), Position(4, 8), Position(3, 7)],
  };

  final List<Position> rivers = [
    // Left river (2x3 area)
    Position(1, 3),
    Position(1, 4),
    Position(1, 5),
    Position(2, 3),
    Position(2, 4),
    Position(2, 5),
    // Right river (2x3 area)
    Position(4, 3),
    Position(4, 4),
    Position(4, 5),
    Position(5, 3),
    Position(5, 4),
    Position(5, 5),
  ];

  GameBoard() {
    _initializeBoard();
  }

  /// Initialize the board with pieces in their starting positions
  void _initializeBoard() {
    // Clear the board
    for (int col = 0; col < columns; col++) {
      for (int row = 0; row < rows; row++) {
        _board[Position(col, row)] = null;
      }
    }

    // Place green pieces (top player)
    _board[Position(0, 0)] = Piece(AnimalType.lion, PlayerColor.green);
    _board[Position(6, 0)] = Piece(AnimalType.tiger, PlayerColor.green);
    _board[Position(1, 1)] = Piece(AnimalType.dog, PlayerColor.green);
    _board[Position(5, 1)] = Piece(AnimalType.cat, PlayerColor.green);
    _board[Position(0, 2)] = Piece(AnimalType.rat, PlayerColor.green);
    _board[Position(2, 2)] = Piece(AnimalType.leopard, PlayerColor.green);
    _board[Position(4, 2)] = Piece(AnimalType.wolf, PlayerColor.green);
    _board[Position(6, 2)] = Piece(AnimalType.elephant, PlayerColor.green);

    // Place red pieces (bottom player)
    _board[Position(6, 8)] = Piece(AnimalType.lion, PlayerColor.red);
    _board[Position(0, 8)] = Piece(AnimalType.tiger, PlayerColor.red);
    _board[Position(5, 7)] = Piece(AnimalType.dog, PlayerColor.red);
    _board[Position(1, 7)] = Piece(AnimalType.cat, PlayerColor.red);
    _board[Position(6, 6)] = Piece(AnimalType.rat, PlayerColor.red);
    _board[Position(4, 6)] = Piece(AnimalType.leopard, PlayerColor.red);
    _board[Position(2, 6)] = Piece(AnimalType.wolf, PlayerColor.red);
    _board[Position(0, 6)] = Piece(AnimalType.elephant, PlayerColor.red);
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
