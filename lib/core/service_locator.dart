import 'package:get_it/get_it.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/game/game_rules.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/game_config.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerLazySingleton<GameBoard>(() => GameBoard());
  locator.registerLazySingleton<GameConfig>(() => GameConfig());

  locator.registerFactory<GameRules>(
    () => GameRules(
      board: locator<GameBoard>(),
      gameConfig: locator<GameConfig>(),
    ),
  );

  locator.registerFactory<GameActions>(
    () => GameActions(
      board: locator<GameBoard>(),
      gameConfig: locator<GameConfig>(),
      gameRules: locator<GameRules>(),
    ),
  );

  locator.registerFactory<GameController>(
    () => GameController(
      board: locator<GameBoard>(),
      gameRules: locator<GameRules>(),
      gameActions: locator<GameActions>(),
      gameConfig: locator<GameConfig>(),
    ),
  );
}

/// Recreate the game controller with the current configuration
GameController recreateGameController() {
  // Unregister existing instances
  locator.unregister<GameRules>();
  locator.unregister<GameActions>();
  locator.unregister<GameController>();

  // Re-register with current config
  locator.registerFactory<GameRules>(
    () => GameRules(
      board: locator<GameBoard>(),
      gameConfig: locator<GameConfig>(),
    ),
  );

  locator.registerFactory<GameActions>(
    () => GameActions(
      board: locator<GameBoard>(),
      gameConfig: locator<GameConfig>(),
      gameRules: locator<GameRules>(),
    ),
  );

  locator.registerFactory<GameController>(
    () => GameController(
      board: locator<GameBoard>(),
      gameRules: locator<GameRules>(),
      gameActions: locator<GameActions>(),
      gameConfig: locator<GameConfig>(),
    ),
  );

  return locator<GameController>();
}
