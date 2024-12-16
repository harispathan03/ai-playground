import 'package:ai_playground/model/face_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  static Database? _database;
  static const tableName = "faces";

  SqliteHelper() {
    _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'faces.db');
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

  Future<void> add(FaceModel note) async {
    final db = await database;
    await db.insert(tableName, note.toMap());
  }

  Future<List<FaceModel>> readAll() async {
    final db = await database;
    final result = await db.query(tableName);
    return result.map((json) => FaceModel.fromMap(json)).toList();
  }

  Future<int> clear() async {
    final db = await database;
    return await db.delete(tableName);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
