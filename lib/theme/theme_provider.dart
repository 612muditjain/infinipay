import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _isDarkMode = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling theme: $e');
      // Revert the change if there's an error
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }

  static final lightTheme = ThemeData(
    primaryColor: Color(0xFF71C9CE), // Pastel Green
    scaffoldBackgroundColor: Color(0xFFE3FDFD), // Light Cyan
    cardColor: Color(0xFFCBF1F5), // Pale Pink
    colorScheme: ColorScheme.light(
      primary: Color(0xFF71C9CE),
      secondary: Color(0xFFA6E3E9), // Soft Yellow
      surface: Color(0xFFCBF1F5),
      background: Color(0xFFE3FDFD),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA6E3E9),
        foregroundColor: Colors.black87,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFFE3FDFD),
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: Color(0xFF1F3A57), // Deep Blue
    scaffoldBackgroundColor: Color(0xFF121212), // Dark Grey/Black
    cardColor: Color(0xFF1E1E1E),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1F3A57),
      secondary: Color(0xFFFF6A5C), // Soft Red
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF6A5C),
        foregroundColor: Colors.white,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
    ),
  );
}