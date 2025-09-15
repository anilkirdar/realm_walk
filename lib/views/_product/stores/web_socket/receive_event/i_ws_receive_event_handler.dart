// import 'package:linqi_app/product/enum/hallway/hallway_enum.dart';
// import 'package:linqi_app/views/_product/_model/hallway/hallway_filter_model.dart';
// import 'package:linqi_app/views/_product/stores/web_socket/models/connected_ack_model.dart';
// import 'package:mobx/mobx.dart';

// import '../../../../../core/base/service/base_service.dart';
// import '../../../../../product/models/web_rtc/signaling/ice_candidate/ice_candidate_model.dart';
// import '../../../../../product/models/web_rtc/signaling/session_description/session_description_model.dart';
// import '../../../../hallway/model/ws_event_model.dart';
// import '../../../_model/user/hallway_user_model.dart';
// import '../models/call_question_ack_model.dart';
// import '../models/wave_user_ack_model.dart';

// abstract class IWSReceiveEventHandler extends BaseService {
//   void onUsersListReceived(
//       {required WSEventModel parsedEvent,
//       required ObservableList<HallwayUserModel> hallwayUsers,
//       required void Function(bool value) setIsHallwayLoading,
//       required void Function(HallwayFilterModel filter) setHallwayFilter});

//   void onUserChangeEventReceived({
//     required WSEventModel event,
//     required List<HallwayUserModel> hallwayUsers,
//     required HallwayEnum hallwayEnum,
//     required void Function(HallwayUserModel newValue) emitUserChange,
//   });

//   /// On Wave User Acknowledgement Received
//   /// Data object structure:
//   /// {
//   /// "isSuccessful": boolean // false if notification couldn't sent or coolDown.
//   /// "cooldown": ?number // set if waver is in coolDown. In minutes.
//   /// "messaage": ?string // set if waver is not in coolDown but isSuccessful is false.
//   /// }
//   void onWaveUserAckReceived({
//     required WSEventModel event,
//     required void Function(WaveUserAckModel newValue) emitWaveUserAck,
//   });

//   /// On Waver User Change Received
//   void onWaverChangedReceived({
//     required WSEventModel event,
//     required void Function(HallwayUserModel user) emitWaverChanged,
//   });

//   void onWaveeChangedReceived({
//     required WSEventModel event,
//     required void Function(HallwayUserModel user) emitWaveeChanged,
//   });

//   void onCallQuestionReceived({
//     required WSEventModel event,
//     required void Function(CallQuestionAckModel user) emitCallQuestionACk,
//   });

//   /// webRTC
//   void onCallICECandidateReceived({
//     required WSEventModel parsedEvent,
//     required void Function(ICECandidateModel newValue) emitICECandidate,
//   });

//   /// webRTC
//   void onCallSessionDescriptionReceived({
//     required WSEventModel parsedEvent,
//     required void Function(SessionDescriptionModel newValue)
//         emitSessionDescription,
//   });

//   /// webRTC
//   void onCallHangUpReceived({
//     required WSEventModel parsedEvent,
//     required void Function(String newValue) emitCallHangUp,
//   });

//   /// webRTC
//   void onCallConnectedReceived(
//       {required WSEventModel parsedEvent,
//       required void Function(ConnectedAckModel connectedAckModel)
//           emitCallConnected});
// }
