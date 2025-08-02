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

## Getting Started

### Prerequisites
- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 2.17 or higher)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd animal_chess
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

To run the app on a connected device or emulator:
```bash
flutter run
```

To run the app on a specific platform:
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For web
flutter run -d chrome

# For Windows
flutter run -d windows
```

### Building the App

To build the app for deployment:
```bash
# For Android
flutter build apk

# For iOS
flutter build ios

# For web
flutter build web

# For Windows
flutter build windows
```

## Project Structure

```
lib/
├── main.dart                 # Entry point of the application
├── game/
│   ├── game_controller.dart  # Game logic and state management
│   └── rules/                # Game rules and variants
│       ├── game_rule_variant.dart          # Base interface for game rule variants
│       ├── standard_game_rule_variant.dart # Standard game rules implementation
│       ├── game_rule_factory.dart          # Factory for creating rule variants
│       └── variants/                       # Individual game variant implementations
│           ├── dog_river_variant.dart      # Dog river variant implementation
│           ├── rat_capture_variant.dart    # Rat capture variant implementation
│           ├── extended_jump_variant.dart  # Extended jump variant implementation
│           └── example_new_variant.dart    # Example for adding new variants
├── models/
│   ├── animal_type.dart      # Animal types and their properties
│   ├── game_board.dart       # Game board representation
│   ├── piece.dart            # Game piece representation
│   ├── player_color.dart     # Player colors
│   └── position.dart         # Position on the board
└── widgets/
    ├── about_dialog_widget.dart # About dialog UI
    ├── game_board_widget.dart # Game board UI
    ├── main_menu_screen.dart  # Main menu UI
    ├── piece_widget.dart      # Individual piece UI
    └── pieces_rank_list_widget.dart # Pieces rank list UI
```

## Extending Game Rules

The game now supports a pluggable variant system that makes it easy to add new rule variants. To add a new variant:

1. Create a new variant class that implements `GameRuleVariant`
2. Implement the required methods (`canEnterRiver`, `canCapture`, `canJumpOverRiver`, `canMoveToDen`)
3. Use the decorator pattern by accepting a base variant in the constructor
4. Delegate to the base variant for any rules not modified by your variant
5. Add your variant to the `GameRuleFactory`

See `lib/game/rules/variants/example_new_variant.dart` for a complete example.

## Testing

To run the tests:
```bash
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the traditional Chinese board game Dou Shou Qi (鬥獸棋)
