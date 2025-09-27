import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../../../../../core/init/notifier/custom_theme.dart';
import '../../../../_main/provider/ar_provider.dart';
import '../../../../_main/provider/location_provider.dart';
import '../../../../_main/model/ar_models.dart';

class ARMapScreen extends StatefulWidget {
  const ARMapScreen({super.key});

  @override
  State<ARMapScreen> createState() => _ARMapScreenState();
}

class _ARMapScreenState extends State<ARMapScreen> {
  GoogleMapController? _mapController;
  CameraController? _cameraController;
  bool _showAROverlay = false;
  bool _isMapInitialized = false;
  late Position _currentPosition;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _initializeARMap();
  }

  Future<void> _initializeARMap() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _isMapInitialized = true;
    });

    // Initialize AR camera
    await _initializeCamera();

    // Load AR objects
    context.read<ARProvider>().refreshARObjects();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMapInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Google Maps Base
          _buildGoogleMap(),

          // AR Camera Overlay (when enabled)
          if (_showAROverlay) _buildAROverlay(),

          // UI Controls
          _buildMapControls(),

          // AR Objects Info Panel
          _buildARObjectsPanel(),

          // Mini Map Toggle
          _buildMiniMapToggle(),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return Consumer<ARProvider>(
      builder: (context, arProvider, child) {
        _updateMarkers(arProvider);

        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _setMapStyle();
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _currentPosition.latitude,
              _currentPosition.longitude,
            ),
            zoom: 16.0,
          ),
          markers: _markers,
          circles: _circles,
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          onTap: (LatLng position) => _onMapTap(position),
        );
      },
    );
  }

  void _updateMarkers(ARProvider arProvider) {
    _markers.clear();
    _circles.clear();

    // Player spawn radius
    _circles.add(
      Circle(
        circleId: const CircleId('spawn_radius'),
        center: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        radius: 200, // 200m radius
        strokeColor: Colors.blue.withOpacity(0.5),
        fillColor: Colors.blue.withOpacity(0.1),
        strokeWidth: 2,
      ),
    );

    // Monster markers
    for (final monster in arProvider.allMonsters) {
      if (monster.location != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(monster.id ?? ''),
            position: LatLng(
              monster.location!.latitude,
              monster.location!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              monster.isPersonal
                  ? BitmapDescriptor.hueMagenta
                  : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: monster.name,
              snippet: '${monster.type} - Level ${monster.level ?? 1}',
            ),
            onTap: () => _onMonsterMarkerTap(monster),
          ),
        );
      }
    }

    // Resource markers
    for (final resource in arProvider.nearbyResources) {
      if (resource.location != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(resource.id ?? ''),
            position: LatLng(
              resource.location!.latitude,
              resource.location!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: InfoWindow(
              title: resource.type,
              snippet: 'Quantity: ${resource.quantity}',
            ),
            onTap: () => _onResourceMarkerTap(resource),
          ),
        );
      }
    }
  }

  Widget _buildAROverlay() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Stack(
          children: [
            // AR Camera preview
            Positioned.fill(child: CameraPreview(_cameraController!)),

            // AR objects overlay
            _buildARObjectsOverlay(),

            // AR UI elements
            _buildARUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildARObjectsOverlay() {
    return Consumer<ARProvider>(
      builder: (context, arProvider, child) {
        return Stack(
          children: [
            // Render AR monsters
            ...arProvider.allMonsters.map((monster) {
              if (!arProvider.isMonsterInRange(monster)) return Container();

              final position = _calculateARPosition(monster.location!);
              return Positioned(
                left: position.dx - 30,
                top: position.dy - 60,
                child: _buildARMonsterWidget(monster),
              );
            }).toList(),

            // Render AR resources
            ...arProvider.nearbyResources.map((resource) {
              if (!arProvider.isResourceInRange(resource)) return Container();

              final position = _calculateARPosition(resource.location!);
              return Positioned(
                left: position.dx - 25,
                top: position.dy - 50,
                child: _buildARResourceWidget(resource),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildARMonsterWidget(ARMonster monster) {
    return GestureDetector(
      onTap: () => _engageMonster(monster),
      child: Container(
        width: 60,
        height: 80,
        decoration: BoxDecoration(
          color: monster.isPersonal
              ? Colors.purple.withOpacity(0.8)
              : Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: (monster.isPersonal ? Colors.purple : Colors.red)
                  .withOpacity(0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(monster.type ?? '🐉', style: TextStyle(fontSize: 24)),
            Text(
              'Lv.${monster.level ?? 1}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            if (monster.isPersonal)
              Icon(Icons.star, color: Colors.yellow, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildARResourceWidget(ARResource resource) {
    return GestureDetector(
      onTap: () => _harvestResource(resource),
      child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getResourceIcon(resource.type),
              color: Colors.white,
              size: 20,
            ),
            Text(
              '${resource.quantity}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Back button
          FloatingActionButton.small(
            heroTag: "back",
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.black.withOpacity(0.7),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),

          Spacer(),

          // AR Toggle
          FloatingActionButton.small(
            heroTag: "ar_toggle",
            onPressed: () => setState(() => _showAROverlay = !_showAROverlay),
            backgroundColor: _showAROverlay
                ? Colors.blue
                : Colors.black.withOpacity(0.7),
            child: Icon(
              _showAROverlay ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),

          SizedBox(width: 8),

          // Refresh button
          FloatingActionButton.small(
            heroTag: "refresh",
            onPressed: () => context.read<ARProvider>().refreshARObjects(),
            backgroundColor: Colors.green.withOpacity(0.7),
            child: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildARObjectsPanel() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Consumer<ARProvider>(
        builder: (context, arProvider, child) {
          final stats = arProvider.getSpawnStats();

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🗺️ AR Map Overview',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _showAROverlay ? 'AR Mode' : 'Map Mode',
                      style: TextStyle(
                        color: _showAROverlay ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatChip('🐉 ${stats['totalMonsters']}', Colors.red),
                    SizedBox(width: 8),
                    _buildStatChip(
                      '⭐ ${stats['personalMonsters']}',
                      Colors.purple,
                    ),
                    SizedBox(width: 8),
                    _buildStatChip(
                      '🌿 ${arProvider.nearbyResources.length}',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniMapToggle() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: FloatingActionButton.small(
        heroTag: "minimap",
        onPressed: () => _toggleMiniMap(),
        backgroundColor: Colors.indigo.withOpacity(0.8),
        child: Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11)),
    );
  }

  // Helper methods
  Offset _calculateARPosition(ARLocation location) {
    // Calculate AR position based on device orientation and distance
    // This is a simplified calculation - in real implementation, you'd use
    // proper AR calculations with camera parameters
    final center = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    return center +
        Offset(
          (location.longitude - _currentPosition.longitude) * 10000,
          (location.latitude - _currentPosition.latitude) * 10000,
        );
  }

  IconData _getResourceIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'wood':
        return Icons.park;
      case 'stone':
        return Icons.landscape;
      case 'metal':
        return Icons.build;
      case 'crystal':
        return Icons.diamond;
      default:
        return Icons.category;
    }
  }

  void _setMapStyle() {
    _mapController?.setMapStyle('''
      [
        {
          "featureType": "all",
          "stylers": [{"saturation": -80}]
        },
        {
          "featureType": "road.arterial",
          "elementType": "geometry",
          "stylers": [{"hue": "#00ffee"}, {"saturation": 50}]
        }
      ]
    ''');
  }

  // Event handlers
  void _onMapTap(LatLng position) {
    // Handle map tap - maybe show location info
  }

  void _onMonsterMarkerTap(ARMonster monster) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildMonsterDetailSheet(monster),
    );
  }

  void _onResourceMarkerTap(ARResource resource) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildResourceDetailSheet(resource),
    );
  }

  Widget _buildMonsterDetailSheet(ARMonster monster) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(monster.type ?? '🐉', style: TextStyle(fontSize: 40)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monster.name ?? 'Unknown Monster',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Level ${monster.level ?? 1} ${monster.isPersonal ? '(Personal)' : '(Global)'}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _engageMonster(monster);
                  },
                  icon: Icon(Icons.military_tech),
                  label: Text('Engage Combat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToMonster(monster);
                  },
                  icon: Icon(Icons.navigation),
                  label: Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceDetailSheet(ARResource resource) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _getResourceIcon(resource.type),
                size: 40,
                color: Colors.green,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.type ?? 'Unknown Resource',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Quantity: ${resource.quantity} | Quality: ${resource.quality ?? 'Unknown'}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _harvestResource(resource);
              },
              icon: Icon(Icons.grass),
              label: Text('Harvest Resource'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMiniMap() {
    // Toggle minimap functionality - could open a separate minimap widget
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 300,
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition.latitude,
                _currentPosition.longitude,
              ),
              zoom: 18.0,
            ),
            markers: _markers,
            circles: _circles,
            mapType: MapType.satellite,
            myLocationEnabled: true,
          ),
        ),
      ),
    );
  }

  void _engageMonster(ARMonster monster) async {
    final arProvider = context.read<ARProvider>();
    final success = await arProvider.engageMonster(monster);

    if (success && mounted) {
      // Navigate to combat screen
      Navigator.pushNamed(
        context,
        '/home/ar-combat',
        arguments: {'monster': monster},
      );
    }
  }

  void _harvestResource(ARResource resource) async {
    final arProvider = context.read<ARProvider>();
    final result = await arProvider.harvestResource(resource);

    if (result != null && mounted) {
      // Show harvest result
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harvested ${result.items.length} items!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToMonster(ARMonster monster) {
    // Add navigation line to the monster
    // This would integrate with device's navigation app or show path on map
  }

  Widget _buildARUI() {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'AR Mode Active - Tap objects to interact',
          style: TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
