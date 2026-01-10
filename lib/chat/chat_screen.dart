import 'package:flutter/material.dart';
import '../core/glass_background.dart';
import '../core/glass_card.dart';
import '../storage/local_storage.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final messages = <String>[];

  void send() async {
    if (controller.text.isEmpty) return;
    await LocalStorage.saveMeal(controller.text);
    setState(() {
      messages.add(controller.text);
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Food Chat', style: TextStyle(fontSize: 22)),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: messages
                      .map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GlassCard(child: Text(m)),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'What did you eat?',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: send,
                    ),
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
