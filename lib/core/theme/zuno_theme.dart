import 'package:flutter/material.dart';
import 'zuno_colors.dart';

class ZunoTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ZunoColors.background,
    colorScheme: const ColorScheme.dark(
      primary: ZunoColors.primary,
      secondary: ZunoColors.secondary,
      surface: ZunoColors.card,
      background: ZunoColors.background,
      onSurface: ZunoColors.text,
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
  );
}
