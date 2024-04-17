import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:msa_app/data/local/expense_data_source.dart';
import 'package:msa_app/data/models/expense_model.dart';
import 'package:msa_app/getx/expense_controller.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late Database database;
  // late MockTaskService taskService;
  List<Expense> expense = List.generate(10, (index) => Expense(id: 0, amount: 100, date: DateTime.now().toString(), description: 'Ok', expenseType: ExpenseType.Fuel.toString()));
  setUpAll(() async {
    Get.put<ExpenseController>(ExpenseController());
    final controller = Get.find<ExpenseController>();
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
          CREATE TABLE 'expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            date TEXT NOT NULL,
            description TEXT NOT NULL,
            expenseType TEXT NOT NULL
          )
        ''');
    // database = DatabaseHelper();
    // database = database;
    when(controller.addNewExpense(amount: 100,description: 'Ok',date: DateTime.now(),expenseType: ExpenseType.Fuel)).thenAnswer((_) async => expense);
    when(controller.updateExpense(amount: 100,description: 'Ok',date: DateTime.now(),expenseType: ExpenseType.Fuel, id: 0)).thenAnswer((_) async => 1);
    when(controller.deleteExpense(0)).thenAnswer((_) async => 1);
  });
  group('ExpenseService Test', () {
    Get.put<ExpenseController>(ExpenseController());
    final controller = Get.find<ExpenseController>();
    test('addExpense_validData_success', () {
      controller.addNewExpense(
          amount: 100,
          expenseType: ExpenseType.Groceries,
          description: 'This is Description',
          date: DateTime.now());
      final success = controller.expenses.isNotEmpty ? true : false;
      // Assert
      expect(success, true);
      // Additional assertions: check if expense is saved in storage (if applicable)
    });

    test('addExpense_invalidAmount_throwsError', () {
      expect(
          () => controller.addNewExpense(
              amount: 0,
              description: '',
              date: DateTime.now(),
              expenseType: ExpenseType.Fuel),
          throwsA(isA<Exception>()));
    });
  });
}
