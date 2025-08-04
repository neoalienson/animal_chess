from ml.train.neural_network import create_animal_chess_model, BOARD_ROWS, BOARD_COLS
import numpy as np

def test_model():
    num_actions = BOARD_ROWS * BOARD_COLS * 4 # Example: 9*7*4 = 252 possible moves
    model = create_animal_chess_model(num_actions)
    model.summary()

    # Create dummy input data
    dummy_input = np.random.randint(0, 9, size=(1, BOARD_ROWS, BOARD_COLS, 2))

    # Make a prediction
    policy_output, value_output = model.predict(dummy_input)

    print(f"Policy output shape: {policy_output.shape}")
    print(f"Value output shape: {value_output.shape}")

    assert policy_output.shape == (1, num_actions)
    assert value_output.shape == (1, 1)

    print("Neural network test passed!")

if __name__ == "__main__":
    test_model()
