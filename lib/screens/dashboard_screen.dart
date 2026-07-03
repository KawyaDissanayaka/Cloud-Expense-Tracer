import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DASHBOARD',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final balance = provider.netBalance;
          final totalIncome = provider.totalIncome;
          final totalExpenses = provider.totalExpenses;
          final budgetUsageRatio = totalExpenses / provider.monthlyBudget;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Glowing Balance Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.balanceGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${balance.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white10,
                                  child: Icon(Icons.arrow_upward_rounded, color: AppTheme.incomeColor, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Income', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                    Text('\$${totalIncome.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.incomeColor)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(width: 1, height: 35, color: Colors.white12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white10,
                                  child: Icon(Icons.arrow_downward_rounded, color: AppTheme.expenseColor, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Expenses', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                    Text('\$${totalExpenses.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.expenseColor)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Budget Alert / Progress Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Budget Limit',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '\$${totalExpenses.toStringAsFixed(0)} / \$${provider.monthlyBudget.toStringAsFixed(0)}',
                              style: const TextStyle(color: AppTheme.accentLight, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: budgetUsageRatio.clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.05),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              budgetUsageRatio > 0.9 ? AppTheme.expenseColor : AppTheme.accentLight,
                            ),
                          ),
                        ),
                        if (budgetUsageRatio > 0.9) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Warning: You are reaching your monthly limit!',
                            style: TextStyle(color: AppTheme.expenseColor, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Text('See all', style: TextStyle(color: AppTheme.accentLight, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),

                // Combined List of recent transactions (Expenses)
                provider.expenses.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Text('No expenses recorded yet.', style: TextStyle(color: AppTheme.textSecondary)),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.expenses.length > 5 ? 5 : provider.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = provider.expenses[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.02)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppTheme.accent.withOpacity(0.1),
                                  child: Icon(
                                    _getCategoryIcon(expense.category),
                                    color: AppTheme.accentLight,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expense.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${expense.category} • ${_formatDate(expense.date)}',
                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '-\$${expense.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppTheme.expenseColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AppTheme.textSecondary, size: 18),
                                      onPressed: () => provider.deleteExpense(expense.id),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cloud':
        return Icons.cloud_outlined;
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.directions_car_filled_outlined;
      case 'subscriptions':
        return Icons.subscriptions_outlined;
      case 'rent':
        return Icons.home_work_outlined;
      default:
        return Icons.payment;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
