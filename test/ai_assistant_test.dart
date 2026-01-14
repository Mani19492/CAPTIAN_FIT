import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/services/ai_assistant.dart';

void main() {
  group('AI Assistant Tests', () {
    late AIAssistantService aiAssistant;

    setUp(() {
      aiAssistant = AIAssistantService();
    });

    test('Detects greeting intent', () {
      final intent = aiAssistant._detectIntent('Hello');
      expect(intent, 'greeting');
    });

    test('Detects workout suggestion intent', () {
      final intent = aiAssistant._detectIntent('Suggest a workout');
      expect(intent, 'workout_suggestion');
    });

    test('Detects meal suggestion intent', () {
      final intent = aiAssistant._detectIntent('What should I eat?');
      expect(intent, 'meal_suggestion');
    });

    test('Generates response for greeting', () {
      final response = aiAssistant._generateResponse('Hello', 'greeting');
      expect(response, isNotEmpty);
      expect(response, contains('Hello'));
    });

    test('Generates response for workout suggestion', () {
      final response = aiAssistant._generateResponse('Suggest a workout', 'workout_suggestion');
      expect(response, isNotEmpty);
      expect(response, contains('workout'));
    });
  });
}