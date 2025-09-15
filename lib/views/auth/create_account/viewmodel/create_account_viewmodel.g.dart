// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_account_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateAccountViewModel on _CreateAccountViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_CreateAccountViewModelBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isErrorAtom = Atom(
    name: '_CreateAccountViewModelBase.isError',
    context: context,
  );

  @override
  bool get isError {
    _$isErrorAtom.reportRead();
    return super.isError;
  }

  @override
  set isError(bool value) {
    _$isErrorAtom.reportWrite(value, super.isError, () {
      super.isError = value;
    });
  }

  late final _$isPasswordVisibleAtom = Atom(
    name: '_CreateAccountViewModelBase.isPasswordVisible',
    context: context,
  );

  @override
  bool get isPasswordVisible {
    _$isPasswordVisibleAtom.reportRead();
    return super.isPasswordVisible;
  }

  @override
  set isPasswordVisible(bool value) {
    _$isPasswordVisibleAtom.reportWrite(value, super.isPasswordVisible, () {
      super.isPasswordVisible = value;
    });
  }

  late final _$isConfirmPasswordVisibleAtom = Atom(
    name: '_CreateAccountViewModelBase.isConfirmPasswordVisible',
    context: context,
  );

  @override
  bool get isConfirmPasswordVisible {
    _$isConfirmPasswordVisibleAtom.reportRead();
    return super.isConfirmPasswordVisible;
  }

  @override
  set isConfirmPasswordVisible(bool value) {
    _$isConfirmPasswordVisibleAtom.reportWrite(
      value,
      super.isConfirmPasswordVisible,
      () {
        super.isConfirmPasswordVisible = value;
      },
    );
  }

  late final _$isCreatingAccountAtom = Atom(
    name: '_CreateAccountViewModelBase.isCreatingAccount',
    context: context,
  );

  @override
  bool get isCreatingAccount {
    _$isCreatingAccountAtom.reportRead();
    return super.isCreatingAccount;
  }

  @override
  set isCreatingAccount(bool value) {
    _$isCreatingAccountAtom.reportWrite(value, super.isCreatingAccount, () {
      super.isCreatingAccount = value;
    });
  }

  late final _$countryCodeAtom = Atom(
    name: '_CreateAccountViewModelBase.countryCode',
    context: context,
  );

  @override
  String get countryCode {
    _$countryCodeAtom.reportRead();
    return super.countryCode;
  }

  @override
  set countryCode(String value) {
    _$countryCodeAtom.reportWrite(value, super.countryCode, () {
      super.countryCode = value;
    });
  }

  late final _$_CreateAccountViewModelBaseActionController = ActionController(
    name: '_CreateAccountViewModelBase',
    context: context,
  );

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_CreateAccountViewModelBaseActionController
        .startAction(name: '_CreateAccountViewModelBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_CreateAccountViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool value) {
    final _$actionInfo = _$_CreateAccountViewModelBaseActionController
        .startAction(name: '_CreateAccountViewModelBase.setError');
    try {
      return super.setError(value);
    } finally {
      _$_CreateAccountViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCreatingAccount(bool value) {
    final _$actionInfo = _$_CreateAccountViewModelBaseActionController
        .startAction(name: '_CreateAccountViewModelBase.setCreatingAccount');
    try {
      return super.setCreatingAccount(value);
    } finally {
      _$_CreateAccountViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePasswordVisibility() {
    final _$actionInfo = _$_CreateAccountViewModelBaseActionController
        .startAction(
          name: '_CreateAccountViewModelBase.togglePasswordVisibility',
        );
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$_CreateAccountViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleConfirmPasswordVisibility() {
    final _$actionInfo = _$_CreateAccountViewModelBaseActionController
        .startAction(
          name: '_CreateAccountViewModelBase.toggleConfirmPasswordVisibility',
        );
    try {
      return super.toggleConfirmPasswordVisibility();
    } finally {
      _$_CreateAccountViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isError: ${isError},
isPasswordVisible: ${isPasswordVisible},
isConfirmPasswordVisible: ${isConfirmPasswordVisible},
isCreatingAccount: ${isCreatingAccount},
countryCode: ${countryCode}
    ''';
  }
}
