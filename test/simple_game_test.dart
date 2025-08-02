import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/game/game_rules.dart';

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

  // Test a simple move for a green piece
  final startPos = Position(0, 0); // Green lion
  final targetPos = Position(0, 1); // Move down one space

  print('Testing move from $startPos to $targetPos');

  // Check what piece is at the start position
  final piece = board.getPiece(startPos);
  if (piece != null) {
    print('Piece at start position: ${piece.playerColor} ${piece.animalType}');
  } else {
    print('No piece at start position');
  }

  // Check what piece is at the target position
  final targetPiece = board.getPiece(targetPos);
  if (targetPiece != null) {
    print(
      'Piece at target position: ${targetPiece.playerColor} ${targetPiece.animalType}',
    );
  } else {
    print('No piece at target position');
  }

  // Check if the move is valid according to the rules
  final isValid = rules.isValidMove(startPos, targetPos, PlayerColor.green);
  print('Is move valid according to rules: $isValid');

  // Check valid moves for this piece
  final validMoves = actions.getValidMoves(startPos);
  print('Valid moves for this piece: ${validMoves.length}');
  for (final move in validMoves) {
    print('  -> ($startPos) -> ($move)');
  }
}
