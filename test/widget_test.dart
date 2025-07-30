// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:animal_chess/main.dart';

void main() {
  testWidgets('Animal Chess app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AnimalChessApp());

    // Verify that the app title is displayed.
    expect(find.text('Animal Chess (鬥獸棋)'), findsOneWidget);

    // Verify that player indicators are displayed.
    expect(find.text('Green Player'), findsOneWidget);
    expect(find.text('Red Player'), findsOneWidget);
  });
}
