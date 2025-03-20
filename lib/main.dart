import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const ScavengerHuntApp());
}

class ScavengerHuntApp extends StatelessWidget {
  const ScavengerHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scavenger Hunt - Engineering College',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapScreen(),
    );
  }
}
