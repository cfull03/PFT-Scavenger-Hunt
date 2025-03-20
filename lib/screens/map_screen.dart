import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/location_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _playerPosition = const LatLng(37.4275, -122.1697);

  final double moveStep = 0.0001;
  final List<LatLng> scavengerLocations = [
    const LatLng(37.4275, -122.1697),
    const LatLng(37.4280, -122.1700),
    const LatLng(37.4285, -122.1710),
    const LatLng(37.4290, -122.1720),
    const LatLng(37.4295, -122.1730),
  ];
  final List<bool> foundLocations = List.filled(5, false);

  void _movePlayer(double dLat, double dLng) {
    setState(() {
      _playerPosition = LatLng(
        _playerPosition.latitude + dLat,
        _playerPosition.longitude + dLng,
      );
    });
    _checkProximity();
  }

  void _checkProximity() {
    for (int i = 0; i < scavengerLocations.length; i++) {
      double distance = Distance().as(
        LengthUnit.Meter,
        _playerPosition,
        scavengerLocations[i],
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
        const SnackBar(content: Text('🎉 Hunt complete!')),
      );
    }
  }

  Widget _buildDirectionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scavenger Hunt')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _playerPosition,
              initialZoom: 17.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: _playerPosition,
                    child: Image.asset(
                      'assets/images/player_sprite.png',
                      fit: BoxFit.contain,
                    ),
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
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _buildDirectionButton('↑', () => _movePlayer(moveStep, 0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDirectionButton('←', () => _movePlayer(0, -moveStep)),
                    const SizedBox(width: 20),
                    _buildDirectionButton('→', () => _movePlayer(0, moveStep)),
                  ],
                ),
                _buildDirectionButton('↓', () => _movePlayer(-moveStep, 0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
