import 'package:flutter/material.dart'; 
import 'home.dart';
import 'theme.dart';

void main() => runApp(const MyApp()); 
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState(); 
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false; 
  void _toggleTheme() => setState(() => isDarkTheme = !isDarkTheme); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp', 
      theme: isDarkTheme ? darkTheme : lightTheme, 
      home: HomeScreen(onThemeChanged: _toggleTheme),
    );
  }
}
