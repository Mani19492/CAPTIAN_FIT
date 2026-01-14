import 'package:flutter/material.dart';
import 'package:captain_fit/services/summary_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weeklySummary = SummaryService.calculateWeeklySummary();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 24),
            const Text(
              'Weekly Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _WeeklySummaryCard(summary: weeklySummary),
            const SizedBox(height: 24),
            const Text(
              'Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _AchievementsGrid(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Captain Fit User',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Member since Jan 2026',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(
                value: '12',
                label: 'Days Streak',
                icon: Icons.local_fire_department,
              ),
              SizedBox(width: 32),
              _StatItem(
                value: '42',
                label: 'Workouts',
                icon: Icons.fitness_center,
              ),
              SizedBox(width: 32),
              _StatItem(
                value: '18',
                label: 'Achievements',
                icon: Icons.emoji_events,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
}

class _WeeklySummaryCard extends StatelessWidget {
  final WeeklySummary summary;

  const _WeeklySummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryStat(
                  label: 'Calories\nConsumed',
                  value: summary.totalCaloriesConsumed.toString(),
                  unit: 'kcal',
                ),
                _SummaryStat(
                  label: 'Calories\nBurned',
                  value: summary.totalCaloriesBurned.toString(),
                  unit: 'kcal',
                ),
                _SummaryStat(
                  label: 'Workout\nTime',
                  value: summary.totalWorkoutDuration.toString(),
                  unit: 'min',
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: summary.workoutDays / 7,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${summary.workoutDays}/7 days active this week',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  const _AchievementsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _AchievementItem(
          icon: Icons.local_fire_department,
          title: '7 Day\nStreak',
          unlocked: true,
        ),
        _AchievementItem(
          icon: Icons.fitness_center,
          title: '100\nWorkouts',
          unlocked: false,
        ),
        _AchievementItem(
          icon: Icons.restaurant,
          title: '30 Days\nLogged',
          unlocked: true,
        ),
        _AchievementItem(
          icon: Icons.emoji_events,
          title: 'Early\nBird',
          unlocked: false,
        ),
        _AchievementItem(
          icon: Icons.self_improvement,
          title: 'Mindful\nEater',
          unlocked: true,
        ),
        _AchievementItem(
          icon: Icons.track_changes,
          title: 'Goal\nSetter',
          unlocked: false,
        ),
      ],
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool unlocked;

  const _AchievementItem({
    required this.icon,
    required this.title,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: unlocked ? null : Colors.grey[800],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: unlocked ? Theme.of(context).colorScheme.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: unlocked ? null : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}