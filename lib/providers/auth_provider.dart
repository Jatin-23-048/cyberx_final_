// File: lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //

class AuthProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isLoggedIn = false;
  String _username = '';
  String _email = '';
  // NEW: Store and track user's join date.
  DateTime? _joinDate; 
  bool _initialized = false;

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;
  // NEW: Getter for join date.
  DateTime? get joinDate => _joinDate;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false; //
    _username = _prefs.getString('username') ?? ''; //
    _email = _prefs.getString('email') ?? ''; //
    
    // NEW: Load the join date from storage.
    String? joinDateString = _prefs.getString('joinDate');
    if (joinDateString != null) {
      _joinDate = DateTime.tryParse(joinDateString);
    }
    
    _initialized = true;
    notifyListeners();
  }

  Future<bool> signup(String username, String email, String password) async {
    if (!_initialized) await _initializeAuth();
    
    // Check if user already exists
    List<String>? users = _prefs.getStringList('users') ?? []; //
    if (users.any((u) => u.contains(email))) {
      return false; // User already exists
    }

    // Capture the current time as the join date
    final newJoinDate = DateTime.now().toIso8601String(); 

    // Save new user (User data is stored as a pipe-separated string: email|password|username|joinDate)
    users.add('$email|$password|$username|$newJoinDate');
    await _prefs.setStringList('users', users); //
    
    // Login the user
    await _login(email, password, newJoinDate); // Pass the date to _login
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (!_initialized) await _initializeAuth();
    
    List<String>? users = _prefs.getStringList('users') ?? []; //
    
    final userEntry = users.firstWhere(
      (u) {
        final parts = u.split('|');
        return parts[0] == email && parts[1] == password;
      },
      orElse: () => '',
    );
    
    if (userEntry.isNotEmpty) {
      // Pass the joinDate (index 3) to _login
      final joinDateString = userEntry.split('|')[3]; 
      await _login(email, password, joinDateString);
      return true;
    }
    return false;
  }

  // Modified _login to accept joinDateString
  Future<void> _login(String email, String password, String joinDateString) async {
    List<String>? users = _prefs.getStringList('users') ?? []; //
    final user = users.firstWhere((u) => u.split('|')[0] == email);
    final parts = user.split('|');
    
    _email = parts[0];
    _username = parts[2];
    _isLoggedIn = true;
    
    // NEW: Set and save the join date
    _joinDate = DateTime.tryParse(joinDateString);
    await _prefs.setString('joinDate', joinDateString); 
    
    await _prefs.setBool('isLoggedIn', true); //
    await _prefs.setString('email', _email); //
    await _prefs.setString('username', _username); //
    
    notifyListeners();
  }

  Future<void> logout() async {
    // ... (rest of logout remains the same)
    _isLoggedIn = false;
    _username = '';
    _email = '';
    _joinDate = null; // Clear date on logout
    
    await _prefs.setBool('isLoggedIn', false); //
    await _prefs.remove('username'); //
    await _prefs.remove('email'); //
    await _prefs.remove('joinDate'); // Remove join date
    
    notifyListeners();
  }

  // Update profile information (username and/or email)
  Future<bool> updateProfile({String? newUsername, String? newEmail}) async {
    if (!_initialized) await _initializeAuth();
    final users = _prefs.getStringList('users') ?? [];
    final idx = users.indexWhere((u) => u.split('|')[0] == _email);
    if (idx == -1) return false;

    final parts = users[idx].split('|');
    final password = parts[1];
    final joinDate = parts.length > 3 ? parts[3] : DateTime.now().toIso8601String();
    final updatedEmail = newEmail ?? _email;
    final updatedUsername = newUsername ?? _username;

    users[idx] = '$updatedEmail|$password|$updatedUsername|$joinDate';
    await _prefs.setStringList('users', users);

    // Update stored quick prefs
    _email = updatedEmail;
    _username = updatedUsername;
    await _prefs.setString('email', _email);
    await _prefs.setString('username', _username);

    notifyListeners();
    return true;
  }
}