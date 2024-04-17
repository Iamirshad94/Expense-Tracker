import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/local/expense_data_source.dart';
import '../data/models/expense_model.dart';

class ExpenseController extends GetxController {
  final _expenses = <Expense>[];
  bool isLoading = false;
  RxDouble totalExpense = 0.0.obs;

  Future<void> getExpensesFromDb() async {
    isLoading = true;
    final db = await DatabaseHelper.openDb();
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.tableName);
    _expenses.clear();
    _expenses.addAll(maps.map((map) => Expense.fromMap(map)).toList());
    totalExpense.value =
        _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    isLoading = false;
    update(); // Update UI after fetching expenses
  }

  @override
  void onInit() {
    super.onInit();
    getExpensesFromDb(); // Fetch expenses on app launch
  }

  List<Expense> get expenses => _expenses.toList();

  void addNewExpense({
    required int amount,
    required DateTime date,
    required String description,
    required ExpenseType expenseType,
  }) async {
    isLoading = true;
    final int newId = _expenses.isEmpty ? 1 : _expenses.last.id + 1;
    // final String id = '$amount${DateTime.now()}';
    debugPrint('Add Expense---->>> ${date.toString()}');
    final expense = Expense(
      id: newId,
      amount: amount,
      date: date.toString(),
      description: description,
      expenseType: expenseType.toString(),
    );
    _expenses.add(expense);
    totalExpense.value += amount;
    await DatabaseHelper.insertExpense(expense); // Insert into database
    isLoading = false;
    update(); // Update UI after adding expense
  }

  Future<void> updateExpense({
    required int id,
    required int amount,
    required DateTime date,
    required String description,
    required ExpenseType expenseType,
  }) async {
    isLoading = true;
    final index = _expenses.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      final expense = Expense(
        id: id,
        amount: amount,
        date: date.toString(),
        description: description,
        expenseType: expenseType.toString(),
      );
      _expenses[index] = expense;
      totalExpense.value =
          totalExpense.value - _expenses[index].amount + amount;
      await DatabaseHelper.updateExpense(expense); // Update in database
    }
    isLoading = false;
    update(); // Update UI after updating expense
  }

  Future<void> deleteExpense(int id) async {
    isLoading = true;
    debugPrint('Delete ID--->> $id');
    final index = _expenses.indexWhere((expense) => expense.id == id);
    debugPrint('Index--->> $index');

    if (index > -1) {
      _expenses.removeAt(index);
      await DatabaseHelper.deleteExpense(id); // Delete from database
    }
    isLoading = false;
    update(); // Update UI after deleting expense
  }
}
