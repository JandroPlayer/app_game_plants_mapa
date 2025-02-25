import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Color _backgroundColor = Colors.white;
  Color get backgroundColor => _backgroundColor;

  Color _textColor = Colors.black;
  Color get textColor => _textColor;

  ThemeProvider() {
    _loadTheme();
  }

  // Carregar el tema desde SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    _updateThemeColors();
    notifyListeners(); // Notificar als oyents quan els valors cambien
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);

    _updateThemeColors();
    notifyListeners(); // Notificar als oyents quan els valors cambien
  }

  void _updateThemeColors() {
    if (_isDarkMode) {
      _backgroundColor = Color(0xFF181A20);
      _textColor = Colors.white;
    } else {
      _backgroundColor = Colors.white;
      _textColor = Color(0xFF181A20);
    }
  }
}
