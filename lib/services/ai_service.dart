import 'dart:math';
import 'package:captain_fit/models/fitness_data.dart';

class AIService {
  static final List<String> _greetingResponses = [
    "Hello! I'm CaptainFit, your personal fitness assistant. How can I help you today?",
    "Hi there! Ready to get fit? Ask me about food suggestions or workout recommendations!",
    "Hey! I'm here to help you with your fitness journey. What would you like to know?",
  ];

  static final List<String> _foodSuggestionResponses = [
    "Here are some healthy options for you:",
    "I recommend these nutritious foods:",
    "Based on your goals, try these options:",
  ];

  static final List<String> _workoutSuggestionResponses = [
    "Here's a great workout for you:",
    "Try this effective routine:",
    "I recommend this exercise plan:",
  ];

  static final List<FoodItem> _commonFoods = [
    FoodItem(
      name: "Grilled Chicken Salad",
      calories: 350,
      protein: 35.0,
      carbs: 15.0,
      fat: 18.0,
      imageUrl: "assets/images/chicken_salad.png",
    ),
    FoodItem(
      name: "Protein Smoothie",
      calories: 250,
      protein: 25.0,
      carbs: 30.0,
      fat: 5.0,
      imageUrl: "assets/images/smoothie.png",
    ),
    FoodItem(
      name: "Quinoa Bowl",
      calories: 420,
      protein: 15.0,
      carbs: 60.0,
      fat: 12.0,
      imageUrl: "assets/images/quinoa_bowl.png",
    ),
    FoodItem(
      name: "Greek Yogurt with Berries",
      calories: 180,
      protein: 20.0,
      carbs: 20.0,
      fat: 2.0,
      imageUrl: "assets/images/yogurt.png",
    ),
    FoodItem(
      name: "Avocado Toast",
      calories: 300,
      protein: 10.0,
      carbs: 35.0,
      fat: 15.0,
      imageUrl: "assets/images/avocado_toast.png",
    ),
  ];

  static final List<Workout> _commonWorkouts = [
    Workout(
      name: "Push-ups",
      description: "A classic upper body exercise",
      gifUrl: "assets/gifs/pushups.gif",
      duration: 5,
      caloriesBurned: 70,
    ),
    Workout(
      name: "Squats",
      description: "Great for building leg strength",
      gifUrl: "assets/gifs/squats.gif",
      duration: 5,
      caloriesBurned: 60,
    ),
    Workout(
      name: "Plank",
      description: "Core strengthening exercise",
      gifUrl: "assets/gifs/plank.gif",
      duration: 3,
      caloriesBurned: 25,
    ),
    Workout(
      name: "Burpees",
      description: "Full body cardio exercise",
      gifUrl: "assets/gifs/burpees.gif",
      duration: 5,
      caloriesBurned: 100,
    ),
    Workout(
      name: "Mountain Climbers",
      description: "Cardio and core workout",
      gifUrl: "assets/gifs/mountain_climbers.gif",
      duration: 4,
      caloriesBurned: 80,
    ),
  ];

  String getGreeting() {
    return _greetingResponses[Random().nextInt(_greetingResponses.length)];
  }

  List<FoodItem> getSuggestedFoods(String query) {
    // In a real app, this would be more sophisticated
    // For now, we'll return a selection of foods
    return _commonFoods;
  }

  List<Workout> getSuggestedWorkouts(String query) {
    // In a real app, this would be more sophisticated
    // For now, we'll return a selection of workouts
    return _commonWorkouts;
  }

  String getFoodSuggestionResponse() {
    return _foodSuggestionResponses[Random().nextInt(_foodSuggestionResponses.length)];
  }

  String getWorkoutSuggestionResponse() {
    return _workoutSuggestionResponses[Random().nextInt(_workoutSuggestionResponses.length)];
  }

  String getConfirmationResponse(String action) {
    final responses = [
      "Got it! I've logged that for you.",
      "Done! I've added that to your records.",
      "Thanks for letting me know! I've saved that.",
      "Noted! I've recorded that in your log.",
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String getHelpResponse() {
    return "I can help you with:\n\n"
        "• Suggesting healthy foods to eat\n"
        "• Logging foods you've eaten\n"
        "• Recommending workouts\n"
        "• Tracking your exercises\n\n"
        "Just tell me what you'd like to do!";
  }
}