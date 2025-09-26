import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/init/notifier/custom_theme.dart';
import '../../../../_main/model/ar_models.dart';
import '../../../../_main/module/ar_mini_map.dart';
import '../../../../_main/provider/ar_provider.dart';
import '../../../../_main/provider/location_provider.dart';
import '../../../../_main/service/ar_service.dart';
import '../../../../_main/service/avatar_movement_service.dart';
import '../../../../_main/service/location_service.dart';

class ARCameraScreen extends StatefulWidget {
  const ARCameraScreen({super.key});

  @override
  State<ARCameraScreen> createState() => _ARCameraScreenState();
}

class _ARCameraScreenState extends State<ARCameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _error;
  bool _showMiniMap = true;
  late AvatarMovementService avatarMovementService;
  late LocationService locationService;
  late ARService arService;

  bool _showTestControls = true;
  final List<String> _testMonsterTypes = [
    'goblin',
    'orc',
    'dragon',
    'wolf',
    'spider',
    'ice_wolf',
    'fire_elemental',
    'forest_dragon',
    'urban_goblin',
    'tech_golem',
  ];

  // Animation controllers for AR objects
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  late AnimationController _spawnAnimationController;
  late Animation<double> _spawnAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _setupAnimations();
    _initializeCamera();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arProvider = context.read<ARProvider>();
      arProvider.startARCamera();
      arProvider.enablePersonalSpawns();
      _refreshARObjects();
    });

    avatarMovementService = AvatarMovementService();
    locationService = LocationService();
    arService = ARService();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = context.read<LocationProvider>();
      if (locationProvider.isTracking) {
        avatarMovementService.startTracking(
          locationService.startLocationTracking(distanceFilter: 1),
        );
      }
    });
  }

  void _setupAnimations() {
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _spawnAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _spawnAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _spawnAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _pulseAnimationController.dispose();
    _spawnAnimationController.dispose();
    context.read<ARProvider>().stopARCamera();
    avatarMovementService.stopTracking();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
      final arProvider = context.read<ARProvider>();
      arProvider.checkProximitySpawns();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = 'Kamera bulunamadı');
        return;
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _error = null;
        });

        // Trigger spawn animation when camera initializes
        _spawnAnimationController.forward();
      }
    } catch (e) {
      setState(() => _error = 'Kamera hatası: $e');
      print('❌ Camera initialization error: $e');
    }
  }

  Future<void> _refreshARObjects() async {
    final locationProvider = context.read<LocationProvider>();
    final arProvider = context.read<ARProvider>();

    if (locationProvider.currentPosition != null) {
      arProvider.updatePosition(locationProvider.currentPosition!);
      await arProvider.refreshARObjects();

      // Spawn animation when new objects appear
      _spawnAnimationController.reset();
      _spawnAnimationController.forward();
    } else {
      print('⚠️ No location available for AR objects');
    }
  }

  Future<void> _spawnTestMonster(
    String monsterType, {
    bool isPersonal = false,
  }) async {
    final locationProvider = context.read<LocationProvider>();
    final currentPosition = locationProvider.currentPosition;

    if (currentPosition == null) {
      _showSnackBar('Konum bilgisi alınamadı', isError: true);
      return;
    }

    try {
      final arProvider = context.read<ARProvider>();
      final success = await arProvider.spawnTestMonster(
        monsterType: monsterType,
        isPersonal: isPersonal,
      );

      if (success) {
        _showSnackBar(
          '${monsterType} spawn edildi! (${isPersonal ? "Kişiye özel" : "Global"})',
          isError: false,
        );
        await _refreshARObjects();
      } else {
        _showSnackBar('Monster spawn edilemedi', isError: true);
      }
    } catch (e) {
      _showSnackBar('Spawn hatası: $e', isError: true);
    }
  }

  Future<void> _clearTestMonsters() async {
    try {
      final arProvider = context.read<ARProvider>();
      await arProvider.clearTestMonsters();
      _showSnackBar('Test monsters temizlendi', isError: false);
    } catch (e) {
      _showSnackBar('Temizleme hatası: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          _buildCameraPreview(),

          if (_isCameraInitialized) Positioned.fill(child: _buildAROverlay()),

          // Mini-Map (Top Right)
          if (_showMiniMap)
            Positioned(
              top: context.mediaQuery.padding.top + 60,
              right: 16,
              child: ARMiniMap(size: 150, zoom: 1.0, showPlayerNames: true),
            ),

          if (_showTestControls) _buildPokemonGoStyleTestControls(),

          // UI Controls
          _buildUIControlsWithMiniMapToggle(),

          // Enhanced debug info
          _buildEnhancedDebugInfo(),

          _buildSpawnStatsOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_isCameraInitialized && _cameraController != null) {
      return Positioned.fill(
        child: AspectRatio(
          aspectRatio: _cameraController!.value.aspectRatio,
          child: CameraPreview(_cameraController!),
        ),
      );
    } else if (_error != null) {
      return Positioned.fill(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializeCamera,
                  child: Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Positioned.fill(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'AR Kamera Başlatılıyor...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAROverlay() {
    return Consumer<ARProvider>(
      builder: (context, arProvider, child) {
        return AnimatedBuilder(
          animation: _spawnAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                ...arProvider.allMonsters.asMap().entries.map((entry) {
                  final index = entry.key;
                  final monster = entry.value;
                  return _buildPokemonGoStyleARMonster(
                    monster,
                    index,
                    arProvider,
                  );
                }).toList(),

                // AR Resources
                ...arProvider.nearbyResources.asMap().entries.map((entry) {
                  final index = entry.key;
                  final resource = entry.value;
                  return _buildARResource(resource, index, arProvider);
                }).toList(),

                // Selection UI
                if (arProvider.selectedMonster != null)
                  _buildMonsterInfo(arProvider.selectedMonster!, arProvider),

                if (arProvider.selectedResource != null)
                  _buildResourceInfo(arProvider.selectedResource!, arProvider),

                _buildPokemonGoStyleIndicators(arProvider),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPokemonGoStyleARMonster(
    ARMonster monster,
    int index,
    ARProvider arProvider,
  ) {
    final distance = arProvider.distanceToMonster(monster);
    final isInRange = arProvider.isMonsterInRange(monster);
    final isPersonal = monster.isPersonal;

    final screenPosition = _calculatePokemonGoARPosition(index, distance, true);

    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      left: screenPosition.dx,
      top: screenPosition.dy,
      child: Transform.scale(
        scale: _spawnAnimation.value,
        child: GestureDetector(
          onTap: () {
            arProvider.selectMonster(monster);
            _pulseAnimationController.forward(from: 0);
          },
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              final isSelected = arProvider.selectedMonster?.id == monster.id;
              final scale = isSelected ? _pulseAnimation.value : 1.0;

              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.red
                          : isPersonal
                          ? Colors
                                .purple // Personal spawns have purple border
                          : (isInRange ? Colors.green : Colors.grey),
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ]
                        : isPersonal
                        ? [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Text(
                            monster.type ?? '',
                            style: TextStyle(fontSize: 40),
                          ),
                          if (isPersonal)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '★',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        monster.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Lv.${monster.level}',
                        style: TextStyle(
                          color: CustomColors.darkRed,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${distance.toInt()}m',
                        style: TextStyle(
                          color: isInRange ? Colors.green : Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      if (monster.biome != null)
                        Text(
                          monster.biome!,
                          style: TextStyle(color: Colors.amber, fontSize: 9),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildARResource(
    ARResource resource,
    int index,
    ARProvider arProvider,
  ) {
    final distance = arProvider.distanceToResource(resource);
    final isInRange = arProvider.isResourceInRange(resource);

    final screenPosition = _calculatePokemonGoARPosition(
      index + arProvider.allMonsters.length,
      distance,
      false,
    );

    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      left: screenPosition.dx,
      top: screenPosition.dy,
      child: Transform.scale(
        scale: _spawnAnimation.value,
        child: GestureDetector(
          onTap: () => arProvider.selectResource(resource),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: arProvider.selectedResource?.id == resource.id
                    ? Colors.blue
                    : (isInRange ? Colors.green : Colors.grey),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(resource.type ?? '', style: TextStyle(fontSize: 28)),
                Text(
                  resource.type ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  '${resource.quantity}',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${distance.toInt()}m',
                  style: TextStyle(
                    color: isInRange ? Colors.green : Colors.grey,
                    fontSize: 9,
                  ),
                ),
                if (resource.biome != null)
                  Text(
                    resource.biome!,
                    style: TextStyle(color: Colors.cyan, fontSize: 8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Offset _calculatePokemonGoARPosition(
    int index,
    double distance,
    bool isMonster,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final arProvider = context.read<ARProvider>();
    final totalObjects = isMonster
        ? arProvider.allMonsters.length
        : arProvider.nearbyResources.length;

    if (totalObjects == 0) return Offset(screenWidth / 2, screenHeight / 2);

    final angleRange = math.pi * 1.2; // 216 degrees
    final startAngle = -angleRange / 2;
    final angleStep = totalObjects > 1 ? angleRange / (totalObjects - 1) : 0;
    final angle = startAngle + (index * angleStep);

    final baseRadius = math.min(screenWidth * 0.25, screenHeight * 0.2);
    final distanceFactor = math.max(
      0.3,
      math.min(1.5, 100 / math.max(20, distance)),
    );
    final radius = baseRadius * distanceFactor;

    // Center position
    final centerX = screenWidth * 0.5;
    final centerY = screenHeight * 0.45;

    // Add some randomness for more natural feel (based on object ID)
    final randomSeed =
        (isMonster
                ? arProvider.allMonsters[index].id
                : arProvider
                      .nearbyResources[index - arProvider.allMonsters.length]
                      .id)
            ?.hashCode ??
        0;
    final random = math.Random(randomSeed);
    final randomOffsetX = (random.nextDouble() - 0.5) * 40;
    final randomOffsetY = (random.nextDouble() - 0.5) * 30;

    final x = centerX + radius * math.cos(angle) + randomOffsetX;
    final y = centerY + radius * math.sin(angle) * 0.5 + randomOffsetY;

    return Offset(
      x.clamp(60.0, screenWidth - 120.0),
      y.clamp(120.0, screenHeight - 250.0),
    );
  }

  Widget _buildPokemonGoStyleTestControls() {
    return Positioned(
      bottom: 120,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toggle button
          FloatingActionButton(
            mini: true,
            heroTag: "toggle_test",
            backgroundColor: Colors.purple,
            onPressed: () =>
                setState(() => _showTestControls = !_showTestControls),
            child: Icon(
              _showTestControls ? Icons.visibility_off : Icons.bug_report,
            ),
          ),

          if (_showTestControls) ...[
            SizedBox(height: 8),
            Container(
              width: 220,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🧪 RealmWalk Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Monster spawn types
                  Container(
                    height: 120,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 2.5,
                      children: _testMonsterTypes.take(8).map((type) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _spawnTestMonster(type, isPersonal: false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                minimumSize: Size(60, 25),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
                            ElevatedButton(
                              onPressed: () =>
                                  _spawnTestMonster(type, isPersonal: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.withOpacity(0.8),
                                minimumSize: Size(60, 20),
                              ),
                              child: Text(
                                'P',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Control buttons
                  Consumer<ARProvider>(
                    builder: (context, arProvider, child) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _refreshARObjects,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: Size(65, 30),
                                ),
                                child: Text(
                                  'Yenile',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _clearTestMonsters,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: Size(65, 30),
                                ),
                                child: Text(
                                  'Temizle',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: arProvider.personalSpawnsEnabled
                                    ? () => arProvider.disablePersonalSpawns()
                                    : () => arProvider.enablePersonalSpawns(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      arProvider.personalSpawnsEnabled
                                      ? Colors.orange
                                      : Colors.grey,
                                  minimumSize: Size(130, 25),
                                ),
                                child: Text(
                                  arProvider.personalSpawnsEnabled
                                      ? 'Personal OFF'
                                      : 'Personal ON',
                                  style: TextStyle(fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPokemonGoStyleIndicators(ARProvider arProvider) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 120,
      right: 16,
      child: Column(
        children: [
          // Personal spawn indicator
          if (arProvider.personalMonsters.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '★ ${arProvider.personalMonsters.length}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

          SizedBox(height: 4),

          // Global spawn indicator
          if (arProvider.nearbyMonsters.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🌍 ${arProvider.nearbyMonsters.length}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpawnStatsOverlay() {
    return Consumer<ARProvider>(
      builder: (context, arProvider, child) {
        final stats = arProvider.getSpawnStats();

        return Positioned(
          bottom: 60,
          left: 16,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.cyan.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '📊 Spawn Stats',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: ${stats['totalMonsters']}',
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
                Text(
                  'Personal: ${stats['personalMonsters']}',
                  style: TextStyle(color: Colors.purple, fontSize: 9),
                ),
                Text(
                  'In Range: ${stats['monstersInRange']}',
                  style: TextStyle(color: Colors.green, fontSize: 9),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUIControlsWithMiniMapToggle() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),

          SizedBox(width: 8),

          // Mini-map toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => setState(() => _showMiniMap = !_showMiniMap),
              icon: Icon(
                _showMiniMap ? Icons.map : Icons.map_outlined,
                color: _showMiniMap ? Colors.blue : Colors.white,
              ),
            ),
          ),

          const Spacer(),

          // Refresh button
          Consumer<ARProvider>(
            builder: (context, arProvider, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: arProvider.isLoading
                      ? null
                      : () => arProvider.refreshARObjects(),
                  icon: arProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.refresh, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDebugInfo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 16,
      child: Consumer<ARProvider>(
        builder: (context, arProvider, child) {
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🎮 AR Debug',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Global Monsters: ${arProvider.nearbyMonsters.length}',
                  style: TextStyle(color: Colors.blue, fontSize: 9),
                ),
                Text(
                  'Personal Monsters: ${arProvider.personalMonsters.length}',
                  style: TextStyle(color: Colors.purple, fontSize: 9),
                ),
                Text(
                  'Resources: ${arProvider.nearbyResources.length}',
                  style: TextStyle(color: Colors.green, fontSize: 9),
                ),
                Text(
                  'Camera: ${_isCameraInitialized ? "✅" : "❌"}',
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
                Text(
                  'Personal Spawns: ${arProvider.personalSpawnsEnabled ? "ON" : "OFF"}',
                  style: TextStyle(
                    color: arProvider.personalSpawnsEnabled
                        ? Colors.green
                        : Colors.red,
                    fontSize: 9,
                  ),
                ),
                if (arProvider.error != null)
                  Text(
                    'Error: ${arProvider.error}',
                    style: TextStyle(color: Colors.red, fontSize: 8),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonsterInfo(ARMonster monster, ARProvider arProvider) {
    final isInRange = arProvider.isMonsterInRange(monster);
    final distance = arProvider.distanceToMonster(monster);

    return Positioned(
      bottom: 180,
      left: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: monster.isPersonal ? Colors.purple : Colors.red,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (monster.isPersonal ? Colors.purple : Colors.red)
                  .withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(monster.type ?? '', style: TextStyle(fontSize: 40)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              monster.name ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (monster.isPersonal)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'PERSONAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Seviye ${monster.level} • ${distance.toInt()}m mesafede',
                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      ),
                      if (monster.biome != null)
                        Text(
                          'Biome: ${monster.biome}',
                          style: TextStyle(color: Colors.amber, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Monster stats
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatChip('❤️', '${monster.stats?.health ?? ''}'),
                _buildStatChip('⚔️', '${monster.stats?.attack ?? ''}'),
                _buildStatChip('🛡️', '${monster.stats?.defense ?? ''}'),
                _buildStatChip(
                  '⭐',
                  '${monster.stats?.experienceReward ?? ''} XP',
                ),
              ],
            ),
            SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isInRange
                        ? () => _engageMonster(monster, arProvider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInRange ? Colors.red : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isInRange
                          ? '⚔️ SAVAŞ!'
                          : '❌ Çok Uzak (${distance.toInt()}m)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => arProvider.clearSelection(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text('İptal', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceInfo(ARResource resource, ARProvider arProvider) {
    final isInRange = arProvider.isResourceInRange(resource);
    final distance = arProvider.distanceToResource(resource);

    return Positioned(
      bottom: 180,
      left: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(resource.type ?? '', style: TextStyle(fontSize: 36)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (resource.type ?? '').toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${resource.quality} • ${resource.quantity} adet • ${distance.toInt()}m',
                        style: TextStyle(color: Colors.amber, fontSize: 14),
                      ),
                      if (resource.biome != null)
                        Text(
                          'Biome: ${resource.biome}',
                          style: TextStyle(color: Colors.cyan, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isInRange
                        ? () => _harvestResource(resource, arProvider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInRange ? Colors.green : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isInRange ? '🌾 TOPLA' : '❌ Çok Uzak',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => arProvider.clearSelection(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text('İptal', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: 12)),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _engageMonster(ARMonster monster, ARProvider arProvider) async {
    final success = await arProvider.engageMonster(monster);

    if (success && mounted) {
      // Navigate to AR combat screen
      context.push('/home/ar-combat', extra: monster).then((_) {
        _refreshARObjects();
      });
    } else if (mounted) {
      _showSnackBar(arProvider.error ?? 'Savaş başlatılamadı', isError: true);
    }
  }

  Future<void> _harvestResource(
    ARResource resource,
    ARProvider arProvider,
  ) async {
    final result = await arProvider.harvestResource(resource);

    if (result != null && mounted) {
      _showSnackBar(
        '${result.quantity} ${result.type} topladın! (+${result.experienceGained} XP)',
        isError: false,
      );
      arProvider.clearSelection();
    } else if (mounted && arProvider.error != null) {
      _showSnackBar(arProvider.error!, isError: true);
    }
  }
}
