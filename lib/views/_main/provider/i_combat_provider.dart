import '../enum/gesture_type_enum.dart';

abstract class ICombatProvider {
  void startCombat();

  void stopCombat();

  void triggerAction(GestureType gesture);

  void activateDefense();
}
