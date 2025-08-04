import numpy as np
import tensorflow as tf
import os

from ml.train.animal_chess_env import AnimalChessEnv
from ml.train.neural_network import create_animal_chess_model
from ml.train.utils import get_num_actions, int_to_move
from ml.train.constants import BOARD_ROWS, BOARD_COLS

MODEL_DIR = 'ml/models'

def evaluate_model(model_path=None):
    print("Starting model evaluation...")

    # Load the model
    model = None
    if model_path is None:
        model_files = [f for f in os.listdir(MODEL_DIR) if f.endswith('.h5')]
        if not model_files:
            print(f"No .h5 models found in {MODEL_DIR}. Please train a model first.")
            return
        model_files.sort(key=lambda x: os.path.getmtime(os.path.join(MODEL_DIR, x)), reverse=True)
        latest_model_path = os.path.join(MODEL_DIR, model_files[0])
        print(f"Loading latest model from: {latest_model_path}")
        model = tf.keras.models.load_model(latest_model_path)
    else:
        print(f"Loading model from: {model_path}")
        model = tf.keras.models.load_model(model_path)

    if model is None:
        print("Failed to load model. Exiting evaluation.")
        return

    # Initialize a game environment to get a board state
    env = AnimalChessEnv()
    initial_observation = env._get_observation()

    # Add batch dimension for model prediction
    input_batch = np.expand_dims(initial_observation, axis=0)

    # Make a prediction
    policy_logits, value_pred = model.predict(input_batch)

    policy_probs = np.squeeze(policy_logits) # Remove batch dimension
    value = np.squeeze(value_pred) # Remove batch dimension

    print("\n--- Model Prediction on Initial Board State ---")
    print(f"Predicted Value (Win Probability): {value:.4f}")

    # Print top N moves from policy
    top_n = 5
    # Get indices of top N probabilities
    top_move_indices = np.argsort(policy_probs)[::-1][:top_n]

    print(f"Top {top_n} Predicted Moves (Policy Probabilities):")
    for i in top_move_indices:
        move_tuple = int_to_move(i)
        prob = policy_probs[i]
        print(f"  Move {move_tuple}: {prob:.4f}")

    print("\nModel evaluation completed.")

if __name__ == '__main__':
    evaluate_model()