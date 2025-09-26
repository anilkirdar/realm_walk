// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterAvatar _$CharacterAvatarFromJson(Map<String, dynamic> json) =>
    CharacterAvatar(
      characterId: json['characterId'] as String?,
      name: json['name'] as String?,
      characterClass: json['characterClass'] as String?,
      level: (json['level'] as num?)?.toInt(),
      position: CharacterAvatar._positionFromJson(
        json['position'] as Map<String, dynamic>?,
      ),
      movement: json['movement'] == null
          ? null
          : CharacterMovement.fromJson(
              json['movement'] as Map<String, dynamic>,
            ),
      appearance: json['appearance'] == null
          ? null
          : CharacterAppearance.fromJson(
              json['appearance'] as Map<String, dynamic>,
            ),
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      isOnline: json['isOnline'] as bool?,
    );

Map<String, dynamic> _$CharacterAvatarToJson(CharacterAvatar instance) =>
    <String, dynamic>{
      'characterId': instance.characterId,
      'name': instance.name,
      'characterClass': instance.characterClass,
      'level': instance.level,
      'position': CharacterAvatar._positionToJson(instance.position),
      'movement': instance.movement,
      'appearance': instance.appearance,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'isOnline': instance.isOnline,
    };

CharacterMovement _$CharacterMovementFromJson(Map<String, dynamic> json) =>
    CharacterMovement(
      speed: (json['speed'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      state: $enumDecodeNullable(_$MovementStateEnumMap, json['state']),
      lastMovement: json['lastMovement'] == null
          ? null
          : DateTime.parse(json['lastMovement'] as String),
    );

Map<String, dynamic> _$CharacterMovementToJson(CharacterMovement instance) =>
    <String, dynamic>{
      'speed': instance.speed,
      'heading': instance.heading,
      'state': _$MovementStateEnumMap[instance.state],
      'lastMovement': instance.lastMovement?.toIso8601String(),
    };

const _$MovementStateEnumMap = {
  MovementState.idle: 'idle',
  MovementState.walking: 'walking',
  MovementState.running: 'running',
  MovementState.teleporting: 'teleporting',
};

CharacterAppearance _$CharacterAppearanceFromJson(Map<String, dynamic> json) =>
    CharacterAppearance(
      classEmoji: json['classEmoji'] as String?,
      outfitColor: json['outfitColor'] as String?,
      weaponType: json['weaponType'] as String?,
      equippedItems:
          (json['equippedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      guildEmblem: json['guildEmblem'] as String?,
    );

Map<String, dynamic> _$CharacterAppearanceToJson(
  CharacterAppearance instance,
) => <String, dynamic>{
  'classEmoji': instance.classEmoji,
  'outfitColor': instance.outfitColor,
  'weaponType': instance.weaponType,
  'equippedItems': instance.equippedItems,
  'guildEmblem': instance.guildEmblem,
};
