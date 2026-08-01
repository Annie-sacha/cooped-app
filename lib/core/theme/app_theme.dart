import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFFE2694B);       
  static const primaryDark = Color(0xFFB84A30);
  static const secondary = Color(0xFF17817A);     
  static const warning = Color(0xFFF4A259);
  static const danger = Color(0xFFD64550);
  static const background = Color(0xFFFFF8F2); 

  /*static const primary = Color(0xFF3E8E5A);       // vert sauge apaisant
  static const primaryDark = Color(0xFF2C6B42);
  static const secondary = Color(0xFF8FBF9F);      // vert tendre
  static const warning = Color(0xFFE0A458);
  static const danger = Color(0xFFC85C5C);
  static const background = Color(0xFFF6FAF7);  */

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
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A2E),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: primary.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11)),
        ),
      );
}