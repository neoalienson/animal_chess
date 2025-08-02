import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:confetti/confetti.dart';
import 'package:animal_chess/widgets/victory_dialog_widget.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  late ConfettiController confettiController;

  setUp(() {
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  });

  tearDown(() {
    confettiController.dispose();
  });

  testWidgets('VictoryDialogWidget shows correct winner text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: VictoryDialogWidget(
            winner: PlayerColor.green,
            confettiController: confettiController,
            onClose: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('Green Player'), findsOneWidget);
  });

  testWidgets('VictoryDialogWidget shows confetti', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: VictoryDialogWidget(
            winner: PlayerColor.red,
            confettiController: confettiController,
            onClose: () {},
          ),
        ),
      ),
    );

    expect(find.byType(ConfettiWidget), findsOneWidget);
  });

  testWidgets('VictoryDialogWidget calls onClose when button pressed', (
    WidgetTester tester,
  ) async {
    var closeCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: VictoryDialogWidget(
            winner: PlayerColor.green,
            confettiController: confettiController,
            onClose: () => closeCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Close'));
    await tester.pump();

    expect(closeCalled, isTrue);
  });
}
