import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/init/notifier/custom_theme.dart';
import '../../../../_main/enum/gesture_type_enum.dart';
import '../../../../_main/model/ar_models.dart';
import '../../../../_main/model/combat_rewards.dart';
import '../../../../_main/provider/ar_provider.dart';
import '../../../../_main/provider/combat_provider.dart';
import '../../../../_main/service/motion_service.dart';

class ARCombatScreen extends StatefulWidget {
  final ARMonster monster;

  const ARCombatScreen({super.key, required this.monster});

  @override
  State<ARCombatScreen> createState() => _ARCombatScreenState();
}

class _ARCombatScreenState extends State<ARCombatScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  // Monster combat state
  int _monsterCurrentHealth = 0;
  int _monsterMaxHealth = 0;
  bool _isMonsterDead = false;

  // Combat animations
  late AnimationController _hitAnimationController;
  late AnimationController _damageAnimationController;
  late AnimationController _monsterAnimationController;
  late Animation<double> _hitAnimation;
  late Animation<double> _damageAnimation;
  late Animation<double> _monsterBounce;

  // Damage numbers
  List<DamageNumber> _damageNumbers = [];
  int _damageNumberId = 0;

  // Combat timer
  Timer? _combatTimer;
  int _combatDuration = 0;

  // Gesture listening
  StreamSubscription<GestureDetection>? _gestureSubscription;

  String? _lastPlayerAction;
  String? _lastMonsterAction;

  MotionService motionService = MotionService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize monster health
    _monsterCurrentHealth = widget.monster.stats?.health ?? 0;
    _monsterMaxHealth = widget.monster.stats?.maxHealth ?? 0;

    // Initialize animations
    _setupAnimations();

    // Initialize camera and combat
    _initializeCamera();
    _startCombat();
  }

  void _setupAnimations() {
    _hitAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _damageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _monsterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _hitAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _hitAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _damageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _damageAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _monsterBounce = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _monsterAnimationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _combatTimer?.cancel();
    _gestureSubscription?.cancel();

    _hitAnimationController.dispose();
    _damageAnimationController.dispose();
    _monsterAnimationController.dispose();

    // Stop motion detection
    motionService.stopListening();

    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  void _startCombat() {
    // Start motion detection
    motionService.startListening();
    _gestureSubscription = motionService.gestureStream.listen(_handleGesture);

    // Start combat timer
    _combatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _combatDuration++);

      // Monster AI - attack every 3-5 seconds
      if (_combatDuration % (3 + math.Random().nextInt(3)) == 0 &&
          !_isMonsterDead) {
        _monsterAttack();
      }
    });
  }

  void _handleGesture(GestureDetection detection) {
    if (_isMonsterDead) return;

    final combatProvider = context.read<CombatProvider>();

    // Calculate damage based on gesture and stats
    int baseDamage = _calculateBaseDamage(
      detection.gesture,
      detection.intensity,
    );
    baseDamage = _applyClassMultiplier(baseDamage, detection.gesture);

    // Random factor and critical hits
    final random = math.Random().nextDouble();
    bool isCritical = random < 0.15; // 15% crit chance

    if (isCritical) {
      baseDamage = (baseDamage * 1.5).round();
    }

    // Apply damage to monster
    _dealDamageToMonster(baseDamage, isCritical, detection.gesture);

    // Update last action
    setState(() {
      _lastPlayerAction = _getActionName(detection.gesture);
    });

    // Trigger hit animation
    _triggerHitAnimation();
  }

  int _calculateBaseDamage(GestureType gesture, double intensity) {
    final combatProvider = context.read<CombatProvider>();
    final playerAttack = combatProvider.playerStats.attack;

    int baseDamage;
    switch (gesture) {
      case GestureType.punch:
        baseDamage = ((playerAttack ?? 0) * 0.8 + intensity * 10).round();
        break;
      case GestureType.uppercut:
        baseDamage = ((playerAttack ?? 0) * 1.2 + intensity * 15).round();
        break;
      case GestureType.spin:
        baseDamage = ((playerAttack ?? 0) * 1.0 + intensity * 12).round();
        break;
      case GestureType.fireball:
        baseDamage = ((playerAttack ?? 0) * 1.1 + intensity * 18).round();
        break;
      default:
        baseDamage = ((playerAttack ?? 0) * 0.6 + intensity * 8).round();
    }

    return baseDamage;
  }

  int _applyClassMultiplier(int baseDamage, GestureType gesture) {
    // This would use actual character class from provider
    // For now, assume warrior
    switch (gesture) {
      case GestureType.punch:
      case GestureType.uppercut:
      case GestureType.spin:
        return (baseDamage * 1.2).round(); // Warrior bonus for physical attacks
      case GestureType.fireball:
        return (baseDamage * 0.8).round(); // Warrior penalty for magic
      default:
        return baseDamage;
    }
  }

  String _getActionName(GestureType gesture) {
    switch (gesture) {
      case GestureType.punch:
        return 'Yumruk!';
      case GestureType.uppercut:
        return 'Üst Kroşe!';
      case GestureType.spin:
        return 'Döner Saldırı!';
      case GestureType.fireball:
        return 'Ateş Topu!';
      case GestureType.block:
        return 'Savunma!';
      case GestureType.heal:
        return 'İyileştir!';
      default:
        return 'Saldırı!';
    }
  }

  void _dealDamageToMonster(int damage, bool isCritical, GestureType gesture) {
    // Apply monster defense
    final finalDamage = math.max(
      1,
      damage - (widget.monster.stats?.defense ?? 0),
    );

    setState(() {
      _monsterCurrentHealth = math.max(0, _monsterCurrentHealth - finalDamage);

      // Add damage number
      _damageNumbers.add(
        DamageNumber(
          id: _damageNumberId++,
          damage: finalDamage,
          isCritical: isCritical,
          position: _getRandomDamagePosition(),
        ),
      );

      // Check if monster is dead
      if (_monsterCurrentHealth <= 0) {
        _isMonsterDead = true;
        _handleMonsterDeath(finalDamage);
      }
    });

    // Animate damage numbers
    _damageAnimationController.reset();
    _damageAnimationController.forward();

    // Remove damage numbers after animation
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _damageNumbers.removeWhere((dn) => dn.id == _damageNumberId - 1);
        });
      }
    });

    // Trigger monster hit animation
    _triggerMonsterHit();
  }

  void _triggerHitAnimation() {
    _hitAnimationController.reset();
    _hitAnimationController.forward().then((_) {
      _hitAnimationController.reverse();
    });
  }

  void _triggerMonsterHit() {
    _monsterAnimationController.reset();
    _monsterAnimationController.forward().then((_) {
      _monsterAnimationController.reverse();
    });
  }

  void _monsterAttack() {
    if (_isMonsterDead) return;

    final combatProvider = context.read<CombatProvider>();

    // Calculate monster damage
    final monsterDamage = widget.monster.stats?.attack ?? 0;
    final playerDefense = combatProvider.playerStats.defense ?? 0;
    final finalDamage = math.max(1, monsterDamage - playerDefense);

    // Apply damage to player
    final newHealth = math.max(
      0,
      (combatProvider.playerStats.health ?? 0) - finalDamage,
    );

    // Update combat provider with new health
    context.read<CombatProvider>().updatePlayerHealth(newHealth);

    setState(() {
      _lastMonsterAction =
          '${widget.monster.name} saldırdı! (-$finalDamage ❤️)';
    });

    // Check if player died
    if (newHealth <= 0) {
      _handlePlayerDeath();
    }
  }

  void _handleMonsterDeath(int finalDamage) async {
    // Stop combat timer and gestures
    _combatTimer?.cancel();
    _gestureSubscription?.cancel();
    motionService.stopListening();

    // Defeat monster on server
    final arProvider = context.read<ARProvider>();
    final rewards = await arProvider.defeatMonster(finalDamage);

    if (rewards != null && mounted) {
      // Show victory screen
      _showVictoryDialog(rewards);
    }
  }

  void _handlePlayerDeath() {
    _combatTimer?.cancel();
    _gestureSubscription?.cancel();
    motionService.stopListening();

    _showDefeatDialog();
  }

  void _showVictoryDialog(CombatRewards rewards) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: CustomColors.gold, size: 32),
            const SizedBox(width: 8),
            Text(
              'Zafer!',
              style: TextStyle(
                color: CustomColors.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.monster.name} yenildi!',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),

            Text(
              'Ödüller:',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${rewards.experience} Deneyim Puanı',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            if (rewards.leveledUp != null && rewards.leveledUp!) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Seviye Atladın! Yeni seviye: ${rewards.newLevel}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],

            if (rewards.loot?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Text(
                'Ganimet:',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ...rewards.loot?.map(
                    (item) => Row(
                      children: [
                        const Icon(
                          Icons.inventory,
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.quantity}x ${item.itemId}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  [],
            ],

            const SizedBox(height: 16),
            Text(
              'Süre: ${_formatDuration(_combatDuration)}',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Close combat screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: CustomColors.gold),
            child: const Text(
              'Devam Et',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Row(
          children: [
            Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              size: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Yenildin!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.monster.name} seni yendi!',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Endişelenme, deneyim kazandın ve daha güçlü olacaksın!',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Close combat screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Geri Dön',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Offset _getRandomDamagePosition() {
    final random = math.Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Offset(
      screenWidth * 0.3 + random.nextDouble() * screenWidth * 0.4,
      screenHeight * 0.2 + random.nextDouble() * screenHeight * 0.3,
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Background
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),

          // AR Monster
          _buildARMonster(),

          // Combat UI
          _buildCombatUI(),

          // Damage Numbers
          ..._damageNumbers.map(_buildDamageNumber),

          // Action Feedback
          _buildActionFeedback(),
        ],
      ),
    );
  }

  Widget _buildARMonster() {
    return AnimatedBuilder(
      animation: Listenable.merge([_hitAnimation, _monsterBounce]),
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          top: MediaQuery.of(context).size.height * 0.4 - _monsterBounce.value,
          child: Transform.scale(
            scale: _hitAnimation.value,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: _isMonsterDead
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(80),
                border: Border.all(
                  color: _isMonsterDead ? Colors.grey : Colors.red,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.monster.type ?? '',
                    style: TextStyle(
                      fontSize: 64,
                      color: _isMonsterDead ? Colors.grey : null,
                    ),
                  ),
                  Text(
                    widget.monster.name ?? '',
                    style: TextStyle(
                      color: _isMonsterDead ? Colors.grey : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Health bar
                  Container(
                    width: 120,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: _monsterCurrentHealth / _monsterMaxHealth,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _monsterCurrentHealth > _monsterMaxHealth * 0.3
                              ? Colors.red
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '$_monsterCurrentHealth/$_monsterMaxHealth',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCombatUI() {
    return Consumer<CombatProvider>(
      builder: (context, combatProvider, child) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: Column(
            children: [
              // Player stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${combatProvider.playerStats.health}/${combatProvider.playerStats.maxHealth}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.flash_on,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${combatProvider.playerStats.energy}/${combatProvider.playerStats.maxEnergy}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value:
                                (combatProvider.playerStats.health ?? 0) /
                                ((combatProvider.playerStats.maxHealth ?? 1) ==
                                        0
                                    ? 1
                                    : (combatProvider.playerStats.maxHealth ??
                                          1)),
                            backgroundColor: Colors.grey[600],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Combat timer and actions
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Süre: ${_formatDuration(_combatDuration)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    if (_lastPlayerAction != null)
                      Text(
                        _lastPlayerAction!,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDamageNumber(DamageNumber damageNumber) {
    return AnimatedBuilder(
      animation: _damageAnimation,
      builder: (context, child) {
        return Positioned(
          left: damageNumber.position.dx,
          top: damageNumber.position.dy - (_damageAnimation.value * 100),
          child: Opacity(
            opacity: 1.0 - _damageAnimation.value,
            child: Text(
              damageNumber.isCritical
                  ? 'CRITICAL!\n${damageNumber.damage}'
                  : '${damageNumber.damage}',
              style: TextStyle(
                color: damageNumber.isCritical ? Colors.orange : Colors.red,
                fontSize: damageNumber.isCritical ? 24 : 20,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionFeedback() {
    return Positioned(
      bottom: 50,
      left: 16,
      right: 16,
      child: Column(
        children: [
          if (_lastMonsterAction != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _lastMonsterAction!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '🥊 Saldırmak için telefonu hızlıca hareket ettir!\n'
              '👊 İleri = Yumruk • ⬆️ Yukarı = Üst kroşe • 🌪️ Çevir = Döner saldırı',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DamageNumber {
  final int id;
  final int damage;
  final bool isCritical;
  final Offset position;

  DamageNumber({
    required this.id,
    required this.damage,
    required this.isCritical,
    required this.position,
  });
}

// Extension for CombatProvider
extension CombatProviderExtension on CombatProvider {
  void updatePlayerHealth(int newHealth) {
    playerStats.copyWith(health: newHealth);
    notifyListeners();
  }
}
