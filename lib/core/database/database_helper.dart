import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/authentication/domain/user.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('library_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        email $idType,
        password $textType,
        user_type $textType,
        last_login $integerType,
        managed_libraries $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id $idType,
        notification_enabled $integerType,
        occupancy_threshold $integerType,
        refresh_frequency $integerType,
        hold_time_threshold $integerType
      )
    ''');

    // Insert default admin user
    await db.insert('users', {
      'email': 'admin@admin.com',
      'password': 'admin123',
      'user_type': 'administrator',
      'last_login': DateTime.now().millisecondsSinceEpoch,
      'managed_libraries': ''
    });

    // Insert default settings
    await db.insert('settings', {
      'id': 'global',
      'notification_enabled': 1,
      'occupancy_threshold': 80,
      'refresh_frequency': 5,
      'hold_time_threshold': 30
    });
  }

  Future<User?> getUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      await db.update(
        'users',
        {'last_login': DateTime.now().millisecondsSinceEpoch},
        where: 'email = ?',
        whereArgs: [email],
      );
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> createUser(User user) async {
    final db = await instance.database;
    try {
      debugPrint('Checking for existing user with email: ${user.email}');
      // Check if user already exists
      final existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [user.email],
      );

      if (existingUser.isNotEmpty) {
        debugPrint('User already exists with email: ${user.email}');
        return false;
      }

      debugPrint('Inserting new user with data: ${user.toMap()}');
      final id = await db.insert('users', user.toMap());
      debugPrint('User inserted with id: $id');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error creating user: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<Map<String, dynamic>> getSettings() async {
    final db = await instance.database;
    final maps =
        await db.query('settings', where: 'id = ?', whereArgs: ['global']);
    return maps.first;
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    final db = await instance.database;
    await db.update(
      'settings',
      settings,
      where: 'id = ?',
      whereArgs: ['global'],
    );
  }

  Future<bool> updateManagedLibraries(
      String email, List<String> libraryIds) async {
    try {
      final db = await instance.database;
      await db.update(
        'users',
        {'managed_libraries': libraryIds.join(',')},
        where: 'email = ?',
        whereArgs: [email],
      );
      return true;
    } catch (e) {
      debugPrint('Error updating managed libraries: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.first;
  }

  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }
}
