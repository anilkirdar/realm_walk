// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapper_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WrapperStore on WrapperStoreBase, Store {
  late final _$isUserPremiumAtom = Atom(
    name: 'WrapperStoreBase.isUserPremium',
    context: context,
  );

  @override
  bool get isUserPremium {
    _$isUserPremiumAtom.reportRead();
    return super.isUserPremium;
  }

  @override
  set isUserPremium(bool value) {
    _$isUserPremiumAtom.reportWrite(value, super.isUserPremium, () {
      super.isUserPremium = value;
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

  late final _$fetchedInitialResultAtom = Atom(
    name: 'WrapperStoreBase.fetchedInitialResult',
    context: context,
  );

  @override
  FetchedInitialResult get fetchedInitialResult {
    _$fetchedInitialResultAtom.reportRead();
    return super.fetchedInitialResult;
  }

  @override
  set fetchedInitialResult(FetchedInitialResult value) {
    _$fetchedInitialResultAtom.reportWrite(
      value,
      super.fetchedInitialResult,
      () {
        super.fetchedInitialResult = value;
      },
    );
  }

  late final _$userProfileAtom = Atom(
    name: 'WrapperStoreBase.userProfile',
    context: context,
  );

  @override
  UserProfileViewDataModel? get userProfile {
    _$userProfileAtom.reportRead();
    return super.userProfile;
  }

  @override
  set userProfile(UserProfileViewDataModel? value) {
    _$userProfileAtom.reportWrite(value, super.userProfile, () {
      super.userProfile = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    'WrapperStoreBase.init',
    context: context,
  );

  @override
  Future<void> init({
    bool isAuthenticated = true,
    bool bypassRedirect = false,
  }) {
    return _$initAsyncAction.run(
      () => super.init(
        isAuthenticated: isAuthenticated,
        bypassRedirect: bypassRedirect,
      ),
    );
  }

  late final _$WrapperStoreBaseActionController = ActionController(
    name: 'WrapperStoreBase',
    context: context,
  );

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
isUserPremium: ${isUserPremium},
isInitFetched: ${isInitFetched},
fetchedInitialResult: ${fetchedInitialResult},
userProfile: ${userProfile}
    ''';
  }
}
