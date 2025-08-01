import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/core/service_locator.dart';

const bool kEnableTestDebugOutput = bool.fromEnvironment('ENABLE_TEST_DEBUG_OUTPUT', defaultValue: false);

void main() {
  group('GameController - Game Variants', () {
    late GameController gameController;

    setUp(() {
      locator.reset(); // Reset GetIt before each test
      setupDependencies();
      gameController = locator<GameController>();
    });

    tearDown(() {
      locator.reset(); // Reset GetIt after each test
    });

    test(
      'Rat-Only Den Entry: Only Rat can win by entering opponent\'s den',
      () {
        GameConfig config = GameConfig(ratOnlyDenEntry: true);
        locator.unregister<GameConfig>();
        locator.registerLazySingleton<GameConfig>(() => config);
        GameController gameController = locator<GameController>();
        gameController.board.clearBoard(); // Clear the board before setting up custom pieces
        gameController.resetGame();

        // Test Setup:
        //   0 1 2 3 4 5 6
        // 0 _ _ _ d _ _ _  (Green Den at (3,0))
        // 1 _ _ _ R _ _ _  (Red Rat at (3,1))
        // 2 _ _ _ _ _ _ _
        // 3 _ _ _ _ _ _ _
        // 4 _ _ _ _ _ _ _
        // 5 _ _ _ _ _ _ _
        // 6 _ _ _ _ _ _ _
        // 7 _ _ _ _ _ _ _
        // 8 _ _ _ _ _ _ _
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
        locator.unregister<GameConfig>();
        locator.registerLazySingleton<GameConfig>(() => config);
        gameController = locator<GameController>();
        gameController.board.clearBoard();
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
        locator.unregister<GameConfig>();
        locator.registerLazySingleton<GameConfig>(() => config);
        GameController gameController = locator<GameController>();
        gameController.board.clearBoard(); // Clear the board before setting up custom pieces
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

    test('Dog can enter river', () {
      GameConfig config = GameConfig(dogRiverVariant: true);
      locator.unregister<GameConfig>();
      locator.registerLazySingleton<GameConfig>(() => config);
      GameController gameController = locator<GameController>();
      gameController.resetGame();
      gameController.board.clearBoard();

      // Dog at (1,2), river at (1,3)
      gameController.board.setPiece(
        Position(1, 2),
        Piece(AnimalType.dog, PlayerColor.red),
      );
      gameController.currentPlayer = PlayerColor.red;
      if (kEnableTestDebugOutput) {
        gameController.board.dumpBoardAndChessPieces();
      }

      gameController.selectPiece(Position(1, 2));
      expect(
        gameController.movePiece(Position(1, 3)),
        isTrue,
      ); // Dog enters river
      expect(
        gameController.board.getPiece(Position(1, 3))?.animalType,
        AnimalType.dog,
      );
    });

    test('Dog River Variant: Dog can enter river and capture from river', () {
      GameConfig config = GameConfig(extendedLionTigerJumps: true);
      locator.unregister<GameConfig>();
      locator.registerLazySingleton<GameConfig>(() => config);
      GameController gameController = locator<GameController>();
      gameController.resetGame();
      gameController.board.clearBoard();

      gameController.board.setPiece(
        Position(1, 3),
        Piece(AnimalType.dog, PlayerColor.red),
      );

      // Place a Cat on the shore next to the dog in the river
      gameController.board.setPiece(
        Position(0, 3),
        Piece(AnimalType.cat, PlayerColor.green),
      );
      gameController.currentPlayer = PlayerColor.red; // Still red's turn
      if (kEnableTestDebugOutput) {
        gameController.board.dumpBoardAndChessPieces();
      }

      gameController.selectPiece(Position(1, 3)); // Select dog in river
      expect(
        gameController.movePiece(Position(0, 3)),
        isTrue,
      ); // Dog captures Cat from river
      expect(
        gameController.board.getPiece(Position(0, 3))?.animalType,
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
      locator.unregister<GameConfig>();
      locator.registerLazySingleton<GameConfig>(() => config);
      GameController gameController = locator<GameController>();
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
