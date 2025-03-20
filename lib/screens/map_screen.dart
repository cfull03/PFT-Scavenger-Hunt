import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/location_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  final List<LatLng> scavengerLocations = [
    const LatLng(37.4275, -122.1697), // Library
    const LatLng(37.4280, -122.1700), // Engineering Hall
    const LatLng(37.4285, -122.1710), // Cafeteria
    const LatLng(37.4290, -122.1720), // Sports Complex
    const LatLng(37.4295, -122.1730), // Auditorium
  ];

  final List<bool> foundLocations = List.filled(5, false);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    _checkProximity();
  }

  void _checkProximity() {
    if (_currentPosition == null) return;

    for (int i = 0; i < scavengerLocations.length; i++) {
      double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        scavengerLocations[i].latitude,
        scavengerLocations[i].longitude,
      );

      if (distance < 20 && !foundLocations[i]) {
        setState(() {
          foundLocations[i] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎯 You found location ${i + 1}!')),
        );
      }
    }

    if (foundLocations.every((found) => found)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 All locations found! You completed the hunt!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering College Scavenger Hunt'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    LocationMarker(
                      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      color: Colors.blue,
                      label: 'You',
                    ),
                    for (int i = 0; i < scavengerLocations.length; i++)
                      LocationMarker(
                        position: scavengerLocations[i],
                        color: foundLocations[i] ? Colors.green : Colors.red,
                        label: 'Location ${i + 1}',
                      ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _getCurrentLocation();
          _checkProximity();
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
