// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import '../enum/gesture_type_enum.dart';

part 'combat_models.g.dart';

@JsonSerializable(explicitToJson: true)
class CombatAction extends INetworkModel<CombatAction> {
  final String id;
  final GestureType gestureType;
  final String name;
  final String description;
  final int baseDamage;
  final int manaCost;
  final int energyCost;
  final Duration? cooldown;
  final String? animation;
  final String? effectEmoji;
  final String? soundEffect;
  final double? criticalChance;
  final double? accuracy;
  final List<String>? statusEffects;
  final String? characterClass;
  final int? minimumLevel;

  const CombatAction({
    required this.id,
    required this.gestureType,
    required this.name,
    required this.description,
    required this.baseDamage,
    this.manaCost = 0,
    this.energyCost = 10,
    this.cooldown,
    this.animation,
    this.effectEmoji,
    this.soundEffect,
    this.criticalChance,
    this.accuracy,
    this.statusEffects,
    this.characterClass,
    this.minimumLevel,
  });

  factory CombatAction.fromJson(Map<String, dynamic> json) =>
      _$CombatActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatActionToJson(this);

  @override
  CombatAction fromJson(Map<String, dynamic> json) =>
      _$CombatActionFromJson(json);

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
    String? soundEffect,
    double? criticalChance,
    double? accuracy,
    List<String>? statusEffects,
    String? characterClass,
    int? minimumLevel,
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
      soundEffect: soundEffect ?? this.soundEffect,
      criticalChance: criticalChance ?? this.criticalChance,
      accuracy: accuracy ?? this.accuracy,
      statusEffects: statusEffects ?? this.statusEffects,
      characterClass: characterClass ?? this.characterClass,
      minimumLevel: minimumLevel ?? this.minimumLevel,
    );
  }

  // Helper methods
  bool get isHealing => baseDamage < 0;
  bool get hasCooldown => cooldown != null && cooldown!.inSeconds > 0;
  bool get hasManaCost => manaCost > 0;
  bool get hasStatusEffects =>
      statusEffects != null && statusEffects!.isNotEmpty;
  bool get hasLevelRequirement => minimumLevel != null && minimumLevel! > 1;

  String get cooldownText {
    if (cooldown == null) return 'Cooldown yok';
    if (cooldown!.inMinutes > 0) {
      return '${cooldown!.inMinutes}m ${cooldown!.inSeconds % 60}s';
    }
    return '${cooldown!.inSeconds}s';
  }

  String get costText {
    List<String> costs = [];
    if (energyCost > 0) costs.add('${energyCost} enerji');
    if (manaCost > 0) costs.add('${manaCost} mana');
    return costs.isEmpty ? 'Maliyet yok' : costs.join(', ');
  }

  String get damageText {
    if (isHealing) return '${baseDamage.abs()} iyileştirme';
    return '$baseDamage hasar';
  }
}

@JsonSerializable(explicitToJson: true)
class CombatStats extends INetworkModel<CombatStats> {
  final int health;
  final int maxHealth;
  final int mana;
  final int maxMana;
  final int energy;
  final int maxEnergy;
  final int attack;
  final int defense;
  final int level;
  final int experience;
  final int experienceToNextLevel;
  final double? criticalChance;
  final double? accuracy;
  final double? dodgeChance;
  final double? blockChance;
  final int? combatsWon;
  final int? combatsLost;
  final int? totalDamageDealt;
  final int? totalDamageReceived;

  const CombatStats({
    this.health = 100,
    this.maxHealth = 100,
    this.mana = 50,
    this.maxMana = 50,
    this.energy = 100,
    this.maxEnergy = 100,
    this.attack = 10,
    this.defense = 5,
    this.level = 1,
    this.experience = 0,
    this.experienceToNextLevel = 100,
    this.criticalChance,
    this.accuracy,
    this.dodgeChance,
    this.blockChance,
    this.combatsWon,
    this.combatsLost,
    this.totalDamageDealt,
    this.totalDamageReceived,
  });

  factory CombatStats.fromJson(Map<String, dynamic> json) =>
      _$CombatStatsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatStatsToJson(this);

