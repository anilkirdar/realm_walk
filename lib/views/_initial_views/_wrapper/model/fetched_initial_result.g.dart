// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetched_initial_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchedInitialResult _$FetchedInitialResultFromJson(
  Map<String, dynamic> json,
) => FetchedInitialResult(
  isAccountSuspended: json['isAccountSuspended'] as bool?,
  isPremium: json['isPremium'] as bool?,
  isAbleToGetMission: json['isAbleToGetMission'] as bool?,
  submittedMissionCount: (json['submittedMissionCount'] as num?)?.toInt(),
  premiumRenewalDate: json['premiumRenewalDate'] == null
      ? null
      : DateTime.parse(json['premiumRenewalDate'] as String),
  subscriptionType: json['subscriptionType'] as String?,
  remainingChatTime: (json['remainingChatTime'] as num?)?.toInt(),
  remainingAgentChatTime: (json['remainingAgentChatTime'] as num?)?.toInt(),
  totalChatTime: (json['totalChatTime'] as num?)?.toInt(),
  linqoinRewards: (json['linqoinRewards'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  premiumRewards: (json['premiumRewards'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  participatedInNPS: json['participatedInNPS'] as bool?,
  isFirstInit: json['isFirstInit'] as bool?,
  totalChatCount: (json['totalChatCount'] as num?)?.toInt(),
  waitingWaves: (json['waitingWaves'] as num?)?.toInt(),
  waveUpdates: (json['waveUpdates'] as num?)?.toInt(),
);

Map<String, dynamic> _$FetchedInitialResultToJson(
  FetchedInitialResult instance,
) => <String, dynamic>{
  'isAccountSuspended': instance.isAccountSuspended,
  'isPremium': instance.isPremium,
  'isAbleToGetMission': instance.isAbleToGetMission,
  'submittedMissionCount': instance.submittedMissionCount,
  'premiumRenewalDate': instance.premiumRenewalDate?.toIso8601String(),
  'subscriptionType': instance.subscriptionType,
  'remainingChatTime': instance.remainingChatTime,
  'remainingAgentChatTime': instance.remainingAgentChatTime,
  'totalChatTime': instance.totalChatTime,
  'linqoinRewards': instance.linqoinRewards,
  'premiumRewards': instance.premiumRewards,
  'participatedInNPS': instance.participatedInNPS,
  'isFirstInit': instance.isFirstInit,
  'totalChatCount': instance.totalChatCount,
  'waitingWaves': instance.waitingWaves,
  'waveUpdates': instance.waveUpdates,
};
