import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isLoggedIn = false;
  String _username = '';
  String _email = '';
  DateTime? _joinDate;
  bool _initialized = false;

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;
  DateTime? get joinDate => _joinDate;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    _username = _prefs.getString('username') ?? '';
    _email = _prefs.getString('email') ?? '';
    
    String? dateStr = _prefs.getString('joinDate');
    if (dateStr != null) {
      _joinDate = DateTime.tryParse(dateStr);
    }

    _initialized = true;
    notifyListeners();
  }

  Future<bool> signup(String username, String email, String password) async {
    if (!_initialized) await _initializeAuth();
    
    // Store user with Join Date
    List<String>? users = _prefs.getStringList('users') ?? [];
    if (users.any((u) => u.startsWith(email))) {
      return false; // User exists
    }

    final now = DateTime.now();
    // Format: email|password|username|joinDate
    users.add('$email|$password|$username|${now.toIso8601String()}');
    await _prefs.setStringList('users', users);
    
    await _login(email, password, username, now);
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (!_initialized) await _initializeAuth();
    
    List<String>? users = _prefs.getStringList('users') ?? [];
    
    try {
      final userEntry = users.firstWhere(
        (u) {
          final parts = u.split('|');
          return parts[0] == email && parts[1] == password;
        },
        orElse: () => '',
      );
      
      if (userEntry.isNotEmpty) {
        final parts = userEntry.split('|');
        final username = parts[2];
        final joinDate = DateTime.tryParse(parts[3]) ?? DateTime.now();
        await _login(email, password, username, joinDate);
        return true;
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return false;
  }

  Future<void> _login(String email, String password, String username, DateTime joinDate) async {
    _email = email;
    _username = username;
    _joinDate = joinDate;
    _isLoggedIn = true;
    
    await _prefs.setBool('isLoggedIn', true);
    await _prefs.setString('username', username);
    await _prefs.setString('email', email);
    await _prefs.setString('joinDate', joinDate.toIso8601String());
    
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = '';
    _email = '';
    _joinDate = null;
    
    await _prefs.setBool('isLoggedIn', false);
    await _prefs.remove('username');
    await _prefs.remove('email');
    await _prefs.remove('joinDate');
    
    notifyListeners();
  }
}