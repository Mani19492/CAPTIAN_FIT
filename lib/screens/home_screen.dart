import 'package:flutter/material.dart';
import 'package:captain_fit/models/fitness_data.dart';
import 'package:captain_fit/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<DailyLog> _dailyLogs = [];
  int _totalCalories = 0;
  int _totalWorkouts = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final logs = await _storageService.getDailyLogs();
    setState(() {
      _dailyLogs = logs;
      
      // Calculate today's stats
      final today = DateTime.now();
      final todayLog = logs.firstWhere(
        (log) => 
          log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day,
        orElse: () => DailyLog(date: today, foods: [], workouts: []),
      );
      
      _totalCalories = todayLog.foods.fold(
        0, 
        (sum, food) => sum + food.calories,
      );
      
      _totalWorkouts = todayLog.workouts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CaptainFit'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats cards
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.restaurant,
                    title: 'Calories',
                    value: _totalCalories.toString(),
                    subtitle: 'Today',
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    icon: Icons.fitness_center,
                    title: 'Workouts',
                    value: _totalWorkouts.toString(),
                    subtitle: 'Today',
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Recent foods
              _buildSectionTitle('Recent Foods'),
              _buildRecentFoods(),
              const SizedBox(height: 24),
              
              // Recent workouts
              _buildSectionTitle('Recent Workouts'),
              _buildRecentWorkouts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentFoods() {
    if (_dailyLogs.isEmpty) {
      return _buildEmptyState('No foods logged yet');
    }
    
    final today = DateTime.now();
    final todayLog = _dailyLogs.firstWhere(
      (log) => 
        log.date.year == today.year &&
        log.date.month == today.month &&
        log.date.day == today.day,
      orElse: () => DailyLog(date: today, foods: [], workouts: []),
    );
    
    if (todayLog.foods.isEmpty) {
      return _buildEmptyState('No foods logged today');
    }
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todayLog.foods.length,
        itemBuilder: (context, index) {
          final food = todayLog.foods[index];
          return _buildFoodItem(food);
        },
      ),
    );
  }

  Widget _buildRecentWorkouts() {
    if (_dailyLogs.isEmpty) {
      return _buildEmptyState('No workouts logged yet');
    }
    
    final today = DateTime.now();
    final todayLog = _dailyLogs.firstWhere(
      (log) => 
        log.date.year == today.year &&
        log.date.month == today.month &&
        log.date.day == today.day,
      orElse: () => DailyLog(date: today, foods: [], workouts: []),
    );
    
    if (todayLog.workouts.isEmpty) {
      return _buildEmptyState('No workouts logged today');
    }
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todayLog.workouts.length,
        itemBuilder: (context, index) {
          final workout = todayLog.workouts[index];
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
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
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