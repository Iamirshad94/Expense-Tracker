// theme.dart
import 'package:flutter/material.dart';

class MyTheme {
  static const Color primaryColor = Color(0xFF000000); // Your primary color
  static const Color accentColor = Color(0xFFFFC107); // Your accent color
  static const Color textColorBlk = Colors.black; // Text color
  static const Color textColorWhite = Colors.white; // Text color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Background color
  static const Color colorBlack = Color(0xFF000000); // Background color
  static const Color colorWhite = Color(0xFFFFFFFF); // Background color
  static const Color colorGrey = Color(0xFFC1BFBF); // Background color

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 24.0,color: MyTheme.primaryColor),
      bodyLarge: TextStyle(fontSize: 20.0,color: colorBlack),
      bodyMedium: TextStyle(fontSize: 16.0, color: colorBlack),
      bodySmall: TextStyle(fontSize: 12.0,color: colorBlack),
    ),
  );
}
