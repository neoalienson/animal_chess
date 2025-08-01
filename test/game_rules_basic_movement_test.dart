import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/core/service_locator.dart';

void main() {
  group('GameController - Basic Movement and Capture', () {
    late GameController gameController;

    setUpAll(() {
      setupDependencies();
    });

    setUp(() {
      gameController = locator<GameController>();
      gameController.resetGame();
    });

    tearDown(() {
      locator.reset();
    });

    test('Piece moves one space orthogonally', () {
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 R _ _ _ _ _ _  (Red Rat at (0,0))
      // 1 _ _ _ _ _ _ _
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 R _ _ _ _ _ _  (Red Rat at (0,0))
      // 1 _ _ _ _ _ _ _
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
      gameController.board.clearBoard();
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 _ _ _ _ _ _ _
      // 1 _ _ _ _ _ _ _
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ R _ _ _  (Red Rat at (3,7))
      // 8 _ _ _ D _ _ _  (Red Den at (3,8))
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 C _ _ _ _ _ _  (Red Cat at (0,0))
      // 1 r _ _ _ _ _ _  (Green Rat at (0,1))
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 R _ _ _ _ _ _  (Red Rat at (0,0))
      // 1 c _ _ _ _ _ _  (Green Cat at (0,1))
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 R _ _ _ _ _ _  (Red Rat at (0,0))
      // 1 e _ _ _ _ _ _  (Green Elephant at (0,1))
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 E _ _ _ _ _ _  (Red Elephant at (0,0))
      // 1 r _ _ _ _ _ _  (Green Rat at (0,1))
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
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
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 _ _ t _ _ _ _  (Green Trap at (2,0))
      // 1 _ _ C _ _ _ _  (Red Cat at (2,1))
      // 2 _ _ _ _ _ _ _
      // 3 _ _ _ _ _ _ _
      // 4 _ _ _ _ _ _ _
      // 5 _ _ _ _ _ _ _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
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
