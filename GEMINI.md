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
- **State Management**: Consider using a state management solution like Provider or Riverpod for more complex state handling as the app grows
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
- **Dependency Injection**: Consider implementing dependency injection for better testability and modularity
- **Constants Management**: Move hardcoded values to constants files for better maintainability
- **Error Handling**: Implement more robust error handling throughout the application

## Plan for Improving Dependency Injection and Constants Management

### Dependency Injection Improvements

#### Current State Analysis
The current implementation has tightly coupled dependencies:
- `GameController` directly instantiates `GameRules` and `GameActions`
- Dependencies are created in constructors rather than being injected
- Makes unit testing more difficult as dependencies cannot be easily mocked

#### Proposed Improvements

1. **Implement a Simple DI Container**:
   - Create a service locator or simple DI container to manage dependencies
   - Register services like `GameRules`, `GameActions`, and `GameBoard` in the container
   - Resolve dependencies through the container rather than instantiating them directly

2. **Refactor GameController**:
   - Modify the constructor to accept injected dependencies instead of creating them internally
   - Use constructor injection for `GameRules` and `GameActions`
   - Example:
     ```dart
     class GameController {
       final GameBoard board;
       final GameRules gameRules;
       final GameActions gameActions;
       // ... other properties
       
       GameController({
         required this.board,
         required this.gameRules,
         required this.gameActions,
         required this.gameConfig,
       }) : currentPlayer = PlayerColor.red {
         // No longer instantiates dependencies directly
       }
     }
     ```

3. **Service Registration**:
   - Create a service locator pattern or use a package like `get_it` for dependency registration
   - Register services at app startup:
     ```dart
     // In main.dart or a separate service configuration file
     final locator = GetIt.instance;
     
     void setupDependencies() {
       locator.registerFactory(() => GameBoard());
       locator.registerFactory<GameRules>((sl) => GameRules(
         board: sl<GameBoard>(),
         gameConfig: sl<GameConfig>(),
       ));
       locator.registerFactory<GameActions>((sl) => GameActions(
         board: sl<GameBoard>(),
         gameConfig: sl<GameConfig>(),
         gameRules: sl<GameRules>(),
         // ... other dependencies
       ));
       locator.registerFactory<GameController>((sl) => GameController(
         board: sl<GameBoard>(),
         gameRules: sl<GameRules>(),
         gameActions: sl<GameActions>(),
         gameConfig: sl<GameConfig>(),
       ));
     }
     ```

4. **Benefits**:
   - Improved testability through easier mocking of dependencies
   - Better separation of concerns
   - More flexible and maintainable code
   - Easier to swap implementations for testing or different environments

### Constants Management Improvements

#### Current State Analysis
The project contains many hardcoded values throughout the codebase:
- Board dimensions (7 columns, 9 rows) defined in `GameBoard`
- Position coordinates for piece placement, dens, traps, and rivers
- UI constants for colors, sizes, padding, border radius, font sizes
- Magic numbers in game logic calculations

#### Proposed Improvements

1. **Create Constants Files**:
   - Create a dedicated directory `lib/constants/` for all constants
   - Organize constants into logical files:
     - `board_constants.dart` for board-related values
     - `ui_constants.dart` for UI-related values
     - `game_constants.dart` for game logic constants

2. **Board Constants** (`lib/constants/board_constants.dart`):
   ```dart
   class BoardConstants {
     static const int columns = 7;
     static const int rows = 9;
     
     // Dens positions
     static const Map<PlayerColor, Position> dens = {
       PlayerColor.green: Position(3, 0),
       PlayerColor.red: Position(3, 8),
     };
     
     // Traps positions
     static const Map<PlayerColor, List<Position>> traps = {
       PlayerColor.green: [
         Position(2, 0), 
         Position(4, 0), 
         Position(3, 1)
       ],
       PlayerColor.red: [
         Position(2, 8), 
         Position(4, 8), 
         Position(3, 7)
       ],
     };
     
     // Rivers positions
     static const List<Position> rivers = [
       // Left river (2x3 area)
       Position(1, 3), Position(1, 4), Position(1, 5),
       Position(2, 3), Position(2, 4), Position(2, 5),
       // Right river (2x3 area)
       Position(4, 3), Position(4, 4), Position(4, 5),
       Position(5, 3), Position(5, 4), Position(5, 5),
     ];
   }
   ```

