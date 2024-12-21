import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;
  late ThemeMode _themeMode;
  
  ThemeProvider() {
    _themeMode = ThemeMode.system;
    _initPrefs();
  }
  
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
  }
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void _loadThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' 
          ? ThemeMode.dark 
          : savedTheme == 'light' 
              ? ThemeMode.light 
              : ThemeMode.system;
      notifyListeners();
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.toString().split('.').last);
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    await setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}
