import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/services/ai_assistant.dart';

void main() {
  test('detects log intent for food message', () {
    final msg = 'I ate 2 eggs and 3 roti';
    expect(AIAssistant.isLogIntent(msg), isTrue);
    expect(AIAssistant.detectFood(msg), equals('eggs'));
    final resp = AIAssistant.generateAIResponse(msg);
    expect(resp.startsWith('✅ Logged'), isTrue);
  });

  test('advice query not logged', () {
    final msg = 'Can I eat one samosa now?';
    expect(AIAssistant.isAdviceQuery(msg), isTrue);
    expect(AIAssistant.isLogIntent(msg), isFalse);
    final resp = AIAssistant.generateAIResponse(msg);
    expect(resp.startsWith('✅ Logged'), isFalse);
  });

  test('generic food logged even when not in DB', () {
    final msg = 'I ate one samosa at 4:16';
    expect(AIAssistant.isLogIntent(msg), isTrue);
    expect(AIAssistant.detectFood(msg), isNull);
    final resp = AIAssistant.generateAIResponse(msg);
    expect(resp.startsWith('✅ Logged'), isTrue);
  });
}