3. **UI Constants** (`lib/constants/ui_constants.dart`):
   ```dart
   class UIConstants {
     // Colors
     static const Color primaryColor = Color(0xFF4CAF50);
     static const Color secondaryColor = Color(0xFFF44336);
     static const Color boardBackgroundColor = Color(0xFFFFF8E1);
     static const Color riverColor = Color(0xFFBBDEFB);
     static const Color greenDenColor = Color(0xFFC8E6C9);
     static const Color redDenColor = Color(0xFFFFCDD2);
     
     // Sizes
     static const double boardBorderWidth = 2.0;
     static const double cellBorderWidth = 0.3;
     static const double pieceBorderWidthNormal = 1.0;
     static const double pieceBorderWidthSelected = 3.0;
     static const double validMoveIndicatorSizeFactor = 0.3;
     static const double pieceSizeFactor = 0.9;
     static const double pieceFontSizeFactor = 0.5;
     
     // Border Radius
     static const double denBorderRadius = 8.0;
     static const double trapBorderRadius = 4.0;
     static const double pieceBorderRadius = 20.0;
     
     // Padding & Spacing
     static const double defaultPadding = 16.0;
     static const double smallPadding = 8.0;
     static const double pieceIndicatorSize = 20.0;
     static const double pieceIndicatorSpacing = 8.0;
     
     // Font Sizes
     static const double titleFontSize = 32.0;
     static const double buttonFontSize = 24.0;
     static const double boardFontSize = 16.0;
     static const double statusFontSize = 18.0;
     static const double rankListFontSize = 12.0;
     
     // Icon Sizes
     static const double denIconSize = 20.0;
     static const double trapIconSize = 16.0;
     static const double riverIconSize = 16.0;
     static const double buttonIconSize = 36.0;
   }
   ```

4. **Game Logic Constants** (`lib/constants/game_constants.dart`):
   ```dart
   class GameConstants {
     // Jump distances
     static const int lionTigerHorizontalJumpDistance = 3;
     static const int lionTigerVerticalJumpDistance = 4;
     static const int extendedLionDoubleRiverJumpHorizontal = 5;
     static const int extendedLionDoubleRiverJumpVertical = 7;
     
     // Piece starting positions
     static const Map<PlayerColor, List<Map<String, dynamic>>> pieceStartPositions = {
       PlayerColor.green: [
         {'type': AnimalType.lion, 'position': Position(0, 0)},
         {'type': AnimalType.tiger, 'position': Position(6, 0)},
         {'type': AnimalType.dog, 'position': Position(1, 1)},
         {'type': AnimalType.cat, 'position': Position(5, 1)},
         {'type': AnimalType.rat, 'position': Position(0, 2)},
         {'type': AnimalType.leopard, 'position': Position(2, 2)},
         {'type': AnimalType.wolf, 'position': Position(4, 2)},
         {'type': AnimalType.elephant, 'position': Position(6, 2)},
       ],
       PlayerColor.red: [
         {'type': AnimalType.lion, 'position': Position(6, 8)},
         {'type': AnimalType.tiger, 'position': Position(0, 8)},
         {'type': AnimalType.dog, 'position': Position(5, 7)},
         {'type': AnimalType.cat, 'position': Position(1, 7)},
         {'type': AnimalType.rat, 'position': Position(6, 6)},
         {'type': AnimalType.leopard, 'position': Position(4, 6)},
         {'type': AnimalType.wolf, 'position': Position(2, 6)},
         {'type': AnimalType.elephant, 'position': Position(0, 6)},
       ],
     };
   }
   ```

5. **Implementation Steps**:
   - Create the constants files with the above structure
   - Replace hardcoded values throughout the codebase with references to these constants
   - Update imports in affected files
   - Verify that all functionality remains the same after the changes

6. **Benefits**:
   - Centralized management of all constant values
   - Easier to make global changes to UI or game mechanics
   - Improved code readability and maintainability
   - Reduced risk of typos or inconsistencies in constant values
   - Better documentation of what values represent through descriptive constant names
