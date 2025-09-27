// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gesture_detection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GestureDetection _$GestureDetectionFromJson(Map<String, dynamic> json) =>
    GestureDetection(
      gesture: $enumDecode(_$GestureTypeEnumMap, json['gesture']),
      intensity: (json['intensity'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      confidence: (json['confidence'] as num?)?.toDouble(),
      sensorData: (json['sensorData'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      deviceInfo: json['deviceInfo'] as String?,
    );

Map<String, dynamic> _$GestureDetectionToJson(GestureDetection instance) =>
    <String, dynamic>{
      'gesture': _$GestureTypeEnumMap[instance.gesture]!,
      'intensity': instance.intensity,
      'timestamp': instance.timestamp.toIso8601String(),
      'confidence': instance.confidence,
      'sensorData': instance.sensorData,
      'duration': instance.duration?.inMicroseconds,
      'deviceInfo': instance.deviceInfo,
    };

const _$GestureTypeEnumMap = {
  GestureType.punch: 'punch',
  GestureType.uppercut: 'uppercut',
  GestureType.block: 'block',
  GestureType.dodge: 'dodge',
  GestureType.spin: 'spin',
  GestureType.fireball: 'fireball',
  GestureType.heal: 'heal',
  GestureType.charge: 'charge',
  GestureType.none: 'none',
};

GestureCalibration _$GestureCalibrationFromJson(Map<String, dynamic> json) =>
    GestureCalibration(
      thresholds: (json['thresholds'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$GestureTypeEnumMap, k),
          (e as num).toDouble(),
        ),
      ),
      sensitivity: (json['sensitivity'] as num?)?.toDouble() ?? 1.0,
      cooldownPeriod: json['cooldownPeriod'] == null
          ? const Duration(milliseconds: 500)
          : Duration(microseconds: (json['cooldownPeriod'] as num).toInt()),
      isCalibrated: json['isCalibrated'] as bool? ?? false,
      lastCalibration: json['lastCalibration'] == null
          ? null
          : DateTime.parse(json['lastCalibration'] as String),
      deviceId: json['deviceId'] as String?,
      deviceSpecificSettings:
          json['deviceSpecificSettings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GestureCalibrationToJson(GestureCalibration instance) =>
    <String, dynamic>{
      'thresholds': instance.thresholds.map(
        (k, e) => MapEntry(_$GestureTypeEnumMap[k]!, e),
      ),
      'sensitivity': instance.sensitivity,
      'cooldownPeriod': instance.cooldownPeriod.inMicroseconds,
      'isCalibrated': instance.isCalibrated,
      'lastCalibration': instance.lastCalibration?.toIso8601String(),
      'deviceId': instance.deviceId,
      'deviceSpecificSettings': instance.deviceSpecificSettings,
    };

GestureHistory _$GestureHistoryFromJson(
  Map<String, dynamic> json,
) => GestureHistory(
  detections: (json['detections'] as List<dynamic>)
      .map((e) => GestureDetection.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionStart: DateTime.parse(json['sessionStart'] as String),
  sessionEnd: json['sessionEnd'] == null
      ? null
      : DateTime.parse(json['sessionEnd'] as String),
  gestureCounts: (json['gestureCounts'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry($enumDecode(_$GestureTypeEnumMap, k), (e as num).toInt()),
  ),
  averageIntensities: (json['averageIntensities'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry($enumDecode(_$GestureTypeEnumMap, k), (e as num).toDouble()),
  ),
  totalGestures: (json['totalGestures'] as num).toInt(),
);

Map<String, dynamic> _$GestureHistoryToJson(GestureHistory instance) =>
    <String, dynamic>{
      'detections': instance.detections.map((e) => e.toJson()).toList(),
      'sessionStart': instance.sessionStart.toIso8601String(),
      'sessionEnd': instance.sessionEnd?.toIso8601String(),
      'gestureCounts': instance.gestureCounts.map(
        (k, e) => MapEntry(_$GestureTypeEnumMap[k]!, e),
      ),
      'averageIntensities': instance.averageIntensities.map(
        (k, e) => MapEntry(_$GestureTypeEnumMap[k]!, e),
      ),
      'totalGestures': instance.totalGestures,
    };
