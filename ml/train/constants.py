# Define constants for board dimensions
BOARD_ROWS = 9
BOARD_COLS = 7

# Piece ranks (from weakest to strongest, 0-indexed for convenience)
# This mapping is for internal use; the ML model expects 0-7 for Elephant-Rat
# We'll use positive values for Red pieces, negative for Green pieces
# Abs value will represent the rank (1 for Rat, 8 for Elephant)
RAT = 1
CAT = 2
DOG = 3
WOLF = 4
LEOPARD = 5
TIGER = 6
LION = 7
ELEPHANT = 11

# Player colors
RED_PLAYER = 1
GREEN_PLAYER = -1

# Special board cell types
LAND = 0
RIVER = 1
DEN = 2
TRAP = 3

# Rewards
REWARD_WIN = 100
REWARD_LOSS = -100
REWARD_INVALID_MOVE = -10
REWARD_MOVE_TOWARDS_DEN = 1 # Small positive reward for moving closer to opponent's den

# Piece values for capture/loss rewards (higher value for stronger pieces)
PIECE_VALUES = {
    RAT: 1,
    CAT: 2,
    DOG: 3,
    WOLF: 4,
    LEOPARD: 5,
    TIGER: 6,
    LION: 7,
    ELEPHANT: 8,
}

# Bonus rewards for special abilities/actions
BONUS_RAT_CAPTURE_ELEPHANT = 10 # Significant bonus for this special capture
BONUS_LION_TIGER_JUMP = 2 # Small bonus for using jump ability
BONUS_LEOPARD_RIVER_CROSS = 1 # Small bonus for using river crossing ability