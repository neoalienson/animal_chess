import 'package:flutter/material.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/constants/ui_constants.dart';

class VariantsDialogWidget extends StatelessWidget {
  const VariantsDialogWidget({
    super.key,
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
            const SizedBox(height: UIConstants.smallPadding),
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
            const SizedBox(height: UIConstants.smallPadding),
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
            const SizedBox(height: UIConstants.smallPadding),
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
