import 'package:flutter/material.dart';
import 'package:captain_fit/core/glass_card.dart';
import 'package:captain_fit/core/glass_background.dart';
import 'package:captain_fit/services/storage_service.dart';
import 'package:captain_fit/services/summary_service.dart';
import 'package:captain_fit/models/fitness_data.dart';

class FuturisticHomeScreen extends StatefulWidget {
  const FuturisticHomeScreen({super.key});

  @override
  State<FuturisticHomeScreen> createState() => _FuturisticHomeScreenState();
}

class _FuturisticHomeScreenState extends State<FuturisticHomeScreen> {
  final StorageService _storageService = StorageService();
  List<Meal> _meals = [];
  List<Workout> _workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // In a real app, this would load from storage
      // For now, we'll use mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _meals = [
          Meal(
            id: '1',
            name: 'Protein Shake',
            calories: 180,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            clientId: 'client_1',
          ),
          Meal(
            id: '2',
            name: 'Grilled Chicken Salad',
            calories: 320,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            clientId: 'client_2',
          ),
        ];
        
        _workouts = [
          Workout(
            id: '1',
            name: 'Morning Run',
            duration: 30,
            calories: 320,
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
            clientId: 'client_3',
          ),
        ];
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : _buildContent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Captain!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () { debugPrint('[FuturisticHome] notifications pressed'); },
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStreakCard(),
          const SizedBox(height: 20),
          _buildCaloriesCard(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return GlassCard(
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 40,
            color: Colors.orange,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '5 Days',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Current Streak',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () { debugPrint('[FuturisticHome] streak info pressed'); },
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard() {
    final dailySummary = SummaryService.calculateDailySummary();
    
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCalorieItem(
                icon: Icons.restaurant,
                value: dailySummary.caloriesConsumed.toString(),
                label: 'Consumed',
              ),
              _buildCalorieItem(
                icon: Icons.local_fire_department,
                value: dailySummary.caloriesBurned.toString(),
                label: 'Burned',
              ),
              _buildCalorieItem(
                icon: Icons.access_time,
                value: dailySummary.workoutDuration.toString(),
                label: 'Minutes',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.65,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 8),
          const Text('65% of daily goal'),
        ],
      ),
    );
  }

  Widget _buildCalorieItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionItem(
              icon: Icons.restaurant,
              label: 'Log Meal',
              onTap: () { debugPrint('[FuturisticHome] QuickAction: Log Meal'); },
            ),
            _buildActionItem(
              icon: Icons.fitness_center,
              label: 'Workout',
              onTap: () { debugPrint('[FuturisticHome] QuickAction: Workout'); },
            ),
            _buildActionItem(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              onTap: () { debugPrint('[FuturisticHome] QuickAction: Chat'); },
            ),
            _buildActionItem(
              icon: Icons.bar_chart,
              label: 'Report',
              onTap: () { debugPrint('[FuturisticHome] QuickAction: Report'); },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._meals.map((meal) => _buildActivityItem(
              icon: Icons.restaurant,
              title: meal.name,
              subtitle: '${meal.calories} calories',
              time: _formatTime(meal.timestamp),
              color: Colors.green,
            )),
        ..._workouts.map((workout) => _buildActivityItem(
              icon: Icons.fitness_center,
              title: workout.name,
              subtitle: '${workout.duration} minutes',
              time: _formatTime(workout.timestamp),
              color: Colors.blue,
            )),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey[400]),
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