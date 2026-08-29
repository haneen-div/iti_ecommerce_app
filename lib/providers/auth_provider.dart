import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? errorMessage;

  User? get user => _authService.currentUser;
  bool get isLoggedIn => _authService.currentUser != null;

  Future<bool> signUp(String name, String email, String password) => _run(
        () => _authService.signUpWithEmail(name, email, password),
  );

  Future<bool> signIn(String email, String password) => _run(
        () => _authService.signInWithEmail(email, password),
  );

  Future<bool> signInWithGoogle() => _run(() => _authService.signInWithGoogle());

  Future<bool> _run(Future<User?> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await action();
      isLoading = false;
      notifyListeners();
      return user != null;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      errorMessage = e.message ?? 'That was a mistake, try again.';
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'That was a mistake, try again.';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}