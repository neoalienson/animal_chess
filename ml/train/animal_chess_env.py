import numpy as np
from ml.train.game_rules_variants import GameRuleFactory
from ml.train.board_scenarios import STANDARD_START_BOARD, get_scenario_board
from ml.train.constants import (
    RED_PLAYER, GREEN_PLAYER, RAT, CAT, DOG, WOLF, LEOPARD, TIGER, LION, ELEPHANT,
    BOARD_ROWS, BOARD_COLS, RIVER, DEN, TRAP, LAND,
    REWARD_WIN, REWARD_LOSS, REWARD_INVALID_MOVE, REWARD_MOVE_TOWARDS_DEN,
    PIECE_VALUES, BONUS_RAT_CAPTURE_ELEPHANT, BONUS_LION_TIGER_JUMP, BONUS_LEOPARD_RIVER_CROSS
)

class AnimalChessEnv:
    def __init__(self, game_config=None, initial_scenario=None):
        self.board = np.zeros((BOARD_ROWS, BOARD_COLS), dtype=int)
        self.current_player = RED_PLAYER  # Red starts
        self.game_over = False
        self.winner = None  # None, RED_PLAYER, or GREEN_PLAYER
        self.game_config = game_config if game_config is not None else {}
        self.rule_variant = GameRuleFactory.create_rule_variant(self.game_config)
        self.initial_scenario = initial_scenario # Store the initial scenario

        # Define special cells
        self.special_cells = np.full((BOARD_ROWS, BOARD_COLS), LAND, dtype=int)
        
        # Dens
        self.special_cells[0, 3] = DEN # Green Den
        self.special_cells[8, 3] = DEN # Red Den

        # Traps
        self.special_cells[0, 2] = TRAP
        self.special_cells[0, 4] = TRAP
        self.special_cells[1, 3] = TRAP
        self.special_cells[8, 2] = TRAP
        self.special_cells[8, 4] = TRAP
        self.special_cells[7, 3] = TRAP

        # Rivers (2 columns by 3 rows each)
        # River 1
        self.special_cells[3:6, 1] = RIVER
        self.special_cells[3:6, 2] = RIVER
        # River 2
        self.special_cells[3:6, 4] = RIVER
        self.special_cells[3:6, 5] = RIVER

        self.reset()

    def reset(self):
        self.board.fill(0)  # Clear the board
        self._initial_board_setup()
        self.game_over = False
        self.winner = None
        return self._get_observation()

    def _initial_board_setup(self):
        if self.initial_scenario:
            # Use the provided scenario
            self.board = get_scenario_board(self.initial_scenario['board'])
            self.current_player = self.initial_scenario['player']
        else:
            # Default initial board setup
            self.board = get_scenario_board(STANDARD_START_BOARD)
            self.current_player = RED_PLAYER

    def _get_den_position(self, player_color):
        if player_color == RED_PLAYER:
            return (0, 3) # Green's den is Red's target
        else:
            return (8, 3) # Red's den is Green's target

    def _manhattan_distance(self, pos1, pos2):
        return abs(pos1[0] - pos2[0]) + abs(pos1[1] - pos2[1])

    def step(self, action):
        # action is a tuple: ((from_row, from_col), (to_row, to_col))
        from_pos, to_pos = action
        reward = 0

        # Store original board state to check for piece loss
        original_board = np.copy(self.board)

        if not self._is_valid_move(from_pos, to_pos):
            # Invalid move, penalize or handle as an error
            return self._get_observation(), REWARD_INVALID_MOVE, True, {"message": "Invalid move"}

        # Calculate distance to opponent's den before move
        opponent_den_pos = self._get_den_position(self.current_player)
        dist_before = self._manhattan_distance(from_pos, opponent_den_pos)

        # Check for capture before applying move
        target_piece_val = self.board[to_pos[0], to_pos[1]]
        is_capture = (target_piece_val != 0)
        captured_piece_rank = abs(target_piece_val)

        # Check for special move types before applying move
        piece_val_moving = self.board[from_pos[0], from_pos[1]]
        piece_rank_moving = abs(piece_val_moving)
        is_river_cell_from = self.special_cells[from_pos[0], from_pos[1]] == RIVER
        is_river_cell_to = self.special_cells[to_pos[0], to_pos[1]] == RIVER

        # Apply the move (this also handles removing captured piece)
        self._apply_move(from_pos, to_pos)

        # Calculate distance to opponent's den after move
        dist_after = self._manhattan_distance(to_pos, opponent_den_pos)

        # Reward for moving towards the opponent's den
        if dist_after < dist_before:
            reward += REWARD_MOVE_TOWARDS_DEN

        # Reward for capturing a piece based on its value
        if is_capture:
            reward += PIECE_VALUES.get(captured_piece_rank, 0) # Add value of captured piece
            # Bonus for Rat capturing Elephant
            if piece_rank_moving == RAT and captured_piece_rank == ELEPHANT:
                reward += BONUS_RAT_CAPTURE_ELEPHANT

        # Penalty for losing a piece (if current player's piece was captured on this turn)
        # This logic needs to be careful as it's from the perspective of the *next* player
        # For now, we assume rewards are for the player who just moved.
        # The value function will learn the penalty of losing a piece over time.

        # Bonus for Lion/Tiger jumps
        if piece_rank_moving in [LION, TIGER] and \
           self.rule_variant.can_jump_over_river(from_pos, to_pos, piece_rank_moving, original_board, self.special_cells, self.game_config):
            # Check if it was actually a jump over river (not just a normal move that happens to be a jump)
            if abs(from_pos[0] - to_pos[0]) > 1 or abs(from_pos[1] - to_pos[1]) > 1:
                reward += BONUS_LION_TIGER_JUMP

        # Bonus for Leopard river crossing
        if piece_rank_moving == LEOPARD and (is_river_cell_from != is_river_cell_to):
            reward += BONUS_LEOPARD_RIVER_CROSS

        # Check for game over conditions
        self.game_over, self.winner = self._check_game_over()
        if self.game_over:
            if self.winner == self.current_player:
                reward = REWARD_WIN  # Win reward
            else:
                reward = REWARD_LOSS # Loss penalty
        else:
            # Switch player
            self.current_player *= -1
            # No additional step penalty here, as we have move-specific rewards

        return self._get_observation(), reward, self.game_over, {}

    def _get_valid_moves(self):
        valid_moves = []
        for r in range(BOARD_ROWS):
            for c in range(BOARD_COLS):
                piece = self.board[r, c]
                if piece * self.current_player > 0: # It's current player's piece
                    from_pos = (r, c)
                    # Check all possible 'to' positions
                    for to_r in range(BOARD_ROWS):
                        for to_c in range(BOARD_COLS):
                            to_pos = (to_r, to_c)
                            if self._is_valid_move(from_pos, to_pos):
                                valid_moves.append((from_pos, to_pos))
        return valid_moves

    def _is_valid_move(self, from_pos, to_pos):
        from_row, from_col = from_pos
        to_row, to_col = to_pos

        # 1. Check bounds
        if not (0 <= to_row < BOARD_ROWS and 0 <= to_col < BOARD_COLS):
            return False

        piece_val = self.board[from_row, from_col]
        piece_rank = abs(piece_val)
        target_piece_val = self.board[to_pos[0], to_pos[1]]
        target_piece_rank = abs(target_piece_val)

        # 2. Check if it's current player's piece
        if piece_val * self.current_player <= 0:
            return False

        # 3. Cannot move into own den (delegated to rule_variant)
        if not self.rule_variant.can_move_to_den(to_pos, self.current_player, self.special_cells, self.game_config):
            return False

        # 4. Cannot capture own pieces
        if target_piece_val != 0 and target_piece_val * self.current_player > 0:
            return False

        # Determine movement type
        is_adjacent = abs(from_row - to_row) + abs(from_col - to_col) == 1
        is_river_cell_from = self.special_cells[from_row, from_col] == RIVER
        is_river_cell_to = self.special_cells[to_row, to_col] == RIVER

        # Handle river jumps (Lion/Tiger)
        if self.rule_variant.can_jump_over_river(from_pos, to_pos, piece_rank, self.board, self.special_cells, self.game_config):
            # If it's a valid jump, check if target is capturable or empty
            if target_piece_val == 0:
                return True
            else:
                return self.rule_variant.can_capture(piece_rank, target_piece_rank, to_pos, self.special_cells, self.game_config)

        # If not a jump, must be adjacent
        if not is_adjacent:
            return False

        # Handle adjacent moves
        if is_river_cell_to: # Moving to river
            if not self.rule_variant.can_enter_river(piece_rank, to_pos, self.board, self.special_cells, self.game_config):
                return False
        elif is_river_cell_from: # Moving from river
            if not self.rule_variant.can_enter_river(piece_rank, from_pos, self.board, self.special_cells, self.game_config):
                # This check is for exiting the river, which is generally allowed if entry was allowed
                # But for DogRiverVariant, it might have specific rules for capturing from river
                pass # For now, assume if you can enter, you can exit normally

        # Handle captures for adjacent moves
        if target_piece_val != 0:
            return self.rule_variant.can_capture(piece_rank, target_piece_rank, to_pos, self.special_cells, self.game_config)

        return True # Valid adjacent move to empty square or valid capture

    def _apply_move(self, from_pos, to_pos):
        from_row, from_col = from_pos
        to_row, to_col = to_pos

        # Move the piece
        self.board[to_row, to_col] = self.board[from_row, from_col]
        self.board[from_row, from_col] = 0

    def _check_game_over(self):
        # Check for den entry win
        # Green player wins if Red's den (8,3) is occupied by a Green piece
        if self.board[8, 3] * GREEN_PLAYER > 0:
            # Check for rat-only den entry variant
            if self.game_config.get('rat_only_den_entry', False):
                if abs(self.board[8, 3]) == RAT:
                    return True, GREEN_PLAYER
                else:
                    return False, None # Non-rat piece cannot win
            else:
                return True, GREEN_PLAYER

        # Red player wins if Green's den (0,3) is occupied by a Red piece
        if self.board[0, 3] * RED_PLAYER > 0:
            # Check for rat-only den entry variant
            if self.game_config.get('rat_only_den_entry', False):
                if abs(self.board[0, 3]) == RAT:
                    return True, RED_PLAYER
                else:
                    return False, None # Non-rat piece cannot win
            else:
                return True, RED_PLAYER

        # Check for all pieces captured win
        red_pieces_left = np.any(self.board > 0)
        green_pieces_left = np.any(self.board < 0)

        if not red_pieces_left:
            return True, GREEN_PLAYER
        if not green_pieces_left:
            return True, RED_PLAYER

        return False, None

    def _get_observation(self):
        # Returns the board state as a 7x9x2 tensor for the ML model
        # Channel 0: Current player's pieces (0-7 for Elephant-Rat, 8 for empty)
        # Channel 1: Opponent's pieces (0-7 for Elephant-Rat, 8 for empty)

        obs = np.zeros((BOARD_ROWS, BOARD_COLS, 2), dtype=int)

        for r in range(BOARD_ROWS):
            for c in range(BOARD_COLS):
                piece = self.board[r, c]
                
                # Map internal piece representation to ML model's 0-7 (Elephant-Rat)
                # ML model: Elephant=0, Lion=1, Tiger=2, Leopard=3, Wolf=4, Dog=5, Cat=6, Rat=7
                # Our internal: Rat=1, Cat=2, Dog=3, Wolf=4, Leopard=5, Tiger=6, Lion=7, Elephant=8
                ml_piece_value = 8 - abs(piece) if piece != 0 else 8 # 8 for empty

                if piece * self.current_player > 0: # Current player's piece
                    obs[r, c, 0] = ml_piece_value
                elif piece * self.current_player < 0: # Opponent's piece
                    obs[r, c, 1] = ml_piece_value
                else: # Empty cell
                    obs[r, c, 0] = 8
                    obs[r, c, 1] = 8
        return obs

    def render(self):
        # Simple text-based rendering for debugging
        piece_map = {
            RAT: 'r', CAT: 'c', DOG: 'd', WOLF: 'w',
            LEOPARD: 'l', TIGER: 't', LION: 'L', ELEPHANT: 'E'
        }
        print("---------------------")
        for r in range(BOARD_ROWS):
            row_str = ""
            for c in range(BOARD_COLS):
                piece = self.board[r, c]
                if piece == 0:
                    if self.special_cells[r,c] == RIVER:
                        row_str += "~ "
                    elif self.special_cells[r,c] == DEN:
                        row_str += "D "
                    elif self.special_cells[r,c] == TRAP:
                        row_str += "T "
                    else:
                        row_str += ". "
                else:
                    char = piece_map[abs(piece)]
                    row_str += (char.upper() if piece > 0 else char.lower()) + " "
            print(row_str)
        print("---------------------")
        print(f"Current Player: {'Red' if self.current_player == RED_PLAYER else 'Green'}")
        if self.game_over:
            print(f"Game Over! Winner: {'Red' if self.winner == RED_PLAYER else 'Green'}")
