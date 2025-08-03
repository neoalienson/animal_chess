import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Placeholder for ML network - to be implemented with TensorFlow Lite or similar
class AnimalChessNetwork {
  late Interpreter _interpreter;
  bool _isModelLoaded;

  bool get isModelLoaded => _isModelLoaded;

  /// Default constructor for ML network
  AnimalChessNetwork() : _isModelLoaded = false {
    // Initialization logic will be added when TensorFlow Lite is available
  }

  /// Constructor for ML network
  AnimalChessNetwork.fromTflite(String modelPath) : _isModelLoaded = false {
    _loadModel(modelPath);
  }

  Future<void> _loadModel(String modelPath) async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      _isModelLoaded = true;
      print('Model loaded successfully from $modelPath');
    } catch (e) {
      print('Failed to load model: $e');
      _isModelLoaded = false;
    }
  }

  /// Convert GameBoard to input tensor for neural network
  List<double> preprocess(GameBoard board, PlayerColor player) {
    // Create a 7x9x2 tensor (board dimensions x 2 channels)
    // Channel 0: Current player's pieces
    // Channel 1: Opponent's pieces
    final tensor = List.filled(7 * 9 * 2, 0.0);
    
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final position = Position(col, row);
        final piece = board.getPiece(position);
        
        if (piece != null) {
          // Determine if piece belongs to current player
          int channel = piece.playerColor == player ? 0 : 1;
          
          // Encode piece type (0-7 for animals, 8 for empty)
          int pieceTypeIndex = 8; // Default to empty
          if (piece.animalType == AnimalType.elephant) pieceTypeIndex = 0;
          else if (piece.animalType == AnimalType.lion) pieceTypeIndex = 1;
          else if (piece.animalType == AnimalType.tiger) pieceTypeIndex = 2;
          else if (piece.animalType == AnimalType.leopard) pieceTypeIndex = 3;
          else if (piece.animalType == AnimalType.wolf) pieceTypeIndex = 4;
          else if (piece.animalType == AnimalType.dog) pieceTypeIndex = 5;
          else if (piece.animalType == AnimalType.cat) pieceTypeIndex = 6;
          else if (piece.animalType == AnimalType.rat) pieceTypeIndex = 7;
          
          // Store in tensor
          tensor[row * 7 + col + channel * 7 * 9] = pieceTypeIndex.toDouble();
        }
      }
    }
    
    return tensor;
  }

  /// Predict move probabilities and win probability
  /// Returns (policy, value) - to be implemented with actual ML inference
  (List<double> policy, double value) predict(List<double> inputTensor) {
    if (!_isModelLoaded) {
      print('Model not loaded. Cannot predict.');
      return (List.filled(7 * 9 * 9 * 7, 0.0), 0.0); // Return dummy values
    }

    // Input tensor shape: [1, 9, 7, 2]
    final input = inputTensor.reshape([1, 9, 7, 2]);

    // Output tensors: policy and value
    // Policy output shape: [1, 9*7*9*7] (total possible moves)
    // Value output shape: [1, 1]
    final Map<int, Object> outputs = {
      0: List.filled(1 * (9 * 7 * 9 * 7), 0.0).reshape([1, (9 * 7 * 9 * 7)]),
      1: List.filled(1 * 1, 0.0).reshape([1, 1]),
    };

    _interpreter.run(input, outputs);

    final policyOutput = (outputs[0] as List<dynamic>).cast<List<double>>()[0];
    final valueOutput = (outputs[1] as List<dynamic>).cast<List<double>>()[0][0];

    return (policyOutput, valueOutput);
  }

  /// Dispose of interpreter resources
  void dispose() {
    if (_isModelLoaded) {
      _interpreter.close();
      _isModelLoaded = false;
      print('Model interpreter disposed.');
    }
  }
}

extension on List<double> {
  List<List<List<List<double>>>> reshape(List<int> dimensions) {
    if (dimensions.length != 4) {
      throw ArgumentError("Only 4D reshaping is supported for now.");
    }
    final d1 = dimensions[0];
    final d2 = dimensions[1];
    final d3 = dimensions[2];
    final d4 = dimensions[3];

    final reshaped = List.generate(d1, (_) =>
        List.generate(d2, (_) =>
            List.generate(d3, (_) =>
                List.filled(d4, 0.0)
            )
        )
    );

    int index = 0;
    for (int i = 0; i < d1; i++) {
      for (int j = 0; j < d2; j++) {
        for (int k = 0; k < d3; k++) {
          for (int l = 0; l < d4; l++) {
            if (index < this.length) {
              reshaped[i][j][k][l] = this[index];
              index++;
            }
          }
        }
      }
    }
    return reshaped;
  }
}
