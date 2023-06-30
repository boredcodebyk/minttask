import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;
  static const tableName = "basic_1";
  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            is_done INTEGER,
            date_created INTEGER,
            date_modified INTEGER,
            has_alarm INTEGER,
            alarm_time TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTodos(colname, filter) async {
    final db = await instance.database;
    //final List<Map<String, dynamic>>
    return await db.query(tableName,
        orderBy: "$colname ${filter.toString().toUpperCase()}");
  }

  Future<List<Map<String, dynamic>>> orderBy() async {
    final db = await instance.database;
    //final List<Map<String, dynamic>>
    return await db.query(tableName);
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    final db = await instance.database;
    return await db.insert(tableName, todo);
  }

  Future<int> updateTodoStauts(int id, int newStatus, int dateModified) async {
    final db = await instance.database;
    return await db.update(
        tableName, {'is_done': newStatus, 'date_modified': dateModified},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTodoTitle(int id, String newTitle, int dateModified) async {
    final db = await instance.database;
    return await db.update(
        tableName, {'title': newTitle, 'date_modified': dateModified},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTodoDescription(
      int id, String newDescription, int dateModified) async {
    final db = await instance.database;
    return await db.update(tableName,
        {'description': newDescription, 'date_modified': dateModified},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getTextById(int id) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  closeDatabase() async {
    final db = await instance.database;
    await db.close();
  }
}
