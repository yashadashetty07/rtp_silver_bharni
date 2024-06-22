// work_database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:rtp_silver/models/work.dart';
import 'database_helper.dart';

class WorkDatabaseService {
  static Database? _db;

  static final WorkDatabaseService instance = WorkDatabaseService._constructor();

  final String _tableName = 'works';
  final String _columnId = 'id';
  final String _columnEmployeeName = 'employeeName';
  final String _columnCategory = 'category';
  final String _columnShikka = 'shikka';
  final String _columnWeight = 'weight';
  final String _columnDate = 'date';
  final String _columnTaskAddingTime = 'taskAddingTime';

  WorkDatabaseService._constructor();

  Future<Database?> get database async {
    if (_db != null) return _db;
    _db = await DatabaseHelper.getDatabase();
    return _db;
  }

  Future<void> addWork(Work work) async {
    final db = await database;
    await db?.insert(_tableName, work.toMap());
  }

  Future<List<Work>> getWorks() async {
    final db = await database;
    final data = await db?.query(_tableName);
    return data?.map((e) => Work(
      id: e[_columnId] as int,
      employeeName: e[_columnEmployeeName] as String,
      category: e[_columnCategory] as String,
      shikka: e[_columnShikka] as String,
      weight: e[_columnWeight] as double,
      date: DateTime.parse(e[_columnDate] as String),
      taskAddingTime: DateTime.parse(e[_columnTaskAddingTime] as String),
    )).toList() ?? [];
  }

  Future<void> updateWork(int id, Work work) async {
    final db = await database;
    await db?.update(
      _tableName,
      work.toMap(),
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteWork(int id) async {
    final db = await database;
    await db?.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}