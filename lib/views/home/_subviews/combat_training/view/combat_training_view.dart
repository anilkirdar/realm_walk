import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../_main/enum/combat_state_enum.dart';
import '../../../../_main/enum/gesture_type_enum.dart';
import '../../../../_main/provider/combat_provider.dart';

class CombatTrainingScreen extends StatefulWidget {
  const CombatTrainingScreen({super.key});

  @override
  State<CombatTrainingScreen> createState() => _CombatTrainingScreenState();
}

class _CombatTrainingScreenState extends State<CombatTrainingScreen>
    with TickerProviderStateMixin {
  late AnimationController _hitAnimationController;
  late AnimationController _shakeAnimationController;
  late Animation<double> _hitAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _hitAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _hitAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _hitAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _shakeAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    // Start combat mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CombatProvider>().startCombat();
    });
  }

  @override
  void dispose() {
    _hitAnimationController.dispose();
    _shakeAnimationController.dispose();
    context.read<CombatProvider>().stopCombat();
    super.dispose();
  }

  void _triggerHitAnimation() {
    _hitAnimationController.reset();
    _hitAnimationController.forward().then((_) {
      _hitAnimationController.reverse();
    });
  }

  void _triggerShakeAnimation() {
    _shakeAnimationController.reset();
    _shakeAnimationController.forward().then((_) {
      _shakeAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Savaş Antrenmanı',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<CombatProvider>(
        builder: (context, combatProvider, child) {
          // Listen to combat state changes for animations
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (combatProvider.combatState == CombatState.attacking) {
              _triggerHitAnimation();
            }
          });

          return Column(
            children: [
              // Combat Stats
              _buildCombatStats(combatProvider),

              // Combat Area
              Expanded(child: _buildCombatArea(combatProvider)),

              // Action Buttons and Instructions
              _buildControlPanel(combatProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCombatStats(CombatProvider combatProvider) {
    final stats = combatProvider.playerStats;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Health Bar
          _buildStatBar(
            'Sağlık',
            stats.health ?? 0,
            stats.maxHealth ?? 0,
            Colors.red,
          ),
          const SizedBox(height: 8),

          // Mana Bar
          _buildStatBar(
            'Mana',
            stats.mana ?? 0,
            stats.maxMana ?? 0,
            Colors.blue,
          ),
          const SizedBox(height: 8),

          // Energy Bar
          _buildStatBar(
            'Enerji',
            stats.energy ?? 0,
            stats.maxEnergy ?? 0,
            Colors.yellow,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int current, int max, Color color) {
    final percentage = current / max;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
            Text(
              '$current/$max',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[600],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildCombatArea(CombatProvider combatProvider) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hitAnimation, _shakeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Transform.scale(
            scale: _hitAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getCombatStateColor(combatProvider.combatState),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Combat State Indicator
                  Icon(
                    _getCombatStateIcon(combatProvider.combatState),
                    size: 80,
                    color: _getCombatStateColor(combatProvider.combatState),
                  ),
                  const SizedBox(height: 16),

                  // Combat State Text
                  Text(
                    _getCombatStateText(combatProvider.combatState),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getCombatStateColor(combatProvider.combatState),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Last Action
                  if (combatProvider.lastAction != null) ...[
                    Text(
                      'Son Hareket: ${combatProvider.lastAction}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Hareket Rehberi:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '👊 İleri doğru sert hareket = Yumruk\n'
                          '🥊 Yukarı doğru hareket = Üst kroşe\n'
                          '🌪️ Telefonu çevir = Döner saldırı\n'
                          '🔥 Sert salla = Ateş topu\n'
                          '✨ Yavaşça çevir = İyileştirme',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[300],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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

  Widget _buildControlPanel(CombatProvider combatProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Manual Test Buttons
          Text(
            'Test Butonları:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTestButton('👊', 'Yumruk', () {
                combatProvider.triggerAction(GestureType.punch);
                _triggerHitAnimation();
              }),
              _buildTestButton('🥊', 'Üst Kroşe', () {
                combatProvider.triggerAction(GestureType.uppercut);
                _triggerHitAnimation();
              }),
              _buildTestButton('🌪️', 'Döner', () {
                combatProvider.triggerAction(GestureType.spin);
                _triggerHitAnimation();
              }),
              _buildTestButton('🔥', 'Ateş', () {
                combatProvider.triggerAction(GestureType.fireball);
                _triggerHitAnimation();
              }),
              _buildTestButton('✨', 'İyileş', () {
                combatProvider.triggerAction(GestureType.heal);
                _triggerHitAnimation();
              }),
              _buildTestButton('🛡️', 'Savun', () {
                combatProvider.activateDefense();
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Combat Mode Toggle
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (combatProvider.isInCombat) {
                  combatProvider.stopCombat();
                } else {
                  combatProvider.startCombat();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: combatProvider.isInCombat
                    ? Colors.red
                    : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                combatProvider.isInCombat
                    ? 'Antrenmana Son Ver'
                    : 'Antrenman Başlat',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(String emoji, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getCombatStateIcon(CombatState state) {
    switch (state) {
      case CombatState.idle:
        return Icons.self_improvement;
      case CombatState.attacking:
        return Icons.flash_on;
      case CombatState.defending:
        return Icons.shield;
      case CombatState.stunned:
        return Icons.sentiment_very_dissatisfied;
      case CombatState.casting:
        return Icons.auto_fix_high;
      case CombatState.dodging:
        return Icons.directions_run;
    }
  }

  Color _getCombatStateColor(CombatState state) {
    switch (state) {
      case CombatState.idle:
        return Colors.blue;
      case CombatState.attacking:
        return Colors.red;
      case CombatState.defending:
        return Colors.green;
      case CombatState.stunned:
        return Colors.purple;
      case CombatState.casting:
        return Colors.orange;
      case CombatState.dodging:
        return Colors.cyan;
    }
  }

  String _getCombatStateText(CombatState state) {
    switch (state) {
      case CombatState.idle:
        return 'Hazır';
      case CombatState.attacking:
        return 'Saldırıyor!';
      case CombatState.defending:
        return 'Savunuyor';
      case CombatState.stunned:
        return 'Sersemlemiş';
      case CombatState.casting:
        return 'Büyü Yapıyor';
      case CombatState.dodging:
        return 'Kaçıyor';
    }
  }
}
