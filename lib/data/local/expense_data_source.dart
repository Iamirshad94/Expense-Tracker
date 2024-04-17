import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../models/expense_model.dart';

class DatabaseHelper {
  static const String tableName = 'expenses';
  static DatabaseHelper? _instance;

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  DatabaseHelper._internal();

  static Future<Database> openDb() async {
    return await openDatabase(
      'expenses.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            date TEXT NOT NULL,
            description TEXT NOT NULL,
            expenseType TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<FutureOr<void>> insertExpense(Expense expense) async {
    final db = await openDb();
    await db.insert(tableName, expense.toMap());
  }

  static Future<FutureOr<List<Expense>>> getAllExpenses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => Expense.fromMap(map)).toList();
  }

  static Future<FutureOr<void>> updateExpense(Expense expense) async {
    final db = await openDb();
    await db.update(
      tableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  static Future<FutureOr<void>> deleteExpense(int id) async {
    final db = await openDb();
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
