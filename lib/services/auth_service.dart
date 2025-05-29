import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class AuthService {
  final dbHelper = DatabaseHelper.instance;

  Future<bool> register(String email, String password) async {
    final db = await dbHelper.database;
    try {
      await db.insert('users', {
        'email': email,
        'password': password, // em produção, use hash!
      });
      return true;
    } on DatabaseException catch (e) {
      // Se violar UNIQUE (e-mail já cadastrado)
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final db = await dbHelper.database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final db = await dbHelper.database;
    final count = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
    return count > 0;
  }
}
