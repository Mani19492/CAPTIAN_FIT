import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/storage/local_db.dart';

void main() {
  group('Local Database Tests', () {
    late LocalDatabase localDb;

    setUp(() {
      localDb = LocalDatabase();
    });

    test('Database initializes correctly', () async {
      final db = await localDb.database;
      expect(db, isNotNull);
    });

    test('Can insert and retrieve meals', () async {
      final meal = {
        'id': 'test_meal_1',
        'client_id': 'client_test_1',
        'name': 'Test Meal',
        'calories': 300,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final id = await localDb.insertMeal(meal);
      expect(id, greaterThan(0));

      final meals = await localDb.getMeals();
      expect(meals, isNotEmpty);
    });

    test('Can insert and retrieve workouts', () async {
      final workout = {
        'id': 'test_workout_1',
        'client_id': 'client_test_2',
        'name': 'Test Workout',
        'duration': 30,
        'calories': 250,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final id = await localDb.insertWorkout(workout);
      expect(id, greaterThan(0));

      final workouts = await localDb.getWorkouts();
      expect(workouts, isNotEmpty);
    });
  });
}