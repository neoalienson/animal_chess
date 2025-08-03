import numpy as np
import math
from ml.train.animal_chess_env import AnimalChessEnv
from ml.train.utils import move_to_int, int_to_move, get_num_actions
from ml.train.constants import RED_PLAYER, GREEN_PLAYER

class MCTSNode:
    def __init__(self, state, parent=None, move=None, prior_p=0):
        self.state = state  # The game state (board, current player)
        self.parent = parent
        self.move = move  # The move that led to this state from parent (integer representation)
        self.children = {}
        self.n = 0  # Visit count
        self.w = 0  # Total win value
        self.q = 0  # Mean action value (w/n)
        self.p = prior_p  # Prior probability from policy network

    def is_leaf(self):
        return len(self.children) == 0

    def is_root(self):
        return self.parent is None

    def uct_value(self, c_puct):
        if self.n == 0:
            return float('inf') # Encourage exploration of unvisited nodes
        return self.q + c_puct * self.p * (math.sqrt(self.parent.n) / (1 + self.n))

    def select_child(self, c_puct):
        """Selects the child with the highest UCT value."""
        best_child = None
        best_uct = -float('inf')
        for move_int, child in self.children.items():
            uct = child.uct_value(c_puct)
            if uct > best_uct:
                best_uct = uct
                best_child = child
        return best_child, int_to_move(best_child.move)

    def expand(self, policy_probs_array):
        """Expands the node by creating new children for all legal moves."""
        env = AnimalChessEnv() # Create a temporary env to get valid moves
        env.board = np.copy(self.state['board'])
        env.current_player = self.state['current_player']

        legal_moves = env._get_valid_moves()

        for move_tuple in legal_moves:
            move_int = move_to_int(move_tuple[0], move_tuple[1])
            
            # Simulate the move to get the next state
            temp_env = AnimalChessEnv() # Use a fresh env for simulation
            temp_env.board = np.copy(self.state['board'])
            temp_env.current_player = self.state['current_player']
            
            # Apply the move, including capture logic
            target_piece_val = temp_env.board[move_tuple[1][0], move_tuple[1][1]]
            if target_piece_val != 0: # If there's a piece at the target, it's a capture
                temp_env.board[move_tuple[1][0], move_tuple[1][1]] = 0 # Remove captured piece
            
            temp_env._apply_move(move_tuple[0], move_tuple[1])
            temp_env.current_player *= -1 # Switch player for next state
            next_state = {'board': temp_env.board, 'current_player': temp_env.current_player}

            prior_p = policy_probs_array[move_int]

            self.children[move_int] = MCTSNode(next_state, parent=self, move=move_int, prior_p=prior_p)

    def backpropagate(self, value):
        """Updates the visit counts and values up the tree."""
        self.n += 1
        self.w += value
        self.q = self.w / self.n
        if self.parent:
            self.parent.backpropagate(-value) # Value is from perspective of current node's player


class MCTS:
    def __init__(self, model, c_puct=1.0, num_simulations=100):
        self.model = model  # The neural network model
        self.c_puct = c_puct
        self.num_simulations = num_simulations
        self.root = None

    def run(self, initial_env):
        """Runs MCTS simulations from the initial environment state."""
        initial_state = {'board': initial_env.board, 'current_player': initial_env.current_player}
        self.root = MCTSNode(initial_state)

        for _ in range(self.num_simulations):
            node = self.root
            env = AnimalChessEnv() # Create a fresh environment for each simulation
            env.board = np.copy(initial_env.board)
            env.current_player = initial_env.current_player

            # 1. Selection
            while not node.is_leaf() and not env.game_over:
                node, move_tuple = node.select_child(self.c_puct)
                # Apply the move to the environment to reach the child's state
                
                # Apply the move, including capture logic
                target_piece_val = env.board[move_tuple[1][0], move_tuple[1][1]]
                if target_piece_val != 0: # If there's a piece at the target, it's a capture
                    env.board[move_tuple[1][0], move_tuple[1][1]] = 0 # Remove captured piece

                env._apply_move(move_tuple[0], move_tuple[1])
                env.current_player *= -1 # Switch player
                env.game_over, env.winner = env._check_game_over()

            # If game is over at selection phase, backpropagate game result
            if env.game_over:
                value = 0
                if env.winner == initial_env.current_player:
                    value = 1
                elif env.winner == -initial_env.current_player:
                    value = -1
                node.backpropagate(value)
                continue

            # 2. Expansion
            # Get policy and value from the neural network for the current node's state
            obs = env._get_observation() # This already returns the 7x9x2 format
            obs_batch = np.expand_dims(obs, axis=0) # Add batch dimension

            policy_logits, value_pred = self.model.predict(obs_batch)
            policy_probs_array = np.squeeze(policy_logits) # Remove batch dimension
            value = np.squeeze(value_pred) # Remove batch dimension

            node.expand(policy_probs_array)

            # 3. Simulation (Rollout)
            # For now, a simple random rollout. Later, can use NN for faster rollouts.
            rollout_env = AnimalChessEnv() # Create a fresh env for rollout
            rollout_env.board = np.copy(env.board)
            rollout_env.current_player = env.current_player

            while not rollout_env.game_over:
                legal_moves = rollout_env._get_valid_moves()
                if not legal_moves:
                    # No legal moves, game is a draw or current player loses
                    rollout_env.game_over = True
                    rollout_env.winner = None # Indicate draw or no winner
                    break
                random_move = legal_moves[np.random.randint(len(legal_moves))]
                
                # Apply the move, including capture logic
                target_piece_val = rollout_env.board[random_move[1][0], random_move[1][1]]
                if target_piece_val != 0: # If there's a piece at the target, it's a capture
                    rollout_env.board[random_move[1][0], random_move[1][1]] = 0 # Remove captured piece

                rollout_env._apply_move(random_move[0], random_move[1])
                rollout_env.current_player *= -1
                rollout_env.game_over, rollout_env.winner = rollout_env._check_game_over()

            # Determine rollout value from the perspective of the player at `node`
            rollout_value = 0
            if rollout_env.winner == node.state['current_player']:
                rollout_value = 1
            elif rollout_env.winner == -node.state['current_player']:
                rollout_value = -1

            # 4. Backpropagation
            node.backpropagate(rollout_value)

    def get_policy(self, temp=1.0):
        """Returns the MCTS-derived policy (visit counts as probabilities)."""
        # Create a dictionary of {move_int: visit_count}
        move_visits = {move_int: child.n for move_int, child in self.root.children.items()}

        # Convert visit counts to probabilities (with temperature if needed)
        total_visits = sum(move_visits.values())
        if total_visits == 0:
            # If no moves were explored (e.g., game ended immediately), return uniform policy over all possible moves
            # This case should ideally not happen if num_simulations > 0 and game is not over at root
            num_actions = get_num_actions()
            policy = {i: 1.0 / num_actions for i in range(num_actions)}
            return policy

        policy = {move_int: count / total_visits for move_int, count in move_visits.items()}
        return policy
