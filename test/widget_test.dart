import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/main.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('App loads without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that the app loads
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Verify that we have a Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}