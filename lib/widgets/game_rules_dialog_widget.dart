import 'package:flutter/material.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class GameRulesDialogWidget extends StatelessWidget {
  const GameRulesDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return AlertDialog(
      title: Text(localizations.gameRules),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.appDescription),
            const SizedBox(height: 10),
            Text('1. ${localizations.gameRule1}'),
            Text('2. ${localizations.gameRule2}'),
            Text('3. ${localizations.gameRule3}'),
            Text('4. ${localizations.gameRule4}'),
            Text('5. ${localizations.gameRule5}'),
            Text('6. ${localizations.gameRule6}'),
            Text('7. ${localizations.gameRule7}'),
            Text('8. ${localizations.gameRule8}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(localizations.close),
        ),
      ],
    );
  }
}
