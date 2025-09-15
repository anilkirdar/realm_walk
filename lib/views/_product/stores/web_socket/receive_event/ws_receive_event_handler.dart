// import 'package:linqi_app/core/init/print_dev.dart';
// import 'package:linqi_app/views/_product/_model/hallway/hallway_filter_model.dart';
// import 'package:linqi_app/views/_product/stores/web_socket/models/agent_user_transcription_result_model.dart';
// import 'package:linqi_app/views/_product/stores/web_socket/models/connected_ack_model.dart';
// import 'package:linqi_app/views/_product/stores/web_socket/models/magic_match_ack_model.dart';
// import 'package:linqi_app/views/_product/stores/web_socket/models/producer_create_model.dart';
// import 'package:linqi_app/views/_product/stores/web_socket/models/transport_restart_ice_model.dart';
// import 'package:mobx/mobx.dart';

// import '../../../../../core/init/network/modules/network_model_parser.dart';
// import '../../../../../product/enum/hallway/hallway_enum.dart';
// import '../../../../../product/models/web_rtc/signaling/ice_candidate/ice_candidate_model.dart';
// import '../../../../../product/models/web_rtc/signaling/session_description/session_description_model.dart';
// import '../../../../hallway/model/ws_event_model.dart';
// import '../../../_model/user/hallway_user_model.dart';
// import '../models/call_incoming_model.dart';
// import '../models/call_question_ack_model.dart';
// import '../models/call_user_ack_model.dart';
// import '../models/wave_user_ack_model.dart';
// import 'i_ws_receive_event_handler.dart';

// class WSReceiveEventHandler extends IWSReceiveEventHandler {
//   @override
//   void onUsersListReceived({
//     required WSEventModel parsedEvent,
//     required ObservableList<HallwayUserModel> hallwayUsers,
//     required void Function(bool value) setIsHallwayLoading,
//     required void Function(HallwayFilterModel filter) setHallwayFilter,
//   }) {
//     final variant = parsedEvent.d?["variant"];
//     final HallwayEnum hallwayEnum =
//         HallwayEnum.values.firstWhere((element) => element.rawValue == variant);

//     final users =
//         ModelParser.parseBody<List<HallwayUserModel>, HallwayUserModel>(
//               model: HallwayUserModel(),
//               responseBody: parsedEvent.d?["users"],
//             )?.toList() ??
//             [];

//     if (users.isNotEmpty) {
//       final userIds = {for (var user in users) user.id};
//       final hallwayVariant = hallwayEnum.rawValue;

//       hallwayUsers
//         ..removeWhere((user) =>
//             userIds.contains(user.id) || user.hallwayVariant == hallwayVariant)
//         ..addAll(
//             users.map((user) => user.copyWith(hallwayVariant: hallwayVariant)))
//         ..sort((a, b) => (b.sortingScore ?? 0).compareTo(a.sortingScore ?? 0));
//     }

//     setIsHallwayLoading(false);

//     if (parsedEvent.d?["filter"] != null) {
//       setHallwayFilter(HallwayFilterModel.fromJson(parsedEvent.d?["filter"]));
//     }
//   }

//   @override
//   void onUserChangeEventReceived({
//     required WSEventModel event,
//     required List<HallwayUserModel> hallwayUsers,
//     required HallwayEnum hallwayEnum,
//     required void Function(HallwayUserModel newValue) emitUserChange,
//   }) {
//     final HallwayUserModel user = HallwayUserModel.fromJson(event.d!['user']);
//     emitUserChange(user);

//     final int userIndex =
//         hallwayUsers.indexWhere((element) => element.id == user.id);

//     /// removes from list since after update its position changes
//     if (userIndex < hallwayUsers.length && userIndex > -1) {
//       hallwayUsers.removeAt(userIndex);
//     }

//     hallwayUsers.add(user);
//     hallwayUsers.sort((a, b) => (b.sortingScore ?? 0) - (a.sortingScore ?? 0));

//     return;
//   }

//   @override
//   void onWaveUserAckReceived({
//     required WSEventModel event,
//     required void Function(WaveUserAckModel newValue) emitWaveUserAck,
//   }) {
//     /// Parse json to model
//     final WaveUserAckModel waveUserAck =
//         WaveUserAckModel.fromJson(event.d ?? {});

//     /// Check if isSuccessful is null, if null, don't send an event
//     if (waveUserAck.isSuccessful == null) return;

//     emitWaveUserAck(waveUserAck);
//   }

