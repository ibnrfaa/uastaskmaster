import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.white),
  scaffoldBackgroundColor: Colors.white,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
  scaffoldBackgroundColor: Colors.blueGrey,
);
 
