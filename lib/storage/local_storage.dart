import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveMeal(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('meals') ?? [];
    list.add(jsonEncode({
      'text': text,
      'time': DateTime.now().toIso8601String(),
    }));
    await prefs.setStringList('meals', list);
  }

  static Future<List<String>> getMeals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('meals') ?? [];
  }

  /// Returns parsed meal objects as maps with `text` and `time` keys.
  static Future<List<Map<String, dynamic>>> getParsedMeals() async {
    final list = await getMeals();
    return list.map((s) {
      try {
        final decoded = jsonDecode(s) as Map<String, dynamic>;
        return decoded;
      } catch (_) {
        // For backwards compatibility, treat plain strings as text only
        return {'text': s, 'time': ''};
      }
    }).toList();
  }

  static Future<List<String>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('workouts') ?? [];
  }

  static Future<void> saveWorkout(String workout) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('workouts') ?? [];
    list.add(workout);
    await prefs.setStringList('workouts', list);
  }
}
