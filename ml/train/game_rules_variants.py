from abc import ABC, abstractmethod
import numpy as np

# Assuming these constants are defined in animal_chess_env.py
# and will be imported or passed around.
# For now, redefine them for self-containment.
BOARD_ROWS = 9
BOARD_COLS = 7

# Piece ranks (from weakest to strongest, 0-indexed for convenience)
RAT = 1
CAT = 2
DOG = 3
WOLF = 4
LEOPARD = 5
TIGER = 6
LION = 7
ELEPHANT = 8

# Player colors
RED_PLAYER = 1
GREEN_PLAYER = -1

# Special board cell types
LAND = 0
RIVER = 1
DEN = 2
TRAP = 3

class GameRuleVariant(ABC):
    def __init__(self, base_variant=None):
        self._base_variant = base_variant

    @abstractmethod
    def can_enter_river(self, piece_rank, to_pos, board, special_cells, game_config):
        pass

    @abstractmethod
    def can_jump_over_river(self, from_pos, to_pos, piece_rank, board, special_cells, game_config):
        pass

    @abstractmethod
    def can_capture(self, attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config):
        pass

    @abstractmethod
    def can_move_to_den(self, to_pos, current_player, special_cells, game_config):
        pass

class StandardGameRuleVariant(GameRuleVariant):
    def can_enter_river(self, piece_rank, to_pos, board, special_cells, game_config):
        # Only Rat can enter the river in standard rules
        return piece_rank == RAT

    def can_jump_over_river(self, from_pos, to_pos, piece_rank, board, special_cells, game_config):
        # Lion and Tiger can jump over river
        if piece_rank not in [LION, TIGER]:
            return False

        from_row, from_col = from_pos
        to_row, to_col = to_pos

        # Check if it's a horizontal jump over river
        if from_row == to_row and abs(from_col - to_col) > 1:
            # Check if there's a river between from_col and to_col
            start_col = min(from_col, to_col) + 1
            end_col = max(from_col, to_col)
            for c in range(start_col, end_col):
                if special_cells[from_row, c] != RIVER:
                    return False # Not jumping over a river
                # Check for rats in the river blocking the jump
                if np.any(np.abs(board[from_row, start_col:end_col]) == RAT):
                    return False # Rat blocking jump
            return True

        # Check if it's a vertical jump over river
        if from_col == to_col and abs(from_row - to_row) > 1:
            # Check if there's a river between from_row and to_row
            start_row = min(from_row, to_row) + 1
            end_row = max(from_row, to_row)
            for r in range(start_row, end_row):
                if special_cells[r, from_col] != RIVER:
                    return False # Not jumping over a river
                # Check for rats in the river blocking the jump
                if np.any(np.abs(board[start_row:end_row, from_col]) == RAT):
                    return False # Rat blocking jump
            return True

        return False

    def can_capture(self, attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config):
        # Any piece can capture a piece in a trap
        if special_cells[to_pos[0], to_pos[1]] == TRAP:
            return True

        # Higher or equal rank can capture lower or equal rank
        if attacking_piece_rank >= defending_piece_rank:
            return True

        # Exception: Rat (1) can capture Elephant (8)
        if attacking_piece_rank == RAT and defending_piece_rank == ELEPHANT:
            return True

        return False

    def can_move_to_den(self, to_pos, current_player, special_cells, game_config):
        # Cannot move into own den
        if special_cells[to_pos[0], to_pos[1]] == DEN:
            if (current_player == GREEN_PLAYER and to_pos[0] == 0) or \
               (current_player == RED_PLAYER and to_pos[0] == 8):
                return False
        return True

# --- Variant Implementations (Decorators) ---

class RatOnlyDenEntryVariant(GameRuleVariant):
    def __init__(self, base_variant):
        super().__init__(base_variant)

    def can_move_to_den(self, to_pos, current_player, special_cells, game_config):
        # If rat-only den entry is enabled, only rat can enter opponent's den
        if game_config.get('rat_only_den_entry', False):
            # This variant only affects opponent's den entry, not own den
            if special_cells[to_pos[0], to_pos[1]] == DEN:
                # Check if it's opponent's den
                is_opponent_den = (current_player == GREEN_PLAYER and to_pos[0] == 8) or \
                                  (current_player == RED_PLAYER and to_pos[0] == 0)
                if is_opponent_den:
                    # We need the piece type here, which is not passed to can_move_to_den
                    # This highlights a limitation of the current interface for this variant.
                    # For now, we'll assume the check for piece type happens in GameActions
                    # or we need to refactor the interface to pass the piece.
                    # For the purpose of this env, we'll assume the piece check is done externally.
                    return True # Allow base variant to handle own den, and assume external check for rat
        return self._base_variant.can_move_to_den(to_pos, current_player, special_cells, game_config)

    def can_enter_river(self, piece_rank, to_pos, board, special_cells, game_config):
        return self._base_variant.can_enter_river(piece_rank, to_pos, board, special_cells, game_config)

    def can_jump_over_river(self, from_pos, to_pos, piece_rank, board, special_cells, game_config):
        return self._base_variant.can_jump_over_river(from_pos, to_pos, piece_rank, board, special_cells, game_config)

    def can_capture(self, attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config):
        return self._base_variant.can_capture(attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config)


