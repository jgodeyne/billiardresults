import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_settings.dart';
import '../models/result.dart';
import '../models/classification_level.dart';

/// Database service for managing local SQLite storage
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('billiard_results.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    // User settings table
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        season_start_day INTEGER NOT NULL,
        season_start_month INTEGER NOT NULL,
        language TEXT NOT NULL
      )
    ''');

    // Results table
    await db.execute('''
      CREATE TABLE results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        discipline TEXT NOT NULL,
        date TEXT NOT NULL,
        points_made INTEGER NOT NULL,
        innings INTEGER NOT NULL,
        highest_run INTEGER NOT NULL,
        adversary TEXT,
        outcome TEXT,
        competition TEXT,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_results_discipline ON results(discipline)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_results_date ON results(date)
    ''');

    // Classification levels table
    await db.execute('''
      CREATE TABLE classification_levels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        discipline TEXT NOT NULL UNIQUE,
        min_average REAL NOT NULL,
        max_average REAL NOT NULL
      )
    ''');

    // Discipline ordering table (for drag-and-drop card order)
    await db.execute('''
      CREATE TABLE discipline_order (
        discipline TEXT PRIMARY KEY,
        order_index INTEGER NOT NULL
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle future database migrations
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }

  /// Delete database (for testing or reset)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'billiard_results.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // ==================== USER SETTINGS ====================

  /// Create or update user settings (should only be one row)
  Future<UserSettings> saveUserSettings(UserSettings settings) async {
    final db = await database;
    
    // Check if settings exist
    final existing = await db.query('user_settings', limit: 1);
    
    if (existing.isEmpty) {
      // Insert new settings
      final id = await db.insert('user_settings', settings.toMap());
      return settings.copyWith(id: id);
    } else {
      // Update existing settings
      await db.update(
        'user_settings',
        settings.toMap(),
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
      return settings.copyWith(id: existing.first['id'] as int);
    }
  }

  /// Get user settings
  Future<UserSettings?> getUserSettings() async {
    final db = await database;
    final maps = await db.query('user_settings', limit: 1);
    
    if (maps.isEmpty) {
      return null;
    }
    
    return UserSettings.fromMap(maps.first);
  }

  /// Check if user settings exist (for first-time setup detection)
  Future<bool> hasUserSettings() async {
    final settings = await getUserSettings();
    return settings != null;
  }

  // ==================== RESULTS ====================

  /// Create a new result
  Future<Result> createResult(Result result) async {
    final db = await database;
    final id = await db.insert('results', result.toMap());
    return result.copyWith(id: id);
  }

  /// Get a single result by ID
  Future<Result?> getResult(int id) async {
    final db = await database;
    final maps = await db.query(
      'results',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) {
      return null;
    }
    
    return Result.fromMap(maps.first);
  }

  /// Get all results
  Future<List<Result>> getAllResults() async {
    final db = await database;
    final maps = await db.query('results', orderBy: 'date DESC');
    return maps.map((map) => Result.fromMap(map)).toList();
  }

  /// Get results by discipline
  Future<List<Result>> getResultsByDiscipline(String discipline) async {
    final db = await database;
    final maps = await db.query(
      'results',
      where: 'discipline = ?',
      whereArgs: [discipline],
      orderBy: 'date DESC',
    );
    return maps.map((map) => Result.fromMap(map)).toList();
  }

  /// Get results for a specific season
  Future<List<Result>> getResultsBySeason({
    required DateTime seasonStart,
    required DateTime seasonEnd,
  }) async {
    final db = await database;
    final maps = await db.query(
      'results',
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        seasonStart.toIso8601String(),
        seasonEnd.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );
    return maps.map((map) => Result.fromMap(map)).toList();
  }

  /// Get results by discipline and season
  Future<List<Result>> getResultsByDisciplineAndSeason({
    required String discipline,
    required DateTime seasonStart,
    required DateTime seasonEnd,
  }) async {
    final db = await database;
    final maps = await db.query(
      'results',
      where: 'discipline = ? AND date >= ? AND date <= ?',
      whereArgs: [
        discipline,
        seasonStart.toIso8601String(),
        seasonEnd.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );
    return maps.map((map) => Result.fromMap(map)).toList();
  }

  /// Get all unique disciplines
  Future<List<String>> getAllDisciplines() async {
    final db = await database;
    final maps = await db.rawQuery(
      'SELECT DISTINCT discipline FROM results ORDER BY discipline',
    );
    return maps.map((map) => map['discipline'] as String).toList();
  }

  /// Get disciplines that have results in a specific season
  Future<List<String>> getDisciplinesBySeason({
    required DateTime seasonStart,
    required DateTime seasonEnd,
  }) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT DISTINCT discipline FROM results 
      WHERE date >= ? AND date <= ? 
      ORDER BY discipline
      ''',
      [seasonStart.toIso8601String(), seasonEnd.toIso8601String()],
    );
    return maps.map((map) => map['discipline'] as String).toList();
  }

  /// Get the date of the first result (for season calculation)
  Future<DateTime?> getFirstResultDate() async {
    final db = await database;
    final maps = await db.query(
      'results',
      columns: ['date'],
      orderBy: 'date ASC',
      limit: 1,
    );
    
    if (maps.isEmpty) {
      return null;
    }
    
    return DateTime.parse(maps.first['date'] as String);
  }

  /// Update a result
  Future<int> updateResult(Result result) async {
    final db = await database;
    return await db.update(
      'results',
      result.toMap(),
      where: 'id = ?',
      whereArgs: [result.id],
    );
  }

  /// Delete a result
  Future<int> deleteResult(int id) async {
    final db = await database;
    return await db.delete(
      'results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all results (for data reset)
  Future<int> deleteAllResults() async {
    final db = await database;
    return await db.delete('results');
  }

  // ==================== CLASSIFICATION LEVELS ====================

  /// Create or update classification level
  Future<ClassificationLevel> saveClassificationLevel(ClassificationLevel level) async {
    final db = await database;
    
    // Check if exists
    final existing = await db.query(
      'classification_levels',
      where: 'discipline = ?',
      whereArgs: [level.discipline],
      limit: 1,
    );
    
    if (existing.isEmpty) {
      final id = await db.insert('classification_levels', level.toMap());
      return level.copyWith(id: id);
    } else {
      await db.update(
        'classification_levels',
        level.toMap(),
        where: 'discipline = ?',
        whereArgs: [level.discipline],
      );
      return level.copyWith(id: existing.first['id'] as int);
    }
  }

  /// Get classification level for a discipline
  Future<ClassificationLevel?> getClassificationLevel(String discipline) async {
    final db = await database;
    final maps = await db.query(
      'classification_levels',
      where: 'discipline = ?',
      whereArgs: [discipline],
      limit: 1,
    );
    
    if (maps.isEmpty) {
      return null;
    }
    
    return ClassificationLevel.fromMap(maps.first);
  }

  /// Get all classification levels
  Future<List<ClassificationLevel>> getAllClassificationLevels() async {
    final db = await database;
    final maps = await db.query('classification_levels', orderBy: 'discipline');
    return maps.map((map) => ClassificationLevel.fromMap(map)).toList();
  }

  /// Delete classification level
  Future<int> deleteClassificationLevel(String discipline) async {
    final db = await database;
    return await db.delete(
      'classification_levels',
      where: 'discipline = ?',
      whereArgs: [discipline],
    );
  }

  // ==================== DISCIPLINE ORDERING ====================

  /// Save discipline order
  Future<void> saveDisciplineOrder(List<String> disciplines) async {
    final db = await database;
    
    // Use a transaction to update all at once
    await db.transaction((txn) async {
      // Clear existing order
      await txn.delete('discipline_order');
      
      // Insert new order
      for (int i = 0; i < disciplines.length; i++) {
        await txn.insert('discipline_order', {
          'discipline': disciplines[i],
          'order_index': i,
        });
      }
    });
  }

  /// Get discipline order
  Future<List<String>> getDisciplineOrder() async {
    final db = await database;
    final maps = await db.query(
      'discipline_order',
      orderBy: 'order_index ASC',
    );
    return maps.map((map) => map['discipline'] as String).toList();
  }

  /// Get ordered disciplines for a season (combines order with season filter)
  Future<List<String>> getOrderedDisciplinesBySeason({
    required DateTime seasonStart,
    required DateTime seasonEnd,
  }) async {
    // Get disciplines with results in this season
    final seasonDisciplines = await getDisciplinesBySeason(
      seasonStart: seasonStart,
      seasonEnd: seasonEnd,
    );
    
    // Get saved order
    final order = await getDisciplineOrder();
    
    // Return disciplines in saved order, followed by any new ones
    final orderedList = <String>[];
    
    // Add ordered disciplines that exist in season
    for (final discipline in order) {
      if (seasonDisciplines.contains(discipline)) {
        orderedList.add(discipline);
      }
    }
    
    // Add any new disciplines not in saved order
    for (final discipline in seasonDisciplines) {
      if (!orderedList.contains(discipline)) {
        orderedList.add(discipline);
      }
    }
    
    return orderedList;
  }
}
