import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../enum/movement_state_enum.dart';
import '../model/character_avatar.dart';
import '../provider/ar_provider.dart';
import '../provider/location_provider.dart';
import '../service/avatar_movement_service.dart';

class ARMiniMap extends StatefulWidget {
  final double size;
  final double zoom;
  final bool showPlayerNames;

  const ARMiniMap({
    super.key,
    this.size = 200,
    this.zoom = 1.0,
    this.showPlayerNames = true,
  });

  @override
  State<ARMiniMap> createState() => _ARMiniMapState();
}

class _ARMiniMapState extends State<ARMiniMap> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  Timer? _updateTimer;
  double _currentZoom = 1.0;
  bool _followPlayer = true;

  // Map display settings
  static const double _metersPerPixel = 2.0; // 2 meters per pixel at zoom 1.0
  static const double _maxZoom = 3.0;
  static const double _minZoom = 0.3;

  AvatarMovementService avatarMovementService = AvatarMovementService();

  @override
  void initState() {
    super.initState();
    _currentZoom = widget.zoom;
    _setupAnimations();
    _startUpdateTimer();
  }

  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(widget.size / 2),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: Stack(
          children: [
            // Map background with grid
            _buildMapBackground(),

            // Player character (center)
            _buildPlayerAvatar(),

            // AR Monsters
            _buildARObjects(),

            // Nearby Players
            _buildNearbyPlayers(),

            // Friends & Guild Members
            _buildFriendsAndGuild(),

            // Map controls
            _buildMapControls(),

            // Compass
            _buildCompass(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBackground() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: MapGridPainter(zoom: _currentZoom),
      ),
    );
  }

  Widget _buildPlayerAvatar() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final movement = avatarMovementService.getCurrentMovement();

        return Positioned(
          left: widget.size / 2 - 15,
          top: widget.size / 2 - 15,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Transform.rotate(
                  angle: movement.heading! * math.pi / 180,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _getMovementColor(
                        movement.state ?? MovementState.idle,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _getMovementColor(
                            movement.state ?? MovementState.idle,
                          ).withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCharacterIcon(),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildARObjects() {
    return Consumer2<LocationProvider, ARProvider>(
      builder: (context, locationProvider, arProvider, child) {
        if (locationProvider.currentPosition == null) {
          return SizedBox.shrink();
        }

        final playerPos = locationProvider.currentPosition!;
        List<Widget> objects = [];

        // Add monsters (red dots)
        for (final monster in arProvider.nearbyMonsters) {
          final relativePos = _calculateRelativePosition(
            playerPos,
            Position(
              latitude: monster.location?.latitude ?? 0,
              longitude: monster.location?.longitude ?? 0,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              headingAccuracy: 0,
            ),
          );

          if (_isWithinMapBounds(relativePos)) {
            objects.add(
              Positioned(
                left: relativePos.dx - 4,
                top: relativePos.dy - 4,
                child: _buildMapDot(
                  color: Colors.red,
                  size: 8,
                  label: monster.level.toString(),
                  tooltip: '${monster.name}\nLevel ${monster.level}',
                ),
              ),
            );
          }
        }

        // Add resources (yellow dots)
        for (final resource in arProvider.nearbyResources) {
          final relativePos = _calculateRelativePosition(
            playerPos,
            Position(
              latitude: resource.location?.latitude ?? 0,
              longitude: resource.location?.longitude ?? 0,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              headingAccuracy: 0,
            ),
          );

          if (_isWithinMapBounds(relativePos)) {
            objects.add(
              Positioned(
                left: relativePos.dx - 3,
                top: relativePos.dy - 3,
                child: _buildMapDot(
                  color: Colors.amber,
                  size: 6,
                  tooltip: '${resource.type}\n${resource.quantity} items',
                ),
              ),
            );
          }
        }

        return Stack(children: objects);
      },
    );
  }

  Widget _buildNearbyPlayers() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        if (locationProvider.currentPosition == null) {
          return SizedBox.shrink();
        }

        // Mock nearby players data - replace with real data from provider
        final nearbyPlayers = _getMockNearbyPlayers();
        List<Widget> playerDots = [];

        for (final player in nearbyPlayers) {
          final relativePos = _calculateRelativePosition(
            locationProvider.currentPosition!,
            player.position ??
                Position(
                  latitude: 0,
                  longitude: 0,
                  timestamp: DateTime.now(),
                  accuracy: 0,
                  altitude: 0,
                  altitudeAccuracy: 0,
                  heading: 0,
                  speed: 0,
                  speedAccuracy: 0,
                  headingAccuracy: 0,
                ),
          );

          if (_isWithinMapBounds(relativePos)) {
            playerDots.add(
              Positioned(
                left: relativePos.dx - 5,
                top: relativePos.dy - 5,
                child: _buildPlayerDot(player),
              ),
            );
          }
        }

        return Stack(children: playerDots);
      },
    );
  }

  Widget _buildFriendsAndGuild() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        if (locationProvider.currentPosition == null) {
          return SizedBox.shrink();
        }

        // Mock friends/guild data - replace with real data
        final friends = _getMockFriends();
        List<Widget> friendDots = [];

        for (final friend in friends) {
          final relativePos = _calculateRelativePosition(
            locationProvider.currentPosition!,
            friend.position ??
                Position(
                  latitude: 0,
                  longitude: 0,
                  timestamp: DateTime.now(),
                  accuracy: 0,
                  altitude: 0,
                  altitudeAccuracy: 0,
                  heading: 0,
                  speed: 0,
                  speedAccuracy: 0,
                  headingAccuracy: 0,
                ),
          );

          if (_isWithinMapBounds(relativePos)) {
            friendDots.add(
              Positioned(
                left: relativePos.dx - 6,
                top: relativePos.dy - 6,
                child: _buildFriendDot(friend),
              ),
            );
          }
        }

        return Stack(children: friendDots);
      },
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 8,
      right: 8,
      child: Column(
        children: [
          // Zoom in
          GestureDetector(
            onTap: () => _changeZoom(0.2),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
          SizedBox(height: 4),
          // Zoom out
          GestureDetector(
            onTap: () => _changeZoom(-0.2),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final movement = avatarMovementService.getCurrentMovement();

        return Positioned(
          top: 8,
          left: 8,
          child: Transform.rotate(
            angle:
                -movement.heading! *
                math.pi /
                180, // Rotate opposite to player heading
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  // North arrow
                  Positioned(
                    top: 2,
                    left: 14,
                    child: Container(
                      width: 4,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // N label
                  Positioned(
                    top: 16,
                    left: 12,
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapDot({
    required Color color,
    required double size,
    String? label,
    String? tooltip,
  }) {
    Widget dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: label != null
          ? Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: dot);
    }

    return dot;
  }

  Widget _buildPlayerDot(CharacterAvatar player) {
    return Tooltip(
      message: '${player.name}\nLevel ${player.level} ${player.characterClass}',
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Text(
            (player.characterClass ?? '').substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendDot(CharacterAvatar friend) {
    return Tooltip(
      message: '${friend.name} (Friend)\nLevel ${friend.level}',
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child:
            (friend.appearance?.guildEmblem != null &&
                friend.appearance?.guildEmblem!.isNotEmpty == true)
            ? Center(
                child: Text(
                  friend.appearance?.guildEmblem ?? '',
                  style: TextStyle(fontSize: 6),
                ),
              )
            : Icon(Icons.favorite, color: Colors.white, size: 6),
      ),
    );
  }

  Offset _calculateRelativePosition(Position center, Position target) {
    // Calculate relative position in meters
    final deltaLat = target.latitude - center.latitude;
    final deltaLng = target.longitude - center.longitude;

    // Convert to meters (approximate)
    final metersNorth = deltaLat * 111320; // 1 degree lat ≈ 111.32 km
    final metersEast =
        deltaLng * 111320 * math.cos(center.latitude * math.pi / 180);

    // Convert to pixels with zoom
    final pixelsPerMeter = _currentZoom / _metersPerPixel;
    final pixelX = widget.size / 2 + metersEast * pixelsPerMeter;
    final pixelY =
        widget.size / 2 - metersNorth * pixelsPerMeter; // Invert Y axis

    return Offset(pixelX, pixelY);
  }

  bool _isWithinMapBounds(Offset position) {
    return position.dx >= 0 &&
        position.dx <= widget.size &&
        position.dy >= 0 &&
        position.dy <= widget.size;
  }

  void _changeZoom(double delta) {
    setState(() {
      _currentZoom = (_currentZoom + delta).clamp(_minZoom, _maxZoom);
    });
  }

  Color _getMovementColor(MovementState state) {
    switch (state) {
      case MovementState.idle:
        return Colors.blue;
      case MovementState.walking:
        return Colors.green;
      case MovementState.running:
        return Colors.orange;
      case MovementState.teleporting:
        return Colors.purple;
    }
  }

  IconData _getCharacterIcon() {
    // This would be based on actual character class
    return Icons.person; // Default icon
  }

  // Mock data - replace with real providers
  List<CharacterAvatar> _getMockNearbyPlayers() {
    // This would come from your LocationProvider or a new NearbyPlayersProvider
    return [];
  }

  List<CharacterAvatar> _getMockFriends() {
    // This would come from FriendsProvider
    return [];
  }
}

// Custom painter for map grid
class MapGridPainter extends CustomPainter {
  final double zoom;

  MapGridPainter({required this.zoom});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    final gridSpacing = 20 * zoom; // Grid lines every 20 pixels * zoom

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw center crosshair
    paint.color = Colors.white.withOpacity(0.3);
    paint.strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(center + Offset(-10, 0), center + Offset(10, 0), paint);
    canvas.drawLine(center + Offset(0, -10), center + Offset(0, 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
