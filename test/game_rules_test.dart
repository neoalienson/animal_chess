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
      // Set up a custom board for testing specific scenarios
      gameController.board = GameBoard(); // Reset board
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
        isTrue,
      ); // Rat captures Cat
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.rat,
      );
      expect(
        gameController.board.getPiece(Position(0, 1))?.playerColor,
        PlayerColor.red,
      );
      expect(
        gameController.capturedPieces.contains(
          Piece(AnimalType.cat, PlayerColor.green),
        ),
        isTrue,
      );
    });

    test("Piece cannot capture opponent's piece of higher rank", () {
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
        isFalse,
      ); // Cat cannot capture Rat
      expect(
        gameController.board.getPiece(Position(0, 0))?.animalType,
        AnimalType.cat,
      );
      expect(
        gameController.board.getPiece(Position(0, 1))?.animalType,
        AnimalType.rat,
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

  group('GameController - River Rules', () {
    late GameController gameController;

    setUp(() {
      gameController = GameController(gameConfig: GameConfig());
      gameController.board = GameBoard(); // Reset board
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

  group('GameController - Game Variants', () {
    test(
      'Rat-Only Den Entry: Only Rat can win by entering opponent\'s den',
      () {
        GameConfig config = GameConfig(ratOnlyDenEntry: true);
        GameController gameController = GameController(gameConfig: config);
        gameController.board = GameBoard(); // Reset board

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
        gameController.board = GameBoard();
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
        gameController.board = GameBoard(); // Reset board

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
      gameController.board = GameBoard(); // Reset board

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
      gameController.board = GameBoard(); // Reset board

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
