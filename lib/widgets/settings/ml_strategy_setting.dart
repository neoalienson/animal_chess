import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/ml_strategy_type.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class MlStrategySetting extends StatelessWidget {
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;
  final String playerLabel;

  const MlStrategySetting({
    super.key,
    required this.gameConfig,
    required this.onConfigChanged,
    required this.playerLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            '$playerLabel ${localizations.aiStrategy.toLowerCase()}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        RadioListTile<MLStrategyType>(
          title: Text(localizations.defensive),
          value: MLStrategyType.defensive,
          groupValue: gameConfig.aiGreenStrategy, // This will need to be updated to support ML
          onChanged: (MLStrategyType? value) {
            if (value != null) {
              onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
            }
          },
        ),
        RadioListTile<MLStrategyType>(
          title: Text(localizations.offensive),
          value: MLStrategyType.offensive,
          groupValue: gameConfig.aiGreenStrategy,
          onChanged: (MLStrategyType? value) {
            if (value != null) {
              onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
            }
          },
        ),
        RadioListTile<MLStrategyType>(
          title: Text(localizations.balanced),
          value: MLStrategyType.balanced,
          groupValue: gameConfig.aiGreenStrategy,
          onChanged: (MLStrategyType? value) {
            if (value != null) {
              onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
            }
          },
        ),
        RadioListTile<MLStrategyType>(
          title: Text(localizations.exploratory),
          value: MLStrategyType.exploratory,
          groupValue: gameConfig.aiGreenStrategy,
          onChanged: (MLStrategyType? value) {
            if (value != null) {
              onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
            }
          },
        ),
        RadioListTile<MLStrategyType>(
          title: Text(localizations.machineLearning),
          value: MLStrategyType.machineLearning,
          groupValue: gameConfig.aiGreenStrategy,
          onChanged: (MLStrategyType? value) {
            if (value != null) {
              onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
            }
          },
        ),
      ],
    );
  }
}
