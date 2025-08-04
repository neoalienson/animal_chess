import tensorflow as tf
from tensorflow.keras import layers, models

def create_simple_animal_chess_model(input_shape=(9, 7, 2)):
    # Input layer
    input_board = layers.Input(shape=input_shape, name='input_board')

    # Flatten the input for a simple feed-forward network
    x = layers.Flatten()(input_board)

    # Hidden layers
    x = layers.Dense(128, activation='relu')(x)
    x = layers.Dense(64, activation='relu')(x)

    # Policy Head: Output for move probabilities
    # Assuming 9*7 board positions * 4 directions = 252 possible moves
    policy_head = layers.Dense(9 * 7 * 4, activation='softmax', name='policy_output')(x)

    # Value Head: Output for win probability
    value_head = layers.Dense(1, activation='tanh', name='value_output')(x)

    model = models.Model(inputs=input_board, outputs=[policy_head, value_head])
    return model

if __name__ == '__main__':
    model = create_simple_animal_chess_model()
    model.summary()
