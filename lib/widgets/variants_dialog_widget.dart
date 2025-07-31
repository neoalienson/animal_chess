import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class VariantsDialogWidget extends StatelessWidget {
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;

  const VariantsDialogWidget({
    super.key,
    required this.gameConfig,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return AlertDialog(
      title: Text(localizations.gameVariants),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. ${localizations.variantRatOnlyDenEntry}',
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              '2. ${localizations.variantExtendedLionTigerJumps}:',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '   - ${localizations.variantLionJumpBothRivers}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '   - ${localizations.variantTigerJumpSingleRiver}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '   - ${localizations.variantLeopardCrossRivers}',
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              '3. ${localizations.variantDogRiver}:',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '   - ${localizations.variantDogEnterRiver}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '   - ${localizations.variantDogCaptureFromRiver}',
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              '4. ${localizations.ratCannotCaptureElephant}',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(localizations.cancel),
        ),
      ],
    );
  }
}
