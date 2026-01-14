import 'package:flutter/material.dart';
import '../core/glass_background.dart';
import '../core/glass_card.dart';
import '../storage/local_storage.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final workouts = [
    'Push Ups 10x3',
    'Squats 15x3',
    'Plank 60s',
    'Running 10 min',
  ];
  List<String> _loggedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final saved = await LocalStorage.getWorkouts();
    setState(() => _loggedWorkouts = saved);
  }

  Future<void> _addWorkout(String workout) async {
    await LocalStorage.saveWorkout(workout);
    await _loadWorkouts();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout logged')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Available Workouts', style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...workouts
                  .map(
                    (w) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        child: ListTile(
                          title: Text(w),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addWorkout(w),
                          ),
                        ),
                      ),
                    ),
                  )
                  ,
              const SizedBox(height: 24),
              const Text("Today's Workouts", style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (_loggedWorkouts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No workouts logged yet', style: TextStyle(color: Color(0xFF9CA3AF)))),
                )
              else
                ..._loggedWorkouts
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(entry.value, style: const TextStyle(color: Color(0xFFFFFFFF))),
                                ),
                                Text('${entry.key + 1}', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    ,
            ],
          ),
        ),
      ),
    );
  }
}
