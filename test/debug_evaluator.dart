import 'package:animal_chess/game/board_evaluator.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/game/game_rules.dart';

// Create a debug version of BoardEvaluator to see detailed scores
class DebugBoardEvaluator extends BoardEvaluator {
  DebugBoardEvaluator({
    required super.gameRules,
    required super.config,
    super.safetyWeight = 0.7,
    super.denProximityWeight = 1.2,
    super.pieceValueWeight = 0.9,
    super.threatWeight = 1.0,
  });

  // Make protected methods public for debugging
  @override
  double evaluatePieceValue(
    Piece piece,
    Position position,
    PlayerColor player,
  ) {
    return super.evaluatePieceValue(piece, position, player);
  }

  @override
  double evaluateSafety(
    GameBoard board,
    Position position,
    PlayerColor player,
  ) {
    final piece = board.getPiece(position);
    if (piece == null) return 0.0;

    print('  Evaluating safety for piece at $position: ${piece.playerColor} ${piece.animalType}');
    
    final opponent = player == PlayerColor.red
        ? PlayerColor.green
        : PlayerColor.red;
    double threatScore = 0.0;

    // Check if any opponent piece can capture this piece
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final opponentPiece = board.getPiece(pos);
        if (opponentPiece?.playerColor == opponent) {
          print('    Checking if ${opponentPiece!.playerColor} ${opponentPiece.animalType} at $pos can capture our piece');
          final canCapture = gameRules.isValidMove(pos, position, opponent);
          print('      Can capture: $canCapture');
          if (canCapture) {
            // Threat is more significant for higher rank pieces
            final threatValue = (9 - opponentPiece.animalType.rank) * 0.7;
            print('      Threat value: $threatValue');
            threatScore -= threatValue;
          }
        }
      }
    }
    
    print('    Final safety score: $threatScore');
    return threatScore;
  }

  @override
  double evaluateThreats(
    GameBoard board,
    Position position,
    Piece piece,
    PlayerColor player,
  ) {
    if (piece.playerColor != player) return 0.0;
    
    print('  Evaluating threats for piece at $position: ${piece.playerColor} ${piece.animalType}');

    double threatScore = 0.0;
    final opponent = player == PlayerColor.red
        ? PlayerColor.green
        : PlayerColor.red;

    // Check if this piece can capture any opponent piece
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final targetPiece = board.getPiece(pos);
        if (targetPiece?.playerColor == opponent) {
          print('    Checking if our ${piece.playerColor} ${piece.animalType} can capture ${targetPiece!.playerColor} ${targetPiece.animalType} at $pos');
          final canCapture = gameRules.isValidMove(position, pos, player);
          print('      Can capture: $canCapture');
          if (canCapture) {
            // Can capture - positive value
            // Value based on the rank of the piece being captured
            final threatValue = targetPiece.animalType.rank * 0.5;
            print('      Threat value: $threatValue');
            threatScore += threatValue;
          }
        }
      }
    }
    
    print('    Final threats score: $threatScore');
    return threatScore;
  }

  @override
  double evaluateDenProximity(GameBoard board, PlayerColor player) {
    return super.evaluateDenProximity(board, player);
  }

  @override
  double evaluateBoardState(GameBoard board, PlayerColor player) {
    double score = 0.0;
    double totalPieceValue = 0.0;
    double totalSafety = 0.0;
    double totalThreats = 0.0;
    double totalDenProximity = 0.0;

    print('Evaluating board for player: $player');

    // Evaluate each piece on the board
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);

        if (piece != null) {
          // Add or subtract based on piece value
          final pieceValue = evaluatePieceValue(piece, pos, player);
          totalPieceValue += pieceValue;
          print(
            '  Piece at $pos: ${piece.playerColor} ${piece.animalType}, value: $pieceValue',
          );

          // Evaluate safety of the piece
          final safety = evaluateSafety(board, pos, player);
          totalSafety += safety * safetyWeight;
          print('    Safety: $safety, weighted: ${safety * safetyWeight}');

          // Evaluate threats this piece can make
          final threats = evaluateThreats(board, pos, piece, player);
          totalThreats += threats * threatWeight;
          print('    Threats: $threats, weighted: ${threats * threatWeight}');
        }
      }
    }

    // Evaluate proximity to opponent's den
    final denProximity = evaluateDenProximity(board, player);
    totalDenProximity = denProximity * denProximityWeight;
    print('Den proximity: $denProximity, weighted: $totalDenProximity');

    score = totalPieceValue + totalSafety + totalThreats + totalDenProximity;

    print('Total piece value: $totalPieceValue');
    print('Total safety: $totalSafety');
    print('Total threats: $totalThreats');
    print('Total den proximity: $totalDenProximity');
    print('Final score: $score');

    return score;
  }
}

void main() {
  final config = GameConfig();

  // Test case 1: Red rat threatened by green cat
  print('=== Test case 1: Red rat threatened by green cat ===');
  final board1 = GameBoard();
  board1.clearBoard();
  board1.setPiece(Position(0, 0), Piece(AnimalType.rat, PlayerColor.red));
  board1.setPiece(Position(0, 1), Piece(AnimalType.cat, PlayerColor.green));

  final rules1 = GameRules(board: board1, gameConfig: config);
  final evaluator1 = DebugBoardEvaluator(gameRules: rules1, config: config);

  final score1 = evaluator1.evaluateBoardState(board1, PlayerColor.red);
  print('Total score: $score1');

  // Test case 2: Red cat can capture green rat
  print('\n=== Test case 2: Red cat can capture green rat ===');
  final board2 = GameBoard();
  board2.clearBoard();
  board2.setPiece(Position(0, 0), Piece(AnimalType.cat, PlayerColor.red));
  board2.setPiece(Position(0, 1), Piece(AnimalType.rat, PlayerColor.green));

  final rules2 = GameRules(board: board2, gameConfig: config);
  final evaluator2 = DebugBoardEvaluator(gameRules: rules2, config: config);

  final score2 = evaluator2.evaluateBoardState(board2, PlayerColor.red);
  print('Total score: $score2');
}
