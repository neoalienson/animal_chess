import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from ml.train.constants import BOARD_ROWS, BOARD_COLS

def create_animal_chess_model(num_actions):
    """
    Creates a Keras model for Animal Chess using convolutional layers.

    Args:
        num_actions (int): The total number of possible moves (policy head output size).
    """
    # Input layer: 7x9x2 board state
    # Channel 0: Current player's pieces (0-7 for Elephant-Rat, 8 for empty)
    # Channel 1: Opponent's pieces (0-7 for Elephant-Rat, 8 for empty)
    input_board = keras.Input(shape=(BOARD_ROWS, BOARD_COLS, 2), name='board_input')

    # --- Convolutional Layers ---
    # First convolutional block
    x = layers.Conv2D(32, (3, 3), padding='same', activation='relu')(input_board)
    x = layers.BatchNormalization()(x)

    # Second convolutional block
    x = layers.Conv2D(64, (3, 3), padding='same', activation='relu')(x)
    x = layers.BatchNormalization()(x)

    # Third convolutional block (optional, can add more for deeper networks)
    x = layers.Conv2D(128, (3, 3), padding='same', activation='relu')(x)
    x = layers.BatchNormalization()(x)

    # Flatten the output of the convolutional layers for the dense heads
    x = layers.Flatten()(x)

    # --- Common Dense Layer before heads ---
    x = layers.Dense(256, activation='relu')(x)
    x = layers.BatchNormalization()(x)

    # --- Policy Head ---
    # Outputs a probability distribution over all possible moves
    policy_head = layers.Dense(num_actions, activation='softmax', name='policy_output')(x)

    # --- Value Head ---
    # Outputs a scalar value representing win probability (-1 to 1)
    value_head = layers.Dense(1, activation='tanh', name='value_output')(x)

    model = keras.Model(inputs=input_board, outputs=[policy_head, value_head])

    return model

if __name__ == '__main__':
    # Example usage:
    # num_actions will be BOARD_ROWS * BOARD_COLS * BOARD_ROWS * BOARD_COLS
    example_num_actions = BOARD_ROWS * BOARD_COLS * BOARD_ROWS * BOARD_COLS # 9*7*9*7 = 3969
    model = create_animal_chess_model(example_num_actions)
    model.summary()

    # Compile the model (example optimizers and loss functions)
    model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=0.001),
        loss={
            'policy_output': keras.losses.CategoricalCrossentropy(),
            'value_output': keras.losses.MeanSquaredError()
        },
        metrics={
            'policy_output': ['accuracy'],
            'value_output': ['mae']
        }
    )

    print("Model created and compiled successfully.")