import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/navigation_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  UserSession? _currentUser;
  bool _initialized = true; // start as true — default is logged out

  @override
  void initState() {
    super.initState();
    // Listen to authentication state changes
    _authService.authStateChanges.listen((session) {
      if (mounted) {
        setState(() {
          _currentUser = session;
        });
      }
    });
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppTheme.accent),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        title: 'Cloud Expense Tracer',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: _currentUser == null
            ? AuthScreen(
                authService: _authService,
                onLoginSuccess: () {
                  // Handled by state listener authStateChanges
                },
              )
            : NavigationShell(
                userName: _currentUser!.displayName,
                onLogOut: () {
                  _authService.logOut();
                },
              ),
      ),
    );
  }
}
