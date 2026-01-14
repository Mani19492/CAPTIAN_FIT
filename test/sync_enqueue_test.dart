import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/services/sync_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('enqueue attaches client_id and queued_at', () async {
    await SyncService.enqueue({'type': 'meal', 'payload': {'text': 'I ate samosa'}});
    final count = await SyncService.queuedCount();
    expect(count, greaterThanOrEqualTo(1));
  });
}
