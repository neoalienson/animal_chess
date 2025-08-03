import numpy as np
import random
from ml.train.animal_chess_env import AnimalChessEnv
from ml.train.mcts import MCTS
from ml.train.neural_network import create_animal_chess_model
from ml.train.utils import get_num_actions, int_to_move, move_to_int
from ml.train.board_scenarios import BOARD_SCENARIOS
from ml.train.constants import RED_PLAYER, GREEN_PLAYER

def run_self_play(model, num_simulations=100, max_moves=200):
    """
    Runs a single self-play game and collects training data.

    Args:
        model: The neural network model.
        num_simulations (int): Number of MCTS simulations per move.
        max_moves (int): Maximum number of moves in a game to prevent infinite loops.

    Returns:
        list: A list of (board_state, mcts_policy, game_outcome) tuples.
    """
    # Randomly select an initial scenario
    initial_scenario = random.choice(BOARD_SCENARIOS)
    print(f"Starting self-play game with scenario: {initial_scenario['name']}")

    env = AnimalChessEnv(initial_scenario=initial_scenario)
    mcts = MCTS(model, num_simulations=num_simulations)
    
    game_data = [] # Stores (board_state, mcts_policy, current_player)
    current_player_at_state = [] # Stores the player whose turn it was at that state

    for i in range(max_moves):
        # Get current board state and player
        board_state = env._get_observation()
        current_player = env.current_player

        # Run MCTS to get policy
        mcts.run(env)
        mcts_policy_dict = mcts.get_policy() # {move_int: prob}

        # Convert MCTS policy to a full array for training
        mcts_policy_array = np.zeros(get_num_actions())
        for move_int, prob in mcts_policy_dict.items():
            mcts_policy_array[move_int] = prob

        game_data.append((board_state, mcts_policy_array, current_player))

        # Select a move based on MCTS policy (with some exploration/temperature)
        # For now, just pick the move with the highest probability
        if not mcts_policy_dict:
            # No legal moves, game might be over or stuck
            break
        
        # Choose move based on policy (can add temperature for exploration)
        # For simplicity, pick the move with the highest probability
        best_move_int = max(mcts_policy_dict, key=mcts_policy_dict.get)
        selected_move_tuple = int_to_move(best_move_int)

        # Apply the move
        obs, reward, done, info = env.step(selected_move_tuple)

        if done:
            break

    # Game has ended, now assign outcomes
    final_outcome = 0 # Draw
    if env.winner == RED_PLAYER:
        final_outcome = 1
    elif env.winner == GREEN_PLAYER:
        final_outcome = -1

    # Backpropagate outcome to all states
    processed_game_data = []
    for board_state, mcts_policy, player_at_state in game_data:
        # Outcome is from the perspective of the player whose turn it was at that state
        outcome_for_player = final_outcome * player_at_state # Multiply by player_at_state (1 or -1)
        processed_game_data.append((board_state, mcts_policy, outcome_for_player))

    return processed_game_data

if __name__ == '__main__':
    # Example usage:
    num_actions = get_num_actions()
    model = create_animal_chess_model(num_actions)
    print("Running a self-play game...")
    data = run_self_play(model, num_simulations=10)
    print(f"Collected {len(data)} states from self-play game.")
    if data:
        print("First data point:")
        print(f"  Board State Shape: {data[0][0].shape}")
        print(f"  MCTS Policy Shape: {data[0][1].shape}")
        print(f"  Game Outcome: {data[0][2]}")
