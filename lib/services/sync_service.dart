import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/storage/local_storage.dart' as app_local;
import 'package:captain_fit/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/// Simple sync service that maintains a queue in SharedPreferences and,
/// when online, attempts to push items to a remote (Supabase) if configured.
/// For an MVP we mark items as synced locally and log progress.
class SyncService {
  static const _queueKey = 'sync_queue';

  static Future<void> enqueue(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_queueKey) ?? [];
    // Ensure each queued item has a client_id and queued_at timestamp
    final payload = Map<String, dynamic>.from(item);
    payload['queued_at'] = DateTime.now().toIso8601String();
    payload['client_id'] = payload['payload'] != null && payload['payload']['client_id'] != null
        ? payload['payload']['client_id']
        : ('q_${DateTime.now().millisecondsSinceEpoch}');
    list.add(jsonEncode(payload));
    await prefs.setStringList(_queueKey, list);
  }

  /// Returns the current number of items in the queue (useful for tests)
  static Future<int> queuedCount() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_queueKey) ?? [];
    return list.length;
  }

  static Future<List<Map<String, dynamic>>> _getQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_queueKey) ?? [];
    return list.map((s) {
      try {
        return Map<String, dynamic>.from(jsonDecode(s));
      } catch (_) {
        return {'raw': s};
      }
    }).toList();
  }

  static Future<void> _clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }

  /// Attempts to sync queued items with the remote Supabase instance.
  /// Returns true if sync was performed (queue cleared or remote writes attempted).
  static Future<bool> attemptSync() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return false;

    final queue = await _getQueue();
    if (queue.isEmpty) return false;

    // Initialize Supabase if available
    await AuthService.initSupabase();

    try {
      if (AuthService.supabaseInitialized) {
        final client = Supabase.instance.client;
        for (final item in queue) {
          final type = item['type'] as String? ?? '';
          final payload = (item['payload'] as Map<String, dynamic>?) ?? {};

          try {
            if (type == 'meal') {
              final clientId = payload['client_id'] as String?;
              if (clientId != null) {
                final existing = await client.from('meals').select('id').eq('client_id', clientId).maybeSingle();
                if (existing != null) {
                  await client.from('meals').update({
                    'text': payload['text'],
                    'time': payload['time'],
                    'detected_food': payload['detectedFood'],
                  }).eq('client_id', clientId);
                } else {
                  await client.from('meals').insert({
                    'text': payload['text'],
                    'time': payload['time'],
                    'detected_food': payload['detectedFood'],
                    'client_id': clientId,
                  });
                }
              } else {
                await client.from('meals').insert({
                  'text': payload['text'],
                  'time': payload['time'],
                  'detected_food': payload['detectedFood'],
                });
              }
            } else if (type == 'workout') {
              final clientId = payload['client_id'] as String?;
              if (clientId != null) {
                final existing = await client.from('workouts').select('id').eq('client_id', clientId).maybeSingle();
                if (existing != null) {
                  await client.from('workouts').update({
                    'name': payload['name'],
                    'time': payload['time'],
                    'detected_exercise': payload['detectedExercise'],
                  }).eq('client_id', clientId);
                } else {
                  await client.from('workouts').insert({
                    'name': payload['name'],
                    'time': payload['time'],
                    'detected_exercise': payload['detectedExercise'],
                    'client_id': clientId,
                  });
                }
              } else {
                await client.from('workouts').insert({
                  'name': payload['name'],
                  'time': payload['time'],
                  'detected_exercise': payload['detectedExercise'],
                });
              }
            } else {
              // Unknown type, skip
              continue;
            }
          } catch (e) {
            // Stop on first remote write failure
            return false;
          }
        }

        await _clearQueue();
        return true;
      } else {
        // Supabase not configured: simulate success by clearing queue
        await _clearQueue();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  /// Helper to watch connectivity and attempt sync when online.
  static void startAutoSync() {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await attemptSync();
      }
    });
  }

  /// Bootstrap helper: enqueue any recent local items that need syncing.
  static Future<void> bootstrapFromLocal() async {
    // Read local meals and workouts and enqueue any items (simple check)
    final meals = await app_local.LocalStorage.getParsedMeals();
    final workouts = await app_local.LocalStorage.getWorkouts();

    for (final m in meals) {
      await enqueue({
        'type': 'meal',
        'payload': {
          'text': m['text'],
          'time': m['time'],
          'detectedFood': m['detectedFood']
        }
      });
    }
    for (final w in workouts) {
      final name = w.toString();
      await enqueue({'type': 'workout', 'payload': {'name': name, 'time': DateTime.now().toIso8601String()}});
    }
  }
}