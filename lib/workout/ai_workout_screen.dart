import 'package:flutter/material.dart';
import 'package:captain_fit/storage/local_storage.dart';
import 'package:captain_fit/services/ai_assistant.dart';

class AIWorkoutScreen extends StatefulWidget {
  const AIWorkoutScreen({super.key});

  @override
  State<AIWorkoutScreen> createState() => _AIWorkoutScreenState();
}

class _AIWorkoutScreenState extends State<AIWorkoutScreen> {
  final _localStorage = LocalStorage();
  List<Workout> _workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final workouts = await _localStorage.getWorkouts();
      
      setState(() {
        _workouts = workouts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveWorkout(Workout workout) async {
    try {
      final workouts = await _localStorage.getWorkouts();
      workouts.add(workout);
      await _localStorage.saveWorkouts(workouts);
      
      setState(() {
        _workouts = workouts;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save workout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Workout Assistant'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWorkoutSuggestions(),
                  const SizedBox(height: 20),
                  _buildWorkoutHistory(),
                ],
              ),
            ),
    );
  }

  Widget _buildWorkoutSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Workouts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const _WorkoutSuggestionCard(
          title: 'Morning Cardio',
          description: '20 minutes of high-intensity cardio',
          duration: 20,
          calories: 180,
        ),
        const SizedBox(height: 12),
        const _WorkoutSuggestionCard(
          title: 'Full Body Strength',
          description: 'Complete body strength training',
          duration: 45,
          calories: 320,
        ),
      ],
    );
  }

  Widget _buildWorkoutHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Workout History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_workouts.isEmpty)
          const Center(
            child: Text('No workouts logged yet'),
          )
        else
          ..._workouts.map((workout) => _WorkoutHistoryItem(workout: workout)),
      ],
    );
  }
}

class _WorkoutSuggestionCard extends StatelessWidget {
  final String title;
  final String description;
  final int duration;
  final int calories;

  const _WorkoutSuggestionCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _WorkoutStat(
                  icon: Icons.access_time,
                  value: '$duration min',
                ),
                _WorkoutStat(
                  icon: Icons.local_fire_department,
                  value: '$calories kcal',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Start workout
                },
                child: const Text('Start Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _WorkoutStat({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }
}

class _WorkoutHistoryItem extends StatelessWidget {
  final Workout workout;

  const _WorkoutHistoryItem({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(workout.name),
        subtitle: Text(
          '${workout.duration} minutes • ${workout.calories} calories',
        ),
        trailing: Text(
          _formatTime(workout.timestamp),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}