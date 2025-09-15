// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_choice_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserChoiceViewModel on _UserChoiceViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_UserChoiceViewModelBase.isLoading',
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
    name: '_UserChoiceViewModelBase.isError',
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

  late final _$selectedUserTypeAtom = Atom(
    name: '_UserChoiceViewModelBase.selectedUserType',
    context: context,
  );

  @override
  UserType? get selectedUserType {
    _$selectedUserTypeAtom.reportRead();
    return super.selectedUserType;
  }

  @override
  set selectedUserType(UserType? value) {
    _$selectedUserTypeAtom.reportWrite(value, super.selectedUserType, () {
      super.selectedUserType = value;
    });
  }

  late final _$isProcessingAtom = Atom(
    name: '_UserChoiceViewModelBase.isProcessing',
    context: context,
  );

  @override
  bool get isProcessing {
    _$isProcessingAtom.reportRead();
    return super.isProcessing;
  }

  @override
  set isProcessing(bool value) {
    _$isProcessingAtom.reportWrite(value, super.isProcessing, () {
      super.isProcessing = value;
    });
  }

  late final _$_UserChoiceViewModelBaseActionController = ActionController(
    name: '_UserChoiceViewModelBase',
    context: context,
  );

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_UserChoiceViewModelBaseActionController.startAction(
      name: '_UserChoiceViewModelBase.setLoading',
    );
    try {
      return super.setLoading(value);
    } finally {
      _$_UserChoiceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool value) {
    final _$actionInfo = _$_UserChoiceViewModelBaseActionController.startAction(
      name: '_UserChoiceViewModelBase.setError',
    );
    try {
      return super.setError(value);
    } finally {
      _$_UserChoiceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectUserType(UserType type) {
    final _$actionInfo = _$_UserChoiceViewModelBaseActionController.startAction(
      name: '_UserChoiceViewModelBase.selectUserType',
    );
    try {
      return super.selectUserType(type);
    } finally {
      _$_UserChoiceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isError: ${isError},
selectedUserType: ${selectedUserType},
isProcessing: ${isProcessing}
    ''';
  }
}
