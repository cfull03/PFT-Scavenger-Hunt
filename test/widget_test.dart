import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scavenger_hunt_pft/main.dart';

void main() {
  testWidgets('App loads with home screen', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const PFTScavengerHuntApp());

    // Verify that the home screen loads by checking for the title.
    expect(find.text('Scavenger Hunt - Engineering College'), findsOneWidget);
    
    // Optionally, check for any expected widgets on the MapScreen.
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
