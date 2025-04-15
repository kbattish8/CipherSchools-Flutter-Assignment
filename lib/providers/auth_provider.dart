import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider() {
    // Initialize user from current auth state
    _user = _authService.currentUser;
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      return userCredential.user != null;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final userCredential = await _authService.signUpWithEmailAndPassword(email, password);
      _setLoading(false);
      return userCredential.user != null;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);
    try {
      final userCredential = await _authService.signInWithGoogle();
      _setLoading(false);
      return userCredential.user != null;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
} 