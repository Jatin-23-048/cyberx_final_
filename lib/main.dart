import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Required for reset
import 'providers/app_state.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/community_screen.dart';
import 'screens/report_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- TEMPORARY: RESET FOR TESTING ---
  // This clears all saved data (Login, Settings) every time you restart the app.
  // Comment this out when you want to keep your login session!
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); 
  // -------------------------------------

  runApp(const DigitalDefenseApp());
}

class DigitalDefenseApp extends StatelessWidget {
  const DigitalDefenseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'CyberX',
            debugShowCheckedModeBanner: false,
            themeMode: appState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            
            // --- LIGHT THEME ---
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Light Grey
              cardColor: Colors.white,
              primaryColor: const Color(0xFF1e7dd6),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1e7dd6),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
                bodyColor: const Color(0xFF1F2937), // Dark Grey text
                displayColor: const Color(0xFF111827), // Nearly Black text
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1e7dd6),
                brightness: Brightness.light,
                surface: Colors.white,
                onSurface: const Color(0xFF1F2937),
              ),
            ),

            // --- DARK THEME (Your Original Design) ---
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF1a1a1a),
              cardColor: const Color(0xFF252f3d),
              primaryColor: const Color(0xFF1e7dd6),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1e7dd6),
                elevation: 0,
                centerTitle: false,
              ),
              textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF1e7dd6),
                surface: const Color(0xFF252f3d),
                onSurface: Colors.white,
                error: const Color(0xFFef4444),
              ),
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isLoggedIn) {
          return const LoginScreen();
        }
        return const MainApp();
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  final List<Widget> _screens = const [
    HomeScreen(),
    AlertsScreen(),
    LearningScreen(),
    CommunityScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          body: _screens[state.currentTabIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentTabIndex,
            onTap: (index) => state.setTabIndex(index),
            type: BottomNavigationBarType.fixed,
            // Dynamic Colors based on Theme
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF0a0a0a) 
                : Colors.white,
            selectedItemColor: const Color(0xFF1e7dd6),
            unselectedItemColor: Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF90A4AE) 
                : Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alerts'),
              BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
              BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Community'),
              BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Report'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}