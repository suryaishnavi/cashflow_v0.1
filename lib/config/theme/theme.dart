import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue.shade900,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),

  // floating button.extended theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue[800],
    foregroundColor: Colors.white,
    extendedTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
  ),
);
