import 'package:flutter/material.dart';
import 'package:captain_fit/models/fitness_data.dart';
import 'package:captain_fit/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  List<DailyLog> _dailyLogs = [];
  List<FoodItem> _foodHistory = [];
  List<Workout> _workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final logs = await _storageService.getDailyLogs();
    final foods = await _storageService.getFoodHistory();
    final workouts = await _storageService.getWorkoutHistory();
    
    setState(() {
      _dailyLogs = logs;
      _foodHistory = foods;
      _workoutHistory = workouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            _buildProfileHeader(),
            const SizedBox(height: 24),
            
            // Stats overview
            _buildStatsOverview(),
            const SizedBox(height: 24),
            
            // Recent activity
            _buildSectionTitle('Recent Activity'),
            _buildRecentActivity(),
            const SizedBox(height: 24),
            
            // Food history
            _buildSectionTitle('Recent Foods'),
            _buildFoodHistory(),
            const SizedBox(height: 24),
            
            // Workout history
            _buildSectionTitle('Recent Workouts'),
            _buildWorkoutHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.blue.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Fitness Enthusiast',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Member since ${DateTime.now().year}',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    // Calculate stats
    int totalCalories = 0;
    int totalWorkouts = 0;
    int streak = 0;
    
    for (var log in _dailyLogs) {
      totalCalories += log.foods.fold(0, (sum, food) => sum + food.calories);
      totalWorkouts += log.workouts.length;
    }
    
    // Calculate streak (simplified)
    if (_dailyLogs.isNotEmpty) {
      streak = _dailyLogs.length;
    }
    
    return Row(
      children: [
        _buildStatCard(
          title: 'Calories',
          value: totalCalories.toString(),
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          title: 'Workouts',
          value: totalWorkouts.toString(),
          icon: Icons.fitness_center,
          color: Colors.blue,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          title: 'Streak',
          value: '$streak days',
          icon: Icons.local_fire_department,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    if (_dailyLogs.isEmpty) {
      return _buildEmptyState('No activity yet');
    }
    
    // Get last 5 activities
    final recentLogs = _dailyLogs.reversed.take(5).toList();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: recentLogs.map((log) {
          return _buildActivityItem(log);
        }).toList(),
      ),
    );
  }

  Widget _buildActivityItem(DailyLog log) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.calendar_today, size: 20),
      ),
      title: Text(
        '${log.date.day}/${log.date.month}/${log.date.year}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${log.foods.length} foods, ${log.workouts.length} workouts',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildFoodHistory() {
    if (_foodHistory.isEmpty) {
      return _buildEmptyState('No food history');
    }
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _foodHistory.length,
        itemBuilder: (context, index) {
          final food = _foodHistory[index];
          return _buildFoodItem(food);
        },
      ),
    );
  }

  Widget _buildWorkoutHistory() {
    if (_workoutHistory.isEmpty) {
      return _buildEmptyState('No workout history');
    }
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _workoutHistory.length,
        itemBuilder: (context, index) {
          final workout = _workoutHistory[index];
          return _buildWorkoutItem(workout);
        },
      ),
    );
  }

  Widget _buildFoodItem(FoodItem food) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.fastfood, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(
            food.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${food.calories} cal',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(Workout workout) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.fitness_center, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            workout.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${workout.duration} min',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}