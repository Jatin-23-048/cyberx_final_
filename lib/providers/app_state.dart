import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/threat.dart';
import '../models/course.dart';
import '../models/discussion.dart';
import '../models/report.dart';

class AppState extends ChangeNotifier {
  late SharedPreferences _prefs;

  List<Threat> _threats = [];
  List<Course> _courses = [];
  List<Discussion> _discussions = [];
  List<Report> _reports = [];
  
  double _securityScore = 78;
  String _currentThreatLevel = 'Medium';
  // Navigation index for main app bottom navigation
  int _currentTabIndex = 0;
  
  // NEW: State for user preferences
  bool _isEmailNotificationEnabled = true;
  bool _isPushNotificationEnabled = true;
  bool _isDarkModeEnabled = false;

  // NEW: Getters for settings
  bool get isEmailNotificationEnabled => _isEmailNotificationEnabled;
  bool get isPushNotificationEnabled => _isPushNotificationEnabled;
  bool get isDarkModeEnabled => _isDarkModeEnabled;
  // Getter for bottom navigation index
  int get currentTabIndex => _currentTabIndex;

  // Setter method to update tab index and persist if needed
  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  AppState() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadMockData();
    // NEW: Load settings on startup
    _loadSettings();
  }

  void _loadSettings() {
    _isEmailNotificationEnabled = _prefs.getBool('emailNotifications') ?? true;
    _isPushNotificationEnabled = _prefs.getBool('pushNotifications') ?? true;
    _isDarkModeEnabled = _prefs.getBool('darkMode') ?? false;
    // Note: Dark Mode functionality must be implemented in main.dart's MaterialApp
    // if you want the switch to change the app theme globally.
  }

  // NEW: Reset the app to initial state (clears stored data and reloads mocks)
  Future<void> resetApp() async {
    await _prefs.clear();
    _threats = [];
    _courses = [];
    _discussions = [];
    _reports = [];
    _securityScore = 78;
    _currentThreatLevel = 'Medium';
    _isEmailNotificationEnabled = true;
    _isPushNotificationEnabled = true;
    _isDarkModeEnabled = false;
    // Recreate mock data
    _addMockThreats();
    _addMockCourses();
    _addMockDiscussions();
    notifyListeners();
  }

  // NEW: Toggle methods for ProfileScreen
  Future<void> toggleEmailNotifications(bool value) async {
    _isEmailNotificationEnabled = value;
    await _prefs.setBool('emailNotifications', value);
    notifyListeners();
  }

  Future<void> togglePushNotifications(bool value) async {
    _isPushNotificationEnabled = value;
    await _prefs.setBool('pushNotifications', value);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkModeEnabled = value;
    await _prefs.setBool('darkMode', value);
    // You would typically call a method to rebuild the MaterialApp here,
    // but we will apply the fix in main.dart next.
    notifyListeners();
  }

  void _loadMockData() {
    if ((_prefs.getStringList('threats') ?? []).isEmpty) {
      _addMockThreats();
    }
    if ((_prefs.getStringList('courses') ?? []).isEmpty) {
      _addMockCourses();
    }
    if ((_prefs.getStringList('discussions') ?? []).isEmpty) {
      _addMockDiscussions();
    }
    _loadDataFromStorage();
  }

  void _addMockThreats() {
    final uuid = Uuid();
    final threats = [
      // ... (Mock data creation remains the same)
      Threat(
        id: uuid.v4(),
        title: 'Banking Trojan Campaign',
        description: 'New banking trojan targeting mobile banking applications in North America.',
        severity: 'CRITICAL',
        status: 'ACTIVE',
        region: 'North America',
        source: 'FBI Division',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        mitigation: 'Update your banking app and enable 2FA.',
      ),
      Threat(
        id: uuid.v4(),
        title: 'Microsoft Exchange Vulnerability',
        description: 'Critical vulnerability in Microsoft Exchange affecting millions of servers.',
        severity: 'HIGH',
        status: 'ACTIVE',
        region: 'Global',
        source: 'CVE Database',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        cveId: 'CVE-2024-XXXX',
        mitigation: 'Apply latest security patches immediately.',
      ),
      Threat(
        id: uuid.v4(),
        title: 'Phishing Campaigns Targeting Financial Institutions',
        description: 'Increased phishing activity targeting banking sector employees.',
        severity: 'HIGH',
        status: 'MONITORING',
        region: 'Global',
        source: 'Threat Intelligence Feed',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Threat(
        id: uuid.v4(),
        title: 'Ransomware Attack on Healthcare',
        description: 'LockBit ransomware targeting healthcare providers.',
        severity: 'CRITICAL',
        status: 'ACTIVE',
        region: 'Europe',
        source: 'CISA',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Threat(
        id: uuid.v4(),
        title: 'Zero-Day Exploit in Chrome',
        description: 'Unpatched vulnerability found in Chrome browser.',
        severity: 'CRITICAL',
        status: 'ACTIVE',
        region: 'Global',
        source: 'Google Security Team',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    final threatStrings = threats.map((t) => jsonEncode(t.toJson())).toList();
    _prefs.setStringList('threats', threatStrings);
    _threats = threats;
  }

  void _addMockCourses() {
    final uuid = Uuid();
    final courses = [
      // ... (Mock data creation remains the same)
      Course(
        id: uuid.v4(),
        title: 'Password Security Fundamentals',
        category: 'Security Basics',
        description: 'Learn how to create and manage strong passwords.',
        lessons: 12,
        duration: 45,
        rating: 4.8,
        progress: 1.0,
        completed: true,
      ),
      Course(
        id: uuid.v4(),
        title: 'Phishing Recognition Training',
        category: 'Threat Awareness',
        description: 'Identify and avoid phishing attacks with real-world examples.',
        lessons: 8,
        duration: 30,
        rating: 4.9,
        progress: 0.75,
        completed: false,
      ),
      Course(
        id: uuid.v4(),
        title: 'Safe Browsing Practices',
        category: 'Security Basics',
        description: 'Browse safely and protect your online privacy.',
        lessons: 10,
        duration: 35,
        rating: 4.7,
        progress: 0.0,
        completed: false,
      ),
      Course(
        id: uuid.v4(),
        title: 'Malware Identification',
        category: 'Threat Analysis',
        description: 'Recognize and respond to malware threats.',
        lessons: 15,
        duration: 50,
        rating: 4.6,
        progress: 0.5,
        completed: false,
      ),
      Course(
        id: uuid.v4(),
        title: 'Social Engineering Awareness',
        category: 'Human Security',
        description: 'Understand social engineering tactics and defend against them.',
        lessons: 9,
        duration: 40,
        rating: 4.8,
        progress: 0.25,
        completed: false,
      ),
    ];

    final courseStrings = courses.map((c) => jsonEncode(c.toJson())).toList();
    _prefs.setStringList('courses', courseStrings);
    _courses = courses;
  }

  void _addMockDiscussions() {
    final uuid = Uuid();
    final discussions = [
      // ... (Mock data creation remains the same)
      Discussion(
        id: uuid.v4(),
        title: 'How to recognize suspicious emails?',
        category: 'General Question',
        content: 'I received an email asking me to verify my bank account. What should I do?',
        authorId: 'user1',
        authorName: 'Sarah Johnson',
        isVerified: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        replies: 12,
        likes: 8,
      ),
      Discussion(
        id: uuid.v4(),
        title: 'Best practices for password management',
        category: 'Best Practices',
        content: 'What password managers do you recommend and trust?',
        authorId: 'user2',
        authorName: 'Alex Chen',
        isVerified: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        replies: 23,
        likes: 45,
      ),
      Discussion(
        id: uuid.v4(),
        title: 'Dealing with ransomware threats',
        category: 'Incident Response',
        content: 'Our company was targeted by ransomware. Here\'s what we did to recover.',
        authorId: 'expert1',
        authorName: 'Dr. Marcus Field',
        isVerified: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        replies: 34,
        likes: 145,
      ),
    ];

    final discussionStrings = discussions.map((d) => jsonEncode(d.toJson())).toList();
    _prefs.setStringList('discussions', discussionStrings);
    _discussions = discussions;
  }

  void _loadDataFromStorage() {
    final threatStrings = _prefs.getStringList('threats') ?? [];
    _threats = threatStrings
        .map((e) => Threat.fromJson(jsonDecode(e)))
        .toList();

    final courseStrings = _prefs.getStringList('courses') ?? [];
    _courses = courseStrings
        .map((e) => Course.fromJson(jsonDecode(e)))
        .toList();

    final discussionStrings = _prefs.getStringList('discussions') ?? [];
    _discussions = discussionStrings
        .map((e) => Discussion.fromJson(jsonDecode(e)))
        .toList();
  }

  // Threats
  List<Threat> get threats => _threats;
  List<Threat> getThreats({String? filter}) {
    if (filter == null) return _threats;
    return _threats.where((t) => t.status == filter).toList();
  }

  void updateCourseProgress(String courseId, double progress) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final updated = _courses[index];
      _courses[index] = Course(
        id: updated.id,
        title: updated.title,
        category: updated.category,
        description: updated.description,
        lessons: updated.lessons,
        duration: updated.duration,
        rating: updated.rating,
        progress: progress,
        completed: progress >= 0.99,
      );
      _updateSecurityScore();
      
      final courseStrings = _courses.map((c) => jsonEncode(c.toJson())).toList();
      _prefs.setStringList('courses', courseStrings);
      
      notifyListeners();
    }
  }

  void _updateSecurityScore() {
    double totalProgress = _courses.fold(0, (sum, c) => sum + c.progress);
    _securityScore = (totalProgress / _courses.length * 100).clamp(0, 100);
  }

  // Courses
  List<Course> get courses => _courses;
  Course? getCourseById(String id) => _courses.firstWhere(
    (c) => c.id == id,
    orElse: () => Course(
      id: '',
      title: '',
      category: '',
      description: '',
      lessons: 0,
      duration: 0,
      rating: 0,
      progress: 0,
    ),
  );

  // Discussions
  List<Discussion> get discussions => _discussions;

  void addDiscussion(String title, String category, String content) {
    final uuid = Uuid();
    final discussion = Discussion(
      id: uuid.v4(),
      title: title,
      category: category,
      content: content,
      authorId: 'currentUser',
      authorName: 'You',
      isVerified: false,
      timestamp: DateTime.now(),
      replies: 0,
      likes: 0,
    );
    _discussions.insert(0, discussion);
    
    final discussionStrings = _discussions.map((d) => jsonEncode(d.toJson())).toList();
    _prefs.setStringList('discussions', discussionStrings);
    
    notifyListeners();
  }

  // Reports
  List<Report> get reports {
    final reportStrings = _prefs.getStringList('reports') ?? [];
    return reportStrings
        .map((e) => Report.fromJson(jsonDecode(e)))
        .toList();
  }

  void submitReport(String threatType, String subject, String description) {
    final uuid = Uuid();
    final report = Report(
      id: uuid.v4(),
      threatType: threatType,
      subject: subject,
      description: description,
      status: 'Under Review',
      timestamp: DateTime.now(),
    );
    
    final reportStrings = _prefs.getStringList('reports') ?? [];
    reportStrings.add(jsonEncode(report.toJson()));
    _prefs.setStringList('reports', reportStrings);
    
    notifyListeners();
  }

  // Security Score
  double get securityScore => _securityScore;
  String get currentThreatLevel => _currentThreatLevel;
}