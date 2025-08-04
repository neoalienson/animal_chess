import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';

// Conditional import for platform-specific implementations
import 'animal_chess_network_mobile.dart'
    if (dart.library.html) 'animal_chess_network_web.dart';

abstract class AnimalChessNetwork {
  Future<void> loadModel();
  List<double> predict(GameBoard board, PlayerColor currentPlayer);
  void close();

  factory AnimalChessNetwork() => getAnimalChessNetwork();
}