import numpy as np
from ml.train.constants import (
    RED_PLAYER, GREEN_PLAYER, RAT, CAT, DOG, WOLF, LEOPARD, TIGER, LION, ELEPHANT,
    BOARD_ROWS, BOARD_COLS, RIVER, DEN, TRAP, LAND
)

# Helper function to generate ASCII board for comments
def _generate_ascii_board(board_dict, current_player=None):
    board = np.full((BOARD_ROWS, BOARD_COLS), '. ', dtype='U2')
    
    # Fill special cells
    special_cells = np.full((BOARD_ROWS, BOARD_COLS), LAND, dtype=int)
    special_cells[0, 3] = DEN # Green Den
    special_cells[8, 3] = DEN # Red Den
    special_cells[0, 2] = TRAP
    special_cells[0, 4] = TRAP
    special_cells[1, 3] = TRAP
    special_cells[8, 2] = TRAP
    special_cells[8, 4] = TRAP
    special_cells[7, 3] = TRAP
    special_cells[3:6, 1] = RIVER
    special_cells[3:6, 2] = RIVER
    special_cells[3:6, 4] = RIVER
    special_cells[3:6, 5] = RIVER

    for r in range(BOARD_ROWS):
        for c in range(BOARD_COLS):
            if special_cells[r, c] == RIVER:
                board[r, c] = '~ '
            elif special_cells[r, c] == DEN:
                board[r, c] = 'D '
            elif special_cells[r, c] == TRAP:
                board[r, c] = 'T '

    piece_map = {
        RAT: 'r', CAT: 'c', DOG: 'd', WOLF: 'w',
        LEOPARD: 'l', TIGER: 't', LION: 'L', ELEPHANT: 'E'
    }

    for pos, piece_val in board_dict.items():
        char = piece_map[abs(piece_val)]
        board[pos[0], pos[1]] = (char.upper() if piece_val > 0 else char.lower()) + ' '

    ascii_str = """# Board Setup:
# ---------------------
"""
    for r in range(BOARD_ROWS):
        ascii_str += "# " + "".join(board[r, c] for c in range(BOARD_COLS)) + "\n"
    ascii_str += "# ---------------------"
    if current_player:
        ascii_str += f"\n# Current Player: {'Red' if current_player == RED_PLAYER else 'Green'}"
    return ascii_str

# Define standard initial board setup
# Board Setup:
# ---------------------
# L . T D T . t 
# . d . T . c . 
# r . l . w . e 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# E . W . L . R 
# . C . T . D . 
# T . T D T . L 
# ---------------------
# Current Player: Red
STANDARD_START_BOARD = {
    (0, 0): GREEN_PLAYER * LION,
    (0, 6): GREEN_PLAYER * TIGER,
    (1, 1): GREEN_PLAYER * DOG,
    (1, 5): GREEN_PLAYER * CAT,
    (2, 0): GREEN_PLAYER * RAT,
    (2, 2): GREEN_PLAYER * LEOPARD,
    (2, 4): GREEN_PLAYER * WOLF,
    (2, 6): GREEN_PLAYER * ELEPHANT,

    (8, 0): RED_PLAYER * TIGER,
    (8, 6): RED_PLAYER * LION,
    (7, 1): RED_PLAYER * CAT,
    (7, 5): RED_PLAYER * DOG,
    (6, 0): RED_PLAYER * ELEPHANT,
    (6, 2): RED_PLAYER * WOLF,
    (6, 4): RED_PLAYER * LEOPARD,
    (6, 6): RED_PLAYER * RAT,
}

# Example Mid-Game Scenario 1
# Board Setup:
# ---------------------
# . . . L . . . 
# . . d T . . . 
# . r . . . . . 
# . ~ ~ . w ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ l ~ ~ . 
# . . . . . . . 
# . . . T c . . 
# . . . T . . . 
# ---------------------
# Current Player: Red
MID_GAME_SCENARIO_1 = {
    (0, 3): GREEN_PLAYER * LION, # Green Lion moved
    (1, 2): GREEN_PLAYER * DOG,
    (2, 1): GREEN_PLAYER * RAT,
    (3, 4): GREEN_PLAYER * WOLF, # Green Wolf moved

    (8, 3): RED_PLAYER * TIGER, # Red Tiger moved
    (7, 4): RED_PLAYER * CAT,
    (6, 5): RED_PLAYER * RAT,
    (5, 2): RED_PLAYER * LEOPARD, # Red Leopard moved

    # Some pieces captured (not present)
}

