import 'package:flutter/material.dart';
import 'destination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> destinations = [
    'Main Entrance', 'Atrium', 'Lab Room 1', 'Lab Room 2',
    'Lecture Hall', 'Library', 'Cafeteria', 'Gym',
    'Rooftop Garden', 'Exit Gate'
  ];

  final Set<String> completedDestinations = {};

  void markCompleted(String destination) {
    setState(() {
      completedDestinations.add(destination);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = completedDestinations.length / destinations.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PFT Scavenger Hunt'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress: ${completedDestinations.length}/${destinations.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: Theme.of(context).colorScheme.secondary,
                  minHeight: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final isCompleted = completedDestinations.contains(destination);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(
                      isCompleted ? Icons.check_circle : Icons.location_on,
                      color: isCompleted ? Colors.green : Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(destination,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DestinationPage(
                            destination: destination,
                            onCheckIn: () => markCompleted(destination),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
