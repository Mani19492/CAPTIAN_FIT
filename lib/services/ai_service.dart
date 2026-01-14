class AIService {
  // Mock AI responses for different intents
  static const Map<String, List<String>> _responses = {
    'greeting': [
      'Hello! I\'m CaptainFit, your personal fitness assistant. How can I help you today?',
      'Hi there! Ready to get fit? Ask me anything about nutrition or workouts!',
      'Greetings! I\'m here to help you achieve your fitness goals. What do you need?',
    ],
    'workout_suggestion': [
      'How about a 20-minute HIIT workout to get your heart pumping?',
      'I recommend a full-body strength training session today.',
      'Try this: 3 sets of push-ups, squats, and planks. 10-15 reps each!',
    ],
    'meal_suggestion': [
      'How about a protein-rich breakfast with eggs, avocado, and whole grain toast?',
      'For lunch, try a quinoa salad with grilled chicken and mixed vegetables.',
      'A light dinner of grilled fish with steamed broccoli sounds perfect!',
    ],
    'encouragement': [
      'You\'re doing great! Keep up the good work!',
      'Every workout counts. You\'re on the right track!',
      'Consistency is key. You\'ve got this!',
    ],
    'default': [
      'I\'m here to help with your fitness journey. You can ask me about workouts, meals, or general fitness advice.',
      'Try asking me for workout suggestions or meal ideas!',
      'I can help you track your progress and stay motivated. What would you like to know?',
    ],
  };

  // Simple intent detection
  static String detectIntent(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('hello') || 
        lowerMessage.contains('hi') || 
        lowerMessage.contains('hey')) {
      return 'greeting';
    }

    if (lowerMessage.contains('workout') || 
        lowerMessage.contains('exercise') || 
        lowerMessage.contains('train')) {
      return 'workout_suggestion';
    }

    if (lowerMessage.contains('meal') || 
        lowerMessage.contains('food') || 
        lowerMessage.contains('eat') || 
        lowerMessage.contains('lunch') || 
        lowerMessage.contains('dinner') || 
        lowerMessage.contains('breakfast')) {
      return 'meal_suggestion';
    }

    if (lowerMessage.contains('good') || 
        lowerMessage.contains('great') || 
        lowerMessage.contains('motivat') || 
        lowerMessage.contains('encourag')) {
      return 'encouragement';
    }

    return 'default';
  }

  // Generate AI response based on intent
  static String generateResponse(String message) {
    final intent = detectIntent(message);
    final responses = _responses[intent] ?? _responses['default']!;
    
    // Return a random response from the list
    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }

  // Process user input and return structured response
  static AIResponse processInput(String userInput) {
    final intent = detectIntent(userInput);
    final response = generateResponse(userInput);
    
    return AIResponse(
      intent: intent,
      response: response,
      timestamp: DateTime.now(),
    );
  }
}

class AIResponse {
  final String intent;
  final String response;
  final DateTime timestamp;

  AIResponse({
    required this.intent,
    required this.response,
    required this.timestamp,
  });
}