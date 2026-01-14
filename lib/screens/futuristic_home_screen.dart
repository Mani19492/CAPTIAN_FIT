import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:captain_fit/models/fitness_data.dart';
import 'package:captain_fit/services/storage_service.dart';
import 'package:captain_fit/theme/futuristic_theme.dart';

class FuturisticHomeScreen extends StatefulWidget {
  const FuturisticHomeScreen({super.key});

  @override
  State<FuturisticHomeScreen> createState() => _FuturisticHomeScreenState();
}

class _FuturisticHomeScreenState extends State<FuturisticHomeScreen>
    with TickerProviderStateMixin {
  final StorageService _storageService = StorageService();
  List<DailyLog> _dailyLogs = [];
  int _totalCalories = 0;
  int _totalBurned = 0;

  final double _calorieTarget = 2500;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _loadData();
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final logs = await _storageService.getDailyLogs();
    setState(() {
      _dailyLogs = logs;
      final today = DateTime.now();
      final todayLog = logs.firstWhere(
        (log) =>
            log.date.year == today.year &&
            log.date.month == today.month &&
            log.date.day == today.day,
        orElse: () => DailyLog(date: today, foods: [], workouts: []),
      );

      _totalCalories = todayLog.foods.fold(0, (sum, food) => sum + food.calories);
      _totalBurned = todayLog.workouts.fold(0, (sum, w) => sum + w.caloriesBurned);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              width: 32,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to the previously committed asset if the new logo isn't available
                return Image.asset(
                  'assets/images/image-removebg-preview_(2).png',
                  height: 32,
                  width: 32,
                  errorBuilder: (context, e, s) => const Icon(Icons.flash_on, color: FuturisticTheme.primaryRed),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text('CAPTAIN FIT'),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: FuturisticTheme.primaryRed),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMainStats(),
              const SizedBox(height: 24),
              _buildCalorieChart(),
              const SizedBox(height: 24),
              _buildWeeklyProgressChart(),
              const SizedBox(height: 24),
              _buildMacroDistribution(),
              const SizedBox(height: 24),
              _buildWorkoutBurnChart(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Performance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: FuturisticTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateTime.now().toString().split(' ')[0],
            style: const TextStyle(
              fontSize: 14,
              color: FuturisticTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats() {
    final remaining = (_calorieTarget - _totalCalories).clamp(0, _calorieTarget);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(_slideController),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Intake',
              value: '$_totalCalories',
              unit: 'kcal',
              icon: Icons.restaurant,
              color: FuturisticTheme.warningOrange,
              backgroundColor: FuturisticTheme.warningOrange.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'Burned',
              value: '$_totalBurned',
              unit: 'kcal',
              icon: Icons.local_fire_department,
              color: FuturisticTheme.primaryRed,
              backgroundColor: FuturisticTheme.primaryRed.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'Remaining',
              value: '${remaining.toInt()}',
              unit: 'kcal',
              icon: Icons.trending_down,
              color: FuturisticTheme.successGreen,
              backgroundColor: FuturisticTheme.successGreen.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FuturisticTheme.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuturisticTheme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: FuturisticTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 11,
              color: FuturisticTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieChart() {
    final intake = _totalCalories.toDouble();
    final target = _calorieTarget;
    final percentage = (intake / target * 100).clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FuturisticTheme.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuturisticTheme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Calorie Goal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FuturisticTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: intake,
                        title: '${percentage.toInt()}%',
                        color: FuturisticTheme.primaryRed,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: (target - intake).clamp(0.0, target),
                        title: '',
                        color: FuturisticTheme.darkCardBg2,
                        radius: 60,
                      ),
                    ],
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$_totalCalories',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FuturisticTheme.primaryRed,
                    ),
                  ),
                  Text(
                    '/ ${_calorieTarget.toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: FuturisticTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Consumed', FuturisticTheme.primaryRed),
              _buildLegendItem('Remaining', FuturisticTheme.darkCardBg2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: FuturisticTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FuturisticTheme.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuturisticTheme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Intake Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FuturisticTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: FuturisticTheme.borderColor,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: FuturisticTheme.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(
                          days[value.toInt() % 7],
                          style: const TextStyle(
                            color: FuturisticTheme.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 2200),
                      const FlSpot(1, 2400),
                      const FlSpot(2, 2100),
                      const FlSpot(3, 2600),
                      const FlSpot(4, 2300),
                      const FlSpot(5, 2500),
                      FlSpot(6, _totalCalories.toDouble()),
                    ],
                    isCurved: true,
                    color: FuturisticTheme.primaryRed,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: FuturisticTheme.primaryRed.withOpacity(0.2),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 6,
                minY: 1500,
                maxY: 3000,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroDistribution() {
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    final today = DateTime.now();
    final todayLog = _dailyLogs.firstWhere(
      (log) =>
          log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day,
      orElse: () => DailyLog(date: today, foods: [], workouts: []),
    );

    for (final food in todayLog.foods) {
      totalProtein += food.protein;
      totalCarbs += food.carbs;
      totalFat += food.fat;
    }

    final total = totalProtein + totalCarbs + totalFat;
    final proteinPercent = total > 0 ? totalProtein / total * 100 : 0.0;
    final carbsPercent = total > 0 ? totalCarbs / total * 100 : 0.0;
    final fatPercent = total > 0 ? totalFat / total * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FuturisticTheme.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuturisticTheme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macro Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FuturisticTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: proteinPercent,
                    title: '${proteinPercent.toInt()}%\nProtein',
                    color: const Color(0xFF00D97E),
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 50,
                  ),
                  PieChartSectionData(
                    value: carbsPercent,
                    title: '${carbsPercent.toInt()}%\nCarbs',
                    color: FuturisticTheme.accentCyan,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 50,
                  ),
                  PieChartSectionData(
                    value: fatPercent,
                    title: '${fatPercent.toInt()}%\nFat',
                    color: FuturisticTheme.warningOrange,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 50,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroStat('Protein', '${totalProtein.toInt()}g', const Color(0xFF00D97E)),
              _buildMacroStat('Carbs', '${totalCarbs.toInt()}g', FuturisticTheme.accentCyan),
              _buildMacroStat('Fat', '${totalFat.toInt()}g', FuturisticTheme.warningOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: FuturisticTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutBurnChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FuturisticTheme.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuturisticTheme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workout Intensity (7 Days)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FuturisticTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 350, color: FuturisticTheme.primaryRed, width: 12),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 280, color: FuturisticTheme.accentCyan, width: 12),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 420, color: FuturisticTheme.successGreen, width: 12),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 310, color: FuturisticTheme.primaryRed, width: 12),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(toY: 290, color: FuturisticTheme.accentCyan, width: 12),
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(toY: 380, color: FuturisticTheme.successGreen, width: 12),
                  ]),
                  BarChartGroupData(x: 6, barRods: [
                    BarChartRodData(toY: _totalBurned.toDouble(), color: FuturisticTheme.warningOrange, width: 12),
                  ]),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: FuturisticTheme.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            color: FuturisticTheme.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: FuturisticTheme.borderColor,
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Total Burned This Week: ${_totalBurned * 7} kcal',
              style: const TextStyle(
                fontSize: 12,
                color: FuturisticTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
