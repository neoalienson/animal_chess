// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:animal_chess/main.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Animal Chess app smoke test', (WidgetTester tester) async {
    // Build our app with localization support and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const AnimalChessApp(),
      ),
    );

    // Wait for localization to load
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.byType(MainMenuScreen), findsOneWidget);

    // Verify that localization is working
    final localizations = AppLocalizations.of(
      tester.element(find.byType(MainMenuScreen)),
    );
    expect(find.text(localizations.animalChess), findsOneWidget);
    expect(find.text(localizations.newGame), findsOneWidget);
    expect(find.text(localizations.gameInstructions), findsOneWidget);
  });
}
