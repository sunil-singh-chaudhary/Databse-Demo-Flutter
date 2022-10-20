import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "Student.db";
  static final _databaseVersion = 1;

  static var table = 'student_table';
  static var studentId = 'student_id';
  static var studentName = 'student_name';
  static var student_rank = 'student_rank';
  static var studentAge = 'student_age';

  DatabaseHelper._privateConstructor();
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $studentId INTEGER PRIMARY KEY,
            $studentName TEXT NOT NULL,
            $student_rank TEXT NOT NULL,
            $studentAge TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var result = await db.query(table);
    print(result.toList());
    return result.toList();
  }

  //Check wheather database is empty or not
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<List<Map<String, Object?>>> queryRow(String name) async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT * FROM $table WHERE $studentName =?', [name]);
    // var simplequery= await db.query(table,where: "$columnName =?", whereArgs: [name]);
    return result;
  }

  Future<int> update(Map<String, dynamic> row, int id) async {
    Database db = await instance.database;
    int uptodateId = id;
    return await db
        .update(table, row, where: '$studentId = ?', whereArgs: [uptodateId]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$studentId = ?', whereArgs: [id]);
  }
}
