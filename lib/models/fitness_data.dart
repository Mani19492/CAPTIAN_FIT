class FitnessData {
  final List<Meal> meals;
  final List<Workout> workouts;
  final List<ChatMessage> chatMessages;

  FitnessData({
    required this.meals,
    required this.workouts,
    required this.chatMessages,
  });

  FitnessData copyWith({
    List<Meal>? meals,
    List<Workout>? workouts,
    List<ChatMessage>? chatMessages,
  }) {
    return FitnessData(
      meals: meals ?? this.meals,
      workouts: workouts ?? this.workouts,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }
}

class Meal {
  final String id;
  final String name;
  final int calories;
  final DateTime timestamp;
  final String clientId;

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
  final String clientId;

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