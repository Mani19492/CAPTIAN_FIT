import 'dart:math';
import 'package:captain_fit/storage/local_storage.dart';
import 'package:captain_fit/services/ai_assistant.dart';

class DailySummary {
  final DateTime date;
  final int mealsLogged;
  final int workoutsLogged;
  final int caloriesIn;
  final int caloriesOut;
  final String status;

  DailySummary({
    required this.date,
    required this.mealsLogged,
    required this.workoutsLogged,
    required this.caloriesIn,
    required this.caloriesOut,
    required this.status,
  });
}

class SummaryService {
  /// Very simple estimator: tries to extract known foods and estimate
  /// calories using heuristics; unknown items default to 200 kcal.
  static int _estimateCaloriesForMealText(String text) {
    final lower = text.toLowerCase();

    if (AIAssistant.detectFood(text) != null) {
      final foodKey = AIAssistant.detectFood(text)!;
      // Heuristic mapping
      final Map<String, int> heur = {
        'eggs': 78, // per egg (we'll try to detect counts though)
        'chicken': 350,
        'salmon': 280,
        'greek yogurt': 180,
        'banana': 100,
        'roti': 75,
        'samosa': 200,
        'rice': 220,
      };

      final base = heur[foodKey] ?? 200;

      // Look for multiplicative counts like '2 eggs' or 'x2' etc.
      final qtyMatch = RegExp(r"(\d+)\s*(eggs|egg|roti|x|pieces|pcs)").firstMatch(lower);
      if (qtyMatch != null) {
        final qty = int.tryParse(qtyMatch.group(1) ?? '') ?? 1;
        return (base * max(qty, 1)).toInt();
      }

      // fallback single portion
      return base;
    }

    // If not detected, try to guess by numbers or keywords
    if (lower.contains('samosa')) return 200;
    if (lower.contains('treadmill') || lower.contains('min')) return 0; // not a food

    // default
    return 200;
  }

  static Future<DailySummary> dailySummary(DateTime day) async {
    final meals = await LocalStorage.getParsedMeals();
    final workoutsRaw = await LocalStorage.getWorkouts();

    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    var caloriesIn = 0;
    var mealsLogged = 0;

    for (final m in meals) {
      try {
        final time = DateTime.parse(m['time'] ?? '');
        if (time.isAfter(dayStart) && time.isBefore(dayEnd)) {
          mealsLogged += 1;
          caloriesIn += _estimateCaloriesForMealText(m['text'] as String);
        }
      } catch (_) {
        continue;
      }
    }

    var caloriesOut = 0;
    var workoutsLogged = 0;
    for (final _ in workoutsRaw) {
      try {
        // For MVP: we don't rely on workout payload structure for the burn estimate
        workoutsLogged += 1;
        caloriesOut += 200;
      } catch (_) {
        continue;
      }
    }

    final net = caloriesIn - caloriesOut;
    final status = net <= 0 ? 'Fat loss supported' : 'Over maintenance';

    return DailySummary(
      date: day,
      mealsLogged: mealsLogged,
      workoutsLogged: workoutsLogged,
      caloriesIn: caloriesIn,
      caloriesOut: caloriesOut,
      status: status,
    );
  }
}