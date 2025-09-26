import '../enum/gesture_type_enum.dart';

abstract class IMotionService {
  void startListening();

  void stopListening();

  void triggerSpellGesture(GestureType spellType);
}
