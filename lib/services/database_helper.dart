// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String database_name = "rtp_bharni.db";
  static const int database_version = 1;

  static Future<Database> getDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, database_name);

    return openDatabase(
      path,
      version: database_version,
      onCreate: (db, version) async {
        // Create employees table
        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            phoneNumber TEXT NOT NULL
          )
        ''');

        // Create works table
        await db.execute('''
          CREATE TABLE works (
            id INTEGER PRIMARY KEY,
            employeeName TEXT NOT NULL,
            category TEXT NOT NULL,
            shikka TEXT NOT NULL,
            weight REAL NOT NULL,
            date TEXT NOT NULL,
            taskAddingTime TEXT NOT NULL
          )
        ''');
      },
    );
  }
}