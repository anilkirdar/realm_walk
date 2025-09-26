// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import '../enum/gesture_type_enum.dart';

part 'combat_models.g.dart';

@JsonSerializable()
class CombatAction extends INetworkModel<CombatAction> {
  final String? id;
  final GestureType? gestureType;
  final String? name;
  final String? description;
  final int? baseDamage;
  final int? manaCost;
  final int? energyCost;
  final Duration cooldown;
  final String? animation;
  final String? effectEmoji;

  const CombatAction({
    this.id,
    this.gestureType,
    this.name,
    this.description,
    this.baseDamage,
    this.manaCost = 0,
    this.energyCost = 10,
    this.cooldown = const Duration(seconds: 1),
    this.animation,
    this.effectEmoji,
  });

  @override
  CombatAction fromJson(Map<String, dynamic> json) {
    return CombatAction.fromJson(json);
  }

  factory CombatAction.fromJson(Map<String, dynamic> json) {
    return _$CombatActionFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$CombatActionToJson(this);

  CombatAction copyWith({
    String? id,
    GestureType? gestureType,
    String? name,
    String? description,
    int? baseDamage,
    int? manaCost,
    int? energyCost,
    Duration? cooldown,
    String? animation,
    String? effectEmoji,
  }) {
    return CombatAction(
      id: id ?? this.id,
      gestureType: gestureType ?? this.gestureType,
      name: name ?? this.name,
      description: description ?? this.description,
      baseDamage: baseDamage ?? this.baseDamage,
      manaCost: manaCost ?? this.manaCost,
      energyCost: energyCost ?? this.energyCost,
      cooldown: cooldown ?? this.cooldown,
      animation: animation ?? this.animation,
      effectEmoji: effectEmoji ?? this.effectEmoji,
    );
  }
}

@JsonSerializable()
class CombatStats {
  final int? health;
  final int? maxHealth;
  final int? mana;
  final int? maxMana;
  final int? energy;
  final int? maxEnergy;
  final int? attack;
  final int? defense;

  CombatStats({
    this.health,
    this.maxHealth,
    this.mana,
    this.maxMana,
    this.energy,
    this.maxEnergy,
    this.attack,
    this.defense,
  });

  @override
  CombatStats fromJson(Map<String, dynamic> json) {
    return CombatStats.fromJson(json);
  }

  factory CombatStats.fromJson(Map<String, dynamic> json) {
    return _$CombatStatsFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$CombatStatsToJson(this);

  CombatStats copyWith({
    int? health,
    int? maxHealth,
    int? mana,
    int? maxMana,
    int? energy,
    int? maxEnergy,
    int? attack,
    int? defense,
  }) {
    return CombatStats(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      mana: mana ?? this.mana,
      maxMana: maxMana ?? this.maxMana,
      energy: energy ?? this.energy,
      maxEnergy: maxEnergy ?? this.maxEnergy,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
    );
  }
}

@JsonSerializable()
class CombatResult {
  final int? damage;
  final bool? isCritical;
  final bool? isBlocked;
  final String? effectDescription;
  final Duration? stunDuration;

  CombatResult({
    this.damage,
    this.isCritical = false,
    this.isBlocked = false,
    this.effectDescription,
    this.stunDuration = Duration.zero,
  });

  @override
  CombatResult fromJson(Map<String, dynamic> json) {
    return CombatResult.fromJson(json);
  }

  factory CombatResult.fromJson(Map<String, dynamic> json) {
    return _$CombatResultFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$CombatResultToJson(this);

  CombatResult copyWith({
    int? damage,
    bool? isCritical,
    bool? isBlocked,
    String? effectDescription,
    Duration? stunDuration,
  }) {
    return CombatResult(
      damage: damage ?? this.damage,
      isCritical: isCritical ?? this.isCritical,
      isBlocked: isBlocked ?? this.isBlocked,
      effectDescription: effectDescription ?? this.effectDescription,
      stunDuration: stunDuration ?? this.stunDuration,
    );
  }
}
