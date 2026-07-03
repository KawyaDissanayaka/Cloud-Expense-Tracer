import 'dart:async';

class UserSession {
  final String uid;
  final String email;
  final String displayName;

  UserSession({
    required this.uid,
    required this.email,
    required this.displayName,
  });
}

class AuthService {
  UserSession? _currentUser;
  final StreamController<UserSession?> _authStateController = StreamController<UserSession?>.broadcast();

  UserSession? get currentUser => _currentUser;
  Stream<UserSession?> get authStateChanges => _authStateController.stream;

  AuthService() {
    // Initial state: signed out
    _authStateController.add(null);
  }

  Future<UserSession> logIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    if (email.contains('@') && password.length >= 6) {
      final name = email.split('@')[0].toUpperCase();
      final user = UserSession(
        uid: 'user_123',
        email: email,
        displayName: name,
      );
      _currentUser = user;
      _authStateController.add(user);
      return user;
    } else {
      throw Exception('Invalid email or password (min 6 characters required).');
    }
  }

  Future<UserSession> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    if (email.contains('@') && password.length >= 6 && name.isNotEmpty) {
      final user = UserSession(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: name,
      );
      _currentUser = user;
      _authStateController.add(user);
      return user;
    } else {
      throw Exception('Please fill all fields correctly. Password must be at least 6 characters.');
    }
  }

  Future<void> logOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}
