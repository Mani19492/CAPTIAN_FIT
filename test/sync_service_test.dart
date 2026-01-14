import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/services/sync_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('enqueue increases queue count', () async {
    final before = await SyncService.queuedCount();
    await SyncService.enqueue({'type': 'meal', 'payload': {'text': 'I ate samosa'}});
    final after = await SyncService.queuedCount();
    expect(after, before + 1);
  });
}
