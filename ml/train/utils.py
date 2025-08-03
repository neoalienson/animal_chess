BOARD_ROWS = 9
BOARD_COLS = 7

def move_to_int(from_pos, to_pos):
    """
    Converts a (from_pos, to_pos) tuple to a unique integer.
    from_pos: (row, col)
    to_pos: (row, col)
    """
    from_row, from_col = from_pos
    to_row, to_col = to_pos
    
    # Each position can be uniquely identified by row * BOARD_COLS + col
    from_idx = from_row * BOARD_COLS + from_col
    to_idx = to_row * BOARD_COLS + to_col
    
    # Combine into a single integer. Max value for from_idx or to_idx is BOARD_ROWS*BOARD_COLS - 1
    # So, total possible moves = (BOARD_ROWS*BOARD_COLS) * (BOARD_ROWS*BOARD_COLS)
    return from_idx * (BOARD_ROWS * BOARD_COLS) + to_idx

def int_to_move(move_int):
    """
    Converts a unique integer back to a (from_pos, to_pos) tuple.
    """
    total_positions = BOARD_ROWS * BOARD_COLS
    
    to_idx = move_int % total_positions
    from_idx = move_int // total_positions
    
    from_row = from_idx // BOARD_COLS
    from_col = from_idx % BOARD_COLS
    
    to_row = to_idx // BOARD_COLS
    to_col = to_idx % BOARD_COLS
    
    return (from_row, from_col), (to_row, to_col)

def get_num_actions():
    """
    Returns the total number of possible actions (moves).
    """
    return (BOARD_ROWS * BOARD_COLS) * (BOARD_ROWS * BOARD_COLS)
