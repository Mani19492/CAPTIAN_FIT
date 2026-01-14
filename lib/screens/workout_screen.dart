import 'package:flutter/material.dart';
import 'package:captain_fit/models/fitness_data.dart';
import 'package:captain_fit/services/ai_service.dart';
import 'package:captain_fit/services/storage_service.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final AIService _aiService = AIService();
  final StorageService _storageService = StorageService();
  List<Workout> _workouts = [];
  final List<Workout> _completedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _workouts = _aiService.getSuggestedWorkouts('');
    });
  }

  void _completeWorkout(Workout workout) {
    setState(() {
      _completedWorkouts.add(workout);
    });
    
    // Save to history
    _storageService.saveWorkoutToHistory(workout);
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged: ${workout.name}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _completedWorkouts.remove(workout);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWorkouts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          const SizedBox(height: 16),
          
          // Completed workouts
          if (_completedWorkouts.isNotEmpty) ...[
            _buildSectionTitle('Completed Today'),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _completedWorkouts.length,
                itemBuilder: (context, index) {
                  return _buildCompletedWorkoutCard(_completedWorkouts[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Workout suggestions
          _buildSectionTitle('Suggested Workouts'),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                return _buildWorkoutCard(_workouts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, size: 32, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Goal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _completedWorkouts.length / 5,
                  backgroundColor: Colors.grey[700],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_completedWorkouts.length} of 5 workouts completed',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCompletedWorkoutCard(Workout workout) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            workout.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${workout.duration} min',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.grey[800]!,
              Colors.grey[900]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 40,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              workout.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${workout.duration} min • ${workout.caloriesBurned} cal',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _completeWorkout(workout),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}