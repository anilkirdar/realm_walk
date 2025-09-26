import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/model/base_view_model.dart';
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
    mainService = MainService(vexanaManager.networkManager);
  }

  dispose() {
    printDev.debug("MAIN VIEW DISPOSE");
  }

  late MainService mainService;
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
