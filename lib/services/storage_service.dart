import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyMeals = 'meals';
  static const String _keyWorkouts = 'workouts';
  static const String _keyChatMessages = 'chat_messages';
  static const String _keyUserPreferences = 'user_preferences';

  late SharedPreferences _prefs;

  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic methods for storing and retrieving data
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Specific methods for app data
  Future<bool> saveMeals(String mealsJson) async {
    return await saveString(_keyMeals, mealsJson);
  }

  String? getMeals() {
    return getString(_keyMeals);
  }

  Future<bool> saveWorkouts(String workoutsJson) async {
    return await saveString(_keyWorkouts, workoutsJson);
  }

  String? getWorkouts() {
    return getString(_keyWorkouts);
  }

  Future<bool> saveChatMessages(String messagesJson) async {
    return await saveString(_keyChatMessages, messagesJson);
  }

  String? getChatMessages() {
    return getString(_keyChatMessages);
  }

  Future<bool> saveUserPreferences(String preferencesJson) async {
    return await saveString(_keyUserPreferences, preferencesJson);
  }

  String? getUserPreferences() {
    return getString(_keyUserPreferences);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
  
  // Add missing method
  Future<List<String>> getDailyLogs() async {
    // This is a placeholder implementation
    // In a real app, this would retrieve daily logs from storage
    return [];
  }
}