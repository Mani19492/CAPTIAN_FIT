import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/storage/local_storage.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'meals': [
        '{"text":"I ate 1 eggs","time":"2020-01-01T00:00:00.000","detectedFood":"eggs"}'
      ]
    });
  });

  test('migrates SharedPreferences meals into Drift DB', () async {
    await LocalStorage.init();
    final meals = await LocalStorage.getParsedMeals();
    expect(meals.length, 1);
    expect(meals.first['detectedFood'], 'eggs');
  });
}
