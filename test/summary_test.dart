import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/services/summary_service.dart';

void main() {
  group('Summary Service Tests', () {
    test('Calculates daily summary correctly', () {
      final summary = SummaryService.calculateDailySummary();
      
      expect(summary, isNotNull);
      expect(summary.caloriesConsumed, greaterThan(0));
      expect(summary.caloriesBurned, greaterThan(0));
      expect(summary.workoutDuration, greaterThan(0));
    });

    test('Calculates weekly summary correctly', () {
      final summary = SummaryService.calculateWeeklySummary();
      
      expect(summary, isNotNull);
      expect(summary.totalCaloriesConsumed, greaterThan(0));
      expect(summary.totalCaloriesBurned, greaterThan(0));
      expect(summary.totalWorkoutDuration, greaterThan(0));
      expect(summary.workoutDays, greaterThan(0));
    });
  });
}