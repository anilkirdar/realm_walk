import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../enum/combat_state_enum.dart';
import '../enum/gesture_type_enum.dart';
import '../model/combat_models.dart';
import '../model/gesture_detection.dart';
import '../service/i_motion_service.dart';
import '../service/motion_service.dart';
import 'i_combat_provider.dart';

class CombatProvider with ChangeNotifier implements ICombatProvider {
  // Services
  late IMotionService _motionService;

  // State variables
  CombatStats _playerStats = CombatStats();
  CombatState _combatState = CombatState.idle;
  bool _isInCombat = false;
  String? _lastAction;
  DateTime? _lastActionTime;
  String _characterClass = 'warrior';
  bool _isTrainingMode = false;

  // Gesture system
  StreamSubscription<GestureDetection>? _gestureSubscription;
  final StreamController<GestureDetection> _gestureController =
      StreamController<GestureDetection>.broadcast();

  // Cooldowns and timing
  final Map<GestureType, DateTime> _cooldowns = {};

  // Character class actions
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
        cooldown: const Duration(seconds: 2),
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
        cooldown: const Duration(seconds: 3),
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
      CombatAction(
        id: 'mage_shield',
        gestureType: GestureType.shield,
        name: 'Büyü Kalkanı',
        description: 'Savunma kalkanı oluştur',
        baseDamage: 0,
        manaCost: 15,
        energyCost: 10,
        cooldown: const Duration(seconds: 5),
        animation: 'shield',
        effectEmoji: '🛡️',
      ),
    ],
    'archer': [
      CombatAction(
        id: 'archer_quick_shot',
        gestureType: GestureType.punch,
        name: 'Hızlı Atış',
        description: 'Hızlı bir ok atışı',
        baseDamage: 12,
        energyCost: 10,
        animation: 'quick_shot',
        effectEmoji: '🏹',
      ),
      CombatAction(
        id: 'archer_dodge',
        gestureType: GestureType.dodge,
        name: 'Kaçış',
        description: 'Hızla kaç ve konter saldırı yap',
        baseDamage: 18,
        energyCost: 20,
        cooldown: const Duration(seconds: 2),
        animation: 'dodge_strike',
        effectEmoji: '💨',
      ),
      CombatAction(
        id: 'archer_power_shot',
        gestureType: GestureType.charge,
        name: 'Güçlü Atış',
        description: 'Yüksek hasarlı güçlü atış',
        baseDamage: 30,
        energyCost: 35,
        cooldown: const Duration(seconds: 4),
        animation: 'power_shot',
        effectEmoji: '🎯',
      ),
    ],
  };

  // Constructor
  CombatProvider() {
    _motionService = MotionService();
    _initializeDefaultStats();
  }

  // Getters implementation
  @override
  CombatStats get playerStats => _playerStats;

  @override
  CombatState get combatState => _combatState;

  @override
  bool get isInCombat => _isInCombat;

  @override
  String? get lastAction => _lastAction;

  @override
  DateTime? get lastActionTime => _lastActionTime;

  @override
  bool get isTrainingMode => _isTrainingMode;

  @override
  Stream<GestureDetection> get gestureStream => _gestureController.stream;

  @override
  Future<void> initializeCombat() async {
    try {
      debugPrint('⚔️ CombatProvider: Initializing combat system');

      _initializeDefaultStats();

      debugPrint('✅ CombatProvider: Combat system initialized');
    } catch (e) {
      debugPrint('❌ CombatProvider: Initialization error - $e');
    }
  }

  @override
  Future<void> startCombat(String characterClass) async {
    if (_isInCombat) return;

    try {
      debugPrint(
        '🏁 CombatProvider: Starting combat with class: $characterClass',
      );

      _characterClass = characterClass;
      _isInCombat = true;
      _combatState = CombatState.idle;
      _lastAction = null;
      _lastActionTime = null;

      // Reset stats for combat
      _initializeDefaultStats();

      // Start gesture listening
      startGestureListening();

      debugPrint('✅ CombatProvider: Combat started');
    } catch (e) {
      debugPrint('❌ CombatProvider: Start combat error - $e');
    }

    notifyListeners();
  }

  @override
  Future<void> endCombat() async {
    if (!_isInCombat) return;

    debugPrint('🏁 CombatProvider: Ending combat');

    _isInCombat = false;
    _combatState = CombatState.idle;
    _lastAction = null;

    // Stop gesture listening
    stopGestureListening();

    debugPrint('✅ CombatProvider: Combat ended');
    notifyListeners();
  }

  @override
  void resetCombat() {
    debugPrint('🔄 CombatProvider: Resetting combat');

    _isInCombat = false;
    _combatState = CombatState.idle;
    _lastAction = null;
    _lastActionTime = null;
    _cooldowns.clear();

    _initializeDefaultStats();
    stopGestureListening();

    debugPrint('✅ CombatProvider: Combat reset');
    notifyListeners();
  }

  @override
  void startGestureListening() {
    if (_gestureSubscription != null) return;

    debugPrint('👁️ CombatProvider: Starting gesture listening');

    _gestureSubscription = _motionService.gestureStream.listen(
      (gesture) {
        _gestureController.add(gesture);

        if (_isInCombat || _isTrainingMode) {
          executeGesture(gesture.gesture);
        }
      },
      onError: (error) {
        debugPrint('❌ CombatProvider: Gesture stream error - $error');
      },
    );

    _motionService.startListening();
  }

  @override
  void stopGestureListening() {
    debugPrint('👁️ CombatProvider: Stopping gesture listening');

    _gestureSubscription?.cancel();
    _gestureSubscription = null;
    _motionService.stopListening();
  }

  @override
  Future<CombatActionResult> performAction(CombatAction action) async {
    if (!canPerformAction(action)) {
      return CombatActionResult(
        success: false,
        damage: 0,
        message: 'Cannot perform action: ${action.name}',
      );
    }

    try {
      debugPrint('🎯 CombatProvider: Performing action: ${action.name}');

      // Set combat state
      setCombatState(CombatState.attacking);
      setLastAction(action.name);

      // Calculate damage
      final damage = _calculateDamage(action);
      final isCritical = _calculateCritical();

      // Apply costs
      _applyActionCosts(action);

      // Set cooldown
      if (action.cooldown != null) {
        _cooldowns[action.gestureType] = DateTime.now().add(action.cooldown!);
      }

      // Create result
      final result = CombatActionResult(
        success: true,
        damage: isCritical ? (damage * 1.5).round() : damage,
        isCritical: isCritical,
        message: '${action.effectEmoji} ${action.name}',
        actionId: action.id,
      );

      // Return to idle after action
      Future.delayed(const Duration(milliseconds: 500), () {
        setCombatState(CombatState.idle);
      });

      debugPrint('✅ CombatProvider: Action performed successfully');
      notifyListeners();

      return result;
    } catch (e) {
      debugPrint('❌ CombatProvider: Perform action error - $e');
      setCombatState(CombatState.idle);

      return CombatActionResult(
        success: false,
        damage: 0,
        message: 'Action failed: $e',
      );
    }
  }

  @override
  Future<CombatActionResult> executeGesture(GestureType gestureType) async {
    final actions = getActionsForClass(_characterClass);
    final action = actions.firstWhere(
      (a) => a.gestureType == gestureType,
      orElse: () => actions.first, // Fallback to first action
    );

    return await performAction(action);
  }

  @override
  bool canPerformAction(CombatAction action) {
    // Check energy
    if (_playerStats.energy < action.energyCost) {
      return false;
    }

    // Check mana
    if (action.manaCost > 0 && _playerStats.mana < action.manaCost) {
      return false;
    }

    // Check cooldown
    if (action.cooldown != null) {
      final lastUsed = _cooldowns[action.gestureType];
      if (lastUsed != null && DateTime.now().isBefore(lastUsed)) {
        return false;
      }
    }

    return true;
  }

  @override
  List<CombatAction> getActionsForClass(String characterClass) {
    return _classActions[characterClass] ?? _classActions['warrior']!;
  }

  @override
  void setCharacterClass(String characterClass) {
    _characterClass = characterClass;
    debugPrint('🎭 CombatProvider: Character class set to $characterClass');
    notifyListeners();
  }

  @override
  void updatePlayerHealth(int newHealth) {
    _playerStats = _playerStats.copyWith(
      health: math.max(0, math.min(newHealth, _playerStats.maxHealth)),
    );
    debugPrint('❤️ CombatProvider: Health updated to ${_playerStats.health}');
    notifyListeners();
  }

  @override
  void updatePlayerEnergy(int newEnergy) {
    _playerStats = _playerStats.copyWith(
      energy: math.max(0, math.min(newEnergy, _playerStats.maxEnergy)),
    );
    debugPrint('⚡ CombatProvider: Energy updated to ${_playerStats.energy}');
    notifyListeners();
  }

  @override
  void updatePlayerMana(int newMana) {
    _playerStats = _playerStats.copyWith(
      mana: math.max(0, math.min(newMana, _playerStats.maxMana)),
    );
    debugPrint('🔮 CombatProvider: Mana updated to ${_playerStats.mana}');
    notifyListeners();
  }

  @override
  void restorePlayerStats() {
    _playerStats = _playerStats.copyWith(
      health: _playerStats.maxHealth,
      energy: _playerStats.maxEnergy,
      mana: _playerStats.maxMana,
    );
    debugPrint('🔄 CombatProvider: Player stats restored');
    notifyListeners();
  }

  @override
  void setCombatState(CombatState state) {
    _combatState = state;
    debugPrint('🎯 CombatProvider: Combat state changed to $state');
    notifyListeners();
  }

  @override
  void setLastAction(String action) {
    _lastAction = action;
    _lastActionTime = DateTime.now();
    debugPrint('⚡ CombatProvider: Last action set to $action');
  }

  @override
  void enableTrainingMode(bool enabled) {
    _isTrainingMode = enabled;
    debugPrint(
      '🎯 CombatProvider: Training mode ${enabled ? "enabled" : "disabled"}',
    );

    if (enabled) {
      startGestureListening();
      _initializeDefaultStats();
    } else {
      stopGestureListening();
    }

    notifyListeners();
  }

  @override
  Duration? getRemainingCooldown(GestureType gestureType) {
    final lastUsed = _cooldowns[gestureType];
    if (lastUsed == null) return null;

    final now = DateTime.now();
    if (now.isAfter(lastUsed)) return null;

    return lastUsed.difference(now);
  }

  @override
  bool isActionOnCooldown(GestureType gestureType) {
    return getRemainingCooldown(gestureType) != null;
  }

  // Private helper methods
  void _initializeDefaultStats() {
    _playerStats = CombatStats(
      health: 100,
      maxHealth: 100,
      energy: 100,
      maxEnergy: 100,
      mana: 50,
      maxMana: 50,
      level: 1,
      experience: 0,
      attack: 15,
      defense: 8,
    );
  }

  int _calculateDamage(CombatAction action) {
    final baseDamage = action.baseDamage;
    final randomFactor = 0.8 + (math.Random().nextDouble() * 0.4); // 80%-120%
    return (baseDamage * randomFactor).round();
  }

  bool _calculateCritical() {
    return math.Random().nextDouble() < 0.15; // 15% critical chance
  }

  void _applyActionCosts(CombatAction action) {
    updatePlayerEnergy(_playerStats.energy - action.energyCost);

    if (action.manaCost > 0) {
      updatePlayerMana(_playerStats.mana - action.manaCost);
    }
  }

  @override
  void dispose() {
    stopGestureListening();
    _gestureController.close();
    _motionService.dispose();
    debugPrint('🔚 CombatProvider: Disposed');
    super.dispose();
  }
}
