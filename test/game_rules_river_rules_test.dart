import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';

void main() {
  group('GameController - River Rules', () {
    late GameController gameController;

    setUp(() {
      gameController = GameController(gameConfig: GameConfig());
      gameController.resetGame();
    });

    test('Only Rat can enter the river', () {
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
      // Lion at (0,4), river at (1,4) and (2,4), target (3,4)
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
      // Tiger at (4,2), river at (4,3), (4,4), (4,5), target (4,6)
      gameController.board.setPiece(
        Position(4, 2),
        Piece(AnimalType.tiger, PlayerColor.red),
      );
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