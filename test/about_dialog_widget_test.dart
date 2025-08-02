import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/widgets/about_dialog_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Mock Localizations delegate
class _TestLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _TestLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      MockAppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

class MockAppLocalizations implements AppLocalizations {
  final Locale locale;

  MockAppLocalizations(this.locale);

  @override
  String get animalChess => 'Animal Chess';

  @override
  String appLegalese(Object? year) =>
      '© ${year ?? DateTime.now().year} Animal Chess Team';

  @override
  String get appDescription => 'A fun animal chess game';

  @override
  dynamic noSuchMethod(Invocation invocation) => '';
}

void main() {
  group('AboutDialogWidget Tests', () {
    testWidgets('renders all dialog components', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            _TestLocalizationsDelegate(),
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) => Scaffold(body: AboutDialogWidget()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Animal Chess'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.byIcon(Icons.adb), findsOneWidget);
      expect(
        find.text('© ${DateTime.now().year} Animal Chess Team'),
        findsOneWidget,
      );
      expect(find.text('A fun animal chess game'), findsOneWidget);
    });

    testWidgets('displays correct application icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            _TestLocalizationsDelegate(),
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) => Scaffold(body: AboutDialogWidget()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.adb), findsOneWidget);
    });
  });
}
