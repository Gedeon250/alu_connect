import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  AppUser? _currentUser;

  bool get isAuthenticated => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AppUser? get currentUser => _currentUser;

  AuthProvider() {
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool saved = prefs.getBool('is_logged_in') ?? false;
    if (saved) {
      _isLoggedIn = true;
      _currentUser = MockData.currentUser;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      _error = 'Please fill in all fields.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!email.contains('@alu')) {
      _error = 'Please use your ALU email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _error = 'Wrong password. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    _isLoggedIn = true;
    _currentUser = MockData.currentUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(
      String name, String email, String password, String campus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _error = 'Please fill in all fields.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!email.endsWith('@alustudent.com')) {
      _error = 'Please use your @alustudent.com email.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    _isLoggedIn = true;
    _currentUser = MockData.currentUser.copyWith(name: name, campus: campus);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
