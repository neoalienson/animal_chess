import numpy as np
from ml.train.mcts import MCTS, MCTSNode
from ml.train.animal_chess_env import AnimalChessEnv, RED_PLAYER, GREEN_PLAYER
from ml.train.neural_network import create_animal_chess_model, BOARD_ROWS, BOARD_COLS
from ml.train.self_play import run_self_play
from ml.train.utils import get_num_actions

def test_mcts():
    print("Initializing AnimalChessEnv...")
    env = AnimalChessEnv()
    env.render()

    print("Creating dummy neural network model...")
    num_actions = get_num_actions()
    model = create_animal_chess_model(num_actions)

    print("Initializing MCTS...")
    mcts = MCTS(model, num_simulations=10)

    print("Running MCTS simulations...")
    mcts.run(env)

    print("Getting MCTS policy...")
    policy = mcts.get_policy()

    print("MCTS Policy:")
    for move_int, prob in policy.items():
        # Convert move_int back to (from_pos, to_pos) for readability
        from ml.train.utils import int_to_move
        move_tuple = int_to_move(move_int)
        print(f"  Move {move_tuple}: {prob:.4f}")

    print("MCTS test completed.")

    print("\n--- Testing Self-Play --- ")
    print("Running a self-play game to collect data...")
    collected_data = run_self_play(model, num_simulations=5, max_moves=50)
    print(f"Collected {len(collected_data)} states from self-play game.")

    if collected_data:
        print("First collected data point:")
        first_board_state, first_mcts_policy, first_game_outcome = collected_data[0]
        print(f"  Board State Shape: {first_board_state.shape}")
        print(f"  MCTS Policy Shape: {first_mcts_policy.shape}")
        print(f"  Game Outcome: {first_game_outcome}")

    print("Self-play test completed.")

if __name__ == "__main__":
    test_mcts()