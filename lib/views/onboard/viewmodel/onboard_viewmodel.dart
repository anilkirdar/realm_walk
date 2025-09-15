import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/base/model/base_view_model.dart';
import '../../../core/init/notifier/theme_notifier.dart';
import '../../../core/init/system_init.dart';
import '../service/i_onboard_service.dart';
import '../service/onboard_service.dart';

part 'onboard_viewmodel.g.dart';

class OnboardViewModel = OnboardViewModelBase with _$OnboardViewModel;

abstract class OnboardViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  @override
  void init() {
    SystemInit.instance.setSystemUIOverlayStyleOnboardView();
    onboardService = OnboardService(vexanaManager.networkManager);
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
    SystemInit.instance.setSystemUIOverlayStyle(
      Provider.of<ThemeNotifier>(viewModelContext, listen: false).isDark,
    );
  }

  late IOnboardService onboardService;

  late PageController pageController;

  @observable
  int currentPage = 0;

  @action
  void onPageChanged(int index) {
    currentPage = index;
  }

  @action
  void skipToLastPage() {
    pageController.animateToPage(
      2, // Son sayfa index'i
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToUserChoice() {
    viewModelContext.go('/auth/user-choice');
  }
}
