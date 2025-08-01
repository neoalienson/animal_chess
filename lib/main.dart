import 'package:flutter/material.dart';
import 'package:animal_chess/screens/main_menu_screen.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/core/service_locator.dart';

void main() {
  setupDependencies();
  runApp(const AnimalChessApp());
}

class AnimalChessApp extends StatefulWidget {
  const AnimalChessApp({super.key});

  @override
  State<AnimalChessApp> createState() => _AnimalChessAppState();
}

class _AnimalChessAppState extends State<AnimalChessApp> {
  Locale _locale = const Locale('zh', 'TW');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Chess 鬥獸棋',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: MainMenuScreen(setLocale: setLocale),
    );
  }
}
