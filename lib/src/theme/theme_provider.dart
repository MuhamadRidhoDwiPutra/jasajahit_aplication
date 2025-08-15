import 'package:flutter/material.dart';
// ignore: unused_import
import 'dynamic_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _adminThemeMode = ThemeMode.system;
  ThemeMode _customerThemeMode = ThemeMode.system;
  String _currentUserType = 'customer'; // 'admin' atau 'customer'

  ThemeMode get themeMode {
    if (_currentUserType == 'admin') {
      return _adminThemeMode;
    } else {
      return _customerThemeMode;
    }
  }

  ThemeMode get adminThemeMode => _adminThemeMode;
  ThemeMode get customerThemeMode => _customerThemeMode;

  bool get isDarkMode {
    if (_currentUserType == 'admin') {
      if (_adminThemeMode == ThemeMode.system) {
        return WidgetsBinding.instance.window.platformBrightness ==
            Brightness.dark;
      }
      return _adminThemeMode == ThemeMode.dark;
    } else {
      if (_customerThemeMode == ThemeMode.system) {
        return WidgetsBinding.instance.window.platformBrightness ==
            Brightness.dark;
      }
      return _customerThemeMode == ThemeMode.dark;
    }
  }

  void setCurrentUserType(String userType) {
    _currentUserType = userType;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    if (_currentUserType == 'admin') {
      _adminThemeMode = mode;
    } else {
      _customerThemeMode = mode;
    }
    notifyListeners();
  }

  void setAdminTheme(ThemeMode mode) {
    _adminThemeMode = mode;
    notifyListeners();
  }

  void setCustomerTheme(ThemeMode mode) {
    _customerThemeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    if (_currentUserType == 'admin') {
      if (_adminThemeMode == ThemeMode.light) {
        _adminThemeMode = ThemeMode.dark;
      } else if (_adminThemeMode == ThemeMode.dark) {
        _adminThemeMode = ThemeMode.light;
      } else {
        // If system, toggle to light
        _adminThemeMode = ThemeMode.light;
      }
    } else {
      if (_customerThemeMode == ThemeMode.light) {
        _customerThemeMode = ThemeMode.light;
      } else if (_customerThemeMode == ThemeMode.dark) {
        _customerThemeMode = ThemeMode.light;
      } else {
        // If system, always light for customer
        _customerThemeMode = ThemeMode.light;
      }
    }
    notifyListeners();
  }

  void toggleAdminTheme() {
    if (_adminThemeMode == ThemeMode.light) {
      _adminThemeMode = ThemeMode.dark;
    } else if (_adminThemeMode == ThemeMode.dark) {
      _adminThemeMode = ThemeMode.light;
    } else {
      // If system, toggle to light
      _adminThemeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void toggleCustomerTheme() {
    // Customer always stays in light mode
    _customerThemeMode = ThemeMode.light;
    notifyListeners();
  }
}
