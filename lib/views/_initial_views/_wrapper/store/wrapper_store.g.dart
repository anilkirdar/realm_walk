// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapper_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WrapperStore on WrapperStoreBase, Store {
  late final _$isLoadingAtom = Atom(
    name: 'WrapperStoreBase.isLoading',
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
    name: 'WrapperStoreBase.isError',
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

  late final _$isInitFetchedAtom = Atom(
    name: 'WrapperStoreBase.isInitFetched',
    context: context,
  );

  @override
  bool get isInitFetched {
    _$isInitFetchedAtom.reportRead();
    return super.isInitFetched;
  }

  @override
  set isInitFetched(bool value) {
    _$isInitFetchedAtom.reportWrite(value, super.isInitFetched, () {
      super.isInitFetched = value;
    });
  }

  late final _$userAtom = Atom(name: 'WrapperStoreBase.user', context: context);

  @override
  UserModel? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$WrapperStoreBaseActionController = ActionController(
    name: 'WrapperStoreBase',
    context: context,
  );

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$WrapperStoreBaseActionController.startAction(
      name: 'WrapperStoreBase.setLoading',
    );
    try {
      return super.setLoading(value);
    } finally {
      _$WrapperStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool value) {
    final _$actionInfo = _$WrapperStoreBaseActionController.startAction(
      name: 'WrapperStoreBase.setError',
    );
    try {
      return super.setError(value);
    } finally {
      _$WrapperStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAll() {
    final _$actionInfo = _$WrapperStoreBaseActionController.startAction(
      name: 'WrapperStoreBase.clearAll',
    );
    try {
      return super.clearAll();
    } finally {
      _$WrapperStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isError: ${isError},
isInitFetched: ${isInitFetched},
user: ${user}
    ''';
  }
}
