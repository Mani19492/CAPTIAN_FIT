import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/services/sync_service.dart';

void main() {
  group('Sync Service Tests', () {
    late SyncService syncService;

    setUp(() {
      syncService = SyncService();
    });

    test('Can get queued count', () async {
      final count = await syncService.queuedCount();
      expect(count, 0);
    });

    test('Can enqueue items', () async {
      final item = SyncItem(
        type: 'meal',
        data: {'name': 'Test Meal'},
        timestamp: DateTime.now(),
      );
      
      await syncService.enqueue(item);
      // If no exception is thrown, the test passes
      expect(true, true);
    });
  });
}