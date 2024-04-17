import 'dart:ffi';

enum ExpenseType { Entertainment, Groceries, Fuel, Utilities, Rent, MedicalExpenses }

class Expense {
  final int id;
  final int amount;
  final String date;
  final String description;
  final String expenseType;

  Expense({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.expenseType,
  });

  factory Expense.fromMap(Map<dynamic, dynamic> map) => Expense(
    id: map['id'] as int,
    amount: map['amount'] as int,
    date: map['date'],
    description: map['description'] as String,
    expenseType: map['expenseType'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'date': date,
    'description': description,
    'expenseType': expenseType,
  };
}
