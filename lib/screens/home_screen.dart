import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CaptainFit'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeCard(),
            SizedBox(height: 20),
            StatsOverview(),
            SizedBox(height: 20),
            QuickActions(),
          ],
        ),
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ready for your daily fitness routine?',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Start workout
                    },
                    child: const Text('Start Workout'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Log food
                    },
                    child: const Text('Log Food'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Stats',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            StatCard(
              title: 'Calories',
              value: '1,250',
              unit: 'kcal',
              icon: Icons.local_fire_department,
            ),
            SizedBox(width: 12),
            StatCard(
              title: 'Steps',
              value: '8,432',
              unit: 'steps',
              icon: Icons.directions_walk,
            ),
          ],
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            QuickActionCard(
              title: 'Workout Plan',
              icon: Icons.fitness_center,
            ),
            QuickActionCard(
              title: 'Meal Log',
              icon: Icons.restaurant,
            ),
            QuickActionCard(
              title: 'Progress',
              icon: Icons.show_chart,
            ),
            QuickActionCard(
              title: 'AI Assistant',
              icon: Icons.smart_toy,
            ),
          ],
        ),
      ],
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle action
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}