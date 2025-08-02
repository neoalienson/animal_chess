import 'package:animal_chess/game/ai_strategy.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/game/ai_move.dart';

void main() {
  // Create a game board
  final board = GameBoard();
  final config = GameConfig();
  final rules = GameRules(board: board, gameConfig: config);
  final actions = GameActions(
    board: board,
    gameConfig: config,
    gameRules: rules,
  );

  // Create AI strategy
  final ai = AIStrategy(config);

  // Print the board state
  print('Board state:');
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 7; col++) {
      final pos = Position(col, row);
      final piece = board.getPiece(pos);
      if (piece != null) {
        print(
          'Position ($col, $row): ${piece.playerColor} ${piece.animalType}',
        );
      }
    }
  }

  // Test AI move calculation for green player
  print('\nGetting valid moves for green player:');
  final validMoves = <Move>[]; // We can't access _getAllValidMoves directly
  print('Found ${validMoves.length} valid moves for green player');

  for (int i = 0; i < validMoves.length && i < 5; i++) {
    final move = validMoves[i];
    print('Move $i: ${move.from} -> ${move.to}');

    // Check what piece is at the from position
    final piece = board.getPiece(move.from);
    if (piece != null) {
      print('  Piece: ${piece.playerColor} ${piece.animalType}');
    }

    // Check what piece is at the to position
    final targetPiece = board.getPiece(move.to);
    if (targetPiece != null) {
      print('  Target: ${targetPiece.playerColor} ${targetPiece.animalType}');
    }
  }

  if (validMoves.isEmpty) {
    print('No valid moves found for green player');

    // Let's check each position to see what pieces green player has
    print('\nGreen player pieces:');
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        if (piece != null && piece.playerColor == PlayerColor.green) {
          print('Green piece at ($col, $row): ${piece.animalType}');

          // Check valid moves for this piece
          final pieceMoves = actions.getValidMoves(pos);
          print('  Valid moves: ${pieceMoves.length}');
          for (final move in pieceMoves) {
            print('    -> ($col, $row) -> (${move.column}, ${move.row})');
          }
        }
      }
    }
  }

  final bestMove = ai.calculateBestMove(board, PlayerColor.green, actions);

  if (bestMove != null) {
    print('\nGreen AI found a move: ${bestMove.from} -> ${bestMove.to}');
  } else {
    print('\nGreen AI could not find a move');
  }
}
