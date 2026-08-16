import 'package:flutter/material.dart';

/// 全局主题：轻国风、温暖、极简、生活化。
class AppTheme {
  static const Color ivory = Color(0xFFFAF8F3);
  static const Color cream = Color(0xFFF7F3EA);
  static const Color wood = Color(0xFFB98252);
  static const Color woodLight = Color(0xFFD9A878);
  static const Color woodDark = Color(0xFF8C5A33);
  static const Color darkBrown = Color(0xFF292621);
  static const Color gray = Color(0xFF817A70);
  static const Color red = Color(0xFFB84A3A);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: wood,
          primary: wood,
          background: ivory,
          surface: ivory,
        ).copyWith(
          onBackground: darkBrown,
          onSurface: darkBrown,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(color: darkBrown, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: darkBrown, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(color: darkBrown, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: darkBrown),
          bodyMedium: TextStyle(color: darkBrown),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ivory,
          foregroundColor: darkBrown,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: cream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: wood,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: wood,
            side: const BorderSide(color: wood),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: ivory,
          selectedItemColor: wood,
          unselectedItemColor: gray,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      );
}
