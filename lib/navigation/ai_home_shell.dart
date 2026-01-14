import 'package:flutter/material.dart';
import 'package:captain_fit/dashboard/ai_dashboard_screen.dart';
import 'package:captain_fit/workout/ai_workout_screen.dart';
import 'package:captain_fit/chat/ai_chat_screen.dart';

class AIHomeShell extends StatefulWidget {
  const AIHomeShell({super.key});

  @override
  State<AIHomeShell> createState() => _AIHomeShellState();
}

class _AIHomeShellState extends State<AIHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AIDashboardScreen(),
    const AIWorkoutScreen(),
    const AIChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}