import 'package:flutter/material.dart';
import 'package:captain_fit/models/fitness_data.dart';
import 'package:captain_fit/services/ai_service.dart';
import 'package:captain_fit/services/storage_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AIService _aiService = AIService();
  final StorageService _storageService = StorageService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _addMessage(
      text: _aiService.getGreeting(),
      isUser: false,
      messageType: MessageType.text,
    );
  }

  void _addMessage({
    required String text,
    required bool isUser,
    MessageType messageType = MessageType.text,
    List<FoodItem>? foods,
    List<Workout>? workouts,
  }) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        messageType: messageType,
        foods: foods,
        workouts: workouts,
        timestamp: DateTime.now(),
      ));
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty || _isSending) return;
    
    final message = _textController.text.trim();
    _textController.clear();
    
    // Add user message
    _addMessage(text: message, isUser: true);
    
    setState(() {
      _isSending = true;
    });
    
    // Simulate AI thinking
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Process user message
    await _processUserMessage(message);
    
    setState(() {
      _isSending = false;
    });
  }

  Future<void> _processUserMessage(String message) async {
    final lowerMessage = message.toLowerCase();
    
    // Check for food logging
    if (lowerMessage.contains('i ate') || 
        lowerMessage.contains('i had') || 
        lowerMessage.contains('i consumed')) {
      _addMessage(
        text: _aiService.getConfirmationResponse('food logging'),
        isUser: false,
      );
      return;
    }
    
    // Check for workout logging
    if (lowerMessage.contains('i did') || 
        lowerMessage.contains('i completed') || 
        lowerMessage.contains('i finished')) {
      _addMessage(
        text: _aiService.getConfirmationResponse('workout logging'),
        isUser: false,
      );
      return;
    }
    
    // Check for food suggestions
    if (lowerMessage.contains('food') || 
        lowerMessage.contains('eat') || 
        lowerMessage.contains('meal') ||
        lowerMessage.contains('snack')) {
      final foods = _aiService.getSuggestedFoods(message);
      _addMessage(
        text: _aiService.getFoodSuggestionResponse(),
        isUser: false,
        messageType: MessageType.foodSuggestion,
        foods: foods,
      );
      return;
    }
    
    // Check for workout suggestions
    if (lowerMessage.contains('workout') || 
        lowerMessage.contains('exercise') || 
        lowerMessage.contains('gym') ||
        lowerMessage.contains('training')) {
      final workouts = _aiService.getSuggestedWorkouts(message);
      _addMessage(
        text: _aiService.getWorkoutSuggestionResponse(),
        isUser: false,
        messageType: MessageType.workoutSuggestion,
        workouts: workouts,
      );
      return;
    }
    
    // Help request
    if (lowerMessage.contains('help') || 
        lowerMessage.contains('what can you do')) {
      _addMessage(
        text: _aiService.getHelpResponse(),
        isUser: false,
      );
      return;
    }
    
    // Default response
    _addMessage(
      text: "I'm here to help with your fitness journey! You can ask me about food suggestions, log what you've eaten, get workout recommendations, or track your exercises.",
      isUser: false,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: 
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isUser 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.grey[800],
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.messageType == MessageType.foodSuggestion) ...[
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: message.foods?.length ?? 0,
                        itemBuilder: (context, index) {
                          final food = message.foods![index];
                          return _buildFoodCard(food);
                        },
                      ),
                    ),
                  ] else if (message.messageType == MessageType.workoutSuggestion) ...[
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: message.workouts?.length ?? 0,
                        itemBuilder: (context, index) {
                          final workout = message.workouts![index];
                          return _buildWorkoutCard(workout);
                        },
                      ),
                    ),
                  ] else
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : null,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.fastfood,
              color: Colors.orange,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            food.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${food.calories} cal',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Log this food
              _addMessage(
                text: "I ate ${food.name}",
                isUser: true,
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                _addMessage(
                  text: _aiService.getConfirmationResponse('food logging'),
                  isUser: false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Log', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(35),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.blue,
              size: 35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            workout.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${workout.duration} min • ${workout.caloriesBurned} cal',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Log this workout
              _addMessage(
                text: "I did ${workout.name}",
                isUser: true,
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                _addMessage(
                  text: _aiService.getConfirmationResponse('workout logging'),
                  isUser: false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Log', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ask about food or workouts...',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _isSending ? null : _sendMessage,
            icon: _isSending
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageType {
  text,
  foodSuggestion,
  workoutSuggestion,
}

class ChatMessage {
  final String text;
  final bool isUser;
  final MessageType messageType;
  final List<FoodItem>? foods;
  final List<Workout>? workouts;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.messageType,
    this.foods,
    this.workouts,
    required this.timestamp,
  });
}