import 'package:flutter/material.dart';

class AppColors {
  static const brown = Color(0xFF6E5038);
  static const pink = Color(0xFFC98F9C);
  static const blue = Color(0xFF7E9BB5);
  static const green = Color(0xFF7F9B83);
  static const lightBrown = Color(0xFFA98B72);
  static const cream = Color(0xFFF8F4EF);
  static const dark = Color(0xFF292522);
  static const grey = Color(0xFF77716C);
  static const red = Color(0xFFC97A6D);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brown,
        primary: AppColors.brown,
        secondary: AppColors.pink,
        surface: AppColors.cream,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.dark,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.dark,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: AppColors.dark, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: AppColors.dark, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: AppColors.dark, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.dark),
        bodyMedium: TextStyle(color: AppColors.grey),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brown,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
