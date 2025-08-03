# Animal Chess Machine Learning Design and Training

This document describes the machine learning architecture and training process for the Animal Chess game.

## Overview

The Animal Chess game incorporates a machine learning component that uses neural networks to make intelligent moves. The ML system is designed to learn optimal strategies through training and can be integrated into the game to provide challenging AI opponents.

## Neural Network Architecture

### Input Representation
The neural network takes a 7×9×2 tensor representing the board state:
- 7×9 grid representing the game board
- 2 channels:
  - Channel 0: Current player's pieces
  - Channel 1: Opponent's pieces

Each piece is encoded as a number from 0-7 (Elephant=0, Lion=1, Tiger=2, Leopard=3, Wolf=4, Dog=5, Cat=6, Rat=7) or 8 for empty positions.

### Output Layers
The network produces two outputs:
1. **Policy Head**: 7×9×4 tensor representing move probabilities
   - Each position has 4 possible directions (up, down, left, right)
   - Outputs probability distribution over valid moves

2. **Value Head**: Scalar value representing win probability
   - Outputs a value between -1 and 1
   - -1 indicates certain loss for current player
   - 1 indicates certain win for current player

## Training Process

### Data Generation
Training data is generated through:
1. Human player games (collected from gameplay)
2. Self-play (AI vs AI games)
3. Random simulations

### Training Script
The main training script is located at `ml/train/train.py` which:
- Sets up the neural network architecture
- Loads training data
- Performs model training with appropriate loss functions
- Saves checkpoints during training

### Model Export
After training, the model must be exported to TensorFlow Lite format for mobile deployment:
```bash
python ml/export/export_to_tflite.py
```

This creates a `.tflite` file that can be loaded by the game.

## Integration with Game

The `AnimalChessNetwork` class in `lib/ai/animal_chess_network.dart` handles the integration:
- Loading and preprocessing board states
- Making predictions using the neural network
- Managing model lifecycle and resources

## Implementation Notes

1. **Model Availability**: The ML features are disabled by default in the UI until a trained model is available
2. **Model Format**: Currently designed for TensorFlow Lite format (.tflite)
3. **Training Requirements**: Requires significant computational resources and data
4. **Extensibility**: The architecture can be extended with more sophisticated neural network designs

## Getting Started with Training

1. Install dependencies:
   ```bash
   pip install -r ml/requirements.txt
   ```

2. Prepare training data (either collect from human games or generate through self-play)

3. Train the model:
   ```bash
   python ml/train/train.py --epochs 100 --samples 10000
   ```

4. Export for use in the game:
   ```bash
   python ml/export/export_to_tflite.py
   ```

5. The exported model should be placed in the appropriate location for the game to load it
