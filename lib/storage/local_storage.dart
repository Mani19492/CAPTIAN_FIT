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

  static Future<void> saveWorkout(String workout) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('workouts') ?? [];
    list.add(workout);
    await prefs.setStringList('workouts', list);
  }
}
