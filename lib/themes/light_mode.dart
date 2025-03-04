import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF9FCFF), // 'background' is deprecated
    secondary: Color(0xFFE7F1FF),  // lightest  // 0xFFD0E3FF // 0xFFE7F1FF
    primary: Color(0xFF7096D1),        // 0xFF7096D1
    tertiary: Color(0xFF334EAC),       // 0xFF334EAC
    inversePrimary: Color(0xFF081F5C), // darkest // 0xFF081F5C
    inverseSurface: Colors.black,
  )
);