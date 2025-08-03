import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:animal_chess/ai/animal_chess_network.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/constants/board_constants.dart';
import 'package:animal_chess/models/position.dart';

class AnimalChessNetworkMobile implements AnimalChessNetwork {
  late Interpreter _interpreter;

  @override
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/animal_chess_model.tflite');
      print('TFLite model loaded successfully.');
    } catch (e) {
      print('Failed to load TFLite model: $e');
      rethrow;
    }
  }

  @override
  List<double> predict(GameBoard board, PlayerColor currentPlayer) {
    // Convert GameBoard to the input tensor format (7x9x2)
    final input = _convertBoardToInput(board, currentPlayer);

    // Define output shapes: policy (7x9x4) and value (1)
    final output = {
      0: List<List<List<double>>>.filled(BoardConstants.rows, List<List<double>>.filled(BoardConstants.columns, List<double>.filled(4, 0.0))),
      1: List<double>.filled(1, 0.0),
    };

    _interpreter.run(input, output);

    // Flatten the policy output and return it along with the value
    final policy = (output[0] as List<List<List<double>>>).expand((row) => row.expand((col) => col)).toList();
    final value = output[1]![0] as double;

    return policy + [value];
  }

  List<List<List<double>>> _convertBoardToInput(GameBoard board, PlayerColor currentPlayer) {
    final input = List<List<List<double>>>.filled(BoardConstants.rows, List<List<double>>.filled(BoardConstants.columns, List<double>.filled(2, 0.0)));

    for (int r = 0; r < BoardConstants.rows; r++) {
      for (int c = 0; c < BoardConstants.columns; c++) {
        final piece = board.getPiece(Position(r, c));
        if (piece != null) {
          final pieceValue = piece.animalType.index.toDouble(); // Assuming AnimalType enum index maps to 0-7
          if (piece.playerColor == currentPlayer) {
            input[r][c][0] = pieceValue; // Current player's pieces
          } else {
            input[r][c][1] = pieceValue; // Opponent's pieces
          }
        } else {
          input[r][c][0] = 8.0; // Empty position for current player
          input[r][c][1] = 8.0; // Empty position for opponent
        }
      }
    }
    return input;
  }

  @override
  void close() {
    _interpreter.close();
  }
}

AnimalChessNetwork getAnimalChessNetwork() => AnimalChessNetworkMobile();
