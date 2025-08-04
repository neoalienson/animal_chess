import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/game/game_rules.dart';

void main() {
  final board = GameBoard();
  final config = GameConfig();
  final rules = GameRules(board: board, gameConfig: config);

  // Test case 1: Red rat threatened by green cat
  print('=== Test case 1: Red rat threatened by green cat ===');
  final board1 = GameBoard();
  board1.clearBoard();
  board1.setPiece(Position(0, 0), Piece(AnimalType.rat, PlayerColor.red));
  board1.setPiece(Position(0, 1), Piece(AnimalType.cat, PlayerColor.green));

  final rules1 = GameRules(board: board1, gameConfig: config);

  print('Can green cat at (0,1) move to (0,0) to capture red rat?');
  final canCapture = rules1.isValidMove(
    Position(0, 1),
    Position(0, 0),
    PlayerColor.green,
  );
  print('Result: $canCapture');

  // Test case 2: Red cat can capture green rat
  print('\n=== Test case 2: Red cat can capture green rat ===');
  final board2 = GameBoard();
  board2.clearBoard();
  board2.setPiece(Position(0, 0), Piece(AnimalType.cat, PlayerColor.red));
  board2.setPiece(Position(0, 1), Piece(AnimalType.rat, PlayerColor.green));

  final rules2 = GameRules(board: board2, gameConfig: config);

  print('Can red cat at (0,0) move to (0,1) to capture green rat?');
  final canCapture2 = rules2.isValidMove(
    Position(0, 0),
    Position(0, 1),
    PlayerColor.red,
  );
  print('Result: $canCapture2');
}