  @override
  CombatStats fromJson(Map<String, dynamic> json) =>
      _$CombatStatsFromJson(json);

  CombatStats copyWith({
    int? health,
    int? maxHealth,
    int? mana,
    int? maxMana,
    int? energy,
    int? maxEnergy,
    int? attack,
    int? defense,
    int? level,
    int? experience,
    int? experienceToNextLevel,
    double? criticalChance,
    double? accuracy,
    double? dodgeChance,
    double? blockChance,
    int? combatsWon,
    int? combatsLost,
    int? totalDamageDealt,
    int? totalDamageReceived,
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
      level: level ?? this.level,
      experience: experience ?? this.experience,
      experienceToNextLevel:
          experienceToNextLevel ?? this.experienceToNextLevel,
      criticalChance: criticalChance ?? this.criticalChance,
      accuracy: accuracy ?? this.accuracy,
      dodgeChance: dodgeChance ?? this.dodgeChance,
      blockChance: blockChance ?? this.blockChance,
      combatsWon: combatsWon ?? this.combatsWon,
      combatsLost: combatsLost ?? this.combatsLost,
      totalDamageDealt: totalDamageDealt ?? this.totalDamageDealt,
      totalDamageReceived: totalDamageReceived ?? this.totalDamageReceived,
    );
  }

  // Helper methods
  double get healthPercentage => maxHealth > 0 ? health / maxHealth : 0.0;
  double get manaPercentage => maxMana > 0 ? mana / maxMana : 0.0;
  double get energyPercentage => maxEnergy > 0 ? energy / maxEnergy : 0.0;
  double get experiencePercentage =>
      experienceToNextLevel > 0 ? experience / experienceToNextLevel : 0.0;

  bool get isAlive => health > 0;
  bool get isDead => health <= 0;
  bool get hasFullHealth => health >= maxHealth;
  bool get hasFullMana => mana >= maxMana;
  bool get hasFullEnergy => energy >= maxEnergy;

  bool get isLowHealth => healthPercentage < 0.25;
  bool get isCriticalHealth => healthPercentage < 0.1;
  bool get isLowMana => manaPercentage < 0.25;
  bool get isLowEnergy => energyPercentage < 0.25;

  int get totalCombats => (combatsWon ?? 0) + (combatsLost ?? 0);
  double get winRate =>
      totalCombats > 0 ? (combatsWon ?? 0) / totalCombats : 0.0;

  int get powerLevel => attack + defense + (level * 5);

  String get healthStatus {
    if (isDead) return 'Ölü';
    if (isCriticalHealth) return 'Kritik';
    if (isLowHealth) return 'Düşük';
    if (hasFullHealth) return 'Tam';
    return 'İyi';
  }

  String get winRateText => '${(winRate * 100).toStringAsFixed(1)}%';

  Map<String, dynamic> get battleStatistics => {
    'totalCombats': totalCombats,
    'winRate': winRate,
    'combatsWon': combatsWon ?? 0,
    'combatsLost': combatsLost ?? 0,
    'totalDamageDealt': totalDamageDealt ?? 0,
    'totalDamageReceived': totalDamageReceived ?? 0,
    'powerLevel': powerLevel,
  };
}

@JsonSerializable(explicitToJson: true)
class CombatActionResult extends INetworkModel<CombatActionResult> {
  final bool success;
  final int damage;
  final bool isCritical;
  final bool isMiss;
  final bool isBlocked;
  final bool isDodged;
  final String message;
  final String? actionId;
  final List<String>? appliedEffects;
  final CombatStats? updatedPlayerStats;
  final CombatStats? updatedEnemyStats;
  final double? animationDuration;

  const CombatActionResult({
    required this.success,
    required this.damage,
    this.isCritical = false,
    this.isMiss = false,
    this.isBlocked = false,
    this.isDodged = false,
    required this.message,
    this.actionId,
    this.appliedEffects,
    this.updatedPlayerStats,
    this.updatedEnemyStats,
    this.animationDuration,
  });

  factory CombatActionResult.fromJson(Map<String, dynamic> json) =>
      _$CombatActionResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatActionResultToJson(this);