//   @override
//   void onWaverChangedReceived({
//     required WSEventModel event,
//     required void Function(HallwayUserModel user) emitWaverChanged,
//   }) {
//     final HallwayUserModel user = HallwayUserModel.fromJson(event.d!['user']);
//     emitWaverChanged(user);
//   }

//   @override
//   void onWaveeChangedReceived({
//     required WSEventModel event,
//     required void Function(HallwayUserModel user) emitWaveeChanged,
//   }) {
//     final HallwayUserModel user = HallwayUserModel.fromJson(event.d!['user']);
//     emitWaveeChanged(user);
//   }

//   @override
//   void onCallQuestionReceived({
//     required WSEventModel event,
//     required void Function(CallQuestionAckModel user) emitCallQuestionACk,
//   }) {
//     if (event.d == null) return;
//     final CallQuestionAckModel callQuestionAck =
//         CallQuestionAckModel.fromJson(event.d ?? {});
//     emitCallQuestionACk(callQuestionAck);
//   }

//   @override
//   void onCallHangUpReceived({
//     required WSEventModel parsedEvent,
//     required void Function(String newValue) emitCallHangUp,
//   }) {
//     PrintDev.instance
//         .debug("CALL_HANGUP_RECEIVED: ${parsedEvent.d?['reason']}");
//     emitCallHangUp(parsedEvent.d?['reason']);
//   }

//   @override
//   void onCallICECandidateReceived({
//     required WSEventModel parsedEvent,
//     required void Function(ICECandidateModel newValue) emitICECandidate,
//   }) {
//     final ICECandidateModel candidate =
//         ICECandidateModel.fromJson(parsedEvent.d ?? {});
//     if (candidate.candidate != null) {
//       emitICECandidate(candidate);
//     }
//   }

//   @override
//   void onCallIncomingReceived({
//     required WSEventModel parsedEvent,
//     required void Function(CallIncomingModel newValue) emitIncomingCall,
//   }) {
//     final CallIncomingModel user = CallIncomingModel.fromJson(parsedEvent.d!);
//     emitIncomingCall(user);
//   }

//   @override
//   void onCallSessionDescriptionReceived({
//     required WSEventModel parsedEvent,
//     required void Function(SessionDescriptionModel newValue)
//         emitSessionDescription,
//   }) {
//     final SessionDescriptionModel sessionDescription =
//         SessionDescriptionModel.fromJson(parsedEvent.d ?? {});

//     if (sessionDescription.description != null) {
//       emitSessionDescription(sessionDescription);
//     }
//   }

//   void onCallUserReceived({
//     required WSEventModel parsedEvent,
//     required void Function(Map<String, dynamic> rtpCapabilities)
//         setRtpCapabilities,
//     required void Function(RoomInfoModel roomInfo) setRoomInfo,
//     required void Function(CallUserAckModel newValue) emitCallUserAck,
//   }) {
//     try {
//       /// there are two types of parsed events
//       /// 1) error (on error)
//       /// 2) configuration (on success)

//       if (parsedEvent.d?['rtpCapabilities'] != null) {
//         setRtpCapabilities(parsedEvent.d?['rtpCapabilities']);
//         setRoomInfo(RoomInfoModel.fromJson(parsedEvent.d?['info']));
//         emitCallUserAck(
//             CallUserAckModel.fromJson(parsedEvent.d!)..isCallAccepted = true);
//         return;
//       }

//       /// Checking if error is received
//       if (parsedEvent.d?['error'] != null) {
//         printDev.debug("errorrr: ${parsedEvent.d?['error']}");

//         emitCallUserAck(CallUserAckModel(
//             isCallAccepted: false,
//             error: parsedEvent.d?['error'],
//             timeout: parsedEvent.d?['timeout']));

//         return;
//       } else {
//         throw Exception('configuration and error is null');
//       }
//     } catch (e) {
//       emitCallUserAck(CallUserAckModel(isCallAccepted: false));
//       crashlyticsManager.sendACrash(
//           error: e.toString(),
//           stackTrace: StackTrace.current,
//           reason: 'onCallUserReceived in ws_receive_event_handler');
//       return;
//     }
//   }

//   void onAgentStateChangedReceived({
//     required WSEventModel parsedEvent,
//     required void Function(String agentState) emitAgentStateChanged,
//   }) {
//     final String agentCodeName = parsedEvent.d?['state'] ?? '';
//     emitAgentStateChanged(agentCodeName);
//   }