# Example End-Game Scenario (Red about to win by den entry)
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . R . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . e . . . 
# . . . D . . . 
# ---------------------
# Current Player: Red
END_GAME_SCENARIO_DEN_WIN = {
    (1, 3): RED_PLAYER * RAT, # Red Rat near Green Den
    (7, 3): GREEN_PLAYER * ELEPHANT, # Green Elephant near Red Den
}

# Example Trap Scenario (Red piece in Green trap)
# Board Setup:
# ---------------------
# L . T D T . . 
# . . d T . . . 
# . . . R  . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . T . . . 
# T . T D T . . 
# ---------------------
# Current Player: Green
TRAP_SCENARIO_1 = {
    (0, 2): RED_PLAYER * RAT, # Red Rat in Green Trap
    (1, 2): GREEN_PLAYER * DOG, # Green Dog nearby to capture
    (8, 0): RED_PLAYER * TIGER,
    (0, 0): GREEN_PLAYER * LION,
}

# New Scenarios for valuable piece capture and special moves

# Scenario: Red Rat can capture Green Elephant
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# e . . . . . . 
# R . . T . . . 
# . . . D . . . 
# ---------------------
# Current Player: Red
CAPTURE_ELEPHANT_SCENARIO = {
    (7, 0): RED_PLAYER * RAT, # Red Rat
    (6, 0): GREEN_PLAYER * ELEPHANT, # Green Elephant, capturable by Rat
    (0, 0): GREEN_PLAYER * LION,
    (8, 6): RED_PLAYER * LION,
}

# Scenario: Red Lion can jump over river to capture Green Tiger
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# L ~ ~ t ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . T . . . 
# . . . D . . . 
# ---------------------
# Current Player: Red
LION_JUMP_CAPTURE_SCENARIO = {
    (4, 0): RED_PLAYER * LION, # Red Lion on left bank
    (4, 3): GREEN_PLAYER * TIGER, # Green Tiger on right bank, across river
    (0, 0): GREEN_PLAYER * LION,
    (8, 6): RED_PLAYER * LION,
}

# Scenario: Green Leopard can cross river to capture Red Cat
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . . . . . . . 
# l . . C ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . T . . . 
# . . . D . . . 
# ---------------------
# Current Player: Green
LEOPARD_RIVER_CROSS_SCENARIO = {
    (3, 0): GREEN_PLAYER * LEOPARD, # Green Leopard near river
    (3, 1): RED_PLAYER * CAT, # Red Cat in river
    (0, 0): GREEN_PLAYER * LION,
    (8, 6): RED_PLAYER * LION,
}

# Scenario: Red Pincer Movement - Red Dog and Wolf contain Green Cat
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . W . . . . . 
# . ~ ~ . ~ ~ . 
# c ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . D . . . . . 
# . . . T . . . 
# . . . D . . . 
# ---------------------
# Current Player: Red
PINCER_CAPTURE_SCENARIO = {
    (6, 1): RED_PLAYER * DOG, # Red Dog
    (4, 0): GREEN_PLAYER * CAT, # Green Cat (target)
    (2, 1): RED_PLAYER * WOLF, # Red Wolf
}

# Scenario: Red forces Green Rat into a trap using Lion and Tiger
# Board Setup:
# ---------------------
# . . T D T . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# T . . . . . . 
# . . L T . . . 
# . r T D . . . 
# ---------------------
# Current Player: Red
FORCE_TRAP_SCENARIO = {
    (8, 1): GREEN_PLAYER * RAT, # Green Rat near Red Trap
    (7, 2): RED_PLAYER * LION, # Red Lion to block escape
    (0, 6): RED_PLAYER * TIGER, # Red Tiger to block escape
}

# Scenario: River Blockage - Rat in river prevents Lion jump
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# L ~ ~ r ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . T . . . 
# . . . D . . . 
# ---------------------
# Current Player: Red
RIVER_BLOCKAGE_SCENARIO = {
    (4, 0): RED_PLAYER * LION, # Red Lion
    (4, 3): GREEN_PLAYER * RAT, # Green Rat in river, blocking jump
    (0, 0): GREEN_PLAYER * LION,
    (8, 6): RED_PLAYER * LION,
}

