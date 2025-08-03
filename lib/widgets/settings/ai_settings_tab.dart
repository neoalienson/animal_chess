import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class AiSettingsTab extends StatelessWidget {
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;

  const AiSettingsTab({
    super.key,
    required this.gameConfig,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAIPlayerSettings(context, localizations),
          _buildAIStrategySettings(context, localizations),
        ],
      ),
    );
  }

  Widget _buildAIPlayerSettings(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            localizations.aiPlayers,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SwitchListTile(
          title: Text(localizations.aiGreenPlayer),
          value: gameConfig.aiGreen,
          onChanged: (bool value) {
            onConfigChanged(gameConfig.copyWith(aiGreen: value));
          },
        ),
        SwitchListTile(
          title: Text(localizations.aiRedPlayer),
          value: gameConfig.aiRed,
          onChanged: (bool value) {
            onConfigChanged(gameConfig.copyWith(aiRed: value));
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              localizations.aiPlayersDescription,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIStrategySettings(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            localizations.aiStrategy,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Green AI Strategy
        if (gameConfig.aiGreen) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(
              '${localizations.aiGreenPlayer} ${localizations.aiStrategy.toLowerCase()}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.defensive),
            value: AIStrategyType.defensive,
            groupValue: gameConfig.aiGreenStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
              }
            },
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.offensive),
            value: AIStrategyType.offensive,
            groupValue: gameConfig.aiGreenStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
              }
            },
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.balanced),
            value: AIStrategyType.balanced,
            groupValue: gameConfig.aiGreenStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
              }
            },
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.exploratory),
            value: AIStrategyType.exploratory,
            groupValue: gameConfig.aiGreenStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiGreenStrategy: value));
              }
            },
          ),
        ],
        // Red AI Strategy
        if (gameConfig.aiRed) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(
              '${localizations.aiRedPlayer} ${localizations.aiStrategy.toLowerCase()}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.defensive),
            value: AIStrategyType.defensive,
            groupValue: gameConfig.aiRedStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiRedStrategy: value));
              }
            },
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.offensive),
            value: AIStrategyType.offensive,
            groupValue: gameConfig.aiRedStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiRedStrategy: value));
              }
            },
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.balanced),
            value: AIStrategyType.balanced,
            groupValue: gameConfig.aiRedStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiRedStrategy: value));
              }
            },
          ),
          RadioListTile<AIStrategyType>(
            title: Text(localizations.exploratory),
            value: AIStrategyType.exploratory,
            groupValue: gameConfig.aiRedStrategy,
            onChanged: (AIStrategyType? value) {
              if (value != null) {
                onConfigChanged(gameConfig.copyWith(aiRedStrategy: value));
              }
            },
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              localizations.aiStrategyDescription,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