  @override
  CombatActionResult fromJson(Map<String, dynamic> json) =>
      _$CombatActionResultFromJson(json);

  CombatActionResult copyWith({
    bool? success,
    int? damage,
    bool? isCritical,
    bool? isMiss,
    bool? isBlocked,
    bool? isDodged,
    String? message,
    String? actionId,
    List<String>? appliedEffects,
    CombatStats? updatedPlayerStats,
    CombatStats? updatedEnemyStats,
    double? animationDuration,
  }) {
    return CombatActionResult(
      success: success ?? this.success,
      damage: damage ?? this.damage,
      isCritical: isCritical ?? this.isCritical,
      isMiss: isMiss ?? this.isMiss,
      isBlocked: isBlocked ?? this.isBlocked,
      isDodged: isDodged ?? this.isDodged,
      message: message ?? this.message,
      actionId: actionId ?? this.actionId,
      appliedEffects: appliedEffects ?? this.appliedEffects,
      updatedPlayerStats: updatedPlayerStats ?? this.updatedPlayerStats,
      updatedEnemyStats: updatedEnemyStats ?? this.updatedEnemyStats,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  // Helper methods
  bool get isHealing => damage < 0;
  bool get hasEffects => appliedEffects != null && appliedEffects!.isNotEmpty;
  bool get isEffective => success && !isMiss && !isBlocked && !isDodged;

  String get resultEmoji {
    if (!success) return '❌';
    if (isMiss) return '💨';
    if (isBlocked) return '🛡️';
    if (isDodged) return '💃';
    if (isCritical) return '💥';
    if (isHealing) return '💚';
    return '⚔️';
  }

  String get damageText {
    if (isMiss) return 'Kaçırıldı';
    if (isBlocked) return 'Bloklandı';
    if (isDodged) return 'Kaçınıldı';
    if (isHealing) return '${damage.abs()} iyileştirme';
    if (isCritical) return 'Kritik ${damage} hasar!';
    return '$damage hasar';
  }

  String get fullResultText {
    String result = damageText;
    if (hasEffects) {
      result += ' (${appliedEffects!.join(', ')})';
    }
    return result;
  }
}

@JsonSerializable(explicitToJson: true)
class CombatResult extends INetworkModel<CombatResult> {
  final bool isVictory;
  final int totalDamageDealt;
  final int totalDamageReceived;
  final Duration combatDuration;
  final int actionsPerformed;
  final int criticalHits;
  final int missedAttacks;
  final int blockedAttacks;
  final int dodgedAttacks;
  final List<String>? usedActions;
  final CombatStats? finalPlayerStats;
  final CombatStats? finalEnemyStats;
  final String? combatRating;
  final Map<String, dynamic>? combatData;

  const CombatResult({
    required this.isVictory,
    required this.totalDamageDealt,
    required this.totalDamageReceived,
    required this.combatDuration,
    required this.actionsPerformed,
    this.criticalHits = 0,
    this.missedAttacks = 0,
    this.blockedAttacks = 0,
    this.dodgedAttacks = 0,
    this.usedActions,
    this.finalPlayerStats,
    this.finalEnemyStats,
    this.combatRating,
    this.combatData,
  });

  factory CombatResult.fromJson(Map<String, dynamic> json) =>
      _$CombatResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatResultToJson(this);

  @override
  CombatResult fromJson(Map<String, dynamic> json) =>
      _$CombatResultFromJson(json);

  CombatResult copyWith({
    bool? isVictory,
    int? totalDamageDealt,
    int? totalDamageReceived,
    Duration? combatDuration,
    int? actionsPerformed,
    int? criticalHits,
    int? missedAttacks,
    int? blockedAttacks,
    int? dodgedAttacks,
    List<String>? usedActions,
    CombatStats? finalPlayerStats,
    CombatStats? finalEnemyStats,
    String? combatRating,
    Map<String, dynamic>? combatData,
  }) {
    return CombatResult(
      isVictory: isVictory ?? this.isVictory,
      totalDamageDealt: totalDamageDealt ?? this.totalDamageDealt,
      totalDamageReceived: totalDamageReceived ?? this.totalDamageReceived,
      combatDuration: combatDuration ?? this.combatDuration,
      actionsPerformed: actionsPerformed ?? this.actionsPerformed,
      criticalHits: criticalHits ?? this.criticalHits,
      missedAttacks: missedAttacks ?? this.missedAttacks,
      blockedAttacks: blockedAttacks ?? this.blockedAttacks,
      dodgedAttacks: dodgedAttacks ?? this.dodgedAttacks,
      usedActions: usedActions ?? this.usedActions,
      finalPlayerStats: finalPlayerStats ?? this.finalPlayerStats,
      finalEnemyStats: finalEnemyStats ?? this.finalEnemyStats,
      combatRating: combatRating ?? this.combatRating,
      combatData: combatData ?? this.combatData,
    );
  }

  // Helper methods
  double get averageDamagePerAction =>
      actionsPerformed > 0 ? totalDamageDealt / actionsPerformed : 0.0;
  double get criticalHitRate =>
      actionsPerformed > 0 ? criticalHits / actionsPerformed : 0.0;
  double get missRate =>
      actionsPerformed > 0 ? missedAttacks / actionsPerformed : 0.0;
  double get blockRate =>
      actionsPerformed > 0 ? blockedAttacks / actionsPerformed : 0.0;
  double get dodgeRate =>
      actionsPerformed > 0 ? dodgedAttacks / actionsPerformed : 0.0;
  double get damagePerSecond => combatDuration.inSeconds > 0
      ? totalDamageDealt / combatDuration.inSeconds
      : 0.0;

  int get netDamage => totalDamageDealt - totalDamageReceived;
  double get damageEfficiency => totalDamageReceived > 0
      ? totalDamageDealt / totalDamageReceived
      : double.infinity;

  String get resultEmoji => isVictory ? '🏆' : '💀';

  String get performanceGrade {
    if (combatRating != null) return combatRating!;

    final efficiency = damageEfficiency;
    final critRate = criticalHitRate;
    final missRateValue = missRate;

    double score = 0;

    // Damage efficiency (40%)
    if (efficiency >= 3.0)
      score += 40;
    else if (efficiency >= 2.0)
      score += 30;
    else if (efficiency >= 1.5)
      score += 20;
    else if (efficiency >= 1.0)
      score += 10;

    // Critical hit rate (30%)
    if (critRate >= 0.3)
      score += 30;
    else if (critRate >= 0.2)
      score += 20;
    else if (critRate >= 0.1)
      score += 10;

    // Miss rate penalty (20%)
    if (missRateValue <= 0.05)
      score += 20;
    else if (missRateValue <= 0.1)
      score += 15;
    else if (missRateValue <= 0.2)
      score += 10;

    // Victory bonus (10%)
    if (isVictory) score += 10;

    if (score >= 90) return 'S';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }

  String get durationText {
    if (combatDuration.inMinutes > 0) {
      return '${combatDuration.inMinutes}m ${combatDuration.inSeconds % 60}s';
    }
    return '${combatDuration.inSeconds}s';
  }

  Map<String, dynamic> get detailedStatistics => {
    'result': isVictory ? 'Victory' : 'Defeat',
    'duration': durationText,
    'totalDamageDealt': totalDamageDealt,
    'totalDamageReceived': totalDamageReceived,
    'netDamage': netDamage,
    'actionsPerformed': actionsPerformed,
    'averageDamagePerAction': averageDamagePerAction.toStringAsFixed(1),
    'damagePerSecond': damagePerSecond.toStringAsFixed(1),
    'criticalHits': criticalHits,
    'criticalHitRate': '${(criticalHitRate * 100).toStringAsFixed(1)}%',
    'missedAttacks': missedAttacks,
    'missRate': '${(missRate * 100).toStringAsFixed(1)}%',
    'blockedAttacks': blockedAttacks,
    'dodgedAttacks': dodgedAttacks,
    'damageEfficiency': damageEfficiency.isFinite
        ? damageEfficiency.toStringAsFixed(2)
        : '∞',
    'performanceGrade': performanceGrade,
  };
}
