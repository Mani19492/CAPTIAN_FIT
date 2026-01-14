import 'package:captain_fit/storage/local_storage.dart';

class AIAssistantService {
  final LocalStorage _storage = LocalStorage();
  
  // Process user message and generate response
  Future<AssistantResponse> processMessage(String message) async {
    // Save user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    // Detect intent and generate response
    final intent = _detectIntent(message);
    final responseText = _generateResponse(message, intent);
    
    // Create assistant response
    final assistantMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    // Save both messages
    final messages = await _storage.getChatMessages();
    messages.addAll([userMessage, assistantMessage]);
    await _storage.saveChatMessages(messages);
    
    return AssistantResponse(
      userMessage: userMessage,
      assistantMessage: assistantMessage,
      intent: intent,
    );
  }
  
  // Detect intent from user message
  String _detectIntent(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Food logging intents
    if (lowerMessage.contains('i ate') || 
        lowerMessage.contains('i had') || 
        lowerMessage.contains('i consumed')) {
      return 'food_log';
    }
    
    // Workout logging intents
    if (lowerMessage.contains('i did') || 
        lowerMessage.contains('i completed') || 
        lowerMessage.contains('finished workout')) {
      return 'workout_log';
    }
    
    // Question intents
    if (lowerMessage.contains('can i') || 
        lowerMessage.contains('should i') || 
        lowerMessage.contains('is it ok')) {
      return 'question';
    }
    
    // Greeting intents
    if (lowerMessage.contains('hello') || 
        lowerMessage.contains('hi') || 
        lowerMessage.contains('hey')) {
      return 'greeting';
    }
    
    // Workout suggestion intents
    if (lowerMessage.contains('workout') || 
        lowerMessage.contains('exercise') || 
        lowerMessage.contains('train')) {
      return 'workout_suggestion';
    }
    
    // Meal suggestion intents
    if (lowerMessage.contains('meal') || 
        lowerMessage.contains('food') || 
        lowerMessage.contains('eat') || 
        lowerMessage.contains('lunch') || 
        lowerMessage.contains('dinner') || 
        lowerMessage.contains('breakfast')) {
      return 'meal_suggestion';
    }
    
    return 'general';
  }
  
  // Generate response based on intent
  String _generateResponse(String message, String intent) {
    switch (intent) {
      case 'food_log':
        return 'Great job logging your meal! I\'ve recorded that for you. '
            'Would you like to add anything else to your food log?';
        
      case 'workout_log':
        return 'Awesome work! I\'ve logged your workout. '
            'Keep up the great effort!';
        
      case 'question':
        return 'That\'s a good question! Based on general nutrition guidelines, '
            'it\'s best to maintain a balanced diet. Would you like specific advice?';
        
      case 'greeting':
        return 'Hello! I\'m CaptainFit, your personal fitness assistant. '
            'How can I help you with your fitness journey today?';
        
      case 'workout_suggestion':
        return 'Here\'s a great workout suggestion: Try 3 sets of 15 push-ups, '
            '20 squats, and a 1-minute plank. This will give you a solid full-body workout!';
        
      case 'meal_suggestion':
        return 'How about a healthy meal with grilled chicken, quinoa, and '
            'roasted vegetables? It\'s packed with protein and nutrients!';
        
      case 'general':
      default:
        return 'I\'m here to help with your fitness journey! You can log meals, '
            'track workouts, or ask for suggestions. What would you like to do?';
    }
  }
  
  // Get chat history
  Future<List<ChatMessage>> getChatHistory() async {
    return await _storage.getChatMessages();
  }
  
  // Clear chat history
  Future<void> clearChatHistory() async {
    final messages = await _storage.getChatMessages();
    messages.clear();
    await _storage.saveChatMessages(messages);
  }
}

class AssistantResponse {
  final ChatMessage userMessage;
  final ChatMessage assistantMessage;
  final String intent;
  
  AssistantResponse({
    required this.userMessage,
    required this.assistantMessage,
    required this.intent,
  });
}