import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../enum/combat_state_enum.dart';
import '../enum/gesture_type_enum.dart';
import '../model/combat_models.dart';
import '../service/motion_service.dart';
import 'i_combat_provider.dart';

class CombatProvider with ChangeNotifier implements ICombatProvider {
  MotionService motionService = MotionService();

  // Combat state
  CombatStats _playerStats = CombatStats(
    health: 100,
    maxHealth: 100,
    mana: 50,
    maxMana: 50,
    energy: 100,
    maxEnergy: 100,
    attack: 15,
    defense: 8,
  );

  CombatState _combatState = CombatState.idle;
  bool _isInCombat = false;
  String? _lastAction;
  DateTime? _lastActionTime;

  // Gesture listening
  StreamSubscription<GestureDetection>? _gestureSubscription;

  // Cooldowns
  final Map<GestureType, DateTime> _cooldowns = {};

  // Combat actions by class
  final Map<String, List<CombatAction>> _classActions = {
    'warrior': [
      CombatAction(
        id: 'warrior_punch',
        gestureType: GestureType.punch,
        name: 'Güçlü Yumruk',
        description: 'Düşmanına güçlü bir yumruk at',
        baseDamage: 15,
        energyCost: 15,
        animation: 'punch',
        effectEmoji: '👊',
      ),
      CombatAction(
        id: 'warrior_uppercut',
        gestureType: GestureType.uppercut,
        name: 'Üst Kroşe',
        description: 'Güçlü bir üst kroşe',
        baseDamage: 25,
        energyCost: 25,
        cooldown: Duration(seconds: 2),
        animation: 'uppercut',
        effectEmoji: '🥊',
      ),
      CombatAction(
        id: 'warrior_spin',
        gestureType: GestureType.spin,
        name: 'Döner Saldırı',
        description: 'Etrafındaki tüm düşmanları vur',
        baseDamage: 20,
        energyCost: 30,
        cooldown: Duration(seconds: 3),
        animation: 'spin',
        effectEmoji: '🌪️',
      ),
    ],
    'mage': [
      CombatAction(
        id: 'mage_fireball',
        gestureType: GestureType.fireball,
        name: 'Ateş Topu',
        description: 'Düşmanına ateş topu fırlat',
        baseDamage: 20,
        manaCost: 15,
        energyCost: 10,
        animation: 'fireball',
        effectEmoji: '🔥',
      ),
      CombatAction(
        id: 'mage_heal',
        gestureType: GestureType.heal,
        name: 'İyileştir',
        description: 'Sağlığını yenile',
        baseDamage: -25, // Negative damage = healing
        manaCost: 20,
        energyCost: 5,
        animation: 'heal',
        effectEmoji: '✨',
      ),
    ],
    'archer': [
      CombatAction(
        id: 'archer_punch',
        gestureType: GestureType.punch,
        name: 'Hızlı Vuruş',
        description: 'Hızlı bir vuruş',
        baseDamage: 12,
        energyCost: 10,
        animation: 'quick_strike',
        effectEmoji: '⚡',
      ),
      CombatAction(
        id: 'archer_dodge',
        gestureType: GestureType.dodge,
        name: 'Kaçış',
        description: 'Hızla kaç ve konter saldırı yap',
        baseDamage: 18,
        energyCost: 20,
        cooldown: Duration(seconds: 2),
        animation: 'dodge_strike',
        effectEmoji: '💨',
      ),
    ],
  };

  // Getters
  CombatStats get playerStats => _playerStats;
  CombatState get combatState => _combatState;
  bool get isInCombat => _isInCombat;
  String? get lastAction => _lastAction;

  // Get available actions for character class
  List<CombatAction> getActionsForClass(String characterClass) {
    return _classActions[characterClass] ?? [];
  }

  // Start combat mode
  @override
  void startCombat() {
    if (_isInCombat) return;

    _isInCombat = true;
    _combatState = CombatState.idle;

    // Start listening to gestures
    motionService.startListening();
    _gestureSubscription = motionService.gestureStream.listen(_handleGesture);

    // Start energy regeneration
    _startEnergyRegeneration();

    notifyListeners();
  }

  // Stop combat mode
  @override
  void stopCombat() {
    if (!_isInCombat) return;

    _isInCombat = false;
    _combatState = CombatState.idle;

    // Stop listening to gestures
    motionService.stopListening();
    _gestureSubscription?.cancel();
    _gestureSubscription = null;

    notifyListeners();
  }

  // Handle detected gestures
  void _handleGesture(GestureDetection detection) {
    if (!_isInCombat || _combatState == CombatState.stunned) return;

    final action = _findActionForGesture(detection.gesture);
    if (action != null && _canPerformAction(action)) {
      _performAction(action, detection.intensity);
    }
  }

