import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'tasks/activity_task.dart';
import 'tasks/riddle_task.dart';
import 'tasks/picture_task.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? userLocation;
  final Distance distance = const Distance();

  final List<Map<String, dynamic>> locations = [
    {'name': 'Main Entrance', 'lat': 30.4123, 'lng': -91.1800, 'type': 'riddle', 'task': 'I roar but have no mouth, I guard but cannot move. What am I?'},
    {'name': 'Atrium', 'lat': 30.4125, 'lng': -91.1805, 'type': 'activity', 'task': 'Count the number of steps in the atrium.'},
    {'name': 'Lab Room 1', 'lat': 30.4127, 'lng': -91.1807, 'type': 'picture', 'task': 'Take a photo of the microscope.'},
    {'name': 'Lab Room 2', 'lat': 30.4129, 'lng': -91.1810, 'type': 'activity', 'task': 'Describe the project on display in Lab 2.'},
    {'name': 'Lecture Hall 1251', 'lat': 30.4131, 'lng': -91.1812, 'type': 'riddle', 'task': 'I talk without a mouth and hear without ears. What am I?'},
    {'name': 'Cheveron Center', 'lat': 30.4133, 'lng': -91.1814, 'type': 'picture', 'task': 'Take a photo of the oldest book you find.'},
    {'name': 'Main Lounge', 'lat': 30.4135, 'lng': -91.1816, 'type': 'activity', 'task': 'List your favorite food item here.'},
    {'name': 'Panera Bread', 'lat': 30.4137, 'lng': -91.1818, 'type': 'activity', 'task': 'Do 10 jumping jacks.'},
    {'name': 'Professor Hall Way', 'lat': 30.4139, 'lng': -91.1820, 'type': 'riddle', 'task': 'I rise with the sun and set with the moon, but never leave the roof. What am I?'},
    {'name': 'Exit Gate', 'lat': 30.4141, 'lng': -91.1822, 'type': 'picture', 'task': 'Take a photo with your team at the gate.'},
  ];

  final Set<String> checkedIn = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _showTaskWidget(Map<String, dynamic> loc) {
    double dist = userLocation != null
        ? distance(userLocation!, LatLng(loc['lat'], loc['lng']))
        : double.infinity;

    bool canCheckIn = dist < 30;

    if (!canCheckIn || checkedIn.contains(loc['name'])) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(loc['name']),
          content: const Text('Get closer to complete this task.\n\nDistance: \${dist.toStringAsFixed(1)} meters'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    Widget taskWidget;
    switch (loc['type']) {
      case 'riddle':
        taskWidget = RiddleTaskWidget(
          riddle: loc['task'],
          onComplete: () {
            setState(() {
              checkedIn.add(loc['name']);
            });
            Navigator.pop(context);
          },
        );
        break;
      case 'activity':
        taskWidget = ActivityTaskWidget(
          taskDescription: loc['task'],
          onComplete: () {
            setState(() {
              checkedIn.add(loc['name']);
            });
            Navigator.pop(context);
          },
        );
        break;
      case 'picture':
        taskWidget = PictureTaskWidget(
          instruction: loc['task'],
          onComplete: () {
            setState(() {
              checkedIn.add(loc['name']);
            });
          },
        );
        break;
      default:
        taskWidget = const SizedBox.shrink();
    }

    showDialog(
      context: context,
      builder: (_) => taskWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PFT Map'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          center: LatLng(30.4123, -91.1800),
          zoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              if (userLocation != null)
                Marker(
                  width: 50,
                  height: 50,
                  point: userLocation!,
                  child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
                ),
              ...locations.map<Marker>((loc) {
                final isCheckedIn = checkedIn.contains(loc['name']);
                return Marker(
                  width: 80,
                  height: 80,
                  point: LatLng(loc['lat'], loc['lng']),
                  child: GestureDetector(
                    onTap: () => _showTaskWidget(loc),
                    child: Tooltip(
                      message: loc['name'],
                      child: Icon(
                        Icons.location_on,
                        size: 30,
                        color: isCheckedIn ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
