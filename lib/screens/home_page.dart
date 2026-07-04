import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../screens/auth_screen.dart';
import '../screens/register_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Welcome', style: GoogleFonts.inter(color: Colors.white70, fontSize: 24)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AuthScreen(
                    authService: authService,
                    onLoginSuccess: () {},
                  ),
                ));
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), side: const BorderSide(color: AppTheme.accent)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: const Text('Register'),
            ),
          ],
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
