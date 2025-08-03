# Animal Chess Machine Learning Design and Training

This document describes the machine learning architecture and training process for the Animal Chess game.

## Overview

The Animal Chess game incorporates a machine learning component that uses neural networks to make intelligent moves. The ML system is designed to learn optimal strategies through training and can be integrated into the game to provide challenging AI opponents.

## Neural Network Architecture

To simplify the initial implementation and training, a basic neural network architecture is proposed. This can be expanded upon later for more sophisticated AI.

### Input Representation
The neural network takes a 7×9×2 tensor representing the board state:
- 7×9 grid representing the game board
- 2 channels:
  - Channel 0: Current player's pieces
  - Channel 1: Opponent's pieces

Each piece is encoded as a number from 0-7 (Elephant=0, Lion=1, Tiger=2, Leopard=3, Wolf=4, Dog=5, Cat=6, Rat=7) or 8 for empty positions.

### Core Network
A simple feed-forward network or a shallow convolutional neural network (CNN) can be used. For instance:
- **Input Layer**: Matches the 7x9x2 board representation.
- **Hidden Layers**: One or two fully connected layers (e.g., with ReLU activation) or a single convolutional layer followed by a fully connected layer. This keeps the model lightweight.

### Output Layers
The network produces two outputs:
1. **Policy Head**: A layer that outputs a probability distribution over all possible moves. This can be a flattened tensor representing all possible (piece, destination) pairs, followed by a softmax activation.
   - Outputs probability distribution over valid moves.

2. **Value Head**: A single neuron with a tanh activation function, outputting a scalar value representing win probability.
   - Outputs a value between -1 and 1
   - -1 indicates certain loss for current player
   - 1 indicates certain win for current player

## Training Process (Reinforcement Learning with Self-Play)

The training process will primarily leverage reinforcement learning through self-play, inspired by methods like AlphaZero. The neural network will learn by playing against itself, iteratively improving its policy (move probabilities) and value (win probability) predictions.

### Data Generation (Self-Play)
Training data will be generated exclusively through self-play games.
1.  **MCTS-Guided Self-Play**: The current neural network model will be used to guide a Monte Carlo Tree Search (MCTS) algorithm. MCTS will explore possible moves and build a search tree, providing robust policy targets.
2.  **Game Play**: The MCTS algorithm will select moves during self-play games.
3.  **Data Collection**: For each move in a self-play game, the following data will be recorded:
    *   Board state (input to the neural network)
    *   MCTS-derived policy (the probability distribution over moves from the MCTS search)
    *   Game outcome (win/loss/draw, used as the target for the value head)

### Training Script
The main training script is located at `ml/train/train.py` which will orchestrate the reinforcement learning loop:
1.  **Initialize Model**: Start with a randomly initialized neural network or a previously trained checkpoint.
2.  **Self-Play Generation**: Run multiple self-play games in parallel using the current model and MCTS. Collect the (state, MCTS_policy, game_outcome) tuples.
3.  **Data Storage**: Store the collected data in a replay buffer or dataset.
4.  **Model Training**:
    *   **Load Data**: Sample batches of data from the collected self-play games.
    *   **Loss Functions**:
        *   **Policy Loss**: Cross-entropy loss between the neural network's predicted policy and the MCTS-derived policy. This teaches the network to mimic the strong MCTS moves.
        *   **Value Loss**: Mean Squared Error (MSE) between the neural network's predicted value and the actual game outcome. This teaches the network to accurately predict win/loss/draw.
    *   **Optimization**: Use an optimizer (e.g., Adam) to minimize the combined policy and value losses.
5.  **Iterative Improvement**: Repeat steps 2-4. As the model trains, it becomes stronger, leading to better MCTS searches, which in turn generates higher quality training data, creating a positive feedback loop.
6.  **Save Checkpoints**: Periodically save the trained model weights as checkpoints.

### Key Components for Reinforcement Learning:
-   **MCTS Implementation**: A robust MCTS algorithm is crucial for generating high-quality training data.
-   **Game Environment**: A fast and accurate game environment (simulator) is needed for self-play.
-   **Replay Buffer**: To store and sample past experiences for training stability.
-   **Learning Rate Schedule**: Often, a decaying learning rate is used during training.

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
