import 'package:animal_chess/ai/animal_chess_network.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';

class AnimalChessNetworkWeb implements AnimalChessNetwork {
  @override
  Future<void> loadModel() async {
    print('TFLite model loading skipped for web.');
  }

  @override
  List<double> predict(GameBoard board, PlayerColor currentPlayer) {
    print('AI prediction skipped for web (dummy implementation).');
    // Return dummy values for policy (7x9x4 = 252) and value (1)
    return List<double>.filled(253, 0.0);
  }

  @override
  void close() {
    print('TFLite interpreter closing skipped for web.');
  }
}

AnimalChessNetwork getAnimalChessNetwork() => AnimalChessNetworkWeb();
