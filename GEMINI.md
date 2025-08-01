# Animal Chess (鬥獸棋)

A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).

## Game Overview

Animal Chess is a strategic board game for two players where each player commands a group of animals with different ranks. The objective is to be the first to move any of your pieces into the opponent's den (cave) or to capture all of your opponent's pieces.

## Game Rules

- 2 players, green and red. The game begins with red's turn

### Board Layout
- The game board is portrait orientation
- 7 columns × 9 rows board
- Green player on top, red player on bottom
- Two dens (caves) - one for each player at opposite ends
- Six traps - three for each player, adjacent to their den
- Two rivers - each river is 2 columns by 3 rows

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

## Code Structure Analysis

The project follows a well-organized Flutter architecture with a clear separation of concerns:

### Project Structure
```
lib/
├── main.dart                 # Entry point of the application
├── game/
│   ├── game_controller.dart  # Main game logic coordinator
│   ├── game_actions.dart     # Game actions implementation
│   └── game_rules.dart       # Game rules validation
├── models/
│   ├── animal_type.dart      # Animal types and their properties
│   ├── game_board.dart       # Game board representation
│   ├── game_config.dart      # Game configuration options
│   ├── piece.dart            # Game piece representation
│   ├── player_color.dart     # Player colors
│   └── position.dart         # Position on the board
├── screens/
│   ├── animal_chess_game_screen.dart # Main game screen
│   └── main_menu_screen.dart         # Main menu screen
└── widgets/
    ├── about_dialog_widget.dart      # About dialog UI
    ├── game_board_widget.dart        # Game board UI
    ├── game_rules_dialog_widget.dart # Game rules dialog UI
    ├── piece_widget.dart             # Individual piece UI
    ├── pieces_rank_list_widget.dart  # Pieces rank list UI
    ├── player_indicator_widget.dart  # Player indicator UI
    ├── settings_dialog_widget.dart   # Settings dialog UI
    ├── variants_dialog_widget.dart   # Game variants dialog UI
    └── ...                           # Other UI components
```

### Key Components

1. **Game Logic Layer** (`lib/game/`):
   - `GameController`: Coordinates the overall game state and interactions between components
   - `GameActions`: Implements game actions like moving pieces and switching players
   - `GameRules`: Validates moves according to game rules

2. **Model Layer** (`lib/models/`):
   - Data classes representing core game concepts (Piece, Board, Position, etc.)
   - Game configuration options for variants

3. **UI Layer** (`lib/screens/` and `lib/widgets/`):
   - Screens for different app views (main menu, game screen)
   - Reusable widgets for game components (board, pieces, dialogs)

### Code Quality Assessment

The codebase demonstrates several good practices:
- Clear separation of concerns between game logic, data models, and UI
- Comprehensive test coverage with unit tests for game rules and variants
- Internationalization support with multiple languages
- Responsive design that works on different screen sizes
- Well-documented code with comments explaining complex logic

## Possible Improvements

### 1. Game Logic Enhancements
- **Game History**: Implement move history to allow undo/redo functionality
- **AI Opponent**: Add a computer player with different difficulty levels

### 2. UI/UX Improvements
- **Animations**: Add smooth animations for piece movements and captures
- **Accessibility**: Improve accessibility with better contrast and screen reader support
- **Customization**: Allow users to customize the board and piece appearance

### 3. Performance Optimizations
- **Board Rendering**: Optimize the game board rendering for better performance with large boards
- **Memory Management**: Implement better memory management for long gameplay sessions

### 4. Testing and Quality
- **Integration Tests**: Add integration tests for the complete game flow
- **UI Tests**: Implement widget tests for all UI components
- **Code Coverage**: Increase test coverage for edge cases and error conditions

### 5. Documentation
- **API Documentation**: Add comprehensive API documentation for all public methods
- **Architecture Diagram**: Create visual diagrams showing the app architecture and data flow
- **Contributing Guide**: Expand the contributing guidelines with coding standards and practices

### 6. DevOps and Deployment
- **CI/CD Pipeline**: Enhance the GitHub Actions workflow with automated testing and deployment
- **Release Management**: Implement a release management strategy with versioning and changelogs
- **Analytics**: Add analytics to track user engagement and game statistics

### 7. Code Structure Improvements
- **Error Handling**: Implement more robust error handling throughout the application
