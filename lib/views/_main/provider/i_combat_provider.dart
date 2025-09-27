import 'dart:async';

import '../enum/combat_state_enum.dart';
import '../enum/gesture_type_enum.dart';
import '../model/combat_models.dart';
import '../model/gesture_detection.dart';

abstract class ICombatProvider {
  // State getters
  CombatStats get playerStats;
  CombatState get combatState;
  bool get isInCombat;
  String? get lastAction;
  DateTime? get lastActionTime;
  bool get isTrainingMode;

  // Combat management
  Future<void> initializeCombat();
  Future<void> startCombat(String characterClass);
  Future<void> endCombat();
  void resetCombat();

  // Gesture system
  void startGestureListening();
  void stopGestureListening();
  Stream<GestureDetection> get gestureStream;

  // Combat actions
  Future<CombatActionResult> performAction(CombatAction action);
  Future<CombatActionResult> executeGesture(GestureType gestureType);
  bool canPerformAction(CombatAction action);

  // Character classes and actions
  List<CombatAction> getActionsForClass(String characterClass);
  void setCharacterClass(String characterClass);

  // Stats management
  void updatePlayerHealth(int newHealth);
  void updatePlayerEnergy(int newEnergy);
  void updatePlayerMana(int newMana);
  void restorePlayerStats();

  // Combat state
  void setCombatState(CombatState state);
  void setLastAction(String action);

  // Training mode
  void enableTrainingMode(bool enabled);

  // Cooldown management
  Duration? getRemainingCooldown(GestureType gestureType);
  bool isActionOnCooldown(GestureType gestureType);
}