# Scenario: Den Defense - Elephant defending its den
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . E . . . 
# . . . D . . . 
# ---------------------
# Current Player: Green
DEN_DEFENSE_SCENARIO = {
    (7, 3): GREEN_PLAYER * ELEPHANT, # Green Elephant defending den
    (1, 3): RED_PLAYER * RAT, # Red Rat trying to enter den
}

# Scenario: Trap Escape/Counter-Capture - Dog in trap can capture adjacent Cat
# Board Setup:
# ---------------------
# . . T D T . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . c D T . . . 
# . . T D T . . 
# ---------------------
# Current Player: Red
TRAP_COUNTER_CAPTURE_SCENARIO = {
    (7, 2): RED_PLAYER * DOG, # Red Dog in trap
    (7, 1): GREEN_PLAYER * CAT, # Green Cat adjacent to trap
}

# Scenario: Multiple Capture Options - Red has multiple capture opportunities
# Board Setup:
# ---------------------
# . . . D . . . 
# . . . T . . . 
# . . . . . . . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . ~ ~ . ~ ~ . 
# . . . . . . . 
# . . . T . . . 
# . . . D . . . 
# ---------------------
# Current Player: Red
MULTIPLE_CAPTURE_SCENARIO = {
    (6, 0): RED_PLAYER * LION, # Red Lion
    (6, 1): GREEN_PLAYER * DOG, # Green Dog (capturable by Lion)
    (7, 0): RED_PLAYER * TIGER, # Red Tiger
    (7, 1): GREEN_PLAYER * CAT, # Green Cat (capturable by Tiger)
}

# List of all scenarios
BOARD_SCENARIOS = [
    {"board": STANDARD_START_BOARD, "player": RED_PLAYER, "name": "Standard Start"},
    {"board": MID_GAME_SCENARIO_1, "player": RED_PLAYER, "name": "Mid-Game 1"},
    {"board": END_GAME_SCENARIO_DEN_WIN, "player": RED_PLAYER, "name": "End-Game Den Win"},
    {"board": TRAP_SCENARIO_1, "player": GREEN_PLAYER, "name": "Trap Scenario 1"},
    {"board": CAPTURE_ELEPHANT_SCENARIO, "player": RED_PLAYER, "name": "Capture Elephant"},
    {"board": LION_JUMP_CAPTURE_SCENARIO, "player": RED_PLAYER, "name": "Lion Jump Capture"},
    {"board": LEOPARD_RIVER_CROSS_SCENARIO, "player": GREEN_PLAYER, "name": "Leopard River Cross"},
    {"board": PINCER_CAPTURE_SCENARIO, "player": RED_PLAYER, "name": "Pincer Capture"},
    {"board": FORCE_TRAP_SCENARIO, "player": RED_PLAYER, "name": "Force into Trap"},
]
#     {"board": RIVER_BLOCKAGE_SCENARIO, "player": RED_PLAYER, "name": "River Blockage"},
#     {"board": DEN_DEFENSE_SCENARIO, "player": GREEN_PLAYER, "name": "Den Defense"},
#     {"board": TRAP_COUNTER_CAPTURE_SCENARIO, "player": RED_PLAYER, "name": "Trap Counter-Capture"},
#     {"board": MULTIPLE_CAPTURE_SCENARIO, "player": RED_PLAYER, "name": "Multiple Capture Options"},
#     {"board": DOUBLE_ATTACK_SCENARIO, "player": RED_PLAYER, "name": "Double Attack"},
#     {"board": TRAPPED_PIECE_SCENARIO, "player": GREEN_PLAYER, "name": "Trapped Piece"},
#     {"board": SACRIFICE_FOR_DEN_ENTRY_SCENARIO, "player": RED_PLAYER, "name": "Sacrifice for Den Entry"},
#     {"board": PIECE_PROTECTION_SCENARIO, "player": RED_PLAYER, "name": "Piece Protection"},
#     {"board": DEN_BLOCKADE_SCENARIO, "player": GREEN_PLAYER, "name": "Den Blockade"},
#     {"board": COUNTER_ATTACK_OPPORTUNITY_SCENARIO, "player": RED_PLAYER, "name": "Counter-Attack Opportunity"},
# ]

