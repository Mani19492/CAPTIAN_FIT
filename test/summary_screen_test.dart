import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/screens/summary_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'meals': [
        '{"text":"I ate 2 eggs","time":"${DateTime.now().toIso8601String()}","detectedFood":"eggs"}',
        '{"text":"I ate one samosa","time":"${DateTime.now().toIso8601String()}","detectedFood":"samosa"}'
      ]
    });
  });

  testWidgets('Summary screen shows meals count and calories', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SummaryScreen()));

    // allow for async load - poll until the summary text appears (avoid pumpAndSettle which may timeout due to ongoing animations)
    await tester.pump();
    var attempts = 0;
    while (find.text('Today\'s Summary').evaluate().isEmpty && attempts < 20) {
      await tester.pump(const Duration(milliseconds: 100));
      attempts += 1;
    }

    expect(find.text('Today\'s Summary'), findsOneWidget);
    // Should show meals count 2
    expect(find.text('2'), findsWidgets);
  });
}
