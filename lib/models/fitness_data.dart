class FoodItem {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}

class Workout {
  final String name;
  final String description;
  final String gifUrl;
  final int duration; // in minutes
  final int caloriesBurned;

  Workout({
    required this.name,
    required this.description,
    required this.gifUrl,
    required this.duration,
    required this.caloriesBurned,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'gifUrl': gifUrl,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'],
      description: json['description'],
      gifUrl: json['gifUrl'],
      duration: json['duration'],
      caloriesBurned: json['caloriesBurned'],
    );
  }
}

class DailyLog {
  final DateTime date;
  final List<FoodItem> foods;
  final List<Workout> workouts;

  DailyLog({
    required this.date,
    required this.foods,
    required this.workouts,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'foods': foods.map((food) => food.toJson()).toList(),
      'workouts': workouts.map((workout) => workout.toJson()).toList(),
    };
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      date: DateTime.parse(json['date']),
      foods: (json['foods'] as List)
          .map((food) => FoodItem.fromJson(food))
          .toList(),
      workouts: (json['workouts'] as List)
          .map((workout) => Workout.fromJson(workout))
          .toList(),
    );
  }
}