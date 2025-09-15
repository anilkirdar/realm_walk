import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../../../core/constants/assets/audio_const.dart';
import 'i_ws_call_manager.dart';

class WSCallManager extends IWSCallManager {
  static WSCallManager? _instance;

  static WSCallManager get instance {
    return _instance ??= WSCallManager._init();
  }

  WSCallManager._init();

  @override
  void intBeepingPlayer() {
    beepingPlayer = AudioPlayer();
  }

  @override
  void intConnectingPlayer() {
    connectingPlayer ??= AudioPlayer();
  }

  @override
  Future<void> stopBeeping() async {
    if (beepingPlayer != null) {
      await beepingPlayer?.stop();
      await beepingPlayer?.release();
    }
  }

  @override
  Future<void> playBeeping() async {
    try {
      final AssetSource ringtone = AssetSource(AudioConst.beepSound);
      if (beepingPlayer != null) {
        await beepingPlayer!.setVolume(1);
        await beepingPlayer!.play(ringtone);

        beepingPlayer!.setReleaseMode(ReleaseMode.loop);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> playConnecting() async {
    try {
      final AssetSource ringtone = AssetSource(AudioConst.reconnect);

      if (connectingPlayer != null) {
        await connectingPlayer!.setVolume(1);
        await connectingPlayer!.play(ringtone);

        connectingPlayer!.setReleaseMode(ReleaseMode.loop);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> stopConnecting() async {
    if (connectingPlayer != null) {
      await connectingPlayer!.stop();
      await connectingPlayer!.release();
    }
  }
}
