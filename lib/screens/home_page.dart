import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentExpenses = List.generate(
      5,
      (i) => ExpenseItem(
        title: 'Coffee #${i + 1}',
        amount: 4.5 + i,
        date: DateTime.now().subtract(Duration(days: i)),
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Good ${_greetingHour()}, User',
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Register', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(child: SummaryCard(label: 'Expenses', amount: '₹ 12,340', color: Colors.redAccent)),
                  SizedBox(width: 8),
                  Expanded(child: SummaryCard(label: 'Income', amount: '₹ 20,500', color: Colors.greenAccent)),
                  SizedBox(width: 8),
                  Expanded(child: SummaryCard(label: 'Balance', amount: '₹ 8,160', color: Colors.blueAccent)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Recent Expenses',
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: recentExpenses.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                  itemBuilder: (context, index) {
                    final e = recentExpenses[index];
                    return ExpenseTile(item: e);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/addExpense'),
        backgroundColor: AppTheme.accent,
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  String _greetingHour() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

class ExpenseItem {
  final String title;
  final double amount;
  final DateTime date;
  const ExpenseItem({required this.title, required this.amount, required this.date});
}
