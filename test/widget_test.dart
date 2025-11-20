// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:dice_game/main.dart';

void main() {
  testWidgets('Main menu appears correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiceGameApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the main menu title appears
    expect(find.text('🎲 DICE COMBAT GAME'), findsOneWidget);
    
    // Verify that class selection buttons appear
    expect(find.text('Guerreiro'), findsOneWidget);
    expect(find.text('Tanque'), findsOneWidget);
    expect(find.text('Mago'), findsOneWidget);
  });
}
