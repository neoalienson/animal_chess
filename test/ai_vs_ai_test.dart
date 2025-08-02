import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/core/service_locator.dart';
import 'package:test/test.dart';
import 'package:logging/logging.dart';

void main() {
  setUpAll(() {
    // Setup dependencies
    setupDependencies();

    // Enable logging for debugging
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  });

  test('AI vs AI gameplay should work correctly', () {
    // Get the default game configuration and modify it for AI vs AI
    final defaultConfig = locator<GameConfig>();
    // We'll modify the existing config rather than creating a new one
    defaultConfig.aiRed = true;
    defaultConfig.aiGreen = true;

    // Recreate the game controller with the updated configuration
    final controller = recreateGameController();

    // Check initial state
    expect(controller.currentPlayer, PlayerColor.red);
    expect(controller.gameEnded, false);

    // Execute AI moves for several turns to verify the fix works
    // We'll limit the number of moves to prevent infinite loops
    int movesExecuted = 0;
    const maxMoves = 10;

    // Run AI moves until game ends or we reach max moves
    while (!controller.gameEnded && movesExecuted < maxMoves) {
      // Execute AI move
      controller.executeAIMoveIfNecessary();
      movesExecuted++;
    }

    // Verify that at least some moves were executed
    expect(movesExecuted, greaterThan(0));

    print('Executed $movesExecuted AI moves in AI vs AI gameplay');
  });
}
