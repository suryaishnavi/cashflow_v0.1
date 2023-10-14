import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue.shade900,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  // elevatedButtonTheme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue[800],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  // outlinedButtonTheme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      foregroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
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
