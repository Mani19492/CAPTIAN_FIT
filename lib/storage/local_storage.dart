import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveMeal(String text, {String? detectedFood}) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('meals') ?? [];
    list.add(jsonEncode({
      'text': text,
      'time': DateTime.now().toIso8601String(),
      'detectedFood': detectedFood,
    }));
    await prefs.setStringList('meals', list);
  }

  static Future<List<String>> getMeals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('meals') ?? [];
  }

  /// Returns parsed meal objects as maps with `text`, `time`, and `detectedFood` keys.
  static Future<List<Map<String, dynamic>>> getParsedMeals() async {
    final list = await getMeals();
    return list.map((s) {
      try {
        final decoded = jsonDecode(s) as Map<String, dynamic>;
        return decoded;
      } catch (_) {
        return {'text': s, 'time': '', 'detectedFood': null};
      }
    }).toList();
  }

  static Future<List<String>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('workouts') ?? [];
  }

  static Future<void> saveWorkout(String workout, {String? detectedExercise}) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('workouts') ?? [];
    list.add(jsonEncode({
      'name': workout,
      'time': DateTime.now().toIso8601String(),
      'detectedExercise': detectedExercise,
    }));
    await prefs.setStringList('workouts', list);
  }

  static Future<void> saveMessage(String text, String sender, {String? type}) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('chat_messages') ?? [];
    list.add(jsonEncode({
      'text': text,
      'sender': sender,
      'time': DateTime.now().toIso8601String(),
      'type': type,
    }));
    await prefs.setStringList('chat_messages', list);
  }

  static Future<List<Map<String, dynamic>>> getChatMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('chat_messages') ?? [];
    return list.map((s) {
      try {
        return jsonDecode(s) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    }).toList();
  }
}
