import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/services/sync_service.dart';

void main() {
  setUp(() async {
    // Ensure Flutter bindings are initialized for platform plugins (Connectivity, etc.)
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  test('attemptSync clears queue when Supabase not configured', () async {
    await SyncService.enqueue({'type': 'meal', 'payload': {'text': 'I ate samosa'}});
    final before = await SyncService.queuedCount();
    expect(before, greaterThan(0));
    final ok = await SyncService.attemptSync();
    expect(ok, isTrue);
    final after = await SyncService.queuedCount();
    expect(after, equals(0));
  });
}
