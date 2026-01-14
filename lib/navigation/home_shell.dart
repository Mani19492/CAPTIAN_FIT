import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../chat/chat_screen.dart';
import '../workout/workout_screen.dart';
import '../screens/summary_screen.dart';
import '../screens/settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = [
    const DashboardScreen(),
    const ChatScreen(),
    const WorkoutScreen(),
    const SummaryScreen(),
  ];

  void _openSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Summary'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openSettings,
        child: const Icon(Icons.settings),
      ),
    );
  }
}
