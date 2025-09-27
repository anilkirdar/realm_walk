import 'dart:async';

import '../enum/gesture_type_enum.dart';
import '../model/gesture_detection.dart';

abstract class IMotionService {
  // Stream getters
  Stream<GestureDetection> get gestureStream;

  // Motion listening
  void startListening();
  void stopListening();
  bool get isListening;

  // Manual gesture triggers
  void triggerSpellGesture(GestureType spellType);
  void triggerCustomGesture(GestureType gestureType, double intensity);

  // Calibration
  void calibrateSensors();
  void resetCalibration();

  // Settings
  void setSensitivity(double sensitivity);
  void setGestureCooldown(Duration cooldown);
  double get currentSensitivity;
  Duration get gestureCooldown;

  // Gesture validation
  bool canDetectGesture();
  DateTime? get lastGestureTime;

  // Cleanup
  void dispose();
}
