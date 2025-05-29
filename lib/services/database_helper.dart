import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('auth_app.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory docs = await getApplicationDocumentsDirectory();
    final path = join(docs.path, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
