import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AboutDialog(
      applicationName: localizations.animalChess,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.adb),
      applicationLegalese: '© 2025 Animal Chess',
      children: [
        Text(
          localizations.appDescription,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
