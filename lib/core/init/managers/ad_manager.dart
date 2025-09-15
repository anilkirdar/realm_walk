import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../product/enum/local_keys_enum.dart';
import '../cache/local_manager.dart';

enum AdManagerUnits {
  hallwayWatchAd,
  hallwayWatchAdBonus,
  hallwayAfterCall,
  linqoinsWatchAd,
  linqoinsWatchAdBonus,
}

class AdManager {
  static final AdManager _instance = AdManager._internal();

  static AdManager get instance => _instance;

  AdManager._internal();

  void init() {
    MobileAds.instance.initialize();
  }

  void loadRewardedAd(AdManagerUnits unit, RewardedAdLoadCallback callback) {
    final adUnitId = _getAdUnitId(unit);
    RewardedAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: callback,
    );
  }

  void loadInterstitialAd(
    AdManagerUnits unit,
    InterstitialAdLoadCallback callback,
  ) {
    final adUnitId = _getAdUnitId(unit);
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: callback,
    );
  }

  String _getAdUnitId(AdManagerUnits unit) {
    final isStaging =
        LocalManager.instance.getBoolValue(LocalManagerKeys.isStagingServer) ??
        false;

    if (isStaging) {
      switch (unit) {
        case AdManagerUnits.hallwayWatchAd:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/1418421931'
              : 'ca-app-pub-5560295540047246/2294289831';
        case AdManagerUnits.hallwayWatchAdBonus:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/7486906762'
              : 'ca-app-pub-5560295540047246/3078987965';
        case AdManagerUnits.hallwayAfterCall:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/8420143669'
              : 'ca-app-pub-5560295540047246/3539088748';
        case AdManagerUnits.linqoinsWatchAd:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/9276855333'
              : 'ca-app-pub-5560295540047246/7452809218';
        case AdManagerUnits.linqoinsWatchAdBonus:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/8974941731'
              : 'ca-app-pub-5560295540047246/8381913359';
        default:
          throw Exception('Invalid ad unit');
      }
    } else {
      switch (unit) {
        case AdManagerUnits.hallwayWatchAd:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/3161695122'
              : 'ca-app-pub-5560295540047246/7931795753';
        case AdManagerUnits.hallwayWatchAdBonus:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/6026681557'
              : 'ca-app-pub-5560295540047246/6618714088';
        case AdManagerUnits.hallwayAfterCall:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/9980903271'
              : 'ca-app-pub-5560295540047246/8317872782';
        case AdManagerUnits.linqoinsWatchAd:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/4593297843'
              : 'ca-app-pub-5560295540047246/5147831610';
        case AdManagerUnits.linqoinsWatchAdBonus:
          return Platform.isIOS
              ? 'ca-app-pub-5560295540047246/8557722882'
              : 'ca-app-pub-5560295540047246/9774338308';
        default:
          throw Exception('Invalid ad unit');
      }
    }
  }
}