# # Scenario: Double Attack - Red Lion threatens Green Dog and Cat
# # Board Setup:
# # ---------------------
# # . . . D . . . 
# # . . . T . . . 
# # . . . . . . . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . . . . . . . 
# # . d L c T . . 
# # . . . D . . . 
# # ---------------------
# # Current Player: Red
# DOUBLE_ATTACK_SCENARIO = {
#     (7, 1): GREEN_PLAYER * DOG, # Green Dog
#     (7, 3): RED_PLAYER * LION, # Red Lion
#     (7, 5): GREEN_PLAYER * CAT, # Green Cat
# }

# # Scenario: Trapped Piece - Green Rat has no legal moves
# # Board Setup:
# # ---------------------
# # . . . D . . . 
# # . . . T . . . 
# # . . . . . . . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . . . . . . . 
# # . . . T . . . 
# # . r T D T . . 
# # ---------------------
# # Current Player: Green
# TRAPPED_PIECE_SCENARIO = {
#     (8, 1): GREEN_PLAYER * RAT, # Green Rat
#     (8, 0): RED_PLAYER * TIGER, # Red Tiger
#     (8, 2): RED_PLAYER * TIGER, # Red Tiger
#     (7, 1): RED_PLAYER * TIGER, # Red Tiger
# }

# # Scenario: Sacrifice for Den Entry - Red Dog sacrifices to clear path for Rat
# # Board Setup:
# # ---------------------
# # . . . D . . . 
# # . . . T . . . 
# # . . . . . . . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . . . . . . . 
# # . . . T . . . 
# # . . . D . . . 
# # ---------------------
# # Current Player: Red
# SACRIFICE_FOR_DEN_ENTRY_SCENARIO = {
#     (1, 3): GREEN_PLAYER * DOG, # Green Dog blocking den
#     (2, 3): RED_PLAYER * RAT, # Red Rat
#     (3, 3): RED_PLAYER * LION, # Red Lion (to capture Dog)
# }

# # Scenario: Piece Protection - Red Elephant protected by Red Rat
# # Board Setup:
# # ---------------------
# # . . . D . . . 
# # . . . T . . . 
# # . . . . . . . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . . . . . . . 
# # . . . T . . . 
# # . . . D . . . 
# # ---------------------
# # Current Player: Red
# PIECE_PROTECTION_SCENARIO = {
#     (6, 0): RED_PLAYER * ELEPHANT, # Red Elephant
#     (7, 0): RED_PLAYER * RAT, # Red Rat protecting Elephant
#     (6, 1): GREEN_PLAYER * LION, # Green Lion threatening Elephant
# }

# # Scenario: Den Blockade - Green pieces blocking their den
# # Board Setup:
# # ---------------------
# # . . . D . . . 
# # . . . T . . . 
# # . . . . . . . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . . . . . . . 
# # . . . T . . . 
# # . . . D . . . 
# # ---------------------
# # Current Player: Green
# DEN_BLOCKADE_SCENARIO = {
#     (0, 2): GREEN_PLAYER * DOG, # Green Dog
#     (0, 4): GREEN_PLAYER * CAT, # Green Cat
#     (1, 3): GREEN_PLAYER * WOLF, # Green Wolf
#     (7, 3): RED_PLAYER * RAT, # Red Rat trying to enter den
# }

# # Scenario: Counter-Attack Opportunity - Red has a strong counter-attack
# # Board Setup:
# # ---------------------
# # . . . D . . . 
# # . . . T . . . 
# # . . . . . . . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . ~ ~ . ~ ~ . 
# # . . . . . . . 
# # . . . T . . . 
# # . . . D . . . 
# # ---------------------
# # Current Player: Red
# COUNTER_ATTACK_OPPORTUNITY_SCENARIO = {
#     (4, 0): RED_PLAYER * LION, # Red Lion
#     (4, 1): GREEN_PLAYER * TIGER, # Green Tiger (just moved here)
#     (5, 0): RED_PLAYER * ELEPHANT, # Red Elephant
# }

def get_scenario_board(scenario_dict):
    board = np.zeros((BOARD_ROWS, BOARD_COLS), dtype=int)
    for pos, piece_val in scenario_dict.items():
        board[pos[0], pos[1]] = piece_val
    return board