//   void onAgentTranscriptionReceived({
//     required WSEventModel parsedEvent,
//     required void Function(String agentTranscription) emitAgentTranscription,
//   }) {
//     final String agentTranscription = parsedEvent.d?['transcription'] ?? '';
//     emitAgentTranscription(agentTranscription);
//   }

//   void onAgentUserTranscriptionReceived({
//     required WSEventModel parsedEvent,
//     required void Function(
//             AgentUserTranscriptionResultModel agentUserTranscription)
//         emitAgentUserTranscription,
//   }) {
//     final AgentUserTranscriptionResultModel agentUserTranscription =
//         AgentUserTranscriptionResultModel.fromJson(parsedEvent.d ?? {});
//     emitAgentUserTranscription(agentUserTranscription);
//   }

//   void onSetRtpCapabilitiesReceived(
//       {required WSEventModel parsedEvent,
//       required void Function() emitSetRtpCapabilities}) {
//     emitSetRtpCapabilities();
//   }

//   void onProducerCreateReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(ProducerCreateModel producerCreateModel)
//           emitProducerCreate}) {
//     print("onProducerCreateReceived: ${parsedEvent.d}");
//     emitProducerCreate(ProducerCreateModel.fromJson(parsedEvent.d!));
//   }

//   void onProducerConnectReceived(
//       {required WSEventModel parsedEvent,
//       required void Function() emitProducerConnect}) {
//     print("onProducerConnectReceived: ${parsedEvent.d}");
//     emitProducerConnect();
//   }

//   void onProducerProduceReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(String id) emitProducerProduce}) {
//     print("onProducerProduceReceived: ${parsedEvent.d}");
//     emitProducerProduce(parsedEvent.d!['id']);
//   }

//   void onProducerRestartIceReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(TransportRestartIceModel newValue)
//           emitProducerRestartIce}) {
//     print("onProducerRestartIceReceived: ${parsedEvent.d}");
//     emitProducerRestartIce(TransportRestartIceModel.fromJson(parsedEvent.d!));
//   }

//   void onConsumerCreateReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(ProducerCreateModel producerCreateModel)
//           emitConsumerCreate}) {
//     print("onConsumerCreateReceived: ${parsedEvent.d}");
//     emitConsumerCreate(ProducerCreateModel.fromJson(parsedEvent.d!));
//   }

//   void onConsumerConnectReceived(
//       {required WSEventModel parsedEvent,
//       required void Function() emitConsumerConnect}) {
//     print("onConsumerConnectReceived: ${parsedEvent.d}");
//     emitConsumerConnect();
//   }

//   void onConsumerConsumeReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(ProducerCreateModel newValue)
//           emitConsumerConsume}) {
//     print("onConsumerConsumeReceived: ${parsedEvent.d}");
//     emitConsumerConsume(ProducerCreateModel.fromJson(parsedEvent.d!));
//   }

//   void onConsumerRestartIceReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(TransportRestartIceModel newValue)
//           emitConsumerRestartIce}) {
//     print("onConsumerRestartIceReceived: ${parsedEvent.d}");
//     emitConsumerRestartIce(TransportRestartIceModel.fromJson(parsedEvent.d!));
//   }

//   @override
//   void onCallConnectedReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(ConnectedAckModel connectedAckModel)
//           emitCallConnected}) {
//     emitCallConnected(ConnectedAckModel.fromJson(parsedEvent.d!));
//   }

//   void onCallReconnectingReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(String userId) emitCallReconnecting}) {
//     emitCallReconnecting(parsedEvent.d!['userId'].toString());
//   }

//   void onCallReconnectedReceived(
//       {required WSEventModel parsedEvent,
//       required void Function() emitCallReconnected}) {
//     emitCallReconnected();
//   }

//   void onMagicMatchAckReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(MagicMatchAckModel newValue) emitMagicMatchAck}) {
//     emitMagicMatchAck(MagicMatchAckModel.fromJson(parsedEvent.d!));
//   }

//   void onReFetchLinqiShop(
//       {required WSEventModel parsedEvent,
//       required void Function() emitReFetchLinqiShop}) {
//     print("#event onReFetchLinqiShop");
//     emitReFetchLinqiShop();
//   }

//   void onReFetchUserInit(
//       {required WSEventModel parsedEvent,
//       required void Function() emitReFetchUserInit}) {
//     print("#event onReFetchUserInit");
//     emitReFetchUserInit();
//   }

//   void onRefetchWaves(
//       {required WSEventModel parsedEvent,
//       required void Function() emitRefetchWaves}) {
//     print("#event onRefetchWaves");
//     emitRefetchWaves();
//   }
// }
