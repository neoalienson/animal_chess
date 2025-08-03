import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class GameVariantsTab extends StatelessWidget {
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;

  const GameVariantsTab({
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
          _buildRatOnlyDenEntryVariant(context, localizations),
          _buildExtendedLionTigerJumpsVariant(context, localizations),
          _buildDogRiverVariant(context, localizations),
          _buildRatCannotCaptureElephantVariant(context, localizations),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: Theme.of(context).textTheme.bodySmall),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildRatOnlyDenEntryVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.ratOnlyDenEntry,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: gameConfig.ratOnlyDenEntry,
          onChanged: (bool value) {
            onConfigChanged(gameConfig.copyWith(ratOnlyDenEntry: value));
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
              gameConfig.ratOnlyDenEntry
                  ? localizations.variantRatOnlyDenEntryDescriptionEnabled
                  : localizations.variantRatOnlyDenEntryDescriptionDisabled,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExtendedLionTigerJumpsVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.extendedLionTigerJumps,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: gameConfig.extendedLionTigerJumps,
          onChanged: (bool value) {
            onConfigChanged(gameConfig.copyWith(extendedLionTigerJumps: value));
          },
        ),
        if (gameConfig.extendedLionTigerJumps) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(
                  context,
                  localizations.variantLionJumpBothRivers,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantTigerJumpSingleRiver,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantLeopardCrossRivers,
                ),
              ],
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(
                  context,
                  localizations.variantLionJumpStandard,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantTigerJumpStandard,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantLeopardCrossRiversStandard,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDogRiverVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.dogRiverVariant,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: gameConfig.dogRiverVariant,
          onChanged: (bool value) {
            onConfigChanged(gameConfig.copyWith(dogRiverVariant: value));
          },
        ),
        if (gameConfig.dogRiverVariant) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(context, localizations.variantDogEnterRiver),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantDogCaptureFromRiver,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatCannotCaptureElephantVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.ratCannotCaptureElephant,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: gameConfig.ratCannotCaptureElephant,
          onChanged: (bool value) {
            onConfigChanged(
              gameConfig.copyWith(ratCannotCaptureElephant: value),
            );
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
              gameConfig.ratCannotCaptureElephant
                  ? localizations
                        .variantRatCannotCaptureElephantDescriptionEnabled
                  : localizations
                        .variantRatCannotCaptureElephantDescriptionDisabled,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
