import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.red,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
