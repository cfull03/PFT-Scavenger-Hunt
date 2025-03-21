import 'package:flutter/material.dart';

class DestinationPage extends StatelessWidget {
  final String destination;
  final VoidCallback onCheckIn;

  const DestinationPage({super.key, required this.destination, required this.onCheckIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 100, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 20),
            const Text(
              'Find this location and press check-in!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                onCheckIn();
                Navigator.pop(context);
              },
              child: const Text('Check-In'),
            )
          ],
        ),
      ),
    );
  }
}
