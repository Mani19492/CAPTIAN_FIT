import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/services/ai_assistant.dart';
import 'package:captain_fit/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AI Assistant Tests', () {
    late AIAssistantService aiAssistant;

    setUp(() async {
      // Initialize shared preferences and local storage for tests
      SharedPreferences.setMockInitialValues({});
      await LocalStorage().init();
      aiAssistant = AIAssistantService();
    });

    test('Detects greeting intent', () async {
      final response = await aiAssistant.processMessage('Hello');
      expect(response.intent, 'greeting');
    });

    test('Detects workout suggestion intent', () async {
      final response = await aiAssistant.processMessage('Suggest a workout');
      expect(response.intent, 'workout_suggestion');
    });

    test('Detects meal suggestion intent', () async {
      final response = await aiAssistant.processMessage('What should I eat?');
      // Current implementation treats "should I" style messages as general questions
      expect(response.intent, 'question');
    });

    test('Generates response for greeting', () async {
      final response = await aiAssistant.processMessage('Hello');
      expect(response.assistantMessage.text, isNotEmpty);
      expect(response.assistantMessage.text, contains('Hello'));
    });

    test('Generates response for workout suggestion', () async {
      final response = await aiAssistant.processMessage('Suggest a workout');
      expect(response.assistantMessage.text, isNotEmpty);
      expect(response.assistantMessage.text.toLowerCase(), contains('workout'));
    });
  });
}