import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const PFTScavengerHuntApp());
}

class PFTScavengerHuntApp extends StatelessWidget {
  const PFTScavengerHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fierce for the Future',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF461D7C),
          primary: const Color(0xFF461D7C),
          secondary: const Color(0xFFFDD023),
        ),
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF461D7C),
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
