import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new workout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Workout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _TodayWorkoutCard(),
            const SizedBox(height: 24),
            const Text(
              'Suggested Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _WorkoutList(),
          ],
        ),
      ),
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full Body Strength',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('30 minutes • Intermediate'),
            const SizedBox(height: 16),
            const LinearProgressIndicator(value: 0.3),
            const SizedBox(height: 8),
            const Text('3/10 exercises completed'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Continue workout
                },
                child: const Text('Continue Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutList extends StatelessWidget {
  const _WorkoutList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _WorkoutItem(
          title: 'Morning Cardio',
          duration: '20 min',
          difficulty: 'Beginner',
          calories: '180 kcal',
        ),
        SizedBox(height: 12),
        _WorkoutItem(
          title: 'HIIT Blast',
          duration: '15 min',
          difficulty: 'Advanced',
          calories: '250 kcal',
        ),
        SizedBox(height: 12),
        _WorkoutItem(
          title: 'Yoga Flow',
          duration: '30 min',
          difficulty: 'Beginner',
          calories: '120 kcal',
        ),
        SizedBox(height: 12),
        _WorkoutItem(
          title: 'Upper Body Focus',
          duration: '45 min',
          difficulty: 'Intermediate',
          calories: '320 kcal',
        ),
      ],
    );
  }
}

class _WorkoutItem extends StatelessWidget {
  final String title;
  final String duration;
  final String difficulty;
  final String calories;

  const _WorkoutItem({
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(duration),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getDifficultyColor(difficulty),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                difficulty,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: Text(calories),
        onTap: () {
          // Start workout
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}