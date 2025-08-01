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
import 'package:flutter/material.dart';



void main() {
  testWidgets('Animal Chess app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AnimalChessApp());

    // Load the app localizations.
    final localizations = await AppLocalizations.delegate.load(const Locale('en'));

    // Verify that the app title is displayed.
    expect(find.text(localizations.animalChess), findsOneWidget);

    // Verify that the main menu elements are displayed.
    expect(find.text(localizations.newGame), findsOneWidget);
    expect(find.text(localizations.gameInstructions), findsOneWidget);
  });
}
