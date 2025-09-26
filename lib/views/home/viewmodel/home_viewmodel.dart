import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/base/model/base_view_model.dart';
import '../../_main/model/character_model.dart';
import '../../_main/model/user_model.dart';
import '../../auth/provider/auth_provider.dart';
import '../../auth/service/auth_service.dart';
part 'home_viewmodel.g.dart';

class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  @override
  void init() async {
    try {
      authService = AuthService(vexanaManager.networkManager);
      authProvider = viewModelContext.read<AuthProvider>();
      setLoading(true);
      setLoading(false);
    } catch (e) {
      setError(true);
      setLoading(false);
    }
  }

  void dispose() {}

  late AuthService authService;

  late AuthProvider authProvider;

  @observable
  bool isLoading = true;

  @observable
  bool isError = false;

  @observable
  int selectedIndex = 0;

  @computed
  UserModel? get user => authProvider.user;

  @computed
  CharacterModel? get character => authProvider.character;

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setError(bool value) {
    isError = value;
  }

  @action
  void setSelectedIndex(int value) {
    selectedIndex = value;
  }
}
