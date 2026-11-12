import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _warnaDasar = Color(0xFF32693D);

  static final ThemeData lightTheme = _buatTema(Brightness.light);
  static final ThemeData darkTheme = _buatTema(Brightness.dark);

  static ThemeData _buatTema(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _warnaDasar,
        brightness: brightness,
      ),
    );
  }
}
