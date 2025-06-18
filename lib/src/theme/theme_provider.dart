import 'package:flutter/material.dart';
// ignore: unused_import
import 'dynamic_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool? get isDarkMode => null;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setThemeMode(bool bool) {}
}
