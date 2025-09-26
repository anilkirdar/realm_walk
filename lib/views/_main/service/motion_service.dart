import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

import '../enum/gesture_type_enum.dart';
import 'i_motion_service.dart';

class MotionService extends IMotionService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamController<GestureDetection>? _gestureController;

  bool _isListening = false;
  DateTime? _lastGestureTime;
  static const Duration _gestureCooldown = Duration(milliseconds: 500);

  // Gesture thresholds
  static const double _punchThreshold = 12.0;
  static const double _uppercutThreshold = 15.0;
  static const double _blockThreshold = 8.0;
  static const double _spinThreshold = 3.0;
  static const double _shakeThreshold = 20.0;

  Stream<GestureDetection> get gestureStream =>
      _gestureController?.stream ?? const Stream.empty();

  @override
  void startListening() {
    if (_isListening) return;

    _isListening = true;
    _gestureController = StreamController<GestureDetection>.broadcast();

    // Accelerometer for linear movements
    _accelerometerSubscription = accelerometerEvents.listen(
      _handleAccelerometerEvent,
      onError: (error) => print('Accelerometer error: $error'),
    );

    // Gyroscope for rotational movements
    _gyroscopeSubscription = gyroscopeEvents.listen(
      _handleGyroscopeEvent,
      onError: (error) => print('Gyroscope error: $error'),
    );
  }

  @override
  void stopListening() {
    if (!_isListening) return;

    _isListening = false;
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _gestureController?.close();

    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _gestureController = null;
  }

  void _handleAccelerometerEvent(AccelerometerEvent event) {
    if (!_canDetectGesture()) return;

    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    final gesture = _detectAccelerometerGesture(event, magnitude);

    if (gesture != GestureType.none) {
      _emitGesture(gesture, _calculateIntensity(magnitude));
    }
  }

  void _handleGyroscopeEvent(GyroscopeEvent event) {
    if (!_canDetectGesture()) return;

    final rotationMagnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    final gesture = _detectGyroscopeGesture(event, rotationMagnitude);

    if (gesture != GestureType.none) {
      _emitGesture(gesture, _calculateRotationIntensity(rotationMagnitude));
    }
  }

  GestureType _detectAccelerometerGesture(
    AccelerometerEvent event,
    double magnitude,
  ) {
    // Strong shake for special attacks
    if (magnitude > _shakeThreshold) {
      return GestureType.fireball;
    }

    // Punch (forward thrust - X axis dominant)
    if (event.x.abs() > _punchThreshold &&
        event.x.abs() > event.y.abs() &&
        event.x.abs() > event.z.abs()) {
      return event.x > 0 ? GestureType.punch : GestureType.block;
    }

    // Uppercut (upward thrust - Y axis dominant)
    if (event.y > _uppercutThreshold && event.y > event.x.abs()) {
      return GestureType.uppercut;
    }

    // Block/Defense (negative Y or controlled movement)
    if (event.y < -_blockThreshold && magnitude < _punchThreshold) {
      return GestureType.block;
    }

    // Dodge (side movement - Z axis)
    if (event.z.abs() > _blockThreshold && event.z.abs() > event.x.abs()) {
      return GestureType.dodge;
    }

    return GestureType.none;
  }

  GestureType _detectGyroscopeGesture(GyroscopeEvent event, double magnitude) {
    // Spin attack (rotation around Z axis)
    if (event.z.abs() > _spinThreshold && magnitude > 2.0) {
      return GestureType.spin;
    }

    // Healing gesture (gentle circular motion)
    if (magnitude > 1.0 &&
        magnitude < 2.5 &&
        event.x.abs() < 1.5 &&
        event.y.abs() < 1.5) {
      return GestureType.heal;
    }

    return GestureType.none;
  }

  bool _canDetectGesture() {
    final now = DateTime.now();
    if (_lastGestureTime != null &&
        now.difference(_lastGestureTime!) < _gestureCooldown) {
      return false;
    }
    return true;
  }

  void _emitGesture(GestureType gesture, double intensity) {
    _lastGestureTime = DateTime.now();
    _gestureController?.add(
      GestureDetection(
        gesture: gesture,
        intensity: intensity,
        timestamp: _lastGestureTime!,
      ),
    );
  }

  double _calculateIntensity(double magnitude) {
    // Normalize intensity between 0.0 and 1.0
    return (magnitude / 25.0).clamp(0.0, 1.0);
  }

  double _calculateRotationIntensity(double magnitude) {
    // Normalize rotation intensity
    return (magnitude / 5.0).clamp(0.0, 1.0);
  }

  // Manual gesture for spell casting (pattern-based)
  @override
  void triggerSpellGesture(GestureType spellType) {
    if (_canDetectGesture()) {
      _emitGesture(spellType, 0.8);
    }
  }
}

class GestureDetection {
  final GestureType gesture;
  final double intensity;
  final DateTime timestamp;

  GestureDetection({
    required this.gesture,
    required this.intensity,
    required this.timestamp,
  });

  @override
  String toString() =>
      'GestureDetection($gesture, ${intensity.toStringAsFixed(2)})';
}
