import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:captain_fit/services/summary_service.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dailySummary = SummaryService.calculateDailySummary();
    final weeklySummary = SummaryService.calculateWeeklySummary();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Summary'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _DailySummaryCard(summary: dailySummary),
            const SizedBox(height: 24),
            const Text(
              'Weekly Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _WeeklySummaryCard(summary: weeklySummary),
            const SizedBox(height: 24),
            const Text(
              'Nutrition Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _NutritionChart(),
          ],
        ),
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  final DailySummary summary;

  const _DailySummaryCard({required this.summary});

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
                _SummaryItem(
                  icon: Icons.restaurant,
                  value: summary.caloriesConsumed.toString(),
                  label: 'Consumed',
                  unit: 'kcal',
                ),
                _SummaryItem(
                  icon: Icons.local_fire_department,
                  value: summary.caloriesBurned.toString(),
                  label: 'Burned',
                  unit: 'kcal',
                ),
                _SummaryItem(
                  icon: Icons.access_time,
                  value: summary.workoutDuration.toString(),
                  label: 'Workout',
                  unit: 'min',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Net Calories',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              summary.netCalories.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              summary.netCalories >= 0 
                  ? 'Surplus' 
                  : 'Deficit',
              style: TextStyle(
                fontSize: 16,
                color: summary.netCalories >= 0 
                    ? Colors.red 
                    : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String unit;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('$label ($unit)'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _WeeklyStat(
                  label: 'Calories\nConsumed',
                  value: summary.totalCaloriesConsumed.toString(),
                ),
                _WeeklyStat(
                  label: 'Calories\nBurned',
                  value: summary.totalCaloriesBurned.toString(),
                ),
                _WeeklyStat(
                  label: 'Workout\nDays',
                  value: summary.workoutDays.toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Activity Progress'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: summary.workoutDays / 7,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text('${summary.workoutDays}/7 days active'),
          ],
        ),
      ),
    );
  }
}

class _WeeklyStat extends StatelessWidget {
  final String label;
  final String value;

  const _WeeklyStat({
    required this.label,
    required this.value,
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
      ],
    );
  }
}

class _NutritionChart extends StatelessWidget {
  const _NutritionChart();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Nutrition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 200,
              child: PieChartSample(),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartSample extends StatelessWidget {
  const PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: const Color(0xFF4FC3F7),
            value: 35,
            title: '35%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFF69F0AE),
            value: 25,
            title: '25%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFFFFD740),
            value: 20,
            title: '20%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFFE040FB),
            value: 20,
            title: '20%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}