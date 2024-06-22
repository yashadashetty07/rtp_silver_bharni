// emp_database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:rtp_silver/models/employee.dart';
import 'database_helper.dart';

class EmpDatabaseService {
  static Database? _db;

  static final EmpDatabaseService instance = EmpDatabaseService._constructor();

  final String _tableName = "employees";
  final String _columnId = "id";
  final String _columnName = "name";
  final String _columnPhone = "phoneNumber";

  EmpDatabaseService._constructor();

  Future<Database?> get database async {
    if (_db != null) return _db;
    _db = await DatabaseHelper.getDatabase();
    return _db;
  }

  Future<void> addEmployee(String name, String phoneNumber) async {
    final db = await database;
    await db?.insert(
      _tableName,
      {
        _columnName: name,
        _columnPhone: phoneNumber,
      },
    );
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final data = await db?.query(_tableName);
    return data?.map((e) => Employee(
      id: e[_columnId] as int,
      name: e[_columnName] as String,
      phoneNumber: e[_columnPhone] as String,
    )).toList() ?? [];
  }

  Future<void> updateEmployee(int id, String name, String phoneNumber) async {
    final db = await database;
    await db?.update(
      _tableName,
      {
        _columnName: name,
        _columnPhone: phoneNumber,
      },
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteEmployee(int id) async {
    final db = await database;
    await db?.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}