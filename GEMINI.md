# Animal Chess (鬥獸棋)

A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).

## Game Overview

Animal Chess is a strategic board game for two players where each player commands a group of animals with different ranks. The objective is to be the first to move any of your pieces into the opponent's den (cave) or to capture all of your opponent's pieces.

## Game Rules

. 2 players, green and red. the game begins with red's turn

### Board Layout
- The game board is portrait orientation
- 7 columns × 9 rows board
- green player on top, red player on bottom
- Two dens (caves) - one for each player at opposite ends
- Six traps - three for each player, adjacent to their den
- Two rivers - each river is 2 columns by 3 rows
- chess piece position (column, row):

    // Green pieces
    board.setPiece(Position(0, 0), Piece(AnimalType.lion, PlayerColor.green));
    board.setPiece(Position(6, 0), Piece(AnimalType.tiger, PlayerColor.green));
    board.setPiece(Position(1, 1), Piece(AnimalType.dog, PlayerColor.green));
    board.setPiece(Position(5, 1), Piece(AnimalType.cat, PlayerColor.green));
    board.setPiece(Position(0, 2), Piece(AnimalType.rat, PlayerColor.green));
    board.setPiece(Position(2, 2), Piece(AnimalType.leopard, PlayerColor.green));
    board.setPiece(Position(4, 2), Piece(AnimalType.wolf, PlayerColor.green));
    board.setPiece(Position(6, 2), Piece(AnimalType.elephant, PlayerColor.green));

    // Red pieces s
    board.setPiece(Position(6, 8), Piece(AnimalType.lion, PlayerColor.green));
    board.setPiece(Position(0, 8), Piece(AnimalType.tiger, PlayerColor.green));
    board.setPiece(Position(5, 7), Piece(AnimalType.dog, PlayerColor.green));
    board.setPiece(Position(1, 7), Piece(AnimalType.cat, PlayerColor.green));
    board.setPiece(Position(6, 6), Piece(AnimalType.rat, PlayerColor.green));
    board.setPiece(Position(4, 6), Piece(AnimalType.leopard, PlayerColor.green));
    board.setPiece(Position(2, 6), Piece(AnimalType.wolf, PlayerColor.green));
    board.setPiece(
      Position(0, 6),
      Piece(AnimalType.elephant, PlayerColor.green),
    );
- dens, traps, river position (column, row):
      dens = {
        PlayerColor.green: Position(3, 0),
        PlayerColor.red: Position(3, 8),
      },
      traps = {
        PlayerColor.green: [Position(2, 0), Position(4, 0), Position(3, 1)],
        PlayerColor.red: [Position(2, 8), Position(4, 8), Position(3, 7)],
      },
      rivers = [
        // Left river (2x3 area) - standard positions
        Position(1, 3),
        Position(1, 4),
        Position(1, 5),
        Position(2, 3),
        Position(2, 4),
        Position(2, 5),
        // Right river (2x3 area) - standard positions
        Position(4, 3),
        Position(4, 4),
        Position(4, 5),
        Position(5, 3),
        Position(5, 4),
        Position(5, 5),
      ];    

### Pieces and Hierarchy
Each player has 8 pieces ranked from strongest to weakest:
1. Elephant (象)
2. Lion (獅)
3. Tiger (虎)
4. Leopard (豹)
5. Wolf (狼)
6. Dog (狗)
7. Cat (貓)
8. Rat (鼠)

### Movement Rules
- Pieces move one space orthogonally (up, down, left, or right)
- Pieces cannot move into their own den
- Only the Rat can enter the river
- The Lion and Tiger can jump over the river both horizontally and vertically, but cannot jump if a Rat is in the river
- Pieces in traps can be captured by any opponent piece

### Capture Rules
- A piece can capture an opponent's piece if it is of equal or lower rank
- Exception: The Rat can capture the Elephant, and the Elephant can capture the Rat
- Any piece can capture an opponent's piece in a trap

## Game Variants

The game includes several optional rule variants:

1. **Rat-Only Den Entry**: Only the Rat can enter the opponent's den to win
2. **Extended Lion/Tiger Jumps**: 
   - Lion can jump over both rivers (double river jump)
   - Tiger can jump over a single river (single river jump)
   - Leopard can cross rivers horizontally
3. **Dog River Variant**: 
   - Dog can enter the river
   - Only the Dog can capture pieces on the shore from within the river
4. **Rat cannot capture Elephant**

## Game Features

- **Timed Gameplay**: Configurable time limit for each player move.
- **Force Pass**: When time expires, play automatically passes to the other player
- **Timer Reset**: Player timer resets when a move is completed
- **Game Instructions**: In-game rules reference available at any time
- **Responsive Design**: Works on both mobile and desktop platforms