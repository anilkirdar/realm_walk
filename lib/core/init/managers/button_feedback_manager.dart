import 'package:universal_io/io.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../../constants/assets/audio_const.dart';

class FeedbackManager {
  static FeedbackManager? _instance;
  static FeedbackManager get instance {
    return _instance ??= FeedbackManager._init();
  }

  FeedbackManager._init() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
      ),
    );
  }

  late AudioPlayer _audioPlayer;

  Future<void> _playSound(String soundAsset) async {
    try {
      bool isSilent = await _getSoundMode();
      if (isSilent) return;

      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.stop();
      }

      await _audioPlayer.play(
        AssetSource(soundAsset),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      print(e);
    }
  }

  void playClickSound() {
    Future.delayed(Duration.zero, () async {
      await _playSound(AudioConst.buttonClick);
    });
  }

  void playAlertSound() {
    Future.delayed(Duration.zero, () async {
      await _playSound(AudioConst.buttonAlert);
    });
  }

  void playFailSound() {
    Future.delayed(Duration.zero, () async {
      await _playSound(AudioConst.fail);
    });
  }

  void playFireSound() {
    Future.delayed(Duration.zero, () async {
      await _playSound(AudioConst.fire);
    });
  }

  void provideHapticFeedback() {
    Future.delayed(Duration.zero, () {
      try {
        HapticFeedback.mediumImpact();
      } catch (e) {
        print(e);
      }
    });
  }

  void handleButtonTap() {
    playClickSound();
    provideHapticFeedback();
    stopMusic();
  }

  void handleAlertButtonTap() {
    playAlertSound();
    provideHapticFeedback();
  }

  void handleFailSound() {
    playFailSound();
    provideHapticFeedback();
  }

  void handleFireSound() {
    playFireSound();
    provideHapticFeedback();
  }

  void stopMusic() {
    Future.delayed(Duration.zero, () async {
      try {
        await _audioPlayer.stop();
      } catch (e) {
        print(e);
      }
    });
  }

  Future<bool> _getSoundMode() async {
    try {
      if (Platform.isIOS) {
        return false;
      }

      const MethodChannel channel = MethodChannel('sound_mode');
      final String soundMode = await channel.invokeMethod(
        'getSoundMode',
      ); // "silent", "vibrate", "normal", "unavailable"
      print('Sound mode: $soundMode');
      if (soundMode == "normal" || soundMode == "unavailable") {
        return false;
      }
      return true;
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }
}
