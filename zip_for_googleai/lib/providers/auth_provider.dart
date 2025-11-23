import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isLoggedIn = false;
  String _username = '';
  String _email = '';
  bool _initialized = false;

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    _username = _prefs.getString('username') ?? '';
    _email = _prefs.getString('email') ?? '';
    _initialized = true;
    notifyListeners();
  }

  Future<bool> signup(String username, String email, String password) async {
    if (!_initialized) await _initializeAuth();
    
    // Check if user already exists
    List<String>? users = _prefs.getStringList('users') ?? [];
    if (users.any((u) => u.contains(email))) {
      return false;
    }

    // Save new user
    users.add('$email|$password|$username');
    await _prefs.setStringList('users', users);
    
    // Login the user
    await _login(email, password);
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (!_initialized) await _initializeAuth();
    
    List<String>? users = _prefs.getStringList('users') ?? [];
    bool userExists = users.any((u) => u.split('|')[0] == email && u.split('|')[1] == password);
    
    if (userExists) {
      await _login(email, password);
      return true;
    }
    return false;
  }

  Future<void> _login(String email, String password) async {
    List<String>? users = _prefs.getStringList('users') ?? [];
    final user = users.firstWhere((u) => u.split('|')[0] == email);
    final parts = user.split('|');
    
    _email = parts[0];
    _username = parts[2];
    _isLoggedIn = true;
    
    await _prefs.setBool('isLoggedIn', true);
    await _prefs.setString('email', _email);
    await _prefs.setString('username', _username);
    
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = '';
    _email = '';
    
    await _prefs.setBool('isLoggedIn', false);
    await _prefs.remove('username');
    await _prefs.remove('email');
    
    notifyListeners();
  }
}