class ExtendedJumpVariant(GameRuleVariant):
    def __init__(self, base_variant):
        super().__init__(base_variant)

    def can_jump_over_river(self, from_pos, to_pos, piece_rank, board, special_cells, game_config):
        if game_config.get('extended_lion_tiger_jumps', False):
            from_row, from_col = from_pos
            to_row, to_col = to_pos

            # Lion can jump over both rivers (double river jump)
            if piece_rank == LION:
                # Horizontal double jump
                if from_row == to_row and abs(from_col - to_col) == 6: # e.g., col 0 to col 6
                    # Check if both rivers are between
                    if (special_cells[from_row, 1] == RIVER and special_cells[from_row, 2] == RIVER and
                        special_cells[from_row, 4] == RIVER and special_cells[from_row, 5] == RIVER):
                        # Check for rats in any river cells between
                        for c in range(min(from_col, to_col) + 1, max(from_col, to_col)):
                            if special_cells[from_row, c] == RIVER and np.abs(board[from_row, c]) == RAT:
                                return False # Rat blocking jump
                        return True
                # Vertical double jump (not applicable for standard board layout with two horizontal rivers)

            # Tiger can jump over a single river (standard jump is already handled by base)
            # This variant doesn't change Tiger's jump from standard, as standard already allows single river jump.
            # The Flutter code implies this variant *adds* to Tiger's jump, but the standard rule already covers it.
            # So, this part might be redundant if the base handles single jumps correctly.

            # Leopard can cross rivers horizontally
            if piece_rank == LEOPARD:
                if from_row == to_row and abs(from_col - to_col) == 1: # Adjacent horizontal move
                    if special_cells[from_row, from_col] == RIVER or special_cells[to_row, to_col] == RIVER:
                        return True # Leopard can cross river if adjacent

        return self._base_variant.can_jump_over_river(from_pos, to_pos, piece_rank, board, special_cells, game_config)

    def can_enter_river(self, piece_rank, to_pos, board, special_cells, game_config):
        return self._base_variant.can_enter_river(piece_rank, to_pos, board, special_cells, game_config)

    def can_capture(self, attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config):
        return self._base_variant.can_capture(attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config)

    def can_move_to_den(self, to_pos, current_player, special_cells, game_config):
        return self._base_variant.can_move_to_den(to_pos, current_player, special_cells, game_config)


class DogRiverVariant(GameRuleVariant):
    def __init__(self, base_variant):
        super().__init__(base_variant)

    def can_enter_river(self, piece_rank, to_pos, board, special_cells, game_config):
        if game_config.get('dog_river_variant', False):
            if piece_rank == DOG: # Dog can enter river
                return True
        return self._base_variant.can_enter_river(piece_rank, to_pos, board, special_cells, game_config)

    def can_capture(self, attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config):
        if game_config.get('dog_river_variant', False):
            # Only the Dog can capture pieces on the shore from within the river
            # This rule is complex as it depends on the attacking piece's position (in river) and target's position (on shore)
            # This check needs to be done in the main _is_valid_move logic, not just in can_capture
            pass # Defer to main logic for now
        return self._base_variant.can_capture(attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config)

    def can_jump_over_river(self, from_pos, to_pos, piece_rank, board, special_cells, game_config):
        return self._base_variant.can_jump_over_river(from_pos, to_pos, piece_rank, board, special_cells, game_config)

    def can_move_to_den(self, to_pos, current_player, special_cells, game_config):
        return self._base_variant.can_move_to_den(to_pos, current_player, special_cells, game_config)


class RatCaptureVariant(GameRuleVariant):
    def __init__(self, base_variant):
        super().__init__(base_variant)

    def can_capture(self, attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config):
        if game_config.get('rat_cannot_capture_elephant', False):
            if attacking_piece_rank == RAT and defending_piece_rank == ELEPHANT:
                return False # Rat cannot capture Elephant
        return self._base_variant.can_capture(attacking_piece_rank, defending_piece_rank, to_pos, special_cells, game_config)

    def can_enter_river(self, piece_rank, to_pos, board, special_cells, game_config):
        return self._base_variant.can_enter_river(piece_rank, to_pos, board, special_cells, game_config)

    def can_jump_over_river(self, from_pos, to_pos, piece_rank, board, special_cells, game_config):
        return self._base_variant.can_jump_over_river(from_pos, to_pos, piece_rank, board, special_cells, game_config)

    def can_move_to_den(self, to_pos, current_player, special_cells, game_config):
        return self._base_variant.can_move_to_den(to_pos, current_player, special_cells, game_config)


class GameRuleFactory:
    @staticmethod
    def create_rule_variant(game_config):
        rule_variant = StandardGameRuleVariant()

        if game_config.get('rat_only_den_entry', False):
            rule_variant = RatOnlyDenEntryVariant(rule_variant)
        if game_config.get('extended_lion_tiger_jumps', False):
            rule_variant = ExtendedJumpVariant(rule_variant)
        if game_config.get('dog_river_variant', False):
            rule_variant = DogRiverVariant(rule_variant)
        if game_config.get('rat_cannot_capture_elephant', False):
            rule_variant = RatCaptureVariant(rule_variant)

        return rule_variant
