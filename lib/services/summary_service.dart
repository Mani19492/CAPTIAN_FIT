class SummaryService {
  // Mock data for demonstration
  static const List<MockMeal> mockMeals = [
    MockMeal(name: 'Oatmeal with berries', calories: 350),
    MockMeal(name: 'Grilled chicken salad', calories: 420),
    MockMeal(name: 'Protein shake', calories: 180),
  ];

  static const List<MockWorkout> mockWorkouts = [
    MockWorkout(name: 'Morning run', duration: 30, calories: 320),
    MockWorkout(name: 'Strength training', duration: 45, calories: 280),
  ];

  // Calculate daily summary
  static DailySummary calculateDailySummary() {
    final totalCaloriesConsumed = mockMeals.fold(
      0, 
      (sum, meal) => sum + meal.calories,
    );
    
    final totalCaloriesBurned = mockWorkouts.fold(
      0, 
      (sum, workout) => sum + workout.calories,
    );
    
    final totalWorkoutDuration = mockWorkouts.fold(
      0, 
      (sum, workout) => sum + workout.duration,
    );
    
    return DailySummary(
      date: DateTime.now(),
      caloriesConsumed: totalCaloriesConsumed,
      caloriesBurned: totalCaloriesBurned,
      workoutDuration: totalWorkoutDuration,
      meals: mockMeals,
      workouts: mockWorkouts,
    );
  }
  
  // Get weekly summary
  static WeeklySummary calculateWeeklySummary() {
    // For simplicity, we'll return mock data
    // In a real app, this would aggregate data from the past 7 days
    
    return WeeklySummary(
      startDate: DateTime.now().subtract(const Duration(days: 6)),
      endDate: DateTime.now(),
      totalCaloriesConsumed: 8750,
      totalCaloriesBurned: 3200,
      totalWorkoutDuration: 210,
      workoutDays: 5,
      bestDay: DateTime.now().subtract(const Duration(days: 2)),
    );
  }
}

class DailySummary {
  final DateTime date;
  final int caloriesConsumed;
  final int caloriesBurned;
  final int workoutDuration;
  final List<MockMeal> meals;
  final List<MockWorkout> workouts;

  DailySummary({
    required this.date,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.workoutDuration,
    required this.meals,
    required this.workouts,
  });

  int get netCalories => caloriesConsumed - caloriesBurned;
}

class WeeklySummary {
  final DateTime startDate;
  final DateTime endDate;
  final int totalCaloriesConsumed;
  final int totalCaloriesBurned;
  final int totalWorkoutDuration;
  final int workoutDays;
  final DateTime bestDay;

  WeeklySummary({
    required this.startDate,
    required this.endDate,
    required this.totalCaloriesConsumed,
    required this.totalCaloriesBurned,
    required this.totalWorkoutDuration,
    required this.workoutDays,
    required this.bestDay,
  });
}

class MockMeal {
  final String name;
  final int calories;

  const MockMeal({required this.name, required this.calories});
}

class MockWorkout {
  final String name;
  final int duration; // in minutes
  final int calories;

  const MockWorkout({
    required this.name, 
    required this.duration, 
    required this.calories,
  });
}