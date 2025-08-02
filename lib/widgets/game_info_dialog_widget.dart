import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/widgets/pieces_rank_list_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class GameInfoDialogWidget extends StatelessWidget {
  final PieceDisplayFormat displayFormat;
  final GameConfig gameConfig;

  const GameInfoDialogWidget({
    super.key,
    required this.displayFormat,
    required this.gameConfig,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TabBar(
            tabs: [
              Tab(text: localizations.piecesRank),
              Tab(text: localizations.gameVariants),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Pieces Rank Tab
                PiecesRankListWidget(displayFormat: displayFormat),

                // Game Variants Tab
                _buildGameVariantsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameVariantsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatOnlyDenEntryVariant(context),
            const SizedBox(height: 24),
            _buildExtendedLionTigerJumpsVariant(context),
            const SizedBox(height: 24),
            _buildDogRiverVariant(context),
            const SizedBox(height: 24),
            _buildRatCannotCaptureElephantVariant(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRatOnlyDenEntryVariant(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVariantHeader(
          context,
          localizations.ratOnlyDenEntry,
          gameConfig.ratOnlyDenEntry,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            gameConfig.ratOnlyDenEntry
                ? localizations.variantRatOnlyDenEntryDescriptionEnabled
                : localizations.variantRatOnlyDenEntryDescriptionDisabled,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildExtendedLionTigerJumpsVariant(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVariantHeader(
          context,
          localizations.extendedLionTigerJumps,
          gameConfig.extendedLionTigerJumps,
        ),
        const SizedBox(height: 8),
        if (gameConfig.extendedLionTigerJumps) ...[
          _buildBulletPoint(context, localizations.variantLionJumpBothRivers),
          const SizedBox(height: 4),
          _buildBulletPoint(context, localizations.variantTigerJumpSingleRiver),
          const SizedBox(height: 4),
          _buildBulletPoint(context, localizations.variantLeopardCrossRivers),
        ] else ...[
          _buildBulletPoint(context, localizations.variantLionJumpStandard),
          const SizedBox(height: 4),
          _buildBulletPoint(context, localizations.variantTigerJumpStandard),
          const SizedBox(height: 4),
          _buildBulletPoint(
            context,
            localizations.variantLeopardCrossRiversStandard,
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            gameConfig.extendedLionTigerJumps
                ? localizations.variantExtendedLionTigerJumpsDescriptionEnabled
                : localizations
                      .variantExtendedLionTigerJumpsDescriptionDisabled,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildDogRiverVariant(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVariantHeader(
          context,
          localizations.dogRiverVariant,
          gameConfig.dogRiverVariant,
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(context, localizations.variantDogEnterRiver),
        const SizedBox(height: 4),
        _buildBulletPoint(context, localizations.variantDogCaptureFromRiver),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            gameConfig.dogRiverVariant
                ? localizations.variantDogRiverDescriptionEnabled
                : localizations.variantDogRiverDescriptionDisabled,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildRatCannotCaptureElephantVariant(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVariantHeader(
          context,
          localizations.ratCannotCaptureElephant,
          gameConfig.ratCannotCaptureElephant,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            gameConfig.ratCannotCaptureElephant
                ? localizations
                      .variantRatCannotCaptureElephantDescriptionEnabled
                : localizations
                      .variantRatCannotCaptureElephantDescriptionDisabled,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildVariantHeader(
    BuildContext context,
    String title,
    bool isEnabled,
  ) {
    final localizations = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isEnabled
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            isEnabled ? localizations.enabled : localizations.disabled,
            style: TextStyle(
              color: isEnabled
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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
}
