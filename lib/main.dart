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
      title: 'PFT Scavenger Hunt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF461D7C),
          primary: const Color(0xFF461D7C),
          secondary: const Color(0xFFFDD023),
        ),
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF461D7C),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
