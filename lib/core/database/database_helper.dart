import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._({
    this.databaseName = 'contabilidad.db',
    this.inMemory = false,
  });

  static final DatabaseHelper instance = DatabaseHelper._();

  factory DatabaseHelper.forTesting() {
    return DatabaseHelper._(
      databaseName: 'contabilidad_test.db',
      inMemory: true,
    );
  }

  final String databaseName;
  final bool inMemory;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = inMemory
        ? inMemoryDatabasePath
        : join(
            await getDatabasesPath(),
            databaseName,
          );

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE operations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        concept TEXT NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_operations_date ON operations(date)',
    );

    await db.execute(
      'CREATE INDEX idx_operations_concept ON operations(concept)',
    );
  }

  Future<void> close() async {
    final db = _database;

    if (db == null) {
      return;
    }

    await db.close();
    _database = null;
  }
}