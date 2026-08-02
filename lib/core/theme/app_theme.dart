import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF6C5CE7);
  static const primaryDark = Color(0xFF4834B8);
  static const secondary = Color(0xFF00B8A9);
  static const warning = Color(0xFFF6A94A);
  static const danger = Color(0xFFE85D75);
  static const background = Color(0xFFF6F5FB);

  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF9B7CF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          error: danger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1A1A2E),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: primary.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11)),
        ),
      );
}