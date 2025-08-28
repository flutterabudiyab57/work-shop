import 'package:flutter/material.dart';

class AppTheme {
  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    fontFamily: 'Graphik Arabic',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 18),   // النصوص الكبيرة
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 16), // النصوص المتوسطة
      bodySmall: TextStyle(color: Colors.black54, fontSize: 14),  // النصوص الصغيرة
      titleLarge: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20), // العناوين
    ),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    fontFamily: 'Graphik Arabic',
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.indigo, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      bodySmall: TextStyle(color: Colors.white60, fontSize: 14),
      titleLarge: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
