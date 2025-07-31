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
            Text('1. ${localizations.variantRatOnlyDenEntry}'),
            const SizedBox(height: 10),
            Text('2. ${localizations.variantExtendedLionTigerJumps}:'),
            Text('   - ${localizations.variantLionJumpBothRivers}'),
            Text('   - ${localizations.variantTigerJumpSingleRiver}'),
            Text('   - ${localizations.variantLeopardCrossRivers}'),
            const SizedBox(height: 10),
            Text('3. ${localizations.variantDogRiver}:'),
            Text('   - ${localizations.variantDogEnterRiver}'),
            Text('   - ${localizations.variantDogCaptureFromRiver}'),
            const SizedBox(height: 10),
            Text('4. ${localizations.ratCannotCaptureElephant}'),
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
