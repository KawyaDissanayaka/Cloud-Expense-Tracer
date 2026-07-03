import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/income.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(
      id: 'e1',
      title: 'AWS Cloud Hosting',
      amount: 120.50,
      category: 'Cloud',
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Monthly production servers',
    ),
    Expense(
      id: 'e2',
      title: 'Starbucks Coffee',
      amount: 6.80,
      category: 'Food',
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Team meeting coffee',
    ),
    Expense(
      id: 'e3',
      title: 'Uber Ride',
      amount: 24.50,
      category: 'Travel',
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Client visit ride',
    ),
    Expense(
      id: 'e4',
      title: 'GitHub Copilot',
      amount: 19.00,
      category: 'Subscriptions',
      date: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Developer productivity tool',
    ),
    Expense(
      id: 'e5',
      title: 'Co-working Office Space',
      amount: 300.00,
      category: 'Rent',
      date: DateTime.now().subtract(const Duration(days: 10)),
      description: 'Monthly rent for desks',
    ),
  ];

  final List<Income> _incomeList = [
    Income(
      id: 'i1',
      source: 'Mobile App Freelance',
      amount: 2500.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      description: 'Milestone 2 payment',
    ),
    Income(
      id: 'i2',
      source: 'Consulting Retainer',
      amount: 1200.00,
      date: DateTime.now().subtract(const Duration(days: 12)),
      description: 'Monthly architectural review retainer',
    ),
  ];

  double _monthlyBudget = 1500.00;

  List<Expense> get expenses => [..._expenses];
  List<Income> get incomeList => [..._incomeList];
  double get monthlyBudget => _monthlyBudget;

  double get totalIncome {
    return _incomeList.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpenses {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get netBalance => totalIncome - totalExpenses;

  // Set new budget
  void updateBudget(double amount) {
    _monthlyBudget = amount;
    notifyListeners();
  }

  // Add Expense
  void addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String description = '',
    String? receiptPath,
  }) {
    final newExpense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      description: description,
      receiptPath: receiptPath,
    );
    _expenses.insert(0, newExpense);
    notifyListeners();
  }

  // Delete Expense
  void deleteExpense(String id) {
    _expenses.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // Add Income
  void addIncome({
    required String source,
    required double amount,
    required DateTime date,
    String description = '',
  }) {
    final newIncome = Income(
      id: const Uuid().v4(),
      source: source,
      amount: amount,
      date: date,
      description: description,
    );
    _incomeList.insert(0, newIncome);
    notifyListeners();
  }

  // Delete Income
  void deleteIncome(String id) {
    _incomeList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // Category statistics map
  Map<String, double> get categoryTotals {
    final Map<String, double> chartData = {};
    for (var expense in _expenses) {
      chartData[expense.category] = (chartData[expense.category] ?? 0.0) + expense.amount;
    }
    return chartData;
  }
}
