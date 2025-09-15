import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/base/model/base_view_model.dart';
import '../service/main_service.dart';
import 'i_main_viewmodel.dart';

part 'main_viewmodel.g.dart';

class MainViewModel = MainViewModelBase with _$MainViewModel;

abstract class MainViewModelBase with Store, BaseViewModel, IMainViewModel {
  @override
  void setContext(BuildContext context) {
    viewModelContext = context;
  }

  @override
  Future<void> init() async {
    // mainService = MainService(vexanaManager.networkManager);

    // hallwayViewModel = viewModelContext.read<HallwayViewModel>();
  }

  dispose() {
    printDev.debug("MAIN VIEW DISPOSE");
  }

  late MainService mainService;

  // late HallwayViewModel hallwayViewModel;
  }
  final List<BuildContext> _navigationContext = [];

  /// Add last context to the list of contexts,
  /// so they can be used when popping screens
  @override
  void setNavigationContext(BuildContext context) {
    /// Before adding context, the below condition makes sure
    /// that context was mounted
    if (context.mounted == true) {
      _navigationContext.add(context);
    }
  }

  // @override
  // @action
  // void updateMissionView() {
  //   ///While signing out, this function is being called;
  //   ///So make sure that token is not empty when returning a widget
  //   if (_userId == -1) {
  //     missionLocation = '';
  //     return;
  //   }

  //   final isFQActive =
  //       localManager.getBoolValue(LocalManagerKeys.isFQCodeActive) ?? false;
  //   final String fetchedMission = localManager.getStringValue(
  //     LocalManagerKeys.fetchedMission,
  //   );
  //   final bool doesFetchedMissionExist =
  //       (fetchedMission.isNotEmpty && fetchedMission != "null");

  //   if (isFQActive) {
  //     cachedMissionMode = MissionModeEnum.friendQuest;
  //   }

  //   final String getViewForMission = getMissionView(
  //     isFQActive: isFQActive,

  //     ///TODO: revise BLogic so that doesFetchedMissionExist and
  //     ///TODO: isMissionPicked are combined into one variable
  //     doesFetchedMissionExist: doesFetchedMissionExist || isMissionPicked,
  //     isMissionSubmitted: isMissionSubmitted,
  //     isUserPremium: isUserPremium,
  //     globalChallengeList: isGlobalChallengeAvailable,
  //     cachedMissionMode: cachedMissionMode,
  //   );

  //   if (isFQActive && isUserPremium) {
  //     flutterErrorToast(viewModelContext.s.toastAlreadyPremium);
  //     LocalManager.instance.removeValue(LocalManagerKeys.isFQCodeActive);
  //   }

  //   missionLocation = getViewForMission;
  // }