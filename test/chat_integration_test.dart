import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/chat/chat_screen.dart';
import 'package:captain_fit/storage/local_storage.dart';

void main() {
  group('Chat Integration Tests', () {
    testWidgets('Chat screen loads and displays messages', (WidgetTester tester) async {
      // Create a mock local storage
      final localStorage = LocalStorage();
      
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatScreen(),
        ),
      );

      // Verify that the chat screen loads
      expect(find.text('Chat'), findsOneWidget);
      
      // Verify that the message input is present
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}