  // Find action for gesture based on character class
  CombatAction? _findActionForGesture(GestureType gesture) {
    // This would normally use the current character's class
    // For now, we'll use warrior as default
    final actions = _classActions['warrior'] ?? [];
    return actions.where((action) => action.gestureType == gesture).firstOrNull;
  }

  // Check if action can be performed (cooldown, resources)
  bool _canPerformAction(CombatAction action) {
    // Check cooldown
    final lastUsed = _cooldowns[action.gestureType];
    if (lastUsed != null &&
        DateTime.now().difference(lastUsed) < action.cooldown) {
      return false;
    }

    // Check resources
    if (((action.manaCost ?? 0) > (_playerStats.mana ?? 0)) ||
        ((action.energyCost ?? 0) > (_playerStats.energy ?? 0))) {
      return false;
    }

    return true;
  }

  // Perform combat action
  void _performAction(CombatAction action, double intensity) {
    _combatState = CombatState.attacking;
    _lastAction = action.name;
    _lastActionTime = DateTime.now();

    // Calculate damage with intensity and random factor
    final baseDamage = action.baseDamage;
    final intensityMultiplier = 0.5 + (intensity * 0.5); // 0.5 to 1.0
    final randomFactor = 0.8 + (Random().nextDouble() * 0.4); // 0.8 to 1.2
    final finalDamage = ((baseDamage ?? 0) * intensityMultiplier * randomFactor)
        .round();

    // Apply resource costs
    _playerStats = _playerStats.copyWith(
      mana: ((_playerStats.mana ?? 0) - (action.manaCost ?? 0)).clamp(
        0,
        (_playerStats.maxMana ?? 0),
      ),
      energy: ((_playerStats.energy ?? 0) - (action.energyCost ?? 0)).clamp(
        0,
        (_playerStats.maxEnergy ?? 0),
      ),
    );

    // Handle healing
    if ((action.baseDamage ?? 0) < 0) {
      final healing = finalDamage.abs();
      _playerStats = _playerStats.copyWith(
        health: ((_playerStats.health ?? 0) + healing).clamp(
          0,
          (_playerStats.maxHealth ?? 0),
        ),
      );
    }

    // Set cooldown
    if (action.gestureType != null) {
      _cooldowns[action.gestureType!] = DateTime.now();
    }

    // Show action feedback
    _showActionFeedback(action, finalDamage, intensity);

    // Return to idle after animation
    Timer(const Duration(milliseconds: 800), () {
      if (_combatState == CombatState.attacking) {
        _combatState = CombatState.idle;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  // Start energy regeneration
  void _startEnergyRegeneration() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isInCombat) {
        timer.cancel();
        return;
      }

      // Regenerate energy (5 per second)
      if ((_playerStats.energy ?? 0) < (_playerStats.maxEnergy ?? 0)) {
        _playerStats = _playerStats.copyWith(
          energy: ((_playerStats.energy ?? 0) + 5).clamp(
            0,
            _playerStats.maxEnergy ?? 0,
          ),
        );
        notifyListeners();
      }

      // Regenerate mana slowly (1 per 2 seconds)
      if ((_playerStats.mana ?? 0) < (_playerStats.maxMana ?? 0) &&
          timer.tick % 2 == 0) {
        _playerStats = _playerStats.copyWith(
          mana: ((_playerStats.mana ?? 0) + 1).clamp(
            0,
            (_playerStats.maxMana ?? 0),
          ),
        );
        notifyListeners();
      }
    });
  }

  // Show action feedback (would integrate with UI animations)
  void _showActionFeedback(CombatAction action, int damage, double intensity) {
    print(
      '${action.effectEmoji} ${action.name} - Hasar: $damage (Yoğunluk: ${intensity.toStringAsFixed(2)})',
    );
  }

  // Manual trigger for testing
  @override
  void triggerAction(GestureType gesture) {
    final detection = GestureDetection(
      gesture: gesture,
      intensity: 0.8,
      timestamp: DateTime.now(),
    );
    _handleGesture(detection);
  }

  // Block/Defense
  @override
  void activateDefense() {
    if (_combatState == CombatState.idle && (_playerStats.energy ?? 0) >= 10) {
      _combatState = CombatState.defending;
      _playerStats = _playerStats.copyWith(
        energy: ((_playerStats.energy ?? 0) - 10).clamp(
          0,
          (_playerStats.maxEnergy ?? 0),
        ),
      );

      Timer(const Duration(seconds: 2), () {
        if (_combatState == CombatState.defending) {
          _combatState = CombatState.idle;
          notifyListeners();
        }
      });

      notifyListeners();
    }
  }
}
