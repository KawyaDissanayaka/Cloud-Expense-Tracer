import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();
  final _budgetController = TextEditingController();

  void _submitIncome() {
    if (!_formKey.currentState!.validate()) return;
    
    final source = _sourceController.text;
    final amount = double.parse(_amountController.text);

    Provider.of<ExpenseProvider>(context, listen: false).addIncome(
      source: source,
      amount: amount,
      date: DateTime.now(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Income logged successfully!'),
        backgroundColor: AppTheme.incomeColor,
      ),
    );

    _sourceController.clear();
    _amountController.clear();
  }

  void _updateBudget() {
    if (_budgetController.text.isEmpty) return;
    final amount = double.tryParse(_budgetController.text);
    if (amount != null && amount > 0) {
      Provider.of<ExpenseProvider>(context, listen: false).updateBudget(amount);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Monthly budget updated to \$${amount.toStringAsFixed(0)}!'),
          backgroundColor: AppTheme.accentLight,
        ),
      );
      _budgetController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INCOME & BUDGET',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Budget display & settings
            Consumer<ExpenseProvider>(
              builder: (context, provider, child) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Monthly Budget Limit',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Currently: \$${provider.monthlyBudget.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppTheme.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Enter amount...',
                                prefixIcon: Icon(Icons.edit_road_outlined, color: AppTheme.textSecondary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _updateBudget,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            child: const Text('Update'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form to log new Income
            Form(
              key: _formKey,
              child: Card(
                color: Colors.white.withOpacity(0.01),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Log New Income',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _sourceController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Income Source',
                          prefixIcon: Icon(Icons.source_outlined, color: AppTheme.textSecondary),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Please enter a source' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Amount (\$)',
                          prefixIcon: Icon(Icons.attach_money, color: AppTheme.textSecondary),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter an amount';
                          if (double.tryParse(v) == null) return 'Please enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitIncome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.incomeColor,
                        ),
                        child: const Text('Log Income Entry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Income List
            Text(
              'Income Ledger',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Consumer<ExpenseProvider>(
              builder: (context, provider, child) => provider.incomeList.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text('No income logged yet.', style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.incomeList.length,
                      itemBuilder: (context, index) {
                        final income = provider.incomeList[index];
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
                                backgroundColor: AppTheme.incomeColor.withOpacity(0.1),
                                child: const Icon(Icons.arrow_upward, color: AppTheme.incomeColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      income.source,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${income.date.day}/${income.date.month}/${income.date.year}',
                                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '+\$${income.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: AppTheme.incomeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppTheme.textSecondary, size: 18),
                                    onPressed: () => provider.deleteIncome(income.id),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
