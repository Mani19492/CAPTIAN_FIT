import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LocalDb {
  Database? _db;
  static LocalDb? _instance;

  LocalDb._();

  factory LocalDb() {
    _instance ??= LocalDb._();
    return _instance!;
  }

  Future<void> connect() async {
    if (_db != null && _db!.isOpen) return;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'captain_fit.sqlite');
    _db = await openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE meals (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT NOT NULL,
          time TEXT NOT NULL,
          detectedFood TEXT,
          client_id TEXT,
          synced INTEGER DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE workouts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          time TEXT NOT NULL,
          detectedExercise TEXT,
          client_id TEXT,
          synced INTEGER DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE chat_messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT NOT NULL,
          sender TEXT NOT NULL,
          time TEXT NOT NULL,
          type TEXT,
          client_id TEXT,
          synced INTEGER DEFAULT 0
        )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        // Add client_id and synced columns when upgrading from v1 to v2
        await db.execute('ALTER TABLE meals ADD COLUMN client_id TEXT');
        await db.execute('ALTER TABLE meals ADD COLUMN synced INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE workouts ADD COLUMN client_id TEXT');
        await db.execute('ALTER TABLE workouts ADD COLUMN synced INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE chat_messages ADD COLUMN client_id TEXT');
        await db.execute('ALTER TABLE chat_messages ADD COLUMN synced INTEGER DEFAULT 0');
      }
    });
  }

  Future<int> insertMeal(String text, String time, {String? detectedFood, String? clientId, bool synced = false}) async {
    await connect();
    return await _db!.insert('meals', {'text': text, 'time': time, 'detectedFood': detectedFood, 'client_id': clientId, 'synced': synced ? 1 : 0});
  }

  Future<List<Map<String, dynamic>>> getMealsAsMaps() async {
    await connect();
    return await _db!.query('meals');
  }

  Future<int> insertWorkout(String name, String time, {String? detectedExercise, String? clientId, bool synced = false}) async {
    await connect();
    return await _db!.insert('workouts', {'name': name, 'time': time, 'detectedExercise': detectedExercise, 'client_id': clientId, 'synced': synced ? 1 : 0});
  }

  Future<List<Map<String, dynamic>>> getWorkoutsAsMaps() async {
    await connect();
    return await _db!.query('workouts');
  }

  Future<int> insertMessage(String text, String sender, String time, {String? type, String? clientId, bool synced = false}) async {
    await connect();
    return await _db!.insert('chat_messages', {'text': text, 'sender': sender, 'time': time, 'type': type, 'client_id': clientId, 'synced': synced ? 1 : 0});
  }

  Future<List<Map<String, dynamic>>> getMessagesAsMaps() async {
    await connect();
    return await _db!.query('chat_messages');
  }
}
