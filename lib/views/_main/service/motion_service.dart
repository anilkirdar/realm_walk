import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

import '../enum/gesture_type_enum.dart';
import '../model/gesture_detection.dart';
import 'i_motion_service.dart';

class MotionService extends IMotionService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamController<GestureDetection>? _gestureController;

  bool _isListening = false;
  DateTime? _lastGestureTime;
  Duration _gestureCooldown = const Duration(milliseconds: 500);
  double _sensitivity = 1.0;

  // Gesture thresholds (adjustable with sensitivity)
  double get _punchThreshold => 12.0 * _sensitivity;
  double get _uppercutThreshold => 15.0 * _sensitivity;
  double get _blockThreshold => 8.0 * _sensitivity;
  double get _spinThreshold => 3.0 * _sensitivity;
  double get _shakeThreshold => 20.0 * _sensitivity;

  @override
  Stream<GestureDetection> get gestureStream =>
      _gestureController?.stream ?? const Stream.empty();

  @override
  bool get isListening => _isListening;

  @override
  double get currentSensitivity => _sensitivity;

  @override
  Duration get gestureCooldown => _gestureCooldown;

  @override
  DateTime? get lastGestureTime => _lastGestureTime;

  @override
  void startListening() {
    if (_isListening) return;

    print('🎯 MotionService: Starting gesture detection');

    _isListening = true;
    _gestureController = StreamController<GestureDetection>.broadcast();

    // Accelerometer for linear movements
    _accelerometerSubscription = accelerometerEvents.listen(
      _handleAccelerometerEvent,
      onError: (error) {
        print('❌ MotionService: Accelerometer error - $error');
        _gestureController?.addError(error);
      },
    );

    // Gyroscope for rotational movements
    _gyroscopeSubscription = gyroscopeEvents.listen(
      _handleGyroscopeEvent,
      onError: (error) {
        print('❌ MotionService: Gyroscope error - $error');
        _gestureController?.addError(error);
      },
    );

    print('✅ MotionService: Gesture detection started');
  }

  @override
  void stopListening() {
    if (!_isListening) return;

    print('⏹️ MotionService: Stopping gesture detection');

    _isListening = false;
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _gestureController?.close();

    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _gestureController = null;

    print('✅ MotionService: Gesture detection stopped');
  }

  @override
  void triggerSpellGesture(GestureType spellType) {
    if (canDetectGesture()) {
      print('🪄 MotionService: Manual spell gesture triggered - $spellType');
      _emitGesture(spellType, 0.8);
    }
  }

  @override
  void triggerCustomGesture(GestureType gestureType, double intensity) {
    if (canDetectGesture()) {
      print('⚡ MotionService: Custom gesture triggered - $gestureType');
      _emitGesture(gestureType, intensity.clamp(0.0, 1.0));
    }
  }

  @override
  void calibrateSensors() {
    print('🔧 MotionService: Calibrating sensors');
    // Reset any offset values or calibration data
    _lastGestureTime = null;
    print('✅ MotionService: Sensor calibration complete');
  }

  @override
  void resetCalibration() {
    print('🔄 MotionService: Resetting calibration');
    _sensitivity = 1.0;
    _gestureCooldown = const Duration(milliseconds: 500);
    _lastGestureTime = null;
    print('✅ MotionService: Calibration reset');
  }

  @override
  void setSensitivity(double sensitivity) {
    _sensitivity = sensitivity.clamp(0.1, 3.0);
    print(
      '📊 MotionService: Sensitivity set to ${_sensitivity.toStringAsFixed(1)}',
    );
  }

  @override
  void setGestureCooldown(Duration cooldown) {
    _gestureCooldown = cooldown;
    print(
      '⏱️ MotionService: Gesture cooldown set to ${cooldown.inMilliseconds}ms',
    );
  }

  @override
  bool canDetectGesture() {
    if (!_isListening) return false;

    final now = DateTime.now();
    if (_lastGestureTime != null &&
        now.difference(_lastGestureTime!) < _gestureCooldown) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    stopListening();
    print('🔚 MotionService: Disposed');
  }

  // Private methods
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    if (!canDetectGesture()) return;

    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    final gesture = _detectAccelerometerGesture(event, magnitude);

    if (gesture != GestureType.none) {
      _emitGesture(gesture, _calculateIntensity(magnitude));
    }
  }

  void _handleGyroscopeEvent(GyroscopeEvent event) {
    if (!canDetectGesture()) return;

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
    // Strong shake for special attacks (fireball)
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

    // Shield gesture (controlled rotation)
    if (magnitude > 0.5 && magnitude < 1.5) {
      return GestureType.shield;
    }

    return GestureType.none;
  }

  void _emitGesture(GestureType gesture, double intensity) {
    _lastGestureTime = DateTime.now();

    final detection = GestureDetection(
      gesture: gesture,
      intensity: intensity,
      timestamp: _lastGestureTime!,
    );

    _gestureController?.add(detection);

    print(
      '⚡ MotionService: Gesture detected - ${gesture.name} (${intensity.toStringAsFixed(2)})',
    );
  }

  double _calculateIntensity(double magnitude) {
    // Normalize intensity between 0.0 and 1.0 based on magnitude
    return (magnitude / 25.0).clamp(0.0, 1.0);
  }

  double _calculateRotationIntensity(double magnitude) {
    // Normalize rotation intensity
    return (magnitude / 5.0).clamp(0.0, 1.0);
  }
}
