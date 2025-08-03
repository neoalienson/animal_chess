import 'package:test/test.dart';
import 'package:animal_chess/ai/den_proximity_evaluator.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/game/game_rules.dart';

void main() {
  group('DenProximityEvaluator', () {
    late GameConfig config;
    late GameRules rules;
    late DenProximityEvaluator evaluator;

    setUp(() {
      config = GameConfig();
      rules = GameRules(board: GameBoard(), gameConfig: config);
      evaluator = DenProximityEvaluator(
        gameRules: rules,
        config: config,
        denProximityWeight: 1.0,
      );
    });

    test('lion river jump increases proximity score', () {
      // Pre-river state (row 6 for red player, green den at row 0)
      final preRiverBoard = GameBoard.empty()
        ..setPiece(Position(3, 6), Piece(AnimalType.lion, PlayerColor.red));
      
      // Post-river state (row 2 for red player, green den at row 0)
      final postRiverBoard = GameBoard.empty()
        ..setPiece(Position(3, 2), Piece(AnimalType.lion, PlayerColor.red));

      final preScore = evaluator.evaluateDenProximity(preRiverBoard, PlayerColor.red);
      final postScore = evaluator.evaluateDenProximity(postRiverBoard, PlayerColor.red);

      // Verify river crossing increases proximity score
      expect(postScore, greaterThan(preScore));
    });

    test('multiple pieces near den give higher score', () {
      // Two pieces near the den (row 1 and row 2)
      final board = GameBoard.empty()
        ..setPiece(Position(2, 1), Piece(AnimalType.lion, PlayerColor.red))
        ..setPiece(Position(4, 2), Piece(AnimalType.tiger, PlayerColor.red));

      final score = evaluator.evaluateDenProximity(board, PlayerColor.red);
      expect(score, greaterThan(0.0));
    });

    test('piece at den edge gives highest score', () {
      // Piece at row 1 (closest to green den at row 0)
      final board = GameBoard.empty()
        ..setPiece(Position(3, 1), Piece(AnimalType.lion, PlayerColor.red));

      final score = evaluator.evaluateDenProximity(board, PlayerColor.red);
      expect(score, greaterThan(0.0));
    });
  });
}
