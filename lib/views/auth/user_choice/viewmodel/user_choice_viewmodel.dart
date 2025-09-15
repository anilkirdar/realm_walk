import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/model/base_view_model.dart';
import '../view/user_choice_view.dart';
part 'user_choice_viewmodel.g.dart';

class UserChoiceViewModel = _UserChoiceViewModelBase with _$UserChoiceViewModel;

abstract class _UserChoiceViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  @override
  void init() async {
    try {
      setLoading(true);
      setLoading(false);
    } catch (e) {
      setError(true);
      setLoading(false);
    }
  }

  void dispose() {}

  @observable
  bool isLoading = true;

  @observable
  bool isError = false;

  @observable
  UserType? selectedUserType;

  @observable
  bool isProcessing = false;

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setError(bool value) {
    isError = value;
  }

  @action
  void selectUserType(UserType type) {
    selectedUserType = type;
    isProcessing = selectedUserType == null;
  }

  void navigateToAuth() {
    viewModelContext.go('/auth/create-account');
  }
}
