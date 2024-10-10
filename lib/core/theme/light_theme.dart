import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black54),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
