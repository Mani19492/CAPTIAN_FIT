
import 'package:flutter/material.dart';
import '../core/glass_background.dart';
import '../core/glass_card.dart';
import '../storage/local_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final LocalStorage _storage = LocalStorage();
  List<Map<String, dynamic>> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    debugPrint('[ChatScreen] _loadMessages() called');
    // Ensure SharedPreferences is initialized
    await _storage.init();
    final meals = await _storage.getMeals();

    setState(() {
      _messages = meals.map((meal) => {
        'text': meal.name,
        'time': meal.timestamp.toLocal().toString(),
      }).toList();
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    debugPrint('[ChatScreen] _send() called with: $text');
    setState(() => _isSending = true);
    try {
      await _storage.init();
      final meals = await _storage.getMeals();
      final meal = Meal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: text,
        calories: 0,
        timestamp: DateTime.now(),
        clientId: '',
      );
      meals.add(meal);
      await _storage.saveMeals(meals);
      _controller.clear();
      await _loadMessages();
    } catch (e, st) {
      debugPrint('[ChatScreen] _send() error: $e\n$st');
      rethrow;
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // App logo (put your image at assets/images/app_logo.png)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Image(
                        image: const AssetImage('assets/images/app_logo.png'),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => const Icon(Icons.fitness_center),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Chat', style: TextStyle(fontSize: 22)),
                  ],
                ),
              ),
              Expanded(
                child: _messages.isEmpty
                    ? const Center(child: Text('No messages yet'))
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[_messages.length - 1 - index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GlassCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(msg['text'] ?? ''),
                                      const SizedBox(height: 8),
                                      Text(
                                        msg['time'] ?? '',
                                        style: const TextStyle(fontSize: 11, color: Colors.white60),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        enabled: !_isSending,
                        decoration: InputDecoration(
                          hintText: 'I ate 2 eggs and banana',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.03),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSending ? null : _send,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                      child: _isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                            )
                          : const Icon(Icons.send),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
