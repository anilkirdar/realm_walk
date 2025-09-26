// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'combat_sessions.g.dart';

@JsonSerializable()
class CombatSession extends INetworkModel<CombatSession> {
  final String? id;
  final String? playerId;
  final String? monsterId;
  final Map<String, dynamic>? monsterStats;
  final Map<String, dynamic>? playerStats;
  final DateTime? startTime;
  final bool isActive;

  const CombatSession({
    this.id,
    this.playerId,
    this.monsterId,
    this.monsterStats,
    this.playerStats,
    this.startTime,
    this.isActive = true,
  });

  factory CombatSession.fromJson(Map<String, dynamic> json) =>
      _$CombatSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatSessionToJson(this);

  @override
  CombatSession fromJson(Map<String, dynamic> json) =>
      _$CombatSessionFromJson(json);
}
