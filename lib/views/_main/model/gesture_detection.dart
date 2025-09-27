// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import '../enum/gesture_type_enum.dart';

part 'gesture_detection.g.dart';

@JsonSerializable(explicitToJson: true)
class GestureDetection extends INetworkModel<GestureDetection> {
  final GestureType gesture;
  final double intensity;
  final DateTime timestamp;
  final double? confidence;
  final Map<String, double>? sensorData;
  final Duration? duration;
  final String? deviceInfo;

  const GestureDetection({
    required this.gesture,
    required this.intensity,
    required this.timestamp,
    this.confidence,
    this.sensorData,
    this.duration,
    this.deviceInfo,
  });

  factory GestureDetection.fromJson(Map<String, dynamic> json) =>
      _$GestureDetectionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GestureDetectionToJson(this);

  @override
  GestureDetection fromJson(Map<String, dynamic> json) =>
      _$GestureDetectionFromJson(json);

  GestureDetection copyWith({
    GestureType? gesture,
    double? intensity,
    DateTime? timestamp,
    double? confidence,
    Map<String, double>? sensorData,
    Duration? duration,
    String? deviceInfo,
  }) {
    return GestureDetection(
      gesture: gesture ?? this.gesture,
      intensity: intensity ?? this.intensity,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
      sensorData: sensorData ?? this.sensorData,
      duration: duration ?? this.duration,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }

  // Helper methods
  bool get isHighIntensity => intensity > 0.7;
  bool get isMediumIntensity => intensity > 0.4 && intensity <= 0.7;
  bool get isLowIntensity => intensity <= 0.4;

  bool get isHighConfidence => confidence != null && confidence! > 0.8;
  bool get isMediumConfidence =>
      confidence != null && confidence! > 0.6 && confidence! <= 0.8;
  bool get isLowConfidence => confidence != null && confidence! <= 0.6;

  String get intensityText {
    if (isHighIntensity) return 'Yüksek';
    if (isMediumIntensity) return 'Orta';
    return 'Düşük';
  }

  String get confidenceText {
    if (confidence == null) return 'Bilinmeyen';
    if (isHighConfidence) return 'Yüksek';
    if (isMediumConfidence) return 'Orta';
    return 'Düşük';
  }

  String get intensityEmoji {
    if (isHighIntensity) return '🔥';
    if (isMediumIntensity) return '⚡';
    return '💫';
  }

  Duration get timeSinceDetection => DateTime.now().difference(timestamp);
  bool get isRecent => timeSinceDetection.inSeconds < 1;

  // Sensor data helpers
  double? get accelerometerMagnitude => sensorData?['accelerometerMagnitude'];
  double? get gyroscopeMagnitude => sensorData?['gyroscopeMagnitude'];
  double? get accelerometerX => sensorData?['accelerometerX'];
  double? get accelerometerY => sensorData?['accelerometerY'];
  double? get accelerometerZ => sensorData?['accelerometerZ'];
  double? get gyroscopeX => sensorData?['gyroscopeX'];
  double? get gyroscopeY => sensorData?['gyroscopeY'];
  double? get gyroscopeZ => sensorData?['gyroscopeZ'];

  bool get hasSensorData => sensorData != null && sensorData!.isNotEmpty;

  @override
  String toString() {
    return 'GestureDetection(${gesture.name}, ${intensity.toStringAsFixed(2)}, ${timestamp.toIso8601String()})';
  }
}

@JsonSerializable(explicitToJson: true)
class GestureCalibration extends INetworkModel<GestureCalibration> {
  final Map<GestureType, double> thresholds;
  final double sensitivity;
  final Duration cooldownPeriod;
  final bool isCalibrated;
  final DateTime? lastCalibration;
  final String? deviceId;
  final Map<String, dynamic>? deviceSpecificSettings;

  const GestureCalibration({
    required this.thresholds,
    this.sensitivity = 1.0,
    this.cooldownPeriod = const Duration(milliseconds: 500),
    this.isCalibrated = false,
    this.lastCalibration,
    this.deviceId,
    this.deviceSpecificSettings,
  });

  factory GestureCalibration.fromJson(Map<String, dynamic> json) =>
      _$GestureCalibrationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GestureCalibrationToJson(this);

  @override
  GestureCalibration fromJson(Map<String, dynamic> json) =>
      _$GestureCalibrationFromJson(json);

  GestureCalibration copyWith({
    Map<GestureType, double>? thresholds,
    double? sensitivity,
    Duration? cooldownPeriod,
    bool? isCalibrated,
    DateTime? lastCalibration,
    String? deviceId,
    Map<String, dynamic>? deviceSpecificSettings,
  }) {
    return GestureCalibration(
      thresholds: thresholds ?? this.thresholds,
      sensitivity: sensitivity ?? this.sensitivity,
      cooldownPeriod: cooldownPeriod ?? this.cooldownPeriod,
      isCalibrated: isCalibrated ?? this.isCalibrated,
      lastCalibration: lastCalibration ?? this.lastCalibration,
      deviceId: deviceId ?? this.deviceId,
      deviceSpecificSettings:
          deviceSpecificSettings ?? this.deviceSpecificSettings,
    );
  }

