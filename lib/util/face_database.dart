import 'package:sqflite/sqflite.dart';

class FaceDatabase {
  static final FaceDatabase instance = FaceDatabase._internal();

  static Database? _database;

  FaceDatabase._internal();
  static const tableName = "faces";

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/faces.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      faceData TEXT,
      createdTime TEXT
        )
      ''');
  }
}
