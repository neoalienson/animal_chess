import numpy as np
import tensorflow as tf
from tensorflow import keras
import os

from ml.train.animal_chess_env import AnimalChessEnv
from ml.train.neural_network import create_animal_chess_model
from ml.train.self_play import run_self_play
from ml.train.utils import get_num_actions

# --- Hyperparameters ---
NUM_ITERATIONS = 10          # Number of training iterations
NUM_SELF_PLAY_GAMES = 5      # Number of self-play games per iteration
NUM_SIMULATIONS_PER_MOVE = 50 # Number of MCTS simulations per move during self-play
BATCH_SIZE = 32              # Batch size for neural network training
LEARNING_RATE = 0.001        # Learning rate for the optimizer

CHECKPOINT_DIR = 'ml/models'

def train_model():
    print("Starting training process...")

    # Create model and optimizer
    num_actions = get_num_actions()
    model = create_animal_chess_model(num_actions)
    optimizer = keras.optimizers.Adam(learning_rate=LEARNING_RATE)

    model.compile(
        optimizer=optimizer,
        loss={
            'policy_output': keras.losses.CategoricalCrossentropy(),
            'value_output': keras.losses.MeanSquaredError()
        },
        metrics={
            'policy_output': ['accuracy'],
            'value_output': ['mae']
        }
    )

    # Create checkpoint directory if it doesn't exist
    os.makedirs(CHECKPOINT_DIR, exist_ok=True)

    for i in range(NUM_ITERATIONS):
        print(f"\n--- Iteration {i+1}/{NUM_ITERATIONS} ---")
        all_game_data = []

        # 1. Self-Play Data Generation
        print(f"Generating {NUM_SELF_PLAY_GAMES} self-play games...")
        for game_idx in range(NUM_SELF_PLAY_GAMES):
            print(f"  Running self-play game {game_idx+1}/{NUM_SELF_PLAY_GAMES}...")
            game_data = run_self_play(model, num_simulations=NUM_SIMULATIONS_PER_MOVE)
            all_game_data.extend(game_data)
        
        if not all_game_data:
            print("No game data collected in this iteration. Skipping training.")
            continue

        # Prepare data for training
        board_states = np.array([d[0] for d in all_game_data])
        mcts_policies = np.array([d[1] for d in all_game_data])
        game_outcomes = np.array([d[2] for d in all_game_data])

        print(f"Collected {len(all_game_data)} data points. Training model...")

        # 2. Model Training
        model.fit(
            board_states,
            {'policy_output': mcts_policies, 'value_output': game_outcomes},
            batch_size=BATCH_SIZE,
            epochs=1, # Train for one epoch per iteration
            verbose=1
        )

        # 3. Save Model Checkpoint
        checkpoint_path = os.path.join(CHECKPOINT_DIR, f'model_iteration_{i+1}.h5')
        model.save(checkpoint_path)
        print(f"Model checkpoint saved to {checkpoint_path}")

    print("Training process completed.")

if __name__ == '__main__':
    train_model()
