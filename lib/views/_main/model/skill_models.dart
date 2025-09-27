import 'package:json_annotation/json_annotation.dart';

part 'skill_models.g.dart';

enum SkillType { attack, defense, magic, heal, special, passive }

enum SkillTarget { self, enemy, ally, area, all_enemies, all_allies }

@JsonSerializable()
class PlayerSkill {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final SkillTarget target;
  final int level;
  final int maxLevel;
  final int manaCost;
  final int cooldown; // in milliseconds
  final Map<String, dynamic> effects;
  final String? iconPath;
  final bool isUnlocked;
  final int requiredLevel;

  const PlayerSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.target,
    required this.level,
    this.maxLevel = 10,
    required this.manaCost,
    required this.cooldown,
    required this.effects,
    this.iconPath,
    this.isUnlocked = false,
    this.requiredLevel = 1,
  });

  factory PlayerSkill.fromJson(Map<String, dynamic> json) =>
      _$PlayerSkillFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerSkillToJson(this);

  PlayerSkill copyWith({
    String? id,
    String? name,
    String? description,
    SkillType? type,
    SkillTarget? target,
    int? level,
    int? maxLevel,
    int? manaCost,
    int? cooldown,
    Map<String, dynamic>? effects,
    String? iconPath,
    bool? isUnlocked,
    int? requiredLevel,
  }) {
    return PlayerSkill(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      target: target ?? this.target,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      manaCost: manaCost ?? this.manaCost,
      cooldown: cooldown ?? this.cooldown,
      effects: effects ?? this.effects,
      iconPath: iconPath ?? this.iconPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      requiredLevel: requiredLevel ?? this.requiredLevel,
    );
  }

  // Calculate actual damage/effect value based on level
  double getEffectValue(String effectKey) {
    final baseValue = effects[effectKey]?.toDouble() ?? 0.0;
    final levelMultiplier = 1.0 + (level - 1) * 0.1; // 10% increase per level
    return baseValue * levelMultiplier;
  }

  // Check if skill can be used
  bool canUse(int currentMana, DateTime? lastUsed) {
    if (currentMana < manaCost) return false;
    if (lastUsed == null) return true;

    final timeSinceLastUse =
        DateTime.now().millisecondsSinceEpoch - lastUsed.millisecondsSinceEpoch;
    return timeSinceLastUse >= cooldown;
  }
}

@JsonSerializable()
class SkillEffect {
  final String type; // 'damage', 'heal', 'buff', 'debuff'
  final double value;
  final int duration; // in turns/seconds
  final SkillTarget target;
  final Map<String, dynamic> properties;

  const SkillEffect({
    required this.type,
    required this.value,
    this.duration = 0,
    required this.target,
    this.properties = const {},
  });

  factory SkillEffect.fromJson(Map<String, dynamic> json) =>
      _$SkillEffectFromJson(json);

  Map<String, dynamic> toJson() => _$SkillEffectToJson(this);
}

@JsonSerializable()
class PlayerStats {
  final int health;
  final int maxHealth;
  final int mana;
  final int maxMana;
  final int attack;
  final int defense;
  final int speed;
  final int level;
  final int experience;
  final int energy;
  final int maxEnergy;

  const PlayerStats({
    required this.health,
    required this.maxHealth,
    required this.mana,
    required this.maxMana,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.level,
    required this.experience,
    required this.energy,
    required this.maxEnergy,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);

  PlayerStats copyWith({
    int? health,
    int? maxHealth,
    int? mana,
    int? maxMana,
    int? attack,
    int? defense,
    int? speed,
    int? level,
    int? experience,
    int? energy,
    int? maxEnergy,
  }) {
    return PlayerStats(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      mana: mana ?? this.mana,
      maxMana: maxMana ?? this.maxMana,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      energy: energy ?? this.energy,
      maxEnergy: maxEnergy ?? this.maxEnergy,
    );
  }

  // Calculate health percentage
  double get healthPercentage => health / maxHealth;

  // Calculate mana percentage
  double get manaPercentage => mana / maxMana;

  // Calculate energy percentage
  double get energyPercentage => energy / maxEnergy;

  // Check if player is alive
  bool get isAlive => health > 0;

  // Check if player can use skills
  bool get canUseMana => mana > 0;

  // Check if player can craft
  bool get canUseEnergy => energy > 0;
}