  // Helper methods
  double getThreshold(GestureType gestureType) {
    return (thresholds[gestureType] ?? 1.0) * sensitivity;
  }

  bool needsRecalibration() {
    if (!isCalibrated) return true;
    if (lastCalibration == null) return true;

    final daysSinceCalibration = DateTime.now()
        .difference(lastCalibration!)
        .inDays;
    return daysSinceCalibration > 7; // Recalibrate weekly
  }

  Duration? get timeSinceCalibration {
    if (lastCalibration == null) return null;
    return DateTime.now().difference(lastCalibration!);
  }

  Map<GestureType, String> get thresholdDescriptions {
    return thresholds.map((gesture, threshold) {
      final adjustedThreshold = threshold * sensitivity;
      String description;

      if (adjustedThreshold < 0.5) {
        description = 'Çok Hassas';
      } else if (adjustedThreshold < 1.0) {
        description = 'Hassas';
      } else if (adjustedThreshold < 1.5) {
        description = 'Normal';
      } else if (adjustedThreshold < 2.0) {
        description = 'Az Hassas';
      } else {
        description = 'Çok Az Hassas';
      }

      return MapEntry(gesture, description);
    });
  }

  String get sensitivityDescription {
    if (sensitivity < 0.5) return 'Çok Düşük';
    if (sensitivity < 0.8) return 'Düşük';
    if (sensitivity < 1.2) return 'Normal';
    if (sensitivity < 1.5) return 'Yüksek';
    return 'Çok Yüksek';
  }

  String get cooldownDescription {
    final ms = cooldownPeriod.inMilliseconds;
    if (ms < 100) return 'Çok Hızlı';
    if (ms < 300) return 'Hızlı';
    if (ms < 700) return 'Normal';
    if (ms < 1000) return 'Yavaş';
    return 'Çok Yavaş';
  }
}

@JsonSerializable(explicitToJson: true)
class GestureHistory extends INetworkModel<GestureHistory> {
  final List<GestureDetection> detections;
  final DateTime sessionStart;
  final DateTime? sessionEnd;
  final Map<GestureType, int> gestureCounts;
  final Map<GestureType, double> averageIntensities;
  final int totalGestures;

  const GestureHistory({
    required this.detections,
    required this.sessionStart,
    this.sessionEnd,
    required this.gestureCounts,
    required this.averageIntensities,
    required this.totalGestures,
  });

  factory GestureHistory.fromJson(Map<String, dynamic> json) =>
      _$GestureHistoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GestureHistoryToJson(this);

  @override
  GestureHistory fromJson(Map<String, dynamic> json) =>
      _$GestureHistoryFromJson(json);

  GestureHistory copyWith({
    List<GestureDetection>? detections,
    DateTime? sessionStart,
    DateTime? sessionEnd,
    Map<GestureType, int>? gestureCounts,
    Map<GestureType, double>? averageIntensities,
    int? totalGestures,
  }) {
    return GestureHistory(
      detections: detections ?? this.detections,
      sessionStart: sessionStart ?? this.sessionStart,
      sessionEnd: sessionEnd ?? this.sessionEnd,
      gestureCounts: gestureCounts ?? this.gestureCounts,
      averageIntensities: averageIntensities ?? this.averageIntensities,
      totalGestures: totalGestures ?? this.totalGestures,
    );
  }

  // Helper methods
  Duration get sessionDuration =>
      (sessionEnd ?? DateTime.now()).difference(sessionStart);

  double get gesturesPerMinute => sessionDuration.inMinutes > 0
      ? totalGestures / sessionDuration.inMinutes
      : 0.0;

  GestureType? get mostUsedGesture {
    if (gestureCounts.isEmpty) return null;
    return gestureCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  GestureType? get highestIntensityGesture {
    if (averageIntensities.isEmpty) return null;
    return averageIntensities.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  List<GestureDetection> get recentDetections {
    final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
    return detections
        .where((d) => d.timestamp.isAfter(fiveMinutesAgo))
        .toList();
  }

  List<GestureDetection> getDetectionsForGesture(GestureType gesture) {
    return detections.where((d) => d.gesture == gesture).toList();
  }

  double getAverageIntensityForGesture(GestureType gesture) {
    return averageIntensities[gesture] ?? 0.0;
  }

  int getCountForGesture(GestureType gesture) {
    return gestureCounts[gesture] ?? 0;
  }

  Map<String, dynamic> get statistics {
    return {
      'totalGestures': totalGestures,
      'sessionDuration': sessionDuration.inMinutes,
      'gesturesPerMinute': gesturesPerMinute,
      'mostUsedGesture': mostUsedGesture?.name,
      'highestIntensityGesture': highestIntensityGesture?.name,
      'uniqueGestureTypes': gestureCounts.keys.length,
      'averageSessionIntensity': averageIntensities.values.isNotEmpty
          ? averageIntensities.values.reduce((a, b) => a + b) /
                averageIntensities.length
          : 0.0,
    };
  }
}
