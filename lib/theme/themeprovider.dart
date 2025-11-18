import 'package:flutter/material.dart';
import 'theme.dart';

class Themeprovider extends ChangeNotifier {
  bool _isDarkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  ThemeData get themeData => _isDarkMode ? darkMode : lightMode;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void systemThemeChanged(Brightness brightness) {
    _isDarkMode = brightness == Brightness.dark;
    notifyListeners();
}
}