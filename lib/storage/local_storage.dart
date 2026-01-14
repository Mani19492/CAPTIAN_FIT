import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:captain_fit/storage/local_db.dart';
import 'package:captain_fit/services/sync_service.dart';

/// Backwards-compatible LocalStorage facade. Uses Drift `LocalDb` when
/// available; falls back to SharedPreferences for bootstrapping/migration.
class LocalStorage {
  static LocalDb? _db;

  static Future<void> init() async {
    if (_db != null) return;
    try {
      final db = LocalDb();
      await db.connect();
      _db = db;
      // Migrate any existing SharedPreferences data into DB
      await _migratePrefsToDb();
    } catch (_) {
      // If sqflite isn't available on the current platform, we'll fall back
      // to SharedPreferences-only behavior.
    }
  }

  static String _generateClientId() {
    // Simple RFC4122 v4-like id using DateTime+random for offline uniqueness
    final rand = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    return 'c_${rand}_${(DateTime.now().microsecondsSinceEpoch % 100000).toString()}';
  }

  static Future<void> _migratePrefsToDb() async {
    final prefs = await SharedPreferences.getInstance();
    final meals = prefs.getStringList('meals') ?? [];
    for (final m in meals) {
      try {
        final decoded = jsonDecode(m);
        if (decoded is Map<String, dynamic>) {
          await _db?.insertMeal(decoded['text'] ?? m, decoded['time'] ?? DateTime.now().toIso8601String(), detectedFood: decoded['detectedFood']);
        }
      } catch (_) {}
    }

    final workouts = prefs.getStringList('workouts') ?? [];
    for (final w in workouts) {
      try {
        final decoded = jsonDecode(w);
        if (decoded is Map<String, dynamic>) {
          await _db?.insertWorkout(decoded['name'] ?? w, decoded['time'] ?? DateTime.now().toIso8601String(), detectedExercise: decoded['detectedExercise']);
        }
      } catch (_) {}
    }

    final messages = prefs.getStringList('chat_messages') ?? [];
    for (final s in messages) {
      try {
        final decoded = jsonDecode(s);
        if (decoded is Map<String, dynamic>) {
          await _db?.insertMessage(decoded['text'] ?? s, decoded['sender'] ?? 'user', decoded['time'] ?? DateTime.now().toIso8601String(), type: decoded['type']);
        }
      } catch (_) {}
    }

    // If migration succeeded, clear the prefs lists
    if ((meals.isNotEmpty || workouts.isNotEmpty || messages.isNotEmpty) && _db != null) {
      await prefs.remove('meals');
      await prefs.remove('workouts');
      await prefs.remove('chat_messages');
    }
  }

  static Future<void> saveMeal(String text, {String? detectedFood}) async {
    await init();
    final clientId = _generateClientId();
    if (_db != null) {
      await _db!.insertMeal(text, DateTime.now().toIso8601String(), detectedFood: detectedFood, clientId: clientId, synced: false);
      // Enqueue for sync
      await SyncService.enqueue({'type': 'meal', 'payload': {'text': text, 'time': DateTime.now().toIso8601String(), 'detectedFood': detectedFood, 'client_id': clientId}});
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('meals') ?? [];
    list.add(jsonEncode({
      'text': text,
      'time': DateTime.now().toIso8601String(),
      'detectedFood': detectedFood,
      'client_id': clientId,
    }));
    await prefs.setStringList('meals', list);
  }

  static Future<List<Map<String, dynamic>>> getParsedMeals() async {
    await init();
    if (_db != null) {
      return _db!.getMealsAsMaps();
    }

    final list = await getMeals();
    return list.map((s) {
      try {
        final decoded = jsonDecode(s) as Map<String, dynamic>;
        return decoded;
      } catch (_) {
        return {'text': s, 'time': '', 'detectedFood': null};
      }
    }).toList();
  }

  static Future<List<String>> getMeals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('meals') ?? [];
  }

  static Future<void> saveWorkout(String workout, {String? detectedExercise}) async {
    await init();
    final clientId = _generateClientId();
    if (_db != null) {
      await _db!.insertWorkout(workout, DateTime.now().toIso8601String(), detectedExercise: detectedExercise, clientId: clientId, synced: false);
      await SyncService.enqueue({'type': 'workout', 'payload': {'name': workout, 'time': DateTime.now().toIso8601String(), 'detectedExercise': detectedExercise, 'client_id': clientId}});
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('workouts') ?? [];
    list.add(jsonEncode({
      'name': workout,
      'time': DateTime.now().toIso8601String(),
      'detectedExercise': detectedExercise,
      'client_id': clientId,
    }));
    await prefs.setStringList('workouts', list);
  }

  static Future<List<String>> getWorkouts() async {
    await init();
    if (_db != null) {
      final rows = await _db!.getWorkoutsAsMaps();
      return rows.map((r) => r['name'] as String? ?? '').where((s) => s.isNotEmpty).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('workouts') ?? [];
  }

  static Future<void> saveMessage(String text, String sender, {String? type}) async {
    await init();
    final clientId = _generateClientId();
    if (_db != null) {
      await _db!.insertMessage(text, sender, DateTime.now().toIso8601String(), type: type, clientId: clientId, synced: false);
      await SyncService.enqueue({'type': 'message', 'payload': {'text': text, 'sender': sender, 'time': DateTime.now().toIso8601String(), 'type': type, 'client_id': clientId}});
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('chat_messages') ?? [];
    list.add(jsonEncode({
      'text': text,
      'sender': sender,
      'time': DateTime.now().toIso8601String(),
      'type': type,
      'client_id': clientId,
    }));
    await prefs.setStringList('chat_messages', list);
  }

  static Future<List<Map<String, dynamic>>> getChatMessages() async {
    await init();
    if (_db != null) return _db!.getMessagesAsMaps();

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('chat_messages') ?? [];
    return list.map<Map<String, dynamic>>((s) {
      try {
        final decoded = jsonDecode(s);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        return <String, dynamic>{'text': s, 'time': ''};
      } catch (_) {
        return <String, dynamic>{'text': s, 'time': ''};
      }
    }).toList();
  }
}
