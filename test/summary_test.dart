import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/storage/local_storage.dart';
import 'package:captain_fit/services/summary_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('daily summary calculates calories from meals', () async {
    await LocalStorage.saveMeal('I ate 2 eggs and 1 roti');
    await LocalStorage.saveMeal('I ate samosa');

    final summary = await SummaryService.dailySummary(DateTime.now());
    expect(summary.mealsLogged, 2);
    expect(summary.caloriesIn > 250, true);
  });
}
