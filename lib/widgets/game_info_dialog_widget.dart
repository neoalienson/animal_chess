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
        mainAxisSize: MainAxisSize.min,
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
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildVariantItem(
            context,
            localizations.ratOnlyDenEntry,
            gameConfig.ratOnlyDenEntry,
          ),
          const Divider(),
          _buildVariantItem(
            context,
            localizations.extendedLionTigerJumps,
            gameConfig.extendedLionTigerJumps,
          ),
          const Divider(),
          _buildVariantItem(
            context,
            localizations.dogRiverVariant,
            gameConfig.dogRiverVariant,
          ),
          const Divider(),
          _buildVariantItem(
            context,
            localizations.ratCannotCaptureElephant,
            gameConfig.ratCannotCaptureElephant,
          ),
        ],
      ),
    );
  }

  Widget _buildVariantItem(BuildContext context, String title, bool isEnabled) {
    final localizations = AppLocalizations.of(context);

    return ListTile(
      title: Text(title),
      trailing: Container(
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
    );
  }
}
