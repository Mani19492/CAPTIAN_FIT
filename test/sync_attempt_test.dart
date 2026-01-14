import 'package:flutter_test/flutter_test.dart';
import 'package:captain_fit/services/sync_service.dart';

void main() {
  group('Sync Attempt Tests', () {
    late SyncService syncService;

    setUp(() {
      syncService = SyncService();
    });

    test('Can attempt sync', () async {
      await syncService.enqueue(SyncItem(
        type: 'meal',
        data: {'name': 'Test Meal'},
        timestamp: DateTime.now(),
      ));
      
      final countBefore = await syncService.queuedCount();
      expect(countBefore, 0);
      
      await syncService.attemptSync();
      
      final countAfter = await syncService.queuedCount();
      expect(countAfter, 0);
    });
  });
}