import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:captain_fit/chat/ai_chat_screen.dart';

void main() {
  testWidgets('send button has semantics label', (WidgetTester tester) async {
    final semantics = SemanticsTester(tester);
    await tester.pumpWidget(const MaterialApp(home: AIChatScreen()));
    await tester.pumpAndSettle();

    final send = find.bySemanticsLabel('Send message');
    expect(send, findsOneWidget);

    final input = find.bySemanticsLabel('Message input');
    expect(input, findsOneWidget);

    semantics.dispose();
  });
}
