import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/core/service_locator.dart';

void main() {
  group('GameController - River Rules', () {
    late GameController gameController;

    setUp(() {
      locator.reset(); // Reset GetIt before each test
      setupDependencies();
      gameController = locator<GameController>();
      gameController.resetGame();
    });

    tearDown(() {
      locator.reset(); // Reset GetIt after each test
    });

    test('Only Rat can enter the river', () {
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 _ _ _ _ _ _ _
      // 1 _ _ _ _ _ _ _
      // 2 _ R _ _ _ _ _  (Red Rat at (1,2))
      // 3 D 0 0 _ 0 0 _  (Red Dog at (0,3), River at (1,3), (2,3), (4,3), (5,3))
      // 4 _ 0 0 _ 0 0 _
      // 5 _ 0 0 _ 0 0 _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
      // River position (1,3)
      gameController.board.setPiece(
        Position(1, 2),
        Piece(AnimalType.rat, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(0, 3),
        Piece(AnimalType.dog, PlayerColor.red),
      ); // Dog near river
      gameController.currentPlayer = PlayerColor.red;

      // Rat can enter river
      gameController.selectPiece(Position(1, 2));
      expect(gameController.movePiece(Position(1, 3)), isTrue);
      expect(
        gameController.board.getPiece(Position(1, 3))?.animalType,
        AnimalType.rat,
      );

      // Dog cannot enter river
      gameController.currentPlayer = PlayerColor.red; // Switch back for dog
      gameController.selectPiece(Position(0, 3));
      expect(
        gameController.movePiece(Position(1, 3)),
        isFalse,
      ); // Dog trying to enter river
      expect(
        gameController.board.getPiece(Position(0, 3))?.animalType,
        AnimalType.dog,
      );
    });

    test('Lion can jump over river horizontally', () {
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 _ _ _ _ _ _ _
      // 1 _ _ _ _ _ _ _
      // 2 _ _ _ _ _ _ _
      // 3 _ 0 0 _ 0 0 _
      // 4 L 0 0 _ 0 0 _  (Red Lion at (0,4), River at (1,4), (2,4), (4,4), (5,4))
      // 5 _ 0 0 _ 0 0 _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
      // Lion at (0,4), river at (1,4) and (2,4), target (3,4)
      gameController.board.clearBoard();
      gameController.board.setPiece(
        Position(0, 4),
        Piece(AnimalType.lion, PlayerColor.red),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 4));
      expect(gameController.movePiece(Position(3, 4)), isTrue); // Lion jumps
      expect(
        gameController.board.getPiece(Position(3, 4))?.animalType,
        AnimalType.lion,
      );
      expect(gameController.board.getPiece(Position(0, 4)), isNull);
    });

    test('Tiger can jump over river vertically', () {
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 _ _ _ _ _ _ _
      // 1 _ _ _ _ _ _ _
      // 2 _ _ _ _ T _ _  (Red Tiger at (4,2))
      // 3 _ 0 0 _ 0 0 _  (River at (4,3))
      // 4 _ 0 0 _ 0 0 _  (River at (4,4))
      // 5 _ 0 0 _ 0 0 _  (River at (4,5))
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
      // Tiger at (4,2), river at (4,3), (4,4), (4,5), target (4,6)
      gameController.board.clearBoard();
      gameController.board.setPiece(
        Position(4, 2),
        Piece(AnimalType.tiger, PlayerColor.red),
      );
      gameController.board.dumpBoardAndChessPieces();
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(4, 2));
      expect(gameController.movePiece(Position(4, 6)), isTrue); // Tiger jumps
      expect(
        gameController.board.getPiece(Position(4, 6))?.animalType,
        AnimalType.tiger,
      );
      expect(gameController.board.getPiece(Position(4, 2)), isNull);
    });

    test('Lion/Tiger cannot jump if Rat is in the river', () {
      // Test Setup:
      //   0 1 2 3 4 5 6
      // 0 _ _ _ _ _ _ _
      // 1 _ _ _ _ _ _ _
      // 2 _ _ _ _ _ _ _
      // 3 _ 0 0 _ 0 0 _
      // 4 L r 0 _ 0 0 _  (Red Lion at (0,4), green rat at (1,4), River at (1,4), (2,4), (4,4), (5,4))
      // 5 _ 0 0 _ 0 0 _
      // 6 _ _ _ _ _ _ _
      // 7 _ _ _ _ _ _ _
      // 8 _ _ _ _ _ _ _
      // Lion at (0,4), Rat at (1,4) (in river), target (3,4)
      gameController.board.setPiece(
        Position(0, 4),
        Piece(AnimalType.lion, PlayerColor.red),
      );
      gameController.board.setPiece(
        Position(1, 4),
        Piece(AnimalType.rat, PlayerColor.green),
      ); // Rat in river
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(0, 4));
      expect(
        gameController.movePiece(Position(3, 4)),
        isFalse,
      ); // Lion cannot jump
      expect(
        gameController.board.getPiece(Position(0, 4))?.animalType,
        AnimalType.lion,
      );
      expect(
        gameController.board.getPiece(Position(1, 4))?.animalType,
        AnimalType.rat,
      );
    });
  });
}
