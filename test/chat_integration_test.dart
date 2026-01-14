import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/chat/ai_chat_screen.dart';
import 'package:captain_fit/storage/local_storage.dart';
import 'package:captain_fit/theme/futuristic_theme.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('sends a food log and stores meal', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const AIChatScreen(), theme: FuturisticTheme.darkTheme));

    // Enter a food log
    final field = find.byType(TextField);
    expect(field, findsOneWidget);
    await tester.enterText(field, 'I ate 2 eggs and 3 roti');

    final send = find.byIcon(Icons.send);
    await tester.tap(send);
    // Allow the asynchronous send flow and small delays to complete
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    final meals = await LocalStorage.getParsedMeals();
    expect(meals.length, 1);
    expect(meals.first['detectedFood'], 'eggs');
  });

  testWidgets('advice query does not log', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const AIChatScreen(), theme: FuturisticTheme.darkTheme));

    final field = find.byType(TextField);
    await tester.enterText(field, 'Can I eat one samosa now?');
    final send = find.byIcon(Icons.send);
    await tester.tap(send);
    // Allow the asynchronous send flow and small delays to complete
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    final meals = await LocalStorage.getParsedMeals();
    expect(meals.length, 0);
  });
}
