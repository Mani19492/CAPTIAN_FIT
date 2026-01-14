import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  static const String _dbName = 'captain_fit.db';
  
  static final LocalDatabase _instance = LocalDatabase._internal();
  
  factory LocalDatabase() => _instance;
  
  LocalDatabase._internal();
  
  Database? _db;
  
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }
  
  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Create meals table
    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        client_id TEXT UNIQUE,
        name TEXT,
        calories INTEGER,
        timestamp TEXT
      )
    ''');
    
    // Create workouts table
    await db.execute('''
      CREATE TABLE workouts (
        id TEXT PRIMARY KEY,
        client_id TEXT UNIQUE,
        name TEXT,
        duration INTEGER,
        calories INTEGER,
        timestamp TEXT
      )
    ''');
    
    // Create chat messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        text TEXT,
        is_user INTEGER,
        timestamp TEXT
      )
    ''');
    
    // Create sync queue table
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_type TEXT,
        item_id TEXT,
        action TEXT,
        timestamp TEXT
      )
    ''');
  }
  
  // Database operations would go here
  // For brevity, we'll just include a few examples
  
  Future<int> insertMeal(Map<String, dynamic> meal) async {
    final db = await database;
    return await db.insert('meals', meal);
  }
  
  Future<List<Map<String, dynamic>>> getMeals() async {
    final db = await database;
    return await db.query('meals', orderBy: 'timestamp DESC');
  }
  
  Future<int> insertWorkout(Map<String, dynamic> workout) async {
    final db = await database;
    return await db.insert('workouts', workout);
  }
  
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await database;
    return await db.query('workouts', orderBy: 'timestamp DESC');
  }
  
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}