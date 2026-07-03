import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ANALYTICS',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final totals = provider.categoryTotals;
          
          if (totals.isEmpty) {
            return const Center(
              child: Text(
                'No data available yet.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }

          final List<String> categories = totals.keys.toList();
          final List<double> values = totals.values.toList();
          final double sum = values.fold(0.0, (a, b) => a + b);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Spending by Category',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Outflow: \$${sum.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Pie Chart Display
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: List.generate(categories.length, (i) {
                        final isTouched = i == touchedIndex;
                        final fontSize = isTouched ? 18.0 : 12.0;
                        final radius = isTouched ? 65.0 : 55.0;
                        final percentage = (values[i] / sum) * 100;
                        
                        return PieChartSectionData(
                          color: _getColor(categories[i]),
                          value: values[i],
                          title: '${percentage.toStringAsFixed(0)}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Custom Indicator/Legends list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, idx) {
                    final catName = categories[idx];
                    final amount = totals[catName]!;
                    final pct = (amount / sum) * 100;
                    
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
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: _getColor(catName),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              catName,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            ),
                          ),
                          Text(
                            '\$${amount.toStringAsFixed(2)} (${pct.toStringAsFixed(1)}%)',
                            style: const TextStyle(color: AppTheme.textSecondary),
                          ),
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

  Color _getColor(String category) {
    switch (category.toLowerCase()) {
      case 'cloud':
        return const Color(0xFF7F5AF0); // violet
      case 'food':
        return const Color(0xFFFF8906); // orange
      case 'travel':
        return const Color(0xFF3DA9FC); // blue
      case 'subscriptions':
        return const Color(0xFFEF4565); // red
      case 'rent':
        return const Color(0xFF2CB67D); // green
      default:
        return const Color(0xFF94A1B2); // gray
    }
  }
}
