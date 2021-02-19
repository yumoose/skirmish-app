import 'package:flutter/material.dart';

class SkirmishTheme {
  static const Color skirmishPrimary = Color.fromRGBO(239, 75, 98, 1);

  static ThemeData get light => ThemeData(
        primaryColor: skirmishPrimary,
        accentColor: Colors.amber,
        backgroundColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.grey[100],
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        primaryColor: skirmishPrimary,
        accentColor: Colors.amber,
        backgroundColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
      );
}
