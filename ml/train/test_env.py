from ml.train.animal_chess_env import AnimalChessEnv, RED_PLAYER, GREEN_PLAYER, RAT

def test_game_flow():
    env = AnimalChessEnv()
    env.render()

    # Example moves (replace with actual valid moves for testing)
    # Move a red piece (Tiger) from (8,0) to (7,0)
    print("\n--- Attempting to move Red Tiger from (8,0) to (7,0) ---")
    obs, reward, done, info = env.step(((8, 0), (7, 0)))
    env.render()
    print(f"Reward: {reward}, Done: {done}, Info: {info}")

    # Move a green piece (Lion) from (0,0) to (1,0)
    print("\n--- Attempting to move Green Lion from (0,0) to (1,0) ---")
    obs, reward, done, info = env.step(((0, 0), (1, 0)))
    env.render()
    print(f"Reward: {reward}, Done: {done}, Info: {info}")

    # Test an invalid move (e.g., moving opponent's piece)
    print("\n--- Attempting invalid move (Red moving Green's piece) ---")
    obs, reward, done, info = env.step(((1, 0), (2, 0))) # Red trying to move Green Lion
    env.render()
    print(f"Reward: {reward}, Done: {done}, Info: {info}")

    # Test a capture (Red Tiger captures Green Dog)
    # First, move Green Dog to a capturable position
    print("\n--- Setting up for capture: Green Dog to (6,0) ---")
    env.board[6,0] = env.board[1,1] # Move Green Dog for testing
    env.board[1,1] = 0
    env.render()

    print("\n--- Attempting to capture Green Dog with Red Tiger ---")
    # Assuming Red is current player, and Tiger is at (7,0)
    obs, reward, done, info = env.step(((7, 0), (6, 0)))
    env.render()
    print(f"Reward: {reward}, Done: {done}, Info: {info}")

    # Test game over by den entry (simplified for testing)
    print("\n--- Setting up for Den Entry Win (Red) ---")
    env.board.fill(0) # Clear board
    env.board[1,3] = RED_PLAYER * RAT # Place Red Rat near Green Den
    env.current_player = RED_PLAYER
    env.render()

    print("\n--- Attempting Den Entry Win (Red Rat to (0,3)) ---")
    obs, reward, done, info = env.step(((1, 3), (0, 3)))
    env.render()
    print(f"Reward: {reward}, Done: {done}, Info: {info}")
    assert done == True and env.winner == RED_PLAYER

    print("\n--- Test complete ---")

if __name__ == "__main__":
    test_game_flow()
