import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';

void main() {
  group('GameController - Game Variants', () {
    test(
      'Rat-Only Den Entry: Only Rat can win by entering opponent\'s den',
      () {
        GameConfig config = GameConfig(ratOnlyDenEntry: true);
        GameController gameController = GameController(gameConfig: config);
      gameController.resetGame();

        // Red Rat at (3,7), Green's den at (3,0)
        gameController.board.setPiece(
          Position(3, 1),
          Piece(AnimalType.rat, PlayerColor.red),
        );
        gameController.currentPlayer = PlayerColor.red;

        gameController.selectPiece(Position(3, 1));
        expect(gameController.movePiece(Position(3, 0)), isTrue); // Rat wins
        expect(gameController.gameEnded, isTrue);
        expect(gameController.winner, PlayerColor.red);

        // Reset and test with a non-rat piece
        gameController = GameController(gameConfig: config);
      gameController.resetGame();
        gameController.board.setPiece(
          Position(3, 1),
          Piece(AnimalType.dog, PlayerColor.red),
        );
        gameController.currentPlayer = PlayerColor.red;

        gameController.selectPiece(Position(3, 1));
        expect(
          gameController.movePiece(Position(3, 0)),
          isFalse,
        ); // Dog cannot win
        expect(gameController.gameEnded, isFalse);
        expect(gameController.winner, isNull);
      },
    );

    test(
      'Extended Lion/Tiger Jumps: Leopard can cross rivers horizontally',
      () {
        GameConfig config = GameConfig(extendedLionTigerJumps: true);
        GameController gameController = GameController(gameConfig: config);
      gameController.resetGame();

        // Leopard at (0,4), river at (1,4) and (2,4), target (3,4)
        gameController.board.setPiece(
          Position(0, 4),
          Piece(AnimalType.leopard, PlayerColor.red),
        );
        gameController.currentPlayer = PlayerColor.red;

        gameController.selectPiece(Position(0, 4));
        expect(
          gameController.movePiece(Position(3, 4)),
          isTrue,
        ); // Leopard jumps
        expect(
          gameController.board.getPiece(Position(3, 4))?.animalType,
          AnimalType.leopard,
        );
      },
    );

    test('Dog River Variant: Dog can enter river and capture from river', () {
      GameConfig config = GameConfig(dogRiverVariant: true);
      GameController gameController = GameController(gameConfig: config);
      gameController.resetGame();

      // Dog at (1,2), river at (1,3)
      gameController.board.setPiece(
        Position(1, 2),
        Piece(AnimalType.dog, PlayerColor.red),
      );
      gameController.currentPlayer = PlayerColor.red;

      gameController.selectPiece(Position(1, 2));
      expect(
        gameController.movePiece(Position(1, 3)),
        isTrue,
      ); // Dog enters river
      expect(
        gameController.board.getPiece(Position(1, 3))?.animalType,
        AnimalType.dog,
      );

      // Place a Cat on the shore next to the dog in the river
      gameController.board.setPiece(
        Position(1, 4),
        Piece(AnimalType.cat, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red; // Still red's turn

      gameController.selectPiece(Position(1, 3)); // Select dog in river
      expect(
        gameController.movePiece(Position(1, 4)),
        isTrue,
      ); // Dog captures Cat from river
      expect(
        gameController.board.getPiece(Position(1, 4))?.animalType,
        AnimalType.dog,
      );
      expect(
        gameController.capturedPieces.contains(
          Piece(AnimalType.cat, PlayerColor.green),
        ),
        isTrue,
      );
    });

    test('Rat cannot capture Elephant variant', () {
      GameConfig config = GameConfig(ratCannotCaptureElephant: true);
      GameController gameController = GameController(gameConfig: config);
      gameController.resetGame();

      // Red Rat at (0,0), Green Elephant at (0,1)
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
        isFalse,
      ); // Rat cannot capture Elephant
      expect(
        gameController.board.getPiece(Position(0, 0))?.animalType,
        AnimalType.rat,
      );
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.elephant,
      );
    });
  });
}