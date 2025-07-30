import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';

void main() {
  group('GameController - Basic Movement and Capture', () {
    late GameController gameController;

    setUp(() {
      gameController = GameController(gameConfig: GameConfig());
      gameController.resetGame();
    });

    test('Piece moves one space orthogonally', () {
      // Place a rat at (0,0)
      gameController.board.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.red),
      );
      gameController.currentPlayer = PlayerColor.red;

      // Valid move: (0,0) to (0,1)
      gameController.selectPiece(Position(0, 0));
      expect(gameController.movePiece(Position(0, 1)), isTrue);
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.rat,
      );
      expect(gameController.board.getPiece(Position(0, 0)), isNull);
    });

    test('Piece cannot move diagonally', () {
      gameController.board.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.red),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 0));
      expect(
        gameController.movePiece(Position(1, 1)),
        isFalse,
      ); // Diagonal move
      expect(
        gameController.board.getPiece(Position(0, 0))?.animalType,
        AnimalType.rat,
      );
      expect(gameController.board.getPiece(Position(1, 1)), isNull);
    });

    test('Piece cannot move into its own den', () {
      // Red's den is at (3,8)
      gameController.board.setPiece(
        Position(3, 7),
        Piece(AnimalType.rat, PlayerColor.red),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(3, 7));
      expect(
        gameController.movePiece(Position(3, 8)),
        isFalse,
      ); // Red trying to enter own den
      expect(
        gameController.board.getPiece(Position(3, 7))?.animalType,
        AnimalType.rat,
      );
    });

    test("Piece can capture opponent's piece of equal or lower rank", () {
      // Red Cat (rank 7) at (0,0), Green Rat (rank 8) at (0,1)
      gameController.board.setPiece(
        Position(0, 0),
        Piece(AnimalType.cat, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(0, 1),
        Piece(AnimalType.rat, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 0));
      expect(
        gameController.movePiece(Position(0, 1)),
        isTrue,
      ); // Cat captures Rat
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.cat,
      );
      expect(
        gameController.board.getPiece(Position(0, 1))?.playerColor,
        PlayerColor.red,
      );
      expect(
        gameController.capturedPieces.contains(
          Piece(AnimalType.rat, PlayerColor.green),
        ),
        isTrue,
      );
    });

    test("Piece cannot capture opponent's piece of higher rank", () {
      // Red Rat (rank 8) at (0,0), Green Cat (rank 7) at (0,1)
      gameController.board.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(0, 1),
        Piece(AnimalType.cat, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 0));
      expect(
        gameController.movePiece(Position(0, 1)),
        isFalse,
      ); // Rat cannot capture Cat
      expect(
        gameController.board.getPiece(Position(0, 0))?.animalType,
        AnimalType.rat,
      );
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.cat,
      );
    });

    test('Rat can capture Elephant', () {
      // Red Rat (rank 8) at (0,0), Green Elephant (rank 1) at (0,1)
      gameController.board.setPiece(
        Position(0, 0),
        Piece(AnimalType.rat, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(0, 1),
        Piece(AnimalType.elephant, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 0));
      expect(
        gameController.movePiece(Position(0, 1)),
        isTrue,
      ); // Rat captures Elephant
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.rat,
      );
      expect(
        gameController.capturedPieces.contains(
          Piece(AnimalType.elephant, PlayerColor.green),
        ),
        isTrue,
      );
    });

    test('Elephant can capture Rat', () {
      // Red Elephant (rank 1) at (0,0), Green Rat (rank 8) at (0,1)
      gameController.board.setPiece(
        Position(0, 0),
        Piece(AnimalType.elephant, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(0, 1),
        Piece(AnimalType.rat, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 0));
      expect(
        gameController.movePiece(Position(0, 1)),
        isTrue,
      ); // Elephant captures Rat
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.elephant,
      );
      expect(
        gameController.capturedPieces.contains(
          Piece(AnimalType.rat, PlayerColor.green),
        ),
        isTrue,
      );
    });

    test('Any piece can capture an opponent\'s piece in a trap', () {
      // Red Cat (rank 7) at (2,1), Green Elephant (rank 1) at (2,0) (Green's trap)
      gameController.board.setPiece(
        Position(2, 1),
        Piece(AnimalType.cat, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(2, 0),
        Piece(AnimalType.elephant, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(2, 1));
      expect(
        gameController.movePiece(Position(2, 0)),
        isTrue,
      ); // Cat captures Elephant in trap
      expect(
        gameController.board.getPiece(Position(2, 0))?.animalType,
        AnimalType.cat,
      );
      expect(
        gameController.capturedPieces.contains(
          Piece(AnimalType.elephant, PlayerColor.green),
        ),
        isTrue,
      );
    });
  });
}