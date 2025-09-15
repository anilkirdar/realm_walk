import 'package:audioplayers/audioplayers.dart';

import '../../../../../core/init/firebase/crashlytics/crashlytics_manager.dart';

abstract class IWSCallManager {
  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;

  AudioPlayer? beepingPlayer;

  AudioPlayer? connectingPlayer;

  void intBeepingPlayer();

  void intConnectingPlayer();

  Future<void> playBeeping();

  Future<void> stopBeeping();

  Future<void> playConnecting();

  Future<void> stopConnecting();
}
