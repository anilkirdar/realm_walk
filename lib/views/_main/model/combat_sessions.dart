// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import 'ar_models.dart';
import 'combat_models.dart';

part 'combat_sessions.g.dart';

@JsonSerializable(explicitToJson: true)
class CombatSession extends INetworkModel<CombatSession> {
  final String id;
  final String playerId;
  final String monsterId;
  final ARMonster? monster;
  final CombatStats playerStats;
  final CombatStats monsterStats;
  final DateTime startTime;
  final DateTime? endTime;
  final CombatSessionStatus status;
  final List<CombatTurn> turns;
  final double? playerLatitude;
  final double? playerLongitude;
  final String? sessionType;

  const CombatSession({
    required this.id,
    required this.playerId,
    required this.monsterId,
    this.monster,
    required this.playerStats,
    required this.monsterStats,
    required this.startTime,
    this.endTime,
    required this.status,
    this.turns = const [],
    this.playerLatitude,
    this.playerLongitude,
    this.sessionType,
  });

  factory CombatSession.fromJson(Map<String, dynamic> json) =>
      _$CombatSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatSessionToJson(this);

  @override
  CombatSession fromJson(Map<String, dynamic> json) =>
      _$CombatSessionFromJson(json);

  CombatSession copyWith({
    String? id,
    String? playerId,
    String? monsterId,
    ARMonster? monster,
    CombatStats? playerStats,
    CombatStats? monsterStats,
    DateTime? startTime,
    DateTime? endTime,
    CombatSessionStatus? status,
    List<CombatTurn>? turns,
    double? playerLatitude,
    double? playerLongitude,
    String? sessionType,
  }) {
    return CombatSession(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      monsterId: monsterId ?? this.monsterId,
      monster: monster ?? this.monster,
      playerStats: playerStats ?? this.playerStats,
      monsterStats: monsterStats ?? this.monsterStats,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      turns: turns ?? this.turns,
      playerLatitude: playerLatitude ?? this.playerLatitude,
      playerLongitude: playerLongitude ?? this.playerLongitude,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  // Helper methods
  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);

  bool get isActive => status == CombatSessionStatus.active;
  bool get isCompleted => status == CombatSessionStatus.completed;
  bool get isAbandoned => status == CombatSessionStatus.abandoned;

  int get turnCount => turns.length;

  List<CombatTurn> get playerTurns =>
      turns.where((turn) => turn.isPlayerTurn).toList();

  List<CombatTurn> get monsterTurns =>
      turns.where((turn) => !turn.isPlayerTurn).toList();

  int get totalPlayerDamage =>
      playerTurns.fold(0, (sum, turn) => sum + (turn.damage ?? 0));

  int get totalMonsterDamage =>
      monsterTurns.fold(0, (sum, turn) => sum + (turn.damage ?? 0));

  CombatResult? get result {
    if (!isCompleted) return null;

    return CombatResult(
      isVictory: playerStats.isAlive && monsterStats.isDead,
      totalDamageDealt: totalPlayerDamage,
      totalDamageReceived: totalMonsterDamage,
      combatDuration: duration,
      actionsPerformed: playerTurns.length,
      criticalHits: playerTurns
          .where((turn) => turn.isCritical ?? false)
          .length,
      missedAttacks: playerTurns.where((turn) => turn.isMiss ?? false).length,
      usedActions: playerTurns
          .map((turn) => turn.actionId)
          .whereType<String>()
          .toList(),
      finalPlayerStats: playerStats,
      finalEnemyStats: monsterStats,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CombatTurn extends INetworkModel<CombatTurn> {
  final String id;
  final String sessionId;
  final int turnNumber;
  final bool isPlayerTurn;
  final String? actionId;
  final String? actionName;
  final int? damage;
  final bool? isCritical;
  final bool? isMiss;
  final List<String>? statusEffects;
  final DateTime timestamp;
  final CombatStats? statsAfterTurn;

  const CombatTurn({
    required this.id,
    required this.sessionId,
    required this.turnNumber,
    required this.isPlayerTurn,
    this.actionId,
    this.actionName,
    this.damage,
    this.isCritical,
    this.isMiss,
    this.statusEffects,
    required this.timestamp,
    this.statsAfterTurn,
  });

  factory CombatTurn.fromJson(Map<String, dynamic> json) =>
      _$CombatTurnFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatTurnToJson(this);

  @override
  CombatTurn fromJson(Map<String, dynamic> json) => _$CombatTurnFromJson(json);

  CombatTurn copyWith({
    String? id,
    String? sessionId,
    int? turnNumber,
    bool? isPlayerTurn,
    String? actionId,
    String? actionName,
    int? damage,
    bool? isCritical,
    bool? isMiss,
    List<String>? statusEffects,
    DateTime? timestamp,
    CombatStats? statsAfterTurn,
  }) {
    return CombatTurn(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      turnNumber: turnNumber ?? this.turnNumber,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      actionId: actionId ?? this.actionId,
      actionName: actionName ?? this.actionName,
      damage: damage ?? this.damage,
      isCritical: isCritical ?? this.isCritical,
      isMiss: isMiss ?? this.isMiss,
      statusEffects: statusEffects ?? this.statusEffects,
      timestamp: timestamp ?? this.timestamp,
      statsAfterTurn: statsAfterTurn ?? this.statsAfterTurn,
    );
  }

  // Helper methods
  bool get isHealing => (damage ?? 0) < 0;
  bool get hasStatusEffects =>
      statusEffects != null && statusEffects!.isNotEmpty;

  String get turnTypeEmoji => isPlayerTurn ? '🗡️' : '👹';
  String get resultEmoji {
    if (isMiss == true) return '💨';
    if (isCritical == true) return '💥';
    if (isHealing) return '💚';
    return '⚔️';
  }
}

enum CombatSessionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('abandoned')
  abandoned,
  @JsonValue('expired')
  expired,
}

extension CombatSessionStatusExtension on CombatSessionStatus {
  String get displayName {
    switch (this) {
      case CombatSessionStatus.pending:
        return 'Bekliyor';
      case CombatSessionStatus.active:
        return 'Aktif';
      case CombatSessionStatus.completed:
        return 'Tamamlandı';
      case CombatSessionStatus.abandoned:
        return 'Terk Edildi';
      case CombatSessionStatus.expired:
        return 'Süresi Doldu';
    }
  }

  String get emoji {
    switch (this) {
      case CombatSessionStatus.pending:
        return '⏳';
      case CombatSessionStatus.active:
        return '⚔️';
      case CombatSessionStatus.completed:
        return '✅';
      case CombatSessionStatus.abandoned:
        return '🏃';
      case CombatSessionStatus.expired:
        return '⏰';
    }
  }

  bool get isFinished =>
      this == CombatSessionStatus.completed ||
      this == CombatSessionStatus.abandoned ||
      this == CombatSessionStatus.expired;
}
