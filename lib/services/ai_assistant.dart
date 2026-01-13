import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FoodSuggestion {
  final String name;
  final String description;
  final String emoji;

  FoodSuggestion({
    required this.name,
    required this.description,
    required this.emoji,
  });
}

class ExerciseSuggestion {
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String difficulty;

  ExerciseSuggestion({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.difficulty,
  });
}

class AIAssistant {
  static const List<String> foodKeywords = [
    'ate', 'eating', 'had', 'consumed', 'breakfast', 'lunch', 'dinner',
    'snack', 'meal', 'food', 'juice', 'coffee', 'tea', 'drink'
  ];

  static const List<String> exerciseKeywords = [
    'did', 'did', 'completed', 'finished', 'exercised', 'workout',
    'trained', 'ran', 'lifted', 'squats', 'pushups', 'gym', 'exercise'
  ];

  static const Map<String, FoodSuggestion> foodDatabase = {
    'chicken': FoodSuggestion(
      name: 'Grilled Chicken Breast',
      description: 'Lean protein, rich in nutrients. Perfect for muscle building.',
      emoji: '🍗',
    ),
    'eggs': FoodSuggestion(
      name: 'Eggs',
      description: 'Complete protein source with healthy fats. Great for any meal.',
      emoji: '🥚',
    ),
    'salmon': FoodSuggestion(
      name: 'Salmon',
      description: 'Rich in omega-3 fatty acids. Excellent for heart and brain health.',
      emoji: '🐟',
    ),
    'greek yogurt': FoodSuggestion(
      name: 'Greek Yogurt',
      description: 'High protein, probiotics. Great as snack or with fruits.',
      emoji: '🥛',
    ),
    'broccoli': FoodSuggestion(
      name: 'Broccoli',
      description: 'Fiber-rich vegetable. Full of vitamins and minerals.',
      emoji: '🥦',
    ),
    'banana': FoodSuggestion(
      name: 'Banana',
      description: 'Great carbs and potassium. Perfect pre or post-workout.',
      emoji: '🍌',
    ),
    'brown rice': FoodSuggestion(
      name: 'Brown Rice',
      description: 'Complex carbs for sustained energy. Fiber-rich.',
      emoji: '🍚',
    ),
    'almonds': FoodSuggestion(
      name: 'Almonds',
      description: 'Healthy fats and protein. Perfect protein-rich snack.',
      emoji: '🌰',
    ),
  };

  static const Map<String, ExerciseSuggestion> exerciseDatabase = {
    'pushups': ExerciseSuggestion(
      name: 'Push-ups',
      description: 'Great for chest, shoulders, and triceps. No equipment needed.',
      imageUrl: 'https://img.icons8.com/color/96/000000/exercise.png',
      category: 'Chest',
      difficulty: 'Beginner',
    ),
    'squats': ExerciseSuggestion(
      name: 'Squats',
      description: 'Strengthens legs and glutes. Bodyweight exercise.',
      imageUrl: 'https://img.icons8.com/color/96/000000/exercise.png',
      category: 'Legs',
      difficulty: 'Beginner',
    ),
    'plank': ExerciseSuggestion(
      name: 'Plank',
      description: 'Core strengthening exercise. Build endurance over time.',
      imageUrl: 'https://img.icons8.com/color/96/000000/exercise.png',
      category: 'Core',
      difficulty: 'Intermediate',
    ),
    'running': ExerciseSuggestion(
      name: 'Running',
      description: 'Cardio exercise. Great for heart health and endurance.',
      imageUrl: 'https://img.icons8.com/color/96/000000/exercise.png',
      category: 'Cardio',
      difficulty: 'Beginner',
    ),
    'dumbbell bench press': ExerciseSuggestion(
      name: 'Dumbbell Bench Press',
      description: 'Chest and triceps. Requires dumbbells.',
      imageUrl: 'https://img.icons8.com/color/96/000000/exercise.png',
      category: 'Chest',
      difficulty: 'Intermediate',
    ),
    'deadlifts': ExerciseSuggestion(
      name: 'Deadlifts',
      description: 'Full body workout. One of the best compound movements.',
      imageUrl: 'https://img.icons8.com/color/96/000000/exercise.png',
      category: 'Back',
      difficulty: 'Advanced',
    ),
  };

  static String? detectFood(String message) {
    final lowerMessage = message.toLowerCase();
    for (final food in foodDatabase.keys) {
      if (lowerMessage.contains(food)) {
        return food;
      }
    }
    return null;
  }

  static String? detectExercise(String message) {
    final lowerMessage = message.toLowerCase();
    for (final exercise in exerciseDatabase.keys) {
      if (lowerMessage.contains(exercise)) {
        return exercise;
      }
    }
    return null;
  }

  static bool isFoodLog(String message) {
    final lowerMessage = message.toLowerCase();
    final hasFoodKeyword = foodKeywords.any((kw) => lowerMessage.contains(kw));
    final hasFood = detectFood(message) != null;
    return hasFoodKeyword && hasFood;
  }

  static bool isExerciseLog(String message) {
    final lowerMessage = message.toLowerCase();
    final hasExerciseKeyword = exerciseKeywords.any((kw) => lowerMessage.contains(kw));
    final hasExercise = detectExercise(message) != null;
    return hasExerciseKeyword && hasExercise;
  }

  static List<FoodSuggestion> getFoodSuggestions(String query) {
    final lowerQuery = query.toLowerCase();
    return foodDatabase.values
        .where((food) =>
            food.name.toLowerCase().contains(lowerQuery) ||
            food.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static List<ExerciseSuggestion> getExerciseSuggestions(String query) {
    final lowerQuery = query.toLowerCase();
    return exerciseDatabase.values
        .where((exercise) =>
            exercise.name.toLowerCase().contains(lowerQuery) ||
            exercise.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static String generateAIResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('suggest') && lowerMessage.contains('food')) {
      return '🍽️ I can suggest some nutritious options! Would you like suggestions for:';
    }

    if (lowerMessage.contains('suggest') && lowerMessage.contains('exercise')) {
      return '💪 Great! Here are some workout suggestions:';
    }

    if (lowerMessage.contains('how many')) {
      return '📊 Let me help you track that!';
    }

    if (lowerMessage.contains('help')) {
      return '👋 I can help you with:\n• Food suggestions\n• Exercise recommendations\n• Logging meals and workouts\n• Tracking your progress';
    }

    final detectedFood = detectFood(message);
    if (isFoodLog(message) && detectedFood != null) {
      final food = foodDatabase[detectedFood];
      return '✅ Logged: ${food?.emoji} ${food?.name}\n\n💡 ${food?.description}';
    }

    final detectedExercise = detectExercise(message);
    if (isExerciseLog(message) && detectedExercise != null) {
      final exercise = exerciseDatabase[detectedExercise];
      return '✅ Logged: 💪 ${exercise?.name}\n\n📝 ${exercise?.description}';
    }

    return '💬 That sounds great! Would you like to:\n• Log a meal\n• Log a workout\n• Get suggestions\n• View progress';
  }
}
