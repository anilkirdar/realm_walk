import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'fetched_initial_result.g.dart';

@JsonSerializable()
class FetchedInitialResult extends INetworkModel<FetchedInitialResult> {
  bool? isAccountSuspended;
  bool? isPremium;
  bool? isAbleToGetMission;
  int? submittedMissionCount;
  DateTime? premiumRenewalDate;
  String? subscriptionType;
  int? remainingChatTime;
  int? remainingAgentChatTime;
  int? totalChatTime;
  List<String>? linqoinRewards;
  List<String>? premiumRewards;
  bool? participatedInNPS;
  bool? isFirstInit;
  int? totalChatCount;
  int? waitingWaves;
  int? waveUpdates;

  FetchedInitialResult(
      {this.isAccountSuspended,
      this.isPremium,
      this.isAbleToGetMission,
      this.submittedMissionCount,
      this.premiumRenewalDate,
      this.subscriptionType,
      this.remainingChatTime,
      this.remainingAgentChatTime,
      this.totalChatTime,
      this.linqoinRewards,
      this.premiumRewards,
      this.participatedInNPS,
      this.isFirstInit,
      this.totalChatCount,
      this.waitingWaves,
      this.waveUpdates});

  @override
  FetchedInitialResult fromJson(Map<String, dynamic> json) =>
      FetchedInitialResult.fromJson(json);

  factory FetchedInitialResult.fromJson(Map<String, dynamic> json) =>
      _$FetchedInitialResultFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$FetchedInitialResultToJson(this);

  FetchedInitialResult copyWith({
    bool? isAccountSuspended,
    bool? isPremium,
    bool? isAbleToGetMission,
    int? submittedMissionCount,
    DateTime? premiumRenewalDate,
    String? subscriptionType,
    int? remainingChatTime,
    int? remainingAgentChatTime,
    int? totalChatTime,
    List<String>? linqoinRewards,
    bool? participatedInNPS,
    bool? isFirstInit,
    int? totalChatCount,
    int? waitingWaves,
    int? waveUpdates,
  }) {
    return FetchedInitialResult(
      isAccountSuspended: isAccountSuspended ?? this.isAccountSuspended,
      isPremium: isPremium ?? this.isPremium,
      isAbleToGetMission: isAbleToGetMission ?? this.isAbleToGetMission,
      submittedMissionCount:
          submittedMissionCount ?? this.submittedMissionCount,
      premiumRenewalDate: premiumRenewalDate ?? this.premiumRenewalDate,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      remainingChatTime: remainingChatTime ?? this.remainingChatTime,
      remainingAgentChatTime:
          remainingAgentChatTime ?? this.remainingAgentChatTime,
      totalChatTime: totalChatTime ?? this.totalChatTime,
      linqoinRewards: linqoinRewards ?? this.linqoinRewards,
      participatedInNPS: participatedInNPS ?? this.participatedInNPS,
      isFirstInit: isFirstInit ?? this.isFirstInit,
      totalChatCount: totalChatCount ?? this.totalChatCount,
      waitingWaves: waitingWaves ?? this.waitingWaves,
      waveUpdates: waveUpdates ?? this.waveUpdates,
    );
  }
}
