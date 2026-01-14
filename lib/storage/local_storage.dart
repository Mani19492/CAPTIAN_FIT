import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyMeals = 'captain_fit_meals';
  static const String _keyWorkouts = 'captain_fit_workouts';
  static const String _keyChatMessages = 'captain_fit_chat_messages';
  
  late SharedPreferences _prefs;

  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() => _instance;

  LocalStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Meals storage
  Future<void> saveMeals(List<Meal> meals) async {
    final mealsJson = jsonEncode(meals.map((meal) => meal.toJson()).toList());
    await _prefs.setString(_keyMeals, mealsJson);
  }

  Future<List<Meal>> getMeals() async {
    final mealsJson = _prefs.getString(_keyMeals);
    if (mealsJson == null) return [];
    
    final List<dynamic> mealsList = jsonDecode(mealsJson);
    return mealsList.map((meal) => Meal.fromJson(meal)).toList();
  }

  // Workouts storage
  Future<void> saveWorkouts(List<Workout> workouts) async {
    final workoutsJson = jsonEncode(
      workouts.map((workout) => workout.toJson()).toList(),
    );
    await _prefs.setString(_keyWorkouts, workoutsJson);
  }

  Future<List<Workout>> getWorkouts() async {
    final workoutsJson = _prefs.getString(_keyWorkouts);
    if (workoutsJson == null) return [];
    
    final List<dynamic> workoutsList = jsonDecode(workoutsJson);
    return workoutsList.map((workout) => Workout.fromJson(workout)).toList();
  }

  // Chat messages storage
  Future<void> saveChatMessages(List<ChatMessage> messages) async {
    final messagesJson = jsonEncode(
      messages.map((message) => message.toJson()).toList(),
    );
    await _prefs.setString(_keyChatMessages, messagesJson);
  }

  Future<List<ChatMessage>> getChatMessages() async {
    final messagesJson = _prefs.getString(_keyChatMessages);
    if (messagesJson == null) return [];
    
    final List<dynamic> messagesList = jsonDecode(messagesJson);
    return messagesList
        .map((message) => ChatMessage.fromJson(message))
        .toList();
  }
}

// Data models
class Meal {
  final String id;
  final String name;
  final int calories;
  final DateTime timestamp;
  final String clientId; // For sync purposes

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.timestamp,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
      'client_id': clientId,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
      timestamp: DateTime.parse(json['timestamp']),
      clientId: json['client_id'],
    );
  }
}

class Workout {
  final String id;
  final String name;
  final int duration; // in minutes
  final int calories;
  final DateTime timestamp;
  final String clientId; // For sync purposes

  Workout({
    required this.id,
    required this.name,
    required this.duration,
    required this.calories,
    required this.timestamp,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
      'client_id': clientId,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      calories: json['calories'],
      timestamp: DateTime.parse(json['timestamp']),
      clientId: json['client_id'],
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      isUser: json['is_user'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}