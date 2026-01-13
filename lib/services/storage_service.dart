import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/models/fitness_data.dart';

class StorageService {
  static const String _dailyLogsKey = 'daily_logs';
  static const String _foodHistoryKey = 'food_history';
  static const String _workoutHistoryKey = 'workout_history';

  Future<void> saveDailyLog(DailyLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await getDailyLogs();
    
    // Remove existing log for the same date if exists
    logs.removeWhere((element) => 
      element.date.year == log.date.year &&
      element.date.month == log.date.month &&
      element.date.day == log.date.day
    );
    
    logs.add(log);
    
    final jsonString = jsonEncode(
      logs.map((log) => log.toJson()).toList()
    );
    
    await prefs.setString(_dailyLogsKey, jsonString);
  }

  Future<List<DailyLog>> getDailyLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_dailyLogsKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => DailyLog.fromJson(json)).toList();
  }

  Future<void> saveFoodToHistory(FoodItem food) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getFoodHistory();
    
    // Remove if already exists
    history.removeWhere((element) => element.name == food.name);
    
    // Add to beginning of list
    history.insert(0, food);
    
    // Keep only last 20 items
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    final jsonString = jsonEncode(
      history.map((food) => food.toJson()).toList()
    );
    
    await prefs.setString(_foodHistoryKey, jsonString);
  }

  Future<List<FoodItem>> getFoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_foodHistoryKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => FoodItem.fromJson(json)).toList();
  }

  Future<void> saveWorkoutToHistory(Workout workout) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWorkoutHistory();
    
    // Remove if already exists
    history.removeWhere((element) => element.name == workout.name);
    
    // Add to beginning of list
    history.insert(0, workout);
    
    // Keep only last 20 items
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    final jsonString = jsonEncode(
      history.map((workout) => workout.toJson()).toList()
    );
    
    await prefs.setString(_workoutHistoryKey, jsonString);
  }

  Future<List<Workout>> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_workoutHistoryKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Workout.fromJson(json)).toList();
  }
